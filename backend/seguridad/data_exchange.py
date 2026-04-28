from __future__ import annotations

import io
import re
import zipfile
from dataclasses import dataclass, field
from datetime import date, datetime, time
from decimal import Decimal, InvalidOperation
from pathlib import Path
from typing import Any, Callable

import pandas as pd
from django.conf import settings
from django.core.management.color import no_style
from django.db import DatabaseError, connection, models, transaction
from django.http import HttpResponse
from rest_framework import status
from rest_framework.parsers import FormParser, JSONParser, MultiPartParser
from rest_framework.response import Response
from rest_framework.views import APIView

from maestros.models import (
    AdmPerfilOpciones,
    MaeChofer,
    MaeCliente,
    MaeCorrelativo,
    MaeGarita,
    MaeGaritaXUsuario,
    MaeModulo,
    MaeOpcion,
    MaePerfil,
    MaePerfilMaeUsuario,
    MaeProveedor,
    MaeSistema,
    MaeTipoDocumento,
    MaeTipoEgreso,
    MaeTipoIncidente,
    MaeTipoIngreso,
    MaeTipoVehiculo,
    MaeUsuario,
    MaeVariable,
    MaeVehiculo,
)
from movimientos.models import (
    CabCierreTurno,
    CabCobranzaCredito,
    CabDocumentoVenta,
    CabReciboEgreso,
    CabReciboIngreso,
    DetCobranzaCredito,
    DetTarifario,
    MovTicket,
)

from .permissions import IsAdministrador


def _normalize_table_key(value: str | None) -> str:
    raw_value = '' if value is None else str(value).strip()
    if not raw_value:
        return ''
    stem = Path(raw_value).stem
    return re.sub(r'[^A-Z0-9]+', '_', stem.upper()).strip('_')


def _is_blank(value: Any) -> bool:
    if value is None:
        return True
    if isinstance(value, float) and pd.isna(value):
        return True
    return str(value).strip() == ''


def _stringify(value: Any) -> str:
    if _is_blank(value):
        return ''
    if isinstance(value, str):
        return value.strip()
    if isinstance(value, bool):
        return '1' if value else '0'
    if isinstance(value, Decimal):
        return format(value, 'f')
    if isinstance(value, datetime):
        return value.strftime('%Y-%m-%d %H:%M:%S')
    if isinstance(value, date):
        return value.strftime('%Y-%m-%d')
    if isinstance(value, time):
        return value.strftime('%H:%M:%S')
    return str(value).strip()


def _serialize_datetime(value: datetime | None) -> str | None:
    if value is None:
        return None
    return value.strftime('%Y-%m-%d %H:%M:%S')


def _serialize_date(value: date | None) -> str | None:
    if value is None:
        return None
    return value.strftime('%Y-%m-%d')


def _serialize_time(value: time | None) -> str | None:
    if value is None:
        return None
    return value.strftime('%H:%M:%S')


def _deserialize_datetime(value: Any) -> datetime | None:
    if _is_blank(value):
        return None
    if isinstance(value, datetime):
        return value.replace(tzinfo=None)
    parsed = pd.to_datetime(str(value).strip(), errors='coerce')
    if pd.isna(parsed):
        raise ValueError(f'No se pudo convertir "{value}" a fecha y hora.')
    return parsed.to_pydatetime().replace(tzinfo=None)


def _deserialize_date(value: Any) -> date | None:
    parsed = _deserialize_datetime(value)
    return parsed.date() if parsed else None


def _deserialize_time(value: Any) -> time | None:
    if _is_blank(value):
        return None
    if isinstance(value, time):
        return value
    parsed = pd.to_datetime(str(value).strip(), errors='coerce')
    if pd.isna(parsed):
        raise ValueError(f'No se pudo convertir "{value}" a hora.')
    return parsed.to_pydatetime().time()


def _deserialize_decimal(value: Any) -> Decimal | None:
    if _is_blank(value):
        return None
    normalized = str(value).strip().replace(',', '.')
    try:
        return Decimal(normalized)
    except InvalidOperation as exc:
        raise ValueError(f'No se pudo convertir "{value}" a decimal.') from exc


def _deserialize_integer(value: Any) -> int | None:
    if _is_blank(value):
        return None
    normalized = str(value).strip()
    try:
        return int(Decimal(normalized))
    except (InvalidOperation, ValueError) as exc:
        raise ValueError(f'No se pudo convertir "{value}" a entero.') from exc


def _deserialize_boolean(value: Any) -> bool | None:
    if _is_blank(value):
        return None
    if isinstance(value, bool):
        return value

    token = str(value).strip().lower()
    truthy = {'1', 'true', 't', 'yes', 'y', 'si', 's', 'a', 'x', 'activo'}
    falsy = {'0', 'false', 'f', 'no', 'n', 'i', 'inactivo'}

    if token in truthy:
        return True
    if token in falsy:
        return False

    raise ValueError(f'No se pudo convertir "{value}" a booleano.')


def _serialize_boolean(model: type[models.Model], field_name: str, value: bool | None) -> str | None:
    if value is None:
        return None
    if model is MaeUsuario and field_name == 'ch_esta_activo':
        return 'X' if value else ''
    if field_name == 'ch_esta_activo':
        return 'A' if value else 'N'
    return 'S' if value else 'N'


def _normalize_dataframe(df: pd.DataFrame) -> pd.DataFrame:
    if df.empty:
        return df

    normalized_columns = []
    for index, column in enumerate(df.columns):
        raw_name = '' if column is None else str(column).strip()
        normalized_columns.append(raw_name or f'COLUMN_{index + 1}')
    df.columns = normalized_columns

    df = df.apply(lambda column: column.map(lambda value: None if _is_blank(value) else value))
    df = df.dropna(axis=0, how='all').dropna(axis=1, how='all')
    return df


def _read_delimited_bytes(file_bytes: bytes) -> pd.DataFrame:
    decode_errors: list[str] = []
    for encoding in ('utf-8-sig', 'utf-8', 'latin-1'):
        try:
            text = file_bytes.decode(encoding)
            df = pd.read_csv(
                io.StringIO(text),
                sep=None,
                engine='python',
                dtype=str,
                keep_default_na=False,
            )
            return _normalize_dataframe(df)
        except Exception as exc:
            decode_errors.append(f'{encoding}: {exc}')

    raise ValueError('No se pudo leer el archivo delimitado. ' + ' | '.join(decode_errors))


def _read_excel_bytes(file_bytes: bytes, filename: str) -> list[tuple[str, pd.DataFrame]]:
    try:
        workbook = pd.ExcelFile(io.BytesIO(file_bytes))
    except Exception as exc:
        raise ValueError(f'No se pudo abrir el Excel "{filename}". {exc}') from exc

    results: list[tuple[str, pd.DataFrame]] = []
    for sheet_name in workbook.sheet_names:
        sheet_df = workbook.parse(sheet_name=sheet_name, dtype=str)
        sheet_df = _normalize_dataframe(sheet_df)
        if sheet_df.empty:
            continue
        results.append((sheet_name, sheet_df))
    return results


def _sample_headers_dir() -> Path:
    return Path(settings.BASE_DIR).parent / 'csv_export'


def _load_sample_headers(filename: str) -> list[str]:
    sample_path = _sample_headers_dir() / f'{filename}.csv'
    if not sample_path.exists():
        return []
    first_line = sample_path.read_text(encoding='utf-8', errors='ignore').splitlines()
    if not first_line:
        return []
    return [column.strip() for column in first_line[0].split(',') if column.strip()]


@dataclass(frozen=True)
class TableConfig:
    key: str
    label: str
    model: type[models.Model]
    group: str
    dependencies: tuple[str, ...]
    natural_key: tuple[str, ...]
    filename: str | None = None
    import_transform: Callable[[dict[str, Any], 'ImportContext'], dict[str, Any]] | None = None
    export_transform: Callable[[models.Model], dict[str, Any]] | None = None
    extra_validator: Callable[[list[dict[str, Any]], 'ImportContext'], list[str]] | None = None
    aliases: tuple[str, ...] = field(default_factory=tuple)

    @property
    def file_stem(self) -> str:
        return self.filename or self.key

    @property
    def pk_attname(self) -> str:
        return self.model._meta.pk.attname

    @property
    def uses_explicit_pk(self) -> bool:
        return self.pk_attname in self.natural_key

    @property
    def concrete_fields(self) -> list[models.Field]:
        return [field for field in self.model._meta.concrete_fields if not field.auto_created]

    def header_candidates(self) -> dict[str, str]:
        mapping: dict[str, str] = {}
        for field in self.concrete_fields:
            if field.is_relation:
                source_name = field.db_column or field.name.upper()
                mapping[_normalize_table_key(source_name)] = field.attname
                mapping[_normalize_table_key(field.attname)] = field.attname
                mapping[_normalize_table_key(field.name)] = field.attname
                continue

            source_name = field.db_column or field.name.upper()
            mapping[_normalize_table_key(source_name)] = field.attname
            mapping[_normalize_table_key(field.attname)] = field.attname
            mapping[_normalize_table_key(field.name)] = field.attname
        return mapping

    def export_headers(self) -> list[str]:
        sample_headers = _load_sample_headers(self.file_stem)
        if sample_headers:
            return sample_headers

        headers: list[str] = []
        for field in self.concrete_fields:
            headers.append(field.db_column or field.name.upper())
        return headers


TABLES: dict[str, TableConfig] = {
    'MAE_SISTEMA': TableConfig(
        key='MAE_SISTEMA',
        label='Sistemas',
        model=MaeSistema,
        group='Seguridad',
        dependencies=(),
        natural_key=('ch_codi_sistema',),
    ),
    'MAE_MODULO': TableConfig(
        key='MAE_MODULO',
        label='Modulos',
        model=MaeModulo,
        group='Seguridad',
        dependencies=('MAE_SISTEMA',),
        natural_key=('ch_codi_sistema_id', 'ch_codi_modulo'),
    ),
    'MAE_OPCION': TableConfig(
        key='MAE_OPCION',
        label='Opciones',
        model=MaeOpcion,
        group='Seguridad',
        dependencies=('MAE_MODULO',),
        natural_key=('ch_codi_sistema', 'ch_codi_modulo_fk_id', 'ch_codi_opcion'),
    ),
    'MAE_PERFIL': TableConfig(
        key='MAE_PERFIL',
        label='Perfiles',
        model=MaePerfil,
        group='Seguridad',
        dependencies=(),
        natural_key=('ch_codi_perfil',),
    ),
    'ADM_PERFIL_OPCIONES': TableConfig(
        key='ADM_PERFIL_OPCIONES',
        label='Perfil por opcion',
        model=AdmPerfilOpciones,
        group='Seguridad',
        dependencies=('MAE_OPCION', 'MAE_PERFIL'),
        natural_key=('ch_codi_sistema', 'ch_codi_modulo', 'ch_codi_opcion', 'ch_codi_perfil_id'),
    ),
    'MAE_USUARIO': TableConfig(
        key='MAE_USUARIO',
        label='Usuarios',
        model=MaeUsuario,
        group='Seguridad',
        dependencies=(),
        natural_key=('ch_codi_usuario',),
    ),
    'MAE_PERFIL_MAE_USUARIO': TableConfig(
        key='MAE_PERFIL_MAE_USUARIO',
        label='Perfil por usuario',
        model=MaePerfilMaeUsuario,
        group='Seguridad',
        dependencies=('MAE_USUARIO', 'MAE_PERFIL'),
        natural_key=('ch_codi_usuario_id', 'ch_codi_perfil_id', 'ch_nume_asigna'),
    ),
    'MAE_GARITA': TableConfig(
        key='MAE_GARITA',
        label='Garitas',
        model=MaeGarita,
        group='Seguridad',
        dependencies=(),
        natural_key=('ch_codi_garita',),
    ),
    'MAE_GARITA_X_USUARIO': TableConfig(
        key='MAE_GARITA_X_USUARIO',
        label='Garita por usuario',
        model=MaeGaritaXUsuario,
        group='Seguridad',
        dependencies=('MAE_GARITA', 'MAE_USUARIO'),
        natural_key=('ch_codi_garita_id', 'ch_codi_usuario_id'),
        filename='mae_garita_x_usuario',
        aliases=('mae_garita_x_usuario',),
    ),
    'MAE_CLIENTE': TableConfig(
        key='MAE_CLIENTE',
        label='Clientes',
        model=MaeCliente,
        group='Maestros',
        dependencies=(),
        natural_key=('ch_codi_cliente',),
    ),
    'MAE_CHOFER': TableConfig(
        key='MAE_CHOFER',
        label='Choferes',
        model=MaeChofer,
        group='Maestros',
        dependencies=(),
        natural_key=('ch_codi_chofer',),
    ),
    'MAE_TIPO_VEHICULO': TableConfig(
        key='MAE_TIPO_VEHICULO',
        label='Tipos de vehiculo',
        model=MaeTipoVehiculo,
        group='Maestros',
        dependencies=(),
        natural_key=('ch_tipo_vehiculo',),
    ),
    'MAE_VEHICULO': TableConfig(
        key='MAE_VEHICULO',
        label='Vehiculos',
        model=MaeVehiculo,
        group='Maestros',
        dependencies=('MAE_TIPO_VEHICULO', 'MAE_CLIENTE', 'MAE_CHOFER'),
        natural_key=('ch_codi_vehiculo',),
    ),
    'MAE_TIPO_INCIDENTE': TableConfig(
        key='MAE_TIPO_INCIDENTE',
        label='Tipos de incidente',
        model=MaeTipoIncidente,
        group='Maestros',
        dependencies=(),
        natural_key=('ch_codi_tipo_incidente',),
    ),
    'MAE_TIPO_EGRESO': TableConfig(
        key='MAE_TIPO_EGRESO',
        label='Tipos de egreso',
        model=MaeTipoEgreso,
        group='Maestros',
        dependencies=(),
        natural_key=('ch_codi_tipo_egreso',),
    ),
    'MAE_TIPO_INGRESO': TableConfig(
        key='MAE_TIPO_INGRESO',
        label='Tipos de ingreso',
        model=MaeTipoIngreso,
        group='Maestros',
        dependencies=(),
        natural_key=('ch_codi_tipo_ingreso',),
    ),
    'MAE_TIPO_DOCUMENTO': TableConfig(
        key='MAE_TIPO_DOCUMENTO',
        label='Tipos de documento',
        model=MaeTipoDocumento,
        group='Maestros',
        dependencies=(),
        natural_key=('ch_codi_tipo_dcmnt',),
    ),
    'MAE_CORRELATIVO': TableConfig(
        key='MAE_CORRELATIVO',
        label='Correlativos',
        model=MaeCorrelativo,
        group='Maestros',
        dependencies=('MAE_TIPO_DOCUMENTO',),
        natural_key=('ch_codi_correlativo',),
    ),
    'MAE_PROVEEDOR': TableConfig(
        key='MAE_PROVEEDOR',
        label='Proveedores',
        model=MaeProveedor,
        group='Maestros',
        dependencies=(),
        natural_key=('ch_codi_proveedor',),
    ),
    'MAE_VARIABLE': TableConfig(
        key='MAE_VARIABLE',
        label='Variables',
        model=MaeVariable,
        group='Maestros',
        dependencies=(),
        natural_key=('ch_codi_variable',),
    ),
    'DET_TARIFARIO': TableConfig(
        key='DET_TARIFARIO',
        label='Tarifario',
        model=DetTarifario,
        group='Movimientos',
        dependencies=('MAE_TIPO_VEHICULO', 'MAE_CLIENTE'),
        natural_key=('ch_codi_tarifario',),
    ),
    'MOV_TICKET': TableConfig(
        key='MOV_TICKET',
        label='Tickets',
        model=MovTicket,
        group='Movimientos',
        dependencies=('MAE_GARITA', 'MAE_VEHICULO', 'MAE_CLIENTE', 'MAE_CHOFER', 'DET_TARIFARIO', 'MAE_TIPO_INCIDENTE'),
        natural_key=('nu_codi_ticket',),
    ),
    'CAB_COBRANZA_CREDITO': TableConfig(
        key='CAB_COBRANZA_CREDITO',
        label='Cabecera cobranza credito',
        model=CabCobranzaCredito,
        group='Movimientos',
        dependencies=('MAE_CLIENTE',),
        natural_key=('nu_codi_cobr_cred',),
    ),
    'DET_COBRANZA_CREDITO': TableConfig(
        key='DET_COBRANZA_CREDITO',
        label='Detalle cobranza credito',
        model=DetCobranzaCredito,
        group='Movimientos',
        dependencies=('CAB_COBRANZA_CREDITO', 'MOV_TICKET'),
        natural_key=('nu_codi_cobr_cred_id', 'nu_codi_detalle'),
    ),
    'CAB_DOCUMENTO_VENTA': TableConfig(
        key='CAB_DOCUMENTO_VENTA',
        label='Documentos de venta',
        model=CabDocumentoVenta,
        group='Movimientos',
        dependencies=('MOV_TICKET', 'MAE_CLIENTE', 'CAB_COBRANZA_CREDITO'),
        natural_key=('nu_codi_docu_vent',),
    ),
    'CAB_CIERRE_TURNO': TableConfig(
        key='CAB_CIERRE_TURNO',
        label='Cierres de turno',
        model=CabCierreTurno,
        group='Movimientos',
        dependencies=(),
        natural_key=('nu_codi_cierre',),
    ),
    'CAB_RECIBO_EGRESO': TableConfig(
        key='CAB_RECIBO_EGRESO',
        label='Recibos de egreso',
        model=CabReciboEgreso,
        group='Movimientos',
        dependencies=('MAE_TIPO_EGRESO', 'MAE_PROVEEDOR'),
        natural_key=('nu_codi_recibo',),
    ),
    'CAB_RECIBO_INGRESO': TableConfig(
        key='CAB_RECIBO_INGRESO',
        label='Recibos de ingreso',
        model=CabReciboIngreso,
        group='Movimientos',
        dependencies=('MAE_TIPO_INGRESO', 'MAE_CLIENTE'),
        natural_key=('nu_codi_recibo',),
    ),
}


TABLE_ALIASES: dict[str, str] = {}
for table_key, config in TABLES.items():
    TABLE_ALIASES[_normalize_table_key(table_key)] = table_key
    TABLE_ALIASES[_normalize_table_key(config.file_stem)] = table_key
    TABLE_ALIASES[_normalize_table_key(config.model._meta.db_table)] = table_key
    for alias in config.aliases:
        TABLE_ALIASES[_normalize_table_key(alias)] = table_key


def _get_table_key(raw_name: str) -> str:
    normalized = _normalize_table_key(raw_name)
    return TABLE_ALIASES.get(normalized, '')


@dataclass
class ParsedDataset:
    table_key: str
    source_name: str
    rows: list[dict[str, Any]]


class ImportContext:
    def __init__(self):
        self._cache: dict[tuple[type[models.Model], tuple[Any, ...]], Any] = {}

    def resolve_modulo_pk(self, codigo_sistema: str | None, codigo_modulo: str | None) -> int | None:
        key = (MaeModulo, (codigo_sistema, codigo_modulo))
        if key in self._cache:
            return self._cache[key]

        if not codigo_sistema or not codigo_modulo:
            self._cache[key] = None
            return None

        modulo_id = (
            MaeModulo.objects.filter(
                ch_codi_sistema_id=codigo_sistema,
                ch_codi_modulo=codigo_modulo,
            )
            .values_list('id', flat=True)
            .first()
        )
        self._cache[key] = modulo_id
        return modulo_id


def _coerce_value(field: models.Field, raw_value: Any) -> Any:
    if field.is_relation:
        relation_field = field.target_field
        coerced = _coerce_value(relation_field, raw_value)
        if field.null:
            if coerced is None:
                return None
            if not isinstance(relation_field, models.CharField) and coerced == 0:
                return None
            if isinstance(relation_field, models.CharField) and coerced == '0':
                return None
        # Normalizar ancho si el campo destino es CharField con max_length
        if (
            isinstance(relation_field, models.CharField)
            and coerced is not None
            and hasattr(relation_field, 'max_length')
            and relation_field.max_length
            and coerced.isdigit()
            and len(coerced) < relation_field.max_length
        ):
            coerced = coerced.zfill(relation_field.max_length)
        return coerced

    if isinstance(field, models.BooleanField):
        return _deserialize_boolean(raw_value)
    if isinstance(field, models.DecimalField):
        return _deserialize_decimal(raw_value)
    if isinstance(field, (models.AutoField, models.BigAutoField, models.IntegerField, models.BigIntegerField, models.SmallIntegerField)):
        return _deserialize_integer(raw_value)
    if isinstance(field, models.DateTimeField):
        return _deserialize_datetime(raw_value)
    if isinstance(field, models.DateField):
        return _deserialize_date(raw_value)
    if isinstance(field, models.TimeField):
        return _deserialize_time(raw_value)
    if _is_blank(raw_value):
        return None
    return str(raw_value).strip()


def _serialize_field_value(model: type[models.Model], field: models.Field, instance: models.Model) -> Any:
    value = getattr(instance, field.attname)

    if isinstance(field, models.BooleanField):
        return _serialize_boolean(model, field.name, value)
    if isinstance(field, models.DateTimeField):
        return _serialize_datetime(value)
    if isinstance(field, models.DateField):
        return _serialize_date(value)
    if isinstance(field, models.TimeField):
        return _serialize_time(value)
    if isinstance(field, models.DecimalField):
        return format(value, 'f') if value is not None else None
    return value


def _default_import_transform(config: TableConfig, row: dict[str, Any], _: ImportContext) -> dict[str, Any]:
    candidates = config.header_candidates()
    prepared: dict[str, Any] = {}

    for source_name, raw_value in row.items():
        attname = candidates.get(_normalize_table_key(source_name))
        if not attname:
            continue
        field = config.model._meta.get_field(attname[:-3] if attname.endswith('_id') and attname[:-3] in {item.name for item in config.model._meta.fields} else attname)
        prepared[attname] = _coerce_value(field, raw_value)

    return prepared


def _mae_opcion_import_transform(row: dict[str, Any], context: ImportContext) -> dict[str, Any]:
    prepared = _default_import_transform(TABLES['MAE_OPCION'], row, context)
    codigo_sistema = prepared.get('ch_codi_sistema')
    codigo_modulo = _stringify(row.get('CH_CODI_MODULO') or row.get('ch_codi_modulo'))

    modulo_pk = context.resolve_modulo_pk(codigo_sistema, codigo_modulo)
    if modulo_pk is None:
        raise ValueError(
            f'No existe el modulo {codigo_sistema}/{codigo_modulo} requerido por MAE_OPCION.'
        )

    prepared['ch_codi_modulo_fk_id'] = modulo_pk
    return prepared


def _mae_opcion_export_transform(instance: MaeOpcion) -> dict[str, Any]:
    return {
        'CH_CODI_SISTEMA': instance.ch_codi_sistema,
        'CH_CODI_MODULO': instance.ch_codi_modulo_fk.ch_codi_modulo if instance.ch_codi_modulo_fk_id else None,
        'CH_CODI_OPCION': instance.ch_codi_opcion,
        'VC_DESC_OPCION': instance.vc_desc_opcion,
        'VC_DESC_NOM_VENTANA': instance.vc_desc_nom_ventana,
        'VC_TIPO_OPCION': instance.vc_tipo_opcion,
        'VC_DESC_ICONO_OPCION': instance.vc_desc_icono_opcion,
        'VC_DESC_RESPONSABLE': instance.vc_desc_responsable,
        'DT_FECH_CREACION_OPCION': _serialize_datetime(instance.dt_fech_creacion_opcion),
        'DT_FECH_MOD_OPCION': _serialize_datetime(instance.dt_fech_mod_opcion),
        'CH_ESTA_PARAMETRO': instance.ch_esta_parametro,
        'CH_ESTA_OPCION': instance.ch_esta_opcion,
        'CH_DESC_NOM_CORTO': instance.ch_desc_nom_corto,
        'CH_RUTA_PROGRAMA': instance.ch_ruta_programa,
        'CH_ESTA_OPCION_INTERNET': instance.ch_esta_opcion_internet,
        'CH_IND_ORIGINAL': instance.ch_ind_original,
    }


def _validate_adm_perfil_opciones(rows: list[dict[str, Any]], _: ImportContext) -> list[str]:
    if not rows:
        return []

    requested = {
        (
            row.get('ch_codi_sistema'),
            row.get('ch_codi_modulo'),
            row.get('ch_codi_opcion'),
        )
        for row in rows
        if row.get('ch_codi_sistema') and row.get('ch_codi_modulo') and row.get('ch_codi_opcion')
    }
    if not requested:
        return []

    existing = {
        (sistema, modulo, opcion)
        for sistema, modulo, opcion in MaeOpcion.objects.select_related('ch_codi_modulo_fk').values_list(
            'ch_codi_sistema',
            'ch_codi_modulo_fk__ch_codi_modulo',
            'ch_codi_opcion',
        )
    }

    missing = sorted(
        f'{sistema}/{modulo}/{opcion}'
        for sistema, modulo, opcion in requested
        if (sistema, modulo, opcion) not in existing
    )
    if not missing:
        return []
    preview = ', '.join(missing[:5])
    suffix = '...' if len(missing) > 5 else ''
    return [f'ADM_PERFIL_OPCIONES referencia opciones inexistentes: {preview}{suffix}']


TABLES['MAE_OPCION'] = TableConfig(
    **{**TABLES['MAE_OPCION'].__dict__, 'import_transform': _mae_opcion_import_transform, 'export_transform': _mae_opcion_export_transform}
)
TABLES['ADM_PERFIL_OPCIONES'] = TableConfig(
    **{**TABLES['ADM_PERFIL_OPCIONES'].__dict__, 'extra_validator': _validate_adm_perfil_opciones}
)

TABLES_BY_MODEL: dict[type[models.Model], str] = {
    config.model: key for key, config in TABLES.items()
}


def _order_table_keys(table_keys: list[str]) -> list[str]:
    requested = {table_key for table_key in table_keys if table_key in TABLES}
    ordered: list[str] = []
    visiting: set[str] = set()
    visited: set[str] = set()

    def visit(table_key: str) -> None:
        if table_key in visited or table_key not in requested:
            return
        if table_key in visiting:
            raise ValueError(f'Se detecto una dependencia ciclica en {table_key}.')
        visiting.add(table_key)
        for dependency in TABLES[table_key].dependencies:
            visit(dependency)
        visiting.remove(table_key)
        visited.add(table_key)
        ordered.append(table_key)

    for table_key in table_keys:
        visit(table_key)

    return ordered


def _parse_dataset(table_key: str, source_name: str, df: pd.DataFrame) -> ParsedDataset:
    rows = df.where(pd.notnull(df), None).to_dict(orient='records')
    normalized_rows = [
        {str(column).strip(): value for column, value in row.items()}
        for row in rows
        if any(not _is_blank(value) for value in row.values())
    ]
    return ParsedDataset(table_key=table_key, source_name=source_name, rows=normalized_rows)


def _parse_upload(uploaded_file) -> tuple[list[ParsedDataset], list[str]]:
    filename = uploaded_file.name
    suffix = Path(filename).suffix.lower()
    warnings: list[str] = []

    if suffix in {'.csv', '.tsv', '.txt'}:
        table_key = _get_table_key(filename)
        if not table_key:
            raise ValueError(f'No se pudo identificar la tabla destino para "{filename}".')
        df = _read_delimited_bytes(uploaded_file.read())
        return [_parse_dataset(table_key, filename, df)], warnings

    if suffix in {'.xlsx', '.xlsm', '.xls'}:
        sheets = _read_excel_bytes(uploaded_file.read(), filename)
        if not sheets:
            raise ValueError(f'El Excel "{filename}" no contiene hojas con datos.')

        parsed: list[ParsedDataset] = []
        fallback_table = _get_table_key(filename)
        for sheet_name, sheet_df in sheets:
            table_key = _get_table_key(sheet_name) or (fallback_table if len(sheets) == 1 else '')
            if not table_key:
                warnings.append(f'Se omitio la hoja "{sheet_name}" de "{filename}" porque no coincide con una tabla soportada.')
                continue
            parsed.append(_parse_dataset(table_key, f'{filename}:{sheet_name}', sheet_df))

        if not parsed:
            raise ValueError(f'No se encontro ninguna hoja soportada dentro de "{filename}".')
        return parsed, warnings

    if suffix == '.zip':
        parsed: list[ParsedDataset] = []
        with zipfile.ZipFile(io.BytesIO(uploaded_file.read())) as archive:
            for info in archive.infolist():
                if info.is_dir():
                    continue
                nested_name = info.filename
                nested_suffix = Path(nested_name).suffix.lower()
                file_bytes = archive.read(info)

                if nested_suffix in {'.csv', '.tsv', '.txt'}:
                    table_key = _get_table_key(nested_name)
                    if not table_key:
                        warnings.append(f'Se omitio "{nested_name}" porque no coincide con una tabla soportada.')
                        continue
                    df = _read_delimited_bytes(file_bytes)
                    parsed.append(_parse_dataset(table_key, nested_name, df))
                    continue

                if nested_suffix in {'.xlsx', '.xlsm', '.xls'}:
                    sheets = _read_excel_bytes(file_bytes, nested_name)
                    fallback_table = _get_table_key(nested_name)
                    for sheet_name, sheet_df in sheets:
                        table_key = _get_table_key(sheet_name) or (fallback_table if len(sheets) == 1 else '')
                        if not table_key:
                            warnings.append(
                                f'Se omitio la hoja "{sheet_name}" dentro de "{nested_name}" porque no coincide con una tabla soportada.'
                            )
                            continue
                        parsed.append(_parse_dataset(table_key, f'{nested_name}:{sheet_name}', sheet_df))
                    continue

                warnings.append(f'Se omitio "{nested_name}" porque su formato no esta soportado.')

        if not parsed:
            raise ValueError(f'El ZIP "{filename}" no contiene archivos soportados.')
        return parsed, warnings

    raise ValueError(
        f'El formato "{suffix or "sin extension"}" no esta soportado. Usa CSV, XLSX/XLSM o ZIP.'
    )


def _validate_required_keys(config: TableConfig, rows: list[dict[str, Any]]) -> list[str]:
    errors: list[str] = []
    for index, row in enumerate(rows, start=1):
        missing = [field_name for field_name in config.natural_key if _is_blank(row.get(field_name))]
        if missing:
            errors.append(
                f'Fila {index}: faltan columnas clave {", ".join(missing)} en {config.key}.'
            )
    return errors


def _validate_foreign_keys(
    config: TableConfig,
    rows: list[dict[str, Any]],
    imported_keys: dict[str, set[Any]] | None = None,
) -> list[str]:
    errors: list[str] = []
    for field in config.model._meta.concrete_fields:
        if not field.is_relation:
            continue

        values = {
            row.get(field.attname)
            for row in rows
            if row.get(field.attname) not in (None, '')
        }
        if not values:
            continue

        target_attname = field.target_field.attname
        existing = set(
            field.related_model.objects.filter(**{f'{target_attname}__in': list(values)}).values_list(target_attname, flat=True)
        )

        dep_key = TABLES_BY_MODEL.get(field.related_model)
        if dep_key and imported_keys and dep_key in imported_keys:
            existing |= imported_keys[dep_key]

        missing = sorted(values - existing, key=lambda value: str(value))
        if not missing:
            continue

        preview = ', '.join(_stringify(value) for value in missing[:5])
        suffix = '...' if len(missing) > 5 else ''
        errors.append(
            f'{config.key}: faltan referencias para {field.attname}: {preview}{suffix}'
        )

    return errors


def _load_existing_lookup(config: TableConfig, rows: list[dict[str, Any]]) -> dict[tuple[Any, ...], Any]:
    if not rows:
        return {}

    if config.uses_explicit_pk and len(config.natural_key) == 1:
        pk_name = config.pk_attname
        values = [row.get(pk_name) for row in rows if row.get(pk_name) is not None]
        if not values:
            return {}
        existing = config.model.objects.filter(**{f'{pk_name}__in': values}).values_list(pk_name, flat=True)
        return {(value,): value for value in existing}

    result: dict[tuple[Any, ...], Any] = {}
    queryset = config.model.objects.all().values(config.pk_attname, *config.natural_key)
    for record in queryset:
        key = tuple(record[field_name] for field_name in config.natural_key)
        result[key] = record[config.pk_attname]
    return result


def _sequence_reset_sql(model: type[models.Model]) -> list[str]:
    try:
        return connection.ops.sequence_reset_sql(no_style(), [model])
    except Exception:
        return []


def _execute_upsert(config: TableConfig, rows: list[dict[str, Any]], dry_run: bool) -> dict[str, int]:
    existing_lookup = _load_existing_lookup(config, rows)
    create_instances: list[models.Model] = []
    update_instances: list[models.Model] = []

    for row in rows:
        key = tuple(row.get(field_name) for field_name in config.natural_key)
        existing_pk = existing_lookup.get(key)
        instance = config.model(**row)
        if existing_pk is None:
            create_instances.append(instance)
            continue
        setattr(instance, config.pk_attname, existing_pk)
        update_instances.append(instance)

    if not dry_run:
        if create_instances:
            config.model.objects.bulk_create(create_instances, batch_size=500)
        if update_instances:
            update_fields = [
                field.attname
                for field in config.model._meta.concrete_fields
                if field.attname != config.pk_attname
            ]
            config.model.objects.bulk_update(update_instances, update_fields, batch_size=500)
        if create_instances:
            for sql in _sequence_reset_sql(config.model):
                with connection.cursor() as cursor:
                    cursor.execute(sql)

    return {
        'created': len(create_instances),
        'updated': len(update_instances),
    }


def _prepare_rows(config: TableConfig, datasets: list[ParsedDataset], context: ImportContext) -> list[dict[str, Any]]:
    prepared_rows: list[dict[str, Any]] = []
    transform = config.import_transform or (lambda row, import_context: _default_import_transform(config, row, import_context))

    for dataset in datasets:
        for index, row in enumerate(dataset.rows, start=1):
            try:
                prepared_rows.append(transform(row, context))
            except ValueError as exc:
                raise ValueError(f'{dataset.source_name} fila {index}: {exc}') from exc

    return prepared_rows


def _dedupe_rows(config: TableConfig, rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    deduped: dict[tuple[Any, ...], dict[str, Any]] = {}
    passthrough: list[dict[str, Any]] = []

    for row in rows:
        key = tuple(row.get(field_name) for field_name in config.natural_key)
        if any(_is_blank(value) for value in key):
            passthrough.append(row)
            continue
        deduped[key] = row

    return passthrough + list(deduped.values())


def _build_import_result(datasets_by_table: dict[str, list[ParsedDataset]], dry_run: bool) -> dict[str, Any]:
    context = ImportContext()
    ordered_tables = _order_table_keys(list(datasets_by_table.keys()))
    results: list[dict[str, Any]] = []
    all_errors: list[str] = []
    imported_keys: dict[str, set[Any]] = {}

    with transaction.atomic():
        for table_key in ordered_tables:
            config = TABLES[table_key]
            prepared_rows = _dedupe_rows(config, _prepare_rows(config, datasets_by_table[table_key], context))
            errors = _validate_required_keys(config, prepared_rows)
            errors.extend(_validate_foreign_keys(config, prepared_rows, imported_keys))
            if config.extra_validator:
                errors.extend(config.extra_validator(prepared_rows, context))

            if errors:
                all_errors.extend(errors)
                continue

            summary = _execute_upsert(config, prepared_rows, dry_run=dry_run)

            pk_attname = config.pk_attname
            imported_keys[table_key] = {
                row.get(pk_attname) for row in prepared_rows
                if row.get(pk_attname) is not None
            }

            results.append(
                {
                    'table': table_key,
                    'label': config.label,
                    'rows': len(prepared_rows),
                    **summary,
                }
            )

        if dry_run or all_errors:
            transaction.set_rollback(True)

    if all_errors:
        raise ValueError('\n'.join(all_errors))

    return {
        'dry_run': dry_run,
        'ordered_tables': ordered_tables,
        'results': results,
        'total_rows': sum(item['rows'] for item in results),
        'total_created': sum(item['created'] for item in results),
        'total_updated': sum(item['updated'] for item in results),
    }


def _export_rows(config: TableConfig) -> list[dict[str, Any]]:
    exporter = config.export_transform
    headers = config.export_headers()

    queryset = config.model.objects.all()
    if config.model is MaeOpcion:
        queryset = queryset.select_related('ch_codi_modulo_fk')

    rows: list[dict[str, Any]] = []
    for instance in queryset.iterator():
        if exporter:
            row = exporter(instance)
        else:
            row = {}
            for field in config.concrete_fields:
                header = field.db_column or field.name.upper()
                row[header] = _serialize_field_value(config.model, field, instance)

        ordered_row = {header: row.get(header) for header in headers}
        for key, value in row.items():
            if key not in ordered_row:
                ordered_row[key] = value
        rows.append(ordered_row)

    return rows


def _build_catalog() -> dict[str, Any]:
    ordered = _order_table_keys(list(TABLES.keys()))
    tables = []
    for table_key in ordered:
        config = TABLES[table_key]
        tables.append(
            {
                'key': table_key,
                'label': config.label,
                'group': config.group,
                'row_count': config.model.objects.count(),
                'dependencies': list(config.dependencies),
                'natural_key': list(config.natural_key),
                'headers': config.export_headers(),
                'file_stem': config.file_stem,
            }
        )
    return {
        'tables': tables,
        'safe_order': ordered,
        'import_formats': ['csv', 'xlsx', 'xlsm', 'zip'],
        'export_formats': ['xlsx', 'zip-csv', 'csv'],
    }


def _dependent_table_keys(table_key: str) -> list[str]:
    ordered = _order_table_keys(list(TABLES.keys()))
    return [candidate_key for candidate_key in ordered if table_key in TABLES[candidate_key].dependencies]


def _blocking_tables_for_clear(table_key: str) -> list[dict[str, Any]]:
    blocking_tables: list[dict[str, Any]] = []
    for dependent_key in _dependent_table_keys(table_key):
        dependent_config = TABLES[dependent_key]
        row_count = dependent_config.model.objects.count()
        if row_count:
            blocking_tables.append(
                {
                    'key': dependent_key,
                    'label': dependent_config.label,
                    'row_count': row_count,
                }
            )
    return blocking_tables


def _clear_table(config: TableConfig) -> int:
    deleted_rows = config.model.objects.count()
    quoted_table_name = connection.ops.quote_name(config.model._meta.db_table)

    with transaction.atomic():
        with connection.cursor() as cursor:
            cursor.execute(f'DELETE FROM {quoted_table_name}')
        for sql in _sequence_reset_sql(config.model):
            with connection.cursor() as cursor:
                cursor.execute(sql)

    return deleted_rows


class DataSyncCatalogView(APIView):
    permission_classes = [IsAdministrador]

    def get(self, request):
        return Response(_build_catalog())


class DataSyncImportView(APIView):
    permission_classes = [IsAdministrador]
    parser_classes = [MultiPartParser, FormParser]

    def post(self, request):
        uploaded_files = request.FILES.getlist('files')
        if not uploaded_files:
            return Response(
                {'detail': 'Debes adjuntar al menos un archivo para importar.'},
                status=status.HTTP_400_BAD_REQUEST,
            )

        dry_run = str(request.data.get('dry_run', '')).strip().lower() in {'1', 'true', 't', 'si', 'yes'}

        datasets_by_table: dict[str, list[ParsedDataset]] = {}
        warnings: list[str] = []

        try:
            for uploaded_file in uploaded_files:
                parsed, parse_warnings = _parse_upload(uploaded_file)
                warnings.extend(parse_warnings)
                for dataset in parsed:
                    datasets_by_table.setdefault(dataset.table_key, []).append(dataset)

            result = _build_import_result(datasets_by_table, dry_run=dry_run)
        except ValueError as exc:
            return Response(
                {
                    'detail': 'No se pudo completar la importacion.',
                    'errors': str(exc).splitlines(),
                    'warnings': warnings,
                },
                status=status.HTTP_400_BAD_REQUEST,
            )
        except Exception as exc:
            return Response(
                {
                    'detail': 'Ocurrio un error inesperado durante la importacion.',
                    'errors': [str(exc)],
                    'warnings': warnings,
                },
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )

        result['warnings'] = warnings
        return Response(result)


class DataSyncClearTableView(APIView):
    permission_classes = [IsAdministrador]
    parser_classes = [JSONParser]

    def post(self, request):
        raw_table = str(request.data.get('table') or '').strip()
        table_key = _get_table_key(raw_table) or raw_table

        if table_key not in TABLES:
            return Response(
                {'detail': 'Debes indicar una tabla soportada para limpiar.'},
                status=status.HTTP_400_BAD_REQUEST,
            )

        config = TABLES[table_key]
        blocking_tables = _blocking_tables_for_clear(table_key)
        if blocking_tables:
            return Response(
                {
                    'detail': 'No se puede limpiar la tabla mientras existan registros en tablas dependientes.',
                    'blocking_tables': blocking_tables,
                },
                status=status.HTTP_400_BAD_REQUEST,
            )

        try:
            deleted_rows = _clear_table(config)
        except DatabaseError as exc:
            return Response(
                {
                    'detail': f'No se pudo limpiar la tabla {table_key}.',
                    'errors': [str(exc)],
                },
                status=status.HTTP_400_BAD_REQUEST,
            )

        return Response(
            {
                'table': table_key,
                'label': config.label,
                'deleted_rows': deleted_rows,
            }
        )


class DataSyncExportView(APIView):
    permission_classes = [IsAdministrador]
    parser_classes = [JSONParser]

    def post(self, request):
        requested_tables = request.data.get('tables') or []
        format_name = str(request.data.get('format') or 'xlsx').strip().lower()

        if not isinstance(requested_tables, list) or not requested_tables:
            return Response(
                {'detail': 'Debes seleccionar al menos una tabla para exportar.'},
                status=status.HTTP_400_BAD_REQUEST,
            )

        invalid_tables = [table for table in requested_tables if table not in TABLES]
        if invalid_tables:
            return Response(
                {'detail': f'Tablas no soportadas: {", ".join(invalid_tables)}'},
                status=status.HTTP_400_BAD_REQUEST,
            )

        ordered_tables = _order_table_keys(requested_tables)
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')

        if format_name == 'csv':
            if len(ordered_tables) != 1:
                return Response(
                    {'detail': 'La exportacion CSV simple solo admite una tabla.'},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            config = TABLES[ordered_tables[0]]
            dataframe = pd.DataFrame(_export_rows(config), columns=config.export_headers())
            csv_payload = dataframe.to_csv(index=False).encode('utf-8-sig')
            response = HttpResponse(csv_payload, content_type='text/csv; charset=utf-8')
            response['Content-Disposition'] = f'attachment; filename="{config.file_stem}_{timestamp}.csv"'
            return response

        if format_name == 'xlsx':
            buffer = io.BytesIO()
            with pd.ExcelWriter(buffer, engine='openpyxl') as writer:
                for table_key in ordered_tables:
                    config = TABLES[table_key]
                    dataframe = pd.DataFrame(_export_rows(config), columns=config.export_headers())
                    sheet_name = config.file_stem[:31] or table_key[:31]
                    dataframe.to_excel(writer, index=False, sheet_name=sheet_name)

            response = HttpResponse(
                buffer.getvalue(),
                content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            )
            response['Content-Disposition'] = f'attachment; filename="sisco_export_{timestamp}.xlsx"'
            return response

        if format_name == 'zip-csv':
            buffer = io.BytesIO()
            with zipfile.ZipFile(buffer, mode='w', compression=zipfile.ZIP_DEFLATED) as archive:
                for table_key in ordered_tables:
                    config = TABLES[table_key]
                    dataframe = pd.DataFrame(_export_rows(config), columns=config.export_headers())
                    archive.writestr(
                        f'{config.file_stem}.csv',
                        dataframe.to_csv(index=False),
                    )

            response = HttpResponse(buffer.getvalue(), content_type='application/zip')
            response['Content-Disposition'] = f'attachment; filename="sisco_export_{timestamp}.zip"'
            return response

        return Response(
            {'detail': 'Formato no soportado. Usa xlsx, zip-csv o csv.'},
            status=status.HTTP_400_BAD_REQUEST,
        )

"""
models.py — BD_SISCO
Generado a partir del script SQL de SQL Server (Microsoft SQL Server).

Estructura general:
  - MAE_*  → Tablas maestras (catálogos)
  - CAB_*  → Cabeceras de transacciones
  - DET_*  → Detalles de transacciones
  - MOV_*  → Movimientos operativos
  - ADM_*  → Administración de permisos

Relaciones principales:
  MAE_SISTEMA → MAE_MODULO → MAE_OPCION ← ADM_PERFIL_OPCIONES ← MAE_PERFIL
  MAE_PERFIL  ← MAE_PERFIL_MAE_USUARIO → MAE_USUARIO
  MAE_GARITA  ← mae_garita_x_usuario  → MAE_USUARIO
  MAE_TIPO_VEHICULO ← MAE_VEHICULO → MAE_CLIENTE, MAE_CHOFER
  MAE_TIPO_VEHICULO ← DET_TARIFARIO → MAE_CLIENTE
  DET_TARIFARIO ← MOV_TICKET → MAE_GARITA, MAE_VEHICULO, MAE_CLIENTE,
                                MAE_CHOFER, MAE_TIPO_INCIDENTE
  MOV_TICKET ← CAB_DOCUMENTO_VENTA → MAE_CLIENTE
  MOV_TICKET ← DET_COBRANZA_CREDITO → CAB_COBRANZA_CREDITO → MAE_CLIENTE
  MAE_TIPO_EGRESO ← CAB_RECIBO_EGRESO → MAE_PROVEEDOR
  MAE_TIPO_INGRESO ← CAB_RECIBO_INGRESO → MAE_CLIENTE
  MAE_TIPO_DOCUMENTO ← MAE_CORRELATIVO
"""

import re

from django.core.exceptions import ValidationError
from django.db import models
from django.utils import timezone
from seguridad.current_user import get_current_user

DEFAULT_GARITA_CODE = 'GAR'
DEFAULT_GARITA_DESC = 'Garita'
VEHICLE_PLATE_ERROR_MESSAGE = 'La placa debe tener el formato ABC-123 usando solo letras mayusculas y numeros.'
VEHICLE_PLATE_PATTERN = re.compile(r'^[A-Z0-9]{3}-[A-Z0-9]{3}$')


def _next_numeric_code(model, field_name, width, prefix=''):
    max_value = 0
    suffix_width = width - len(prefix)
    for raw_value in model.objects.values_list(field_name, flat=True):
        value = str(raw_value or '').strip()
        if prefix:
            if not value.startswith(prefix):
                continue
            value = value[len(prefix):]
        if value.isdigit():
            max_value = max(max_value, int(value))
    return f'{prefix}{str(max_value + 1).zfill(suffix_width)}'


def _preserve_existing_code(instance, field_name):
    if not instance.pk:
        return
    existing = type(instance).objects.filter(pk=instance.pk).only(field_name).first()
    if existing:
        setattr(instance, field_name, getattr(existing, field_name))


def _current_audit_user_code():
    user = get_current_user()
    if not user:
        return None

    user_code = getattr(user, 'ch_codi_usua', None) or getattr(user, 'ch_codi_usuario', None)
    return str(user_code).strip()[:15] if user_code else None


def _current_audit_datetime():
    now = timezone.now()
    return timezone.localtime(now) if timezone.is_aware(now) else now


def normalize_vehicle_plate(value):
    raw_value = '' if value is None else str(value).strip().upper()
    if not raw_value:
        raise ValidationError(VEHICLE_PLATE_ERROR_MESSAGE)

    compact_value = raw_value.replace('-', '').replace(' ', '')
    if len(compact_value) != 6 or not compact_value.isalnum():
        raise ValidationError(VEHICLE_PLATE_ERROR_MESSAGE)

    normalized_value = f'{compact_value[:3]}-{compact_value[3:]}'
    if not VEHICLE_PLATE_PATTERN.fullmatch(normalized_value):
        raise ValidationError(VEHICLE_PLATE_ERROR_MESSAGE)

    return normalized_value


def ensure_default_garita():
    garita, created = MaeGarita.objects.get_or_create(
        ch_codi_garita=DEFAULT_GARITA_CODE,
        defaults={
            'vc_desc_garita': DEFAULT_GARITA_DESC,
            'ch_esta_activo': True,
        },
    )
    updates = []
    if garita.vc_desc_garita != DEFAULT_GARITA_DESC:
        garita.vc_desc_garita = DEFAULT_GARITA_DESC
        updates.append('vc_desc_garita')
    if garita.ch_esta_activo is not True:
        garita.ch_esta_activo = True
        updates.append('ch_esta_activo')
    if updates:
        garita.save(update_fields=updates)
    return garita


class AuditFieldsMixin(models.Model):
    class Meta:
        abstract = True

    def save(self, *args, **kwargs):
        creating = self._state.adding
        current_user_code = _current_audit_user_code()
        current_datetime = _current_audit_datetime()

        if creating:
            if hasattr(self, 'dt_fech_usua_regi'):
                self.dt_fech_usua_regi = current_datetime
            if current_user_code and hasattr(self, 'ch_codi_usua_regi'):
                self.ch_codi_usua_regi = current_user_code
            if hasattr(self, 'dt_fech_usua_modi'):
                self.dt_fech_usua_modi = None
            if hasattr(self, 'ch_codi_usua_modi'):
                self.ch_codi_usua_modi = None
        else:
            previous = type(self).objects.filter(pk=self.pk).values(
                'ch_codi_usua_regi',
                'dt_fech_usua_regi',
            ).first()
            if previous:
                if hasattr(self, 'ch_codi_usua_regi'):
                    self.ch_codi_usua_regi = previous.get('ch_codi_usua_regi')
                if hasattr(self, 'dt_fech_usua_regi'):
                    self.dt_fech_usua_regi = previous.get('dt_fech_usua_regi')
            if hasattr(self, 'dt_fech_usua_modi'):
                self.dt_fech_usua_modi = current_datetime
            if current_user_code and hasattr(self, 'ch_codi_usua_modi'):
                self.ch_codi_usua_modi = current_user_code

        super().save(*args, **kwargs)


# ---------------------------------------------------------------------------
# MAESTRAS BASE
# ---------------------------------------------------------------------------

class MaeSistema(models.Model):
    """Sistema al que pertenecen los módulos y opciones."""
    ch_codi_sistema = models.CharField(max_length=3, primary_key=True)
    vc_desl_sistema = models.CharField(max_length=50, null=True, blank=True)
    vc_desc_sistema = models.CharField(max_length=30, null=True, blank=True)
    ch_esta_sistema = models.CharField(max_length=1, null=True, blank=True)
    vc_desc_logo = models.CharField(max_length=50, null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)

    class Meta:
        db_table = 'MAE_SISTEMA'
        verbose_name = 'Sistema'

    def __str__(self):
        return f'{self.ch_codi_sistema} – {self.vc_desc_sistema}'


class MaeModulo(models.Model):
    """Módulo dentro de un sistema."""
    # Clave primaria compuesta (sistema + módulo)
    ch_codi_sistema = models.ForeignKey(
        MaeSistema,
        on_delete=models.PROTECT,
        db_column='CH_CODI_SISTEMA',
        to_field='ch_codi_sistema',
    )
    ch_codi_modulo = models.CharField(max_length=3)
    vc_desc_modulo = models.CharField(max_length=50, null=True, blank=True)
    ch_esta_modulo = models.CharField(max_length=1, null=True, blank=True)

    class Meta:
        db_table = 'MAE_MODULO'
        unique_together = [('ch_codi_sistema', 'ch_codi_modulo')]
        verbose_name = 'Módulo'

    def __str__(self):
        return f'{self.ch_codi_sistema_id}/{self.ch_codi_modulo} – {self.vc_desc_modulo}'


class MaeOpcion(models.Model):
    """Opción / pantalla dentro de un módulo."""
    ch_codi_sistema = models.CharField(max_length=3)
    ch_codi_modulo_fk = models.ForeignKey(
        MaeModulo,
        on_delete=models.PROTECT,
        db_column='CH_CODI_MODULO_FK_ID',  # columna en BD
        related_name='opciones',
        # Sin to_field → apunta a la PK (id autoincremental)
    )
    ch_codi_opcion = models.CharField(max_length=2)
    vc_desc_opcion = models.CharField(max_length=50, null=True, blank=True)
    vc_desc_nom_ventana = models.CharField(max_length=50, null=True, blank=True)
    vc_tipo_opcion = models.CharField(max_length=3, null=True, blank=True)
    vc_desc_icono_opcion = models.CharField(max_length=50, null=True, blank=True)
    vc_desc_responsable = models.CharField(max_length=50, null=True, blank=True)
    dt_fech_creacion_opcion = models.DateTimeField(null=True, blank=True)
    dt_fech_mod_opcion = models.DateTimeField(null=True, blank=True)
    ch_esta_parametro = models.CharField(max_length=1, null=True, blank=True)
    ch_esta_opcion = models.CharField(max_length=1, null=True, blank=True)
    ch_desc_nom_corto = models.CharField(max_length=50, null=True, blank=True)
    ch_ruta_programa = models.CharField(max_length=50, null=True, blank=True)
    ch_esta_opcion_internet = models.CharField(max_length=1, null=True, blank=True)
    ch_ind_original = models.CharField(max_length=1, null=True, blank=True)

    class Meta:
        db_table = 'MAE_OPCION'
        unique_together = [('ch_codi_sistema', 'ch_codi_modulo_fk', 'ch_codi_opcion')]
        verbose_name = 'Opción'

    def __str__(self):
        return f'{self.ch_codi_sistema}/{self.ch_codi_modulo_fk_id}/{self.ch_codi_opcion}'


class MaePerfil(models.Model):
    """Perfil de seguridad asignable a usuarios."""
    ch_codi_perfil = models.CharField(max_length=3, primary_key=True)
    vc_desc_perfil = models.CharField(max_length=50, null=True, blank=True)
    ch_esta_perfil = models.CharField(max_length=1, null=True, blank=True)

    class Meta:
        db_table = 'MAE_PERFIL'
        verbose_name = 'Perfil'

    def __str__(self):
        return f'{self.ch_codi_perfil} – {self.vc_desc_perfil}'


class AdmPerfilOpciones(models.Model):
    """
    Asignación de opciones a perfiles.
    Relaciones:
      → MAE_PERFIL (ch_codi_perfil)
      → MAE_OPCION (sistema + modulo + opcion)
    """
    ch_codi_sistema = models.CharField(max_length=3)
    ch_codi_modulo = models.CharField(max_length=3)
    ch_codi_opcion = models.CharField(max_length=2)
    ch_codi_perfil = models.ForeignKey(
        MaePerfil,
        on_delete=models.PROTECT,
        db_column='CH_CODI_PERFIL',
        to_field='ch_codi_perfil',
        related_name='opciones_perfil',
    )
    # Nota: la FK compuesta a MAE_OPCION se representa con los tres campos anteriores.
    # Para navegación directa, utilice un manager o una propiedad que filtre MaeOpcion.

    class Meta:
        db_table = 'ADM_PERFIL_OPCIONES'
        unique_together = [('ch_codi_sistema', 'ch_codi_modulo', 'ch_codi_opcion', 'ch_codi_perfil')]
        verbose_name = 'Perfil – Opción'


class MaeUsuario(models.Model):
    """Usuario del sistema."""
    ch_codi_usuario = models.CharField(max_length=20, primary_key=True)
    vc_desc_nomb_usuario = models.CharField(max_length=30, null=True, blank=True)
    ch_codi_centro = models.CharField(max_length=4, null=True, blank=True)
    vc_desc_apell_paterno = models.CharField(max_length=30, null=True, blank=True)
    vc_desc_apell_materno = models.CharField(max_length=30, null=True, blank=True)
    vc_desc_email_usuario = models.CharField(max_length=30, null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)
    vc_host_conexion = models.CharField(max_length=30, null=True, blank=True)
    ch_esta_conexion = models.CharField(max_length=1, null=True, blank=True)
    ch_pass_usua = models.CharField(max_length=10, null=True, blank=True)
    ch_codi_usua = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_ulti_actu = models.DateTimeField(null=True, blank=True)
    ch_codi_cta_upch = models.CharField(max_length=15, null=True, blank=True) # No usado
    ch_esta_programa_todos = models.CharField(max_length=1, null=True, blank=True)
    ch_esta_horas_extra = models.CharField(max_length=1, null=True, blank=True)
    ch_esta_autoriza = models.CharField(max_length=1, null=True, blank=True)
    ch_tipo_usuario = models.CharField(max_length=1, null=True, blank=True) # No usado
    ch_pass_usua2 = models.CharField(max_length=10, null=True, blank=True) # No usado

    class Meta:
        db_table = 'MAE_USUARIO'
        verbose_name = 'Usuario'

    def __str__(self):
        return f'{self.ch_codi_usuario} – {self.vc_desc_nomb_usuario}'

    @property
    def is_authenticated(self):
        return True

    @property
    def is_anonymous(self):
        return False

    @property
    def username(self):
        return self.ch_codi_usuario

    @classmethod
    def generar_codigo_interno(cls):
        ultimo = (
            cls.objects.exclude(ch_codi_usua__isnull=True)
            .exclude(ch_codi_usua__exact='')
            .order_by('-ch_codi_usua')
            .values_list('ch_codi_usua', flat=True)
            .first()
        )
        if ultimo and str(ultimo).isdigit():
            return str(int(ultimo) + 1).zfill(max(len(str(ultimo)), 3))
        return '001'

    def save(self, *args, **kwargs):
        if not self.ch_codi_usua:
            self.ch_codi_usua = self.generar_codigo_interno()
        now = timezone.now()
        self.dt_fech_ulti_actu = timezone.localtime(now) if timezone.is_aware(now) else now
        super().save(*args, **kwargs)


class MaePerfilMaeUsuario(models.Model):
    """
    Asignación de perfiles a usuarios (tabla intermedia M2M con datos extra).
    Relaciones:
      → MAE_PERFIL (ch_codi_perfil)
      → MAE_USUARIO (ch_codi_usuario)
    """
    ch_codi_usuario = models.ForeignKey(
        MaeUsuario,
        on_delete=models.PROTECT,
        db_column='CH_CODI_USUARIO',
        to_field='ch_codi_usuario',
        related_name='perfiles',
    )
    ch_codi_perfil = models.ForeignKey(
        MaePerfil,
        on_delete=models.PROTECT,
        db_column='CH_CODI_PERFIL',
        to_field='ch_codi_perfil',
        related_name='usuarios',
    )
    ch_nume_asigna = models.CharField(max_length=3)
    dt_fech_asigna = models.DateTimeField(null=True, blank=True)
    ch_codi_usua_asigna = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_revoca = models.DateTimeField(null=True, blank=True)
    ch_codi_usua_revoca = models.CharField(max_length=15, null=True, blank=True)
    ch_esta_perfil_usua = models.CharField(max_length=1, null=True, blank=True)

    class Meta:
        db_table = 'MAE_PERFIL_MAE_USUARIO'
        unique_together = [('ch_codi_usuario', 'ch_codi_perfil', 'ch_nume_asigna')]
        verbose_name = 'Perfil – Usuario'


# ---------------------------------------------------------------------------
# MAESTRAS OPERATIVAS
# ---------------------------------------------------------------------------

class MaeGarita(AuditFieldsMixin, models.Model):
    """Garita / punto de control."""
    ch_codi_garita = models.CharField(max_length=3, primary_key=True)
    vc_desc_garita = models.CharField(max_length=50, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)

    class Meta:
        db_table = 'MAE_GARITA'
        verbose_name = 'Garita'

    def __str__(self):
        return f'{self.ch_codi_garita} – {self.vc_desc_garita}'

    def save(self, *args, **kwargs):
        if not self.ch_codi_garita:
            self.ch_codi_garita = DEFAULT_GARITA_CODE
        if self.ch_codi_garita == DEFAULT_GARITA_CODE:
            self.vc_desc_garita = DEFAULT_GARITA_DESC
            if self.ch_esta_activo is None:
                self.ch_esta_activo = True
        super().save(*args, **kwargs)


class MaeGaritaXUsuario(AuditFieldsMixin, models.Model):
    """
    Asignación de usuarios a garitas.
    Relaciones:
      → MAE_GARITA (ch_codi_garita)
      → MAE_USUARIO (ch_codi_usuario)
    """
    ch_codi_garita = models.ForeignKey(
        MaeGarita,
        on_delete=models.PROTECT,
        db_column='ch_codi_garita',
        to_field='ch_codi_garita',
        related_name='usuarios_garita',
    )
    ch_codi_usuario = models.ForeignKey(
        MaeUsuario,
        on_delete=models.PROTECT,
        db_column='ch_codi_usuario',
        to_field='ch_codi_usuario',
        related_name='garitas',
    )
    ch_esta_activo = models.BooleanField(null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'mae_garita_x_usuario'
        unique_together = [('ch_codi_garita', 'ch_codi_usuario')]
        verbose_name = 'Garita × Usuario'


class MaeCliente(AuditFieldsMixin, models.Model):
    """Cliente corporativo o particular."""
    ch_codi_cliente = models.CharField(max_length=4, primary_key=True)
    ch_ruc_cliente = models.CharField(max_length=11, null=True, blank=True)
    vc_razo_soci_cliente = models.CharField(max_length=100, null=True, blank=True)
    vc_dire_cliente = models.CharField(max_length=100, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)
    ch_esta_cliente_vip = models.BooleanField(null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)
    ch_esta_tarifa_unica = models.CharField(max_length=1, null=True, blank=True)
    nu_impo_tarifa = models.DecimalField(max_digits=13, decimal_places=3, null=True, blank=True)

    class Meta:
        db_table = 'MAE_CLIENTE'
        verbose_name = 'Cliente'

    def __str__(self):
        return f'{self.ch_codi_cliente} – {self.vc_razo_soci_cliente}'

    def save(self, *args, **kwargs):
        if self.pk:
            _preserve_existing_code(self, 'ch_codi_cliente')
        elif not self.ch_codi_cliente:
            self.ch_codi_cliente = _next_numeric_code(MaeCliente, 'ch_codi_cliente', 4, prefix='C')
        super().save(*args, **kwargs)


class MaeChofer(AuditFieldsMixin, models.Model):
    """Conductor registrado."""
    ch_codi_chofer = models.CharField(max_length=4, primary_key=True)
    vc_desc_chofer = models.CharField(max_length=100, null=True, blank=True)
    ch_nume_celu = models.CharField(max_length=20, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)
    vc_dire_chofer = models.CharField(max_length=100, null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)
    ch_nume_dni = models.CharField(max_length=15, null=True, blank=True)

    class Meta:
        db_table = 'MAE_CHOFER'
        verbose_name = 'Chofer'

    def __str__(self):
        return f'{self.ch_codi_chofer} – {self.vc_desc_chofer}'

    def save(self, *args, **kwargs):
        if self.pk:
            _preserve_existing_code(self, 'ch_codi_chofer')
        elif not self.ch_codi_chofer:
            self.ch_codi_chofer = _next_numeric_code(MaeChofer, 'ch_codi_chofer', 4, prefix='C')
        super().save(*args, **kwargs)


class MaeTipoVehiculo(AuditFieldsMixin, models.Model):
    """Tipo / categoría de vehículo."""
    ch_tipo_vehiculo = models.CharField(max_length=2, primary_key=True)
    vc_desc_tipo_vehiculo = models.CharField(max_length=50, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)

    class Meta:
        db_table = 'MAE_TIPO_VEHICULO'
        verbose_name = 'Tipo de Vehículo'

    def __str__(self):
        return f'{self.ch_tipo_vehiculo} – {self.vc_desc_tipo_vehiculo}'

    def save(self, *args, **kwargs):
        if self.pk:
            _preserve_existing_code(self, 'ch_tipo_vehiculo')
        elif not self.ch_tipo_vehiculo:
            self.ch_tipo_vehiculo = _next_numeric_code(MaeTipoVehiculo, 'ch_tipo_vehiculo', 2)
        super().save(*args, **kwargs)


class MaeVehiculo(AuditFieldsMixin, models.Model):
    """
    Vehículo registrado.
    Relaciones:
      → MAE_TIPO_VEHICULO (ch_tipo_vehiculo)
      → MAE_CLIENTE       (ch_codi_cliente)
      → MAE_CHOFER        (ch_codi_chofer)
    """
    ch_codi_vehiculo = models.CharField(max_length=6, primary_key=True)
    ch_plac_vehiculo = models.CharField(max_length=20, null=True, blank=True)
    ch_tipo_vehiculo = models.ForeignKey(
        MaeTipoVehiculo,
        on_delete=models.PROTECT,
        db_column='CH_TIPO_VEHICULO',
        to_field='ch_tipo_vehiculo',
        null=True, blank=True,
        related_name='vehiculos',
    )
    ch_codi_cliente = models.ForeignKey(
        MaeCliente,
        on_delete=models.PROTECT,
        db_column='CH_CODI_CLIENTE',
        to_field='ch_codi_cliente',
        null=True, blank=True,
        related_name='vehiculos',
    )
    ch_codi_chofer = models.ForeignKey(
        MaeChofer,
        on_delete=models.PROTECT,
        db_column='CH_CODI_CHOFER',
        to_field='ch_codi_chofer',
        null=True, blank=True,
        related_name='vehiculos',
    )
    nu_nume_llanta = models.IntegerField(null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)
    ch_esta_parqueado = models.BooleanField(null=True, blank=True)
    nu_impo_alquiler = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)

    class Meta:
        db_table = 'MAE_VEHICULO'
        verbose_name = 'Vehículo'

    def __str__(self):
        return f'{self.ch_codi_vehiculo} – {self.ch_plac_vehiculo}'

    def save(self, *args, **kwargs):
        if self.pk:
            _preserve_existing_code(self, 'ch_codi_vehiculo')
        elif not self.ch_codi_vehiculo:
            self.ch_codi_vehiculo = _next_numeric_code(MaeVehiculo, 'ch_codi_vehiculo', 6, prefix='V')
        self.ch_plac_vehiculo = normalize_vehicle_plate(self.ch_plac_vehiculo)
        super().save(*args, **kwargs)


class MaeTipoIncidente(AuditFieldsMixin, models.Model):
    """Tipo de incidente registrable en tickets."""
    ch_codi_tipo_incidente = models.CharField(max_length=3, primary_key=True)
    vc_desc_tipo_incidente = models.CharField(max_length=50, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)

    class Meta:
        db_table = 'MAE_TIPO_INCIDENTE'
        verbose_name = 'Tipo de Incidente'

    def __str__(self):
        return f'{self.ch_codi_tipo_incidente} – {self.vc_desc_tipo_incidente}'

    def save(self, *args, **kwargs):
        if self.pk:
            _preserve_existing_code(self, 'ch_codi_tipo_incidente')
        elif not self.ch_codi_tipo_incidente:
            self.ch_codi_tipo_incidente = _next_numeric_code(MaeTipoIncidente, 'ch_codi_tipo_incidente', 3, prefix='N')
        super().save(*args, **kwargs)


class MaeTipoEgreso(AuditFieldsMixin, models.Model):
    """Categoría de egreso de caja."""
    ch_codi_tipo_egreso = models.CharField(max_length=3, primary_key=True)
    vc_desc_tipo_egreso = models.CharField(max_length=50, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)

    class Meta:
        db_table = 'MAE_TIPO_EGRESO'
        verbose_name = 'Tipo de Egreso'

    def __str__(self):
        return f'{self.ch_codi_tipo_egreso} – {self.vc_desc_tipo_egreso}'

    def save(self, *args, **kwargs):
        if self.pk:
            _preserve_existing_code(self, 'ch_codi_tipo_egreso')
        elif not self.ch_codi_tipo_egreso:
            self.ch_codi_tipo_egreso = _next_numeric_code(MaeTipoEgreso, 'ch_codi_tipo_egreso', 3, prefix='E')
        super().save(*args, **kwargs)


class MaeTipoIngreso(AuditFieldsMixin, models.Model):
    """Categoría de ingreso de caja."""
    ch_codi_tipo_ingreso = models.CharField(max_length=3, primary_key=True)
    vc_desc_tipo_ingreso = models.CharField(max_length=50, null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'MAE_TIPO_INGRESO'
        verbose_name = 'Tipo de Ingreso'

    def __str__(self):
        return f'{self.ch_codi_tipo_ingreso} – {self.vc_desc_tipo_ingreso}'

    def save(self, *args, **kwargs):
        if self.pk:
            _preserve_existing_code(self, 'ch_codi_tipo_ingreso')
        elif not self.ch_codi_tipo_ingreso:
            self.ch_codi_tipo_ingreso = _next_numeric_code(MaeTipoIngreso, 'ch_codi_tipo_ingreso', 3, prefix='I')
        super().save(*args, **kwargs)


class MaeTipoDocumento(AuditFieldsMixin, models.Model):
    """Tipo de documento fiscal/comercial (boleta, factura, etc.)."""
    ch_codi_tipo_dcmnt = models.CharField(max_length=2, primary_key=True)
    vc_desc_tipo_dcmnt = models.CharField(max_length=30, null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'MAE_TIPO_DOCUMENTO'
        verbose_name = 'Tipo de Documento'

    def __str__(self):
        return f'{self.ch_codi_tipo_dcmnt} – {self.vc_desc_tipo_dcmnt}'


class MaeCorrelativo(AuditFieldsMixin, models.Model):
    """
    Correlativos de series/números por tipo de documento.
    Relaciones:
      → MAE_TIPO_DOCUMENTO (ch_codi_tipo_dcmnt)
    """
    ch_codi_correlativo = models.CharField(max_length=4, primary_key=True)
    ch_codi_tipo_dcmnt = models.ForeignKey(
        MaeTipoDocumento,
        on_delete=models.PROTECT,
        db_column='CH_CODI_TIPO_DCMNT',
        to_field='ch_codi_tipo_dcmnt',
        null=True, blank=True,
        related_name='correlativos',
    )
    ch_seri_actual = models.CharField(max_length=4, null=True, blank=True)
    ch_nume_actual = models.CharField(max_length=10, null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'MAE_CORRELATIVO'
        verbose_name = 'Correlativo'


class MaeProveedor(AuditFieldsMixin, models.Model):
    """Proveedor para egresos de caja."""
    ch_codi_proveedor = models.CharField(max_length=4, primary_key=True)
    vc_razo_soci_prov = models.CharField(max_length=100, null=True, blank=True)
    ch_ruc_prov = models.CharField(max_length=11, null=True, blank=True)
    vc_dire_prov = models.CharField(max_length=100, null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'MAE_PROVEEDOR'
        verbose_name = 'Proveedor'

    def __str__(self):
        return f'{self.ch_codi_proveedor} – {self.vc_razo_soci_prov}'

    def save(self, *args, **kwargs):
        if self.pk:
            _preserve_existing_code(self, 'ch_codi_proveedor')
        elif not self.ch_codi_proveedor:
            self.ch_codi_proveedor = _next_numeric_code(MaeProveedor, 'ch_codi_proveedor', 4, prefix='P')
        super().save(*args, **kwargs)


class MaeVariable(models.Model):
    """Variables de configuración del sistema."""
    ch_codi_variable = models.CharField(max_length=2, primary_key=True)
    vc_desc_variable = models.CharField(max_length=70, null=True, blank=True)
    nu_nume_valor = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)
    dt_fech_ulti_actu = models.DateTimeField(null=True, blank=True)
    ch_codi_usua = models.CharField(max_length=15, null=True, blank=True)
    ch_valo_variable = models.CharField(max_length=10, null=True, blank=True)
    nu_nume_valo_desde = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    nu_nume_valo_hasta = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    ch_nume_valo_desde = models.CharField(max_length=10, null=True, blank=True)
    ch_nume_valo_hasta = models.CharField(max_length=10, null=True, blank=True)

    class Meta:
        db_table = 'MAE_VARIABLE'
        verbose_name = 'Variable'

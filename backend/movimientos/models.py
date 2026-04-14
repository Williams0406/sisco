"""
models.py — App movimientos
Basado en el models.py original de BD_SISCO
"""
from datetime import datetime, time, timedelta
from decimal import Decimal
from django.db import models, transaction
from django.db.models import Max, Sum
from django.core.exceptions import ValidationError
from django.utils import timezone
from maestros.models import (
    AuditFieldsMixin,
    MaeCliente, MaeChofer, MaeTipoVehiculo, MaeVehiculo, MaeUsuario,
    MaeTipoIncidente, MaeTipoEgreso, MaeTipoIngreso,
    MaeGarita, MaeProveedor, ensure_default_garita, DEFAULT_GARITA_CODE,
)


ZERO = Decimal('0.000')
IGV_FACTOR = Decimal('1.18')
IGV_RATE = Decimal('0.18')


def _decimal_or_zero(value):
    if value in (None, ''):
        return ZERO
    return Decimal(str(value))


def _is_true_flag(value):
    return str(value).strip().lower() in {'1', 'true', 't', 'yes', 'si'}


def _validate_personal_cajero_code(codigo, field_name='ch_codi_cajero'):
    if codigo in (None, ''):
        return

    exists = (
        MaeUsuario.objects.filter(
            ch_codi_usuario=codigo,
            ch_esta_activo=True,
            perfiles__ch_esta_perfil_usua='1',
            perfiles__ch_codi_perfil_id='PER',
        )
        .distinct()
        .exists()
    )
    if not exists:
        raise ValidationError({
            field_name: 'Debe corresponder a un usuario activo con perfil Personal.'
        })


def _default_garita_code():
    return ensure_default_garita().ch_codi_garita


def _credit_tracking_tickets_queryset():
    return MovTicket.objects.filter(
        models.Q(dt_fech_salida__isnull=False) | models.Q(dt_fech_ingreso__isnull=False)
    )


def _next_prefixed_code(model_cls, field_name, prefix, width=3):
    values = model_cls.objects.filter(**{f'{field_name}__startswith': prefix}).values_list(field_name, flat=True)
    max_num = 0
    for value in values:
        suffix = str(value)[len(prefix):]
        if suffix.isdigit():
            max_num = max(max_num, int(suffix))
    return f'{prefix}{str(max_num + 1).zfill(width)}'


def _next_series_and_number(model_cls, series_field, number_field, default_series='0001', number_width=7):
    last = (
        model_cls.objects.exclude(**{number_field: None})
        .exclude(**{number_field: ''})
        .order_by(f'-{number_field}')
        .values(series_field, number_field)
        .first()
    )
    series = default_series
    next_number = 1
    if last:
        series = last.get(series_field) or default_series
        current_number = str(last.get(number_field) or '')
        if current_number.isdigit():
            next_number = int(current_number) + 1
    return series, str(next_number).zfill(number_width)


def _preserve_existing_fields(instance, field_names):
    if not instance.pk:
        return
    previous = type(instance).objects.filter(pk=instance.pk).values(*field_names).first()
    if not previous:
        return
    for field_name in field_names:
        setattr(instance, field_name, previous.get(field_name))


def _build_shift_interval(base_date, start_time, end_time):
    start_dt = datetime.combine(base_date, start_time)
    end_dt = datetime.combine(base_date, end_time)
    if end_dt <= start_dt:
        end_dt += timedelta(days=1)
    return start_dt, end_dt


def _get_active_shift_config():
    config_turno = ConfiguracionTurno.objects.filter(ch_esta_activo='1').order_by('nu_codi_config_turno').first()
    if not config_turno:
        config_turno = ConfiguracionTurno.objects.order_by('nu_codi_config_turno').first()
    return config_turno or ConfiguracionTurno()


def _time_is_within_range(reference_time, start_time, end_time):
    if start_time <= end_time:
        return start_time <= reference_time < end_time
    return reference_time >= start_time or reference_time < end_time


def _resolve_turno_caja(reference_dt):
    if not reference_dt:
        return None

    config_turno = _get_active_shift_config()
    reference_time = reference_dt.time()

    if _time_is_within_range(reference_time, config_turno.tm_hora_inicio_dia, config_turno.tm_hora_fin_dia):
        return 'dia'
    if _time_is_within_range(reference_time, config_turno.tm_hora_inicio_noche, config_turno.tm_hora_fin_noche):
        return 'noche'
    return None


def _resolve_turno_bucket(reference_dt):
    if not reference_dt:
        return None, None

    config_turno = _get_active_shift_config()
    turno = _resolve_turno_caja(reference_dt)
    if not turno:
        return None, None

    shift_start_time = config_turno.tm_hora_inicio_dia if turno == 'dia' else config_turno.tm_hora_inicio_noche
    bucket_date = reference_dt.date()
    if turno == 'noche' and config_turno.tm_hora_inicio_noche > config_turno.tm_hora_fin_noche:
        if reference_dt.time() < config_turno.tm_hora_inicio_dia:
            bucket_date -= timedelta(days=1)
    bucket_dt = datetime.combine(bucket_date, shift_start_time)
    return turno, bucket_dt


def _matches_shift_bucket(reference_dt, shift_date, shift_code):
    if not reference_dt or not shift_date or not shift_code:
        return False
    bucket_code, bucket_dt = _resolve_turno_bucket(reference_dt)
    if not bucket_code or not bucket_dt:
        return False
    return bucket_dt.date() == shift_date and bucket_code == shift_code


def _shift_related_dates(shift_date):
    if not shift_date:
        return []
    return [shift_date, shift_date + timedelta(days=1)]


def _ticket_credit_applies_to_shift(ticket, shift_bucket_dt):
    if not ticket or not shift_bucket_dt:
        return False

    start_reference = ticket.dt_fech_salida or ticket.dt_fech_ingreso
    start_code, start_bucket_dt = _resolve_turno_bucket(start_reference)
    if not start_code or not start_bucket_dt:
        return False

    end_reference = ticket.dt_fech_cancelado
    if end_reference:
        end_code, end_bucket_dt = _resolve_turno_bucket(end_reference)
        if not end_code or not end_bucket_dt:
            end_bucket_dt = shift_bucket_dt
    else:
        end_bucket_dt = shift_bucket_dt

    if end_bucket_dt < start_bucket_dt:
        return False

    if end_reference:
        return start_bucket_dt <= shift_bucket_dt < end_bucket_dt
    return start_bucket_dt <= shift_bucket_dt <= end_bucket_dt


def _next_detail_number(cabecera):
    max_value = (
        DetCobranzaCredito.objects
        .filter(nu_codi_cobr_cred=cabecera)
        .aggregate(max_num=Max('nu_codi_detalle'))
        .get('max_num')
    )
    return int(max_value or 0) + 1


def _recalculate_cobranza_credito(cabecera):
    total = (
        DetCobranzaCredito.objects
        .filter(nu_codi_cobr_cred=cabecera, ch_esta_activo='1')
        .aggregate(total=Sum('nu_impo_cobr'))
        .get('total')
    ) or ZERO
    cabecera.nu_impo_total = _decimal_or_zero(total)
    if cabecera.nu_impo_total > ZERO:
        cabecera.ch_esta_activo = '1'
    elif cabecera.ch_esta_activo not in (None, ''):
        cabecera.ch_esta_activo = '0'
    cabecera.save(update_fields=['nu_impo_total', 'ch_esta_activo'])


def _same_day_cobranza_header(cliente_id, reference_dt):
    if not cliente_id or not reference_dt:
        return None
    return (
        CabCobranzaCredito.objects
        .filter(
            ch_codi_cliente_id=cliente_id,
            ch_esta_activo='1',
            dt_fech_cobr__date=reference_dt.date(),
        )
        .order_by('-nu_codi_cobr_cred')
        .first()
    )


def _ensure_daily_cierre_turno(shift_datetime, defaults=None):
    if not shift_datetime:
        return None

    shift_code, bucket_datetime = _resolve_turno_bucket(shift_datetime)
    if not shift_code or not bucket_datetime:
        return None

    shift_date = bucket_datetime.date()
    defaults = defaults or {}
    if defaults.get('ch_codi_garita') in (None, ''):
        defaults['ch_codi_garita'] = _default_garita_code()

    cierre = (
        CabCierreTurno.objects
        .filter(dt_fech_turno__date=shift_date, ch_codi_turno_caja=shift_code)
        .order_by('nu_codi_cierre')
        .first()
    )
    if cierre:
        for field_name, value in defaults.items():
            if value not in (None, '') and getattr(cierre, field_name) in (None, ''):
                setattr(cierre, field_name, value)
        cierre.ch_codi_turno_caja = shift_code
        cierre.save()
        return cierre

    cierre = CabCierreTurno(
        dt_fech_turno=bucket_datetime,
        ch_codi_turno_caja=shift_code,
        ch_esta_activo=defaults.get('ch_esta_activo', '1'),
        ch_tipo_cierre=defaults.get('ch_tipo_cierre', 'T'),
        ch_codi_cajero=defaults.get('ch_codi_cajero'),
        ch_codi_garita=defaults.get('ch_codi_garita'),
        nu_impo_tota_efectivo=defaults.get('nu_impo_tota_efectivo'),
        vc_obse_cierre=defaults.get('vc_obse_cierre'),
    )
    cierre.save()
    return cierre


# ---------------------------------------------------------------------------
# TARIFARIO
# ---------------------------------------------------------------------------

class DetTarifario(AuditFieldsMixin, models.Model):
    """Tarifario de estacionamiento por tipo de vehículo y cliente."""
    ch_codi_tarifario = models.CharField(max_length=6, primary_key=True)
    vc_desc_tarifario = models.CharField(max_length=50, null=True, blank=True)
    ch_tipo_vehiculo = models.ForeignKey(
        MaeTipoVehiculo,
        on_delete=models.PROTECT,
        db_column='CH_TIPO_VEHICULO',
        to_field='ch_tipo_vehiculo',
        null=True, blank=True,
        related_name='tarifarios',
    )
    ch_codi_cliente = models.ForeignKey(
        MaeCliente,
        on_delete=models.PROTECT,
        db_column='CH_CODI_CLIENTE',
        to_field='ch_codi_cliente',
        null=True, blank=True,
        related_name='tarifarios',
    )
    nu_impo_dia = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_noche = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_frccn_dia = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_frccn_noche = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_nume_hora_tlrnc = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_nume_hora_frccn = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    ch_tipo_cmprbnt = models.CharField(max_length=2, null=True, blank=True)
    ch_esta_activo = models.CharField(max_length=1, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'DET_TARIFARIO'
        verbose_name = 'Tarifario'

    def __str__(self):
        return f'{self.ch_codi_tarifario} – {self.vc_desc_tarifario}'

    def save(self, *args, **kwargs):
        if self.pk:
            _preserve_existing_fields(self, ['ch_codi_tarifario'])
        elif not self.ch_codi_tarifario:
            self.ch_codi_tarifario = _next_prefixed_code(type(self), 'ch_codi_tarifario', 'TAR', 3)
        super().save(*args, **kwargs)

class ConfiguracionTurno(models.Model):
    """Configuracion global de horarios de turno para el calculo de tickets."""
    nu_codi_config_turno = models.AutoField(primary_key=True)
    tm_hora_inicio_dia = models.TimeField(db_column='TM_HORA_INICIO_DIA', default=time(7, 0))
    tm_hora_fin_dia = models.TimeField(db_column='TM_HORA_FIN_DIA', default=time(19, 0))
    tm_hora_inicio_noche = models.TimeField(db_column='TM_HORA_INICIO_NOCHE', default=time(19, 0))
    tm_hora_fin_noche = models.TimeField(db_column='TM_HORA_FIN_NOCHE', default=time(7, 0))
    ch_esta_activo = models.CharField(max_length=1, null=True, blank=True, default='1')

    class Meta:
        db_table = 'CAB_CONFIG_TURNO'
        verbose_name = 'Configuracion de Turno'

    def __str__(self):
        return f'Config turno #{self.nu_codi_config_turno}'

    def get_shift_intervals(self, start_dt, end_dt):
        # Turno dia: desde tm_hora_inicio_dia hasta tm_hora_fin_dia del mismo dia.
        # Turno noche: desde tm_hora_inicio_noche del mismo dia hasta tm_hora_fin_noche del dia siguiente.
        start_anchor = (start_dt - timedelta(days=1)).date()
        end_anchor = (end_dt + timedelta(days=1)).date()
        current = start_anchor
        intervals = []

        while current <= end_anchor:
            dia_start, dia_end = _build_shift_interval(current, self.tm_hora_inicio_dia, self.tm_hora_fin_dia)
            noche_start, noche_end = _build_shift_interval(current, self.tm_hora_inicio_noche, self.tm_hora_fin_noche)

            intervals.append(('dia', dia_start.replace(tzinfo=start_dt.tzinfo), dia_end.replace(tzinfo=start_dt.tzinfo)))
            intervals.append(('noche', noche_start.replace(tzinfo=start_dt.tzinfo), noche_end.replace(tzinfo=start_dt.tzinfo)))
            current += timedelta(days=1)

        intervals.sort(key=lambda item: item[1])
        return intervals


# ---------------------------------------------------------------------------
# TICKET
# ---------------------------------------------------------------------------

class MovTicket(AuditFieldsMixin, models.Model):
    """Ticket de ingreso/salida de vehículo. Tabla central del sistema."""
    nu_codi_ticket = models.AutoField(primary_key=True)
    ch_codi_garita = models.ForeignKey(
        MaeGarita,
        on_delete=models.PROTECT,
        db_column='CH_CODI_GARITA',
        to_field='ch_codi_garita',
        null=True, blank=True,
        related_name='tickets',
    )
    dt_fech_emision = models.DateTimeField(null=True, blank=True)
    dt_fech_turno = models.DateTimeField(null=True, blank=True)
    ch_codi_turno_caja = models.CharField(max_length=5, null=True, blank=True)
    ch_codi_vehiculo = models.ForeignKey(
        MaeVehiculo,
        on_delete=models.PROTECT,
        db_column='CH_CODI_VEHICULO',
        to_field='ch_codi_vehiculo',
        null=True, blank=True,
        related_name='tickets',
    )
    ch_codi_cliente = models.ForeignKey(
        MaeCliente,
        on_delete=models.PROTECT,
        db_column='CH_CODI_CLIENTE',
        to_field='ch_codi_cliente',
        null=True, blank=True,
        related_name='tickets',
    )
    ch_codi_chofer = models.ForeignKey(
        MaeChofer,
        on_delete=models.PROTECT,
        db_column='CH_CODI_CHOFER',
        to_field='ch_codi_chofer',
        null=True, blank=True,
        related_name='tickets',
    )
    ch_codi_tarifario = models.ForeignKey(
        DetTarifario,
        on_delete=models.PROTECT,
        db_column='CH_CODI_TARIFARIO',
        to_field='ch_codi_tarifario',
        null=True, blank=True,
        related_name='tickets',
    )
    ch_codi_tipo_incidente = models.ForeignKey(
        MaeTipoIncidente,
        on_delete=models.PROTECT,
        db_column='CH_CODI_TIPO_INCIDENTE',
        to_field='ch_codi_tipo_incidente',
        null=True, blank=True,
        related_name='tickets',
    )
    dt_fech_ingreso = models.DateTimeField(null=True, blank=True)
    dt_fech_salida = models.DateTimeField(null=True, blank=True)
    ch_nume_telefono = models.CharField(max_length=20, null=True, blank=True)
    ch_esta_duermen = models.CharField(max_length=1, null=True, blank=True)
    ch_esta_llave = models.CharField(max_length=1, null=True, blank=True)
    vc_obse_tckt_ingreso = models.CharField(max_length=100, null=True, blank=True)
    ch_obse_tckt_salida = models.CharField(max_length=100, null=True, blank=True)
    ch_codi_cajero = models.CharField(max_length=15, null=True, blank=True)
    nu_impo_total = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_subtotal = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_saldo = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_dscto = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_dia = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_noche = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_cant_dia = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_cant_noche = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_tota_dia = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_tota_noche = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_dia_frccn = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_noche_frccn = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_cant_dia_frccn = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_cant_noche_frccn = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_paga = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_vuelto = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    ch_tipo_comprobante = models.CharField(max_length=2, null=True, blank=True)
    ch_seri_tckt = models.CharField(max_length=4, null=True, blank=True)
    ch_nume_tckt = models.CharField(max_length=10, null=True, blank=True)
    ch_esta_ticket = models.CharField(max_length=1, null=True, blank=True)
    ch_esta_activo = models.CharField(max_length=1, null=True, blank=True)
    ch_esta_cancelado = models.CharField(max_length=1, null=True, blank=True)
    ch_esta_condicion = models.CharField(max_length=1, null=True, blank=True)
    ch_esta_incidente = models.CharField(max_length=1, null=True, blank=True)
    ch_esta_cliente_vip = models.CharField(max_length=1, null=True, blank=True)
    ch_tipo_vehiculo = models.CharField(max_length=2, null=True, blank=True)
    ch_codi_garita_sld = models.CharField(max_length=3, null=True, blank=True)
    ch_codi_turno_sld = models.CharField(max_length=5, null=True, blank=True)
    ch_codi_cajero_sld = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_dscto = models.CharField(max_length=15, null=True, blank=True)
    vc_desc_dscto = models.CharField(max_length=100, null=True, blank=True)
    dt_fech_cancelado = models.DateTimeField(null=True, blank=True)
    dt_fech_turno_sld = models.DateTimeField(null=True, blank=True)
    dt_fech_emision_sld = models.DateTimeField(null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi_sld = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi_sld = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'MOV_TICKET'
        verbose_name = 'Ticket'

    def __str__(self):
        return f'Ticket #{self.nu_codi_ticket}'

    def _reset_calculated_fields(self):
        self.nu_impo_total = ZERO
        self.nu_impo_subtotal = ZERO
        self.nu_impo_saldo = ZERO
        self.nu_impo_dia = ZERO
        self.nu_impo_noche = ZERO
        self.nu_tota_dia = ZERO
        self.nu_tota_noche = ZERO
        self.nu_cant_dia = ZERO
        self.nu_cant_noche = ZERO
        self.nu_impo_dia_frccn = ZERO
        self.nu_impo_noche_frccn = ZERO
        self.nu_cant_dia_frccn = ZERO
        self.nu_cant_noche_frccn = ZERO

    def _hydrate_vehicle_context(self):
        vehiculo = self.ch_codi_vehiculo
        if not vehiculo:
            return

        if not self.ch_tipo_vehiculo:
            self.ch_tipo_vehiculo = getattr(vehiculo, 'ch_tipo_vehiculo_id', None)
        if not self.ch_codi_cliente_id:
            self.ch_codi_cliente_id = getattr(vehiculo, 'ch_codi_cliente_id', None)
        if not self.ch_codi_chofer_id:
            self.ch_codi_chofer_id = getattr(vehiculo, 'ch_codi_chofer_id', None)

    def _resolve_tarifario(self):
        if self.ch_codi_tarifario:
            return self.ch_codi_tarifario

        vehiculo = self.ch_codi_vehiculo
        if not vehiculo:
            return None

        tipo_vehiculo = self.ch_tipo_vehiculo or getattr(vehiculo, 'ch_tipo_vehiculo_id', None)
        cliente_id = self.ch_codi_cliente_id or getattr(vehiculo, 'ch_codi_cliente_id', None)

        if not tipo_vehiculo:
            return None

        def first_matching_tariff(include_cliente):
            queryset = DetTarifario.objects.filter(ch_tipo_vehiculo=tipo_vehiculo)
            if include_cliente:
                queryset = queryset.filter(ch_codi_cliente=cliente_id)
            prioritized = (
                queryset.filter(ch_esta_activo='1')
                .order_by('ch_codi_tarifario')
                .first()
            )
            if prioritized:
                return prioritized
            return queryset.order_by('ch_codi_tarifario').first()

        tarifario = first_matching_tariff(include_cliente=True) if cliente_id else None
        if not tarifario:
            tarifario = first_matching_tariff(include_cliente=False)

        if tarifario:
            self.ch_codi_tarifario = tarifario
            if not self.ch_tipo_vehiculo:
                self.ch_tipo_vehiculo = tipo_vehiculo
        return tarifario

    def _calculate_tariff_totals(self):
        ingreso = self.dt_fech_ingreso
        salida = self.dt_fech_salida

        self._reset_calculated_fields()

        if not ingreso or not salida or salida <= ingreso:
            return

        config_turno = _get_active_shift_config()

        intervals = [
            item for item in config_turno.get_shift_intervals(ingreso, salida)
            if item[2] > ingreso and item[1] < salida
        ]
        if not intervals:
            return

        tarifario = self._resolve_tarifario()
        if not tarifario:
            return

        tolerance_hours = _decimal_or_zero(tarifario.nu_nume_hora_tlrnc)
        fraction_hours = _decimal_or_zero(tarifario.nu_nume_hora_frccn)
        day_amount = _decimal_or_zero(tarifario.nu_impo_dia)
        night_amount = _decimal_or_zero(tarifario.nu_impo_noche)
        day_fraction_amount = _decimal_or_zero(tarifario.nu_impo_frccn_dia)
        night_fraction_amount = _decimal_or_zero(tarifario.nu_impo_frccn_noche)
        fraction_limit = tolerance_hours + fraction_hours

        # Conteo base:
        # nu_cant_dia / nu_cant_noche = cantidad de veces que el horario de turno
        # (dia o noche) definido en ConfiguracionTurno se repite dentro del rango
        # dt_fech_ingreso – dt_fech_salida del ticket.
        # Se cuenta 1 por cada bloque de turno que tenga cualquier intersección
        # con la permanencia del vehículo (no se exige cobertura total).
        for shift_type, shift_start, shift_end in intervals:
            overlap_start = max(ingreso, shift_start)
            overlap_end = min(salida, shift_end)

            if overlap_end <= overlap_start:
                continue

            # Cualquier intersección > 0 cuenta como una aparición del turno
            elapsed_hours = Decimal(str((overlap_end - overlap_start).total_seconds() / 3600))
            if shift_type == 'dia':
                if elapsed_hours > fraction_limit:
                    self.nu_cant_dia += Decimal('1')
                elif elapsed_hours > tolerance_hours:
                    self.nu_impo_dia_frccn += day_fraction_amount
                    self.nu_cant_dia_frccn += day_fraction_amount
            else:
                if elapsed_hours > fraction_limit:
                    self.nu_cant_noche += Decimal('1')
                elif elapsed_hours > tolerance_hours:
                    self.nu_impo_noche_frccn += night_fraction_amount
                    self.nu_cant_noche_frccn += night_fraction_amount

        self.nu_impo_dia = self.nu_cant_dia * day_amount
        self.nu_impo_noche = self.nu_cant_noche * night_amount
        self.nu_tota_dia = self.nu_impo_dia + self.nu_impo_dia_frccn
        self.nu_tota_noche = self.nu_impo_noche + self.nu_impo_noche_frccn
        self.nu_impo_subtotal = self.nu_tota_dia + self.nu_tota_noche
        self.nu_impo_total = self.nu_impo_subtotal * IGV_FACTOR
        self.nu_impo_saldo = self.nu_impo_total

    def _sync_credit_collection(self):
        related_details = list(
            DetCobranzaCredito.objects.select_related('nu_codi_cobr_cred').filter(nu_codi_ticket=self)
        )
        affected_headers = {detail.nu_codi_cobr_cred for detail in related_details}
        should_include = (
            not _is_true_flag(self.ch_esta_cancelado)
            and bool(self.ch_codi_cliente_id)
            and _decimal_or_zero(self.nu_impo_saldo or self.nu_impo_total) > ZERO
        )

        if not should_include:
            for detail in related_details:
                if detail.ch_esta_activo != '0':
                    detail.ch_esta_activo = '0'
                    detail.save(update_fields=['ch_esta_activo'])
            for header in affected_headers:
                _recalculate_cobranza_credito(header)
            return

        reference_dt = self.dt_fech_salida or timezone.now()
        header = _same_day_cobranza_header(self.ch_codi_cliente_id, reference_dt)
        if not header:
            header = CabCobranzaCredito.objects.create(
                dt_fech_cobr=reference_dt,
                ch_codi_cliente_id=self.ch_codi_cliente_id,
                ch_codi_cajero=self.ch_codi_cajero,
                ch_codi_garita=self.ch_codi_garita_id,
                ch_codi_turno_caja=self.ch_codi_turno_caja,
                dt_fech_turno=self.dt_fech_turno,
                ch_esta_activo='1',
            )

        detail = related_details[0] if related_details else None
        if detail and detail.nu_codi_cobr_cred_id != header.nu_codi_cobr_cred:
            affected_headers.add(detail.nu_codi_cobr_cred)
            detail.nu_codi_cobr_cred = header
            detail.nu_codi_detalle = _next_detail_number(header)
        if not detail:
            detail = DetCobranzaCredito(
                nu_codi_cobr_cred=header,
                nu_codi_detalle=_next_detail_number(header),
                nu_codi_ticket=self,
            )

        detail.nu_impo_cobr = _decimal_or_zero(self.nu_impo_saldo or self.nu_impo_total)
        detail.nu_impo_original = _decimal_or_zero(self.nu_impo_total)
        detail.ch_seri_tckt = self.ch_seri_tckt
        detail.ch_nume_tckt = self.ch_nume_tckt
        detail.ch_plac_vehiculo = getattr(self.ch_codi_vehiculo, 'ch_plac_vehiculo', None)
        detail.ch_esta_activo = '1'
        detail.save()

        affected_headers.add(header)
        for active_header in affected_headers:
            _recalculate_cobranza_credito(active_header)

    def _sync_documento_venta(self, previous_cancelado=False):
        should_create = (
            _is_true_flag(self.ch_esta_cancelado)
            and not previous_cancelado
            and self.ch_esta_ticket == '1'
            and _decimal_or_zero(self.nu_impo_total) > ZERO
        )
        if not should_create:
            return

        emission_dt = timezone.now()
        cobranza_header = _same_day_cobranza_header(self.ch_codi_cliente_id, emission_dt)
        total = _decimal_or_zero(self.nu_impo_total)
        igv = (IGV_RATE * total) / IGV_FACTOR if total else ZERO
        afecto = _decimal_or_zero(self.nu_impo_subtotal)

        defaults = {
            'dt_fech_emision': emission_dt,
            'ch_codi_cliente_id': self.ch_codi_cliente_id,
            'nu_codi_cobr_cred': cobranza_header,
            'ch_tipo_cmprbnt': self.ch_tipo_comprobante,
            'nu_impo_total': total,
            'nu_impo_igv': igv,
            'nu_impo_afecto': afecto,
            'ch_esta_activo': '1',
        }

        cliente = self.ch_codi_cliente
        if cliente:
            defaults['vc_desc_cliente'] = getattr(cliente, 'vc_razo_soci_cliente', None)
            defaults['vc_dire_cliente'] = getattr(cliente, 'vc_dire_cliente', None)
            defaults['ch_ruc_cliente'] = getattr(cliente, 'ch_ruc_cliente', None)

        documento = CabDocumentoVenta.objects.filter(nu_codi_ticket=self).order_by('-nu_codi_docu_vent').first()
        if documento:
            for field_name, value in defaults.items():
                setattr(documento, field_name, value)
            documento.save()
            return

        CabDocumentoVenta.objects.create(
            nu_codi_ticket=self,
            **defaults,
        )

    def save(self, *args, **kwargs):
        paid_amount = ZERO
        previous_cancelado = False
        self._hydrate_vehicle_context()
        turno_caja = _resolve_turno_caja(self.dt_fech_ingreso)
        if turno_caja:
            self.ch_codi_turno_caja = turno_caja
        turno_salida = _resolve_turno_caja(self.dt_fech_salida)
        if turno_salida:
            self.ch_codi_turno_sld = turno_salida
        if self.dt_fech_salida:
            if not self.dt_fech_turno_sld:
                self.dt_fech_turno_sld = self.dt_fech_salida
            if not self.dt_fech_emision_sld:
                self.dt_fech_emision_sld = self.dt_fech_salida
        if self.pk:
            _preserve_existing_fields(self, ['ch_seri_tckt', 'ch_nume_tckt'])
        elif not self.ch_seri_tckt or not self.ch_nume_tckt:
            self.ch_seri_tckt, self.ch_nume_tckt = _next_series_and_number(
                type(self),
                'ch_seri_tckt',
                'ch_nume_tckt',
                default_series='T001',
                number_width=7,
            )
        if self.pk:
            previous = type(self).objects.filter(pk=self.pk).values('nu_impo_total', 'nu_impo_saldo', 'ch_esta_cancelado').first()
            if previous:
                previous_total = _decimal_or_zero(previous.get('nu_impo_total'))
                previous_saldo = _decimal_or_zero(previous.get('nu_impo_saldo'))
                previous_cancelado = _is_true_flag(previous.get('ch_esta_cancelado'))
                paid_amount = previous_total - previous_saldo
                if paid_amount < ZERO:
                    paid_amount = ZERO

        self._calculate_tariff_totals()
        if paid_amount > ZERO:
            saldo = self.nu_impo_total - paid_amount
            self.nu_impo_saldo = saldo if saldo > ZERO else ZERO
        if _is_true_flag(self.ch_esta_cancelado):
            if not self.dt_fech_cancelado:
                self.dt_fech_cancelado = timezone.now()
        else:
            self.dt_fech_cancelado = None
        if not self.ch_codi_garita_id:
            self.ch_codi_garita_id = _default_garita_code()
        _validate_personal_cajero_code(self.ch_codi_cajero, 'ch_codi_cajero')

        with transaction.atomic():
            super().save(*args, **kwargs)
            self._sync_credit_collection()
            self._sync_documento_venta(previous_cancelado=previous_cancelado)
            for target_shift_dt in (self.dt_fech_ingreso, self.dt_fech_salida, self.dt_fech_cancelado):
                _ensure_daily_cierre_turno(
                    target_shift_dt,
                    defaults={
                        'ch_esta_activo': '1',
                        'ch_tipo_cierre': 'T',
                        'ch_codi_cajero': self.ch_codi_cajero,
                        'ch_codi_garita': self.ch_codi_garita_id,
                    },
                )


# ---------------------------------------------------------------------------
# COBRANZA A CRÉDITO
# ---------------------------------------------------------------------------

class CabCobranzaCredito(AuditFieldsMixin, models.Model):
    """Cabecera de cobranza al crédito."""
    nu_codi_cobr_cred = models.AutoField(primary_key=True)
    dt_fech_cobr = models.DateTimeField(null=True, blank=True)
    vc_obse_cobr = models.CharField(max_length=100, null=True, blank=True)
    ch_seri_cobr = models.CharField(max_length=4, null=True, blank=True)
    ch_nume_cobr = models.CharField(max_length=10, null=True, blank=True) #innecesario
    nu_impo_total = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    ch_codi_cliente = models.ForeignKey(
        MaeCliente,
        on_delete=models.PROTECT,
        db_column='CH_CODI_CLIENTE',
        to_field='ch_codi_cliente',
        null=True, blank=True,
        related_name='cobranzas_credito',
    )
    ch_codi_cajero = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_garita = models.CharField(max_length=3, null=True, blank=True)
    ch_codi_turno_caja = models.CharField(max_length=5, null=True, blank=True) #por que?
    dt_fech_turno = models.DateTimeField(null=True, blank=True) 
    ch_esta_activo = models.CharField(max_length=1, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'CAB_COBRANZA_CREDITO'
        verbose_name = 'Cobranza Crédito'

    def __str__(self):
        return f'Cobranza #{self.nu_codi_cobr_cred}'

    def save(self, *args, **kwargs):
        turno_caja = _resolve_turno_caja(self.dt_fech_turno or self.dt_fech_cobr)
        if turno_caja:
            self.ch_codi_turno_caja = turno_caja
        if not self.ch_codi_garita:
            self.ch_codi_garita = _default_garita_code()
        _validate_personal_cajero_code(self.ch_codi_cajero, 'ch_codi_cajero')
        if self.pk:
            _preserve_existing_fields(self, ['ch_seri_cobr', 'ch_nume_cobr'])
        elif not self.ch_seri_cobr or not self.ch_nume_cobr:
            self.ch_seri_cobr, self.ch_nume_cobr = _next_series_and_number(
                type(self),
                'ch_seri_cobr',
                'ch_nume_cobr',
                default_series='CC01',
                number_width=7,
            )
        super().save(*args, **kwargs)


class DetCobranzaCredito(AuditFieldsMixin, models.Model):
    """Detalle de tickets en una cobranza al crédito."""
    nu_codi_cobr_cred = models.ForeignKey(
        CabCobranzaCredito,
        on_delete=models.PROTECT,
        db_column='NU_CODI_COBR_CRED',
        to_field='nu_codi_cobr_cred',
        related_name='detalles',
    )
    nu_codi_detalle = models.IntegerField() # no es autoincremental, se asigna secuencialmente por cada cobranza
    nu_codi_ticket = models.ForeignKey(
        MovTicket,
        on_delete=models.PROTECT,
        db_column='NU_CODI_TICKET',
        to_field='nu_codi_ticket',
        null=True, blank=True,
        related_name='detalles_cobranza',
    )
    nu_impo_cobr = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_original = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    ch_seri_tckt = models.CharField(max_length=4, null=True, blank=True) #repetitivo
    ch_nume_tckt = models.CharField(max_length=10, null=True, blank=True)
    ch_plac_vehiculo = models.CharField(max_length=20, null=True, blank=True) #Relacionar
    ch_esta_activo = models.CharField(max_length=1, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'DET_COBRANZA_CREDITO'
        unique_together = [('nu_codi_cobr_cred', 'nu_codi_detalle')]
        verbose_name = 'Detalle Cobranza Crédito'

    def __str__(self):
        return f'Det.Cobranza {self.nu_codi_cobr_cred_id}-{self.nu_codi_detalle}'

    def save(self, *args, **kwargs):
        if self.nu_codi_cobr_cred_id and not self.nu_codi_detalle:
            self.nu_codi_detalle = _next_detail_number(self.nu_codi_cobr_cred)
        if not self.ch_esta_activo:
            self.ch_esta_activo = '1'
        super().save(*args, **kwargs)


# ---------------------------------------------------------------------------
# DOCUMENTO DE VENTA
# ---------------------------------------------------------------------------

class CabDocumentoVenta(AuditFieldsMixin, models.Model):
    """Comprobante de venta generado a partir de un ticket."""
    nu_codi_docu_vent = models.AutoField(primary_key=True)
    dt_fech_emision = models.DateTimeField(null=True, blank=True)
    nu_codi_ticket = models.ForeignKey(
        MovTicket,
        on_delete=models.PROTECT,
        db_column='NU_CODI_TICKET',
        to_field='nu_codi_ticket',
        null=True, blank=True,
        related_name='documentos_venta',
    )
    ch_codi_cliente = models.ForeignKey(
        MaeCliente,
        on_delete=models.PROTECT,
        db_column='CH_CODI_CLIENTE',
        to_field='ch_codi_cliente',
        null=True, blank=True,
        related_name='documentos_venta',
    )
    nu_codi_cobr_cred = models.ForeignKey(
        CabCobranzaCredito,
        on_delete=models.SET_NULL,
        db_column='NU_CODI_COBR_CRED',
        to_field='nu_codi_cobr_cred',
        null=True, blank=True,
        related_name='documentos_venta',
    )
    ch_seri_cmprbt = models.CharField(max_length=4, null=True, blank=True)
    ch_nume_cmprbt = models.CharField(max_length=10, null=True, blank=True)
    ch_tipo_cmprbnt = models.CharField(max_length=2, null=True, blank=True)
    vc_desc_cliente = models.CharField(max_length=100, null=True, blank=True)
    vc_dire_cliente = models.CharField(max_length=100, null=True, blank=True)
    vc_obse_cmprbt = models.CharField(max_length=100, null=True, blank=True)
    ch_ruc_cliente = models.CharField(max_length=11, null=True, blank=True)
    nu_impo_total = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_igv = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_afecto = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    ch_esta_activo = models.CharField(max_length=1, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'CAB_DOCUMENTO_VENTA'
        verbose_name = 'Documento de Venta'

    def __str__(self):
        return f'DocVenta #{self.nu_codi_docu_vent} – {self.ch_seri_cmprbt}-{self.ch_nume_cmprbt}'

    def save(self, *args, **kwargs):
        if self.pk:
            _preserve_existing_fields(self, ['ch_seri_cmprbt', 'ch_nume_cmprbt'])
        elif not self.ch_seri_cmprbt or not self.ch_nume_cmprbt:
            default_series = 'B001' if self.ch_tipo_cmprbnt == 'BO' else 'F001' if self.ch_tipo_cmprbnt == 'FA' else 'D001'
            self.ch_seri_cmprbt, self.ch_nume_cmprbt = _next_series_and_number(
                type(self),
                'ch_seri_cmprbt',
                'ch_nume_cmprbt',
                default_series=default_series,
                number_width=8,
            )
        super().save(*args, **kwargs)


# ---------------------------------------------------------------------------
# CIERRE DE TURNO
# ---------------------------------------------------------------------------

class CabCierreTurno(AuditFieldsMixin, models.Model):
    """Cierre de turno de caja."""
    nu_codi_cierre = models.AutoField(primary_key=True)
    dt_fech_turno = models.DateTimeField(null=True, blank=True)
    ch_codi_turno_caja = models.CharField(max_length=5, null=True, blank=True)
    ch_codi_cajero = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_garita = models.CharField(max_length=3, null=True, blank=True)
    ch_seri_cierre = models.CharField(max_length=4, null=True, blank=True)
    ch_nume_cierre = models.CharField(max_length=10, null=True, blank=True)
    nu_impo_tota_efectivo = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_tota_credito = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_cobr_cred = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_tota_ingr = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_egre = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_otro_ingr = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_total = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_util_turno = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    ch_tipo_cierre = models.CharField(max_length=1, null=True, blank=True)
    ch_esta_activo = models.CharField(max_length=1, null=True, blank=True)
    vc_obse_cierre = models.CharField(max_length=100, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'CAB_CIERRE_TURNO'
        verbose_name = 'Cierre de Turno'

    def __str__(self):
        return f'Cierre #{self.nu_codi_cierre}'

    def _get_shift_date(self):
        return self.dt_fech_turno.date() if self.dt_fech_turno else None

    def has_source_activity(self):
        shift_date = self._get_shift_date()
        shift_code = self.ch_codi_turno_caja
        if not shift_date or not shift_code:
            return False

        related_dates = _shift_related_dates(shift_date)
        shift_bucket_dt = self.dt_fech_turno

        has_same_shift_activity = (
            any(
                _matches_shift_bucket(ticket.dt_fech_cancelado, shift_date, shift_code)
                for ticket in MovTicket.objects.filter(dt_fech_cancelado__date__in=related_dates)
            )
            or any(
                _matches_shift_bucket(egreso.dt_fech_egre, shift_date, shift_code)
                for egreso in CabReciboEgreso.objects.filter(dt_fech_egre__date__in=related_dates)
            )
            or any(
                _matches_shift_bucket(ingreso.dt_fech_ingr, shift_date, shift_code)
                for ingreso in CabReciboIngreso.objects.filter(dt_fech_ingr__date__in=related_dates)
            )
        )
        if has_same_shift_activity:
            return True

        total_credito_pendiente = (
            sum(
                _decimal_or_zero(ticket.nu_impo_total)
                for ticket in _credit_tracking_tickets_queryset()
                if _ticket_credit_applies_to_shift(ticket, shift_bucket_dt)
            )
        )
        return _decimal_or_zero(total_credito_pendiente) > ZERO

    def has_duplicate_shift_date(self):
        shift_date = self._get_shift_date()
        shift_code = self.ch_codi_turno_caja
        if not shift_date or not shift_code:
            return False

        queryset = type(self).objects.filter(dt_fech_turno__date=shift_date, ch_codi_turno_caja=shift_code)
        if self.pk:
            queryset = queryset.exclude(pk=self.pk)
        return queryset.exists()

    def _recalculate_amounts(self):
        shift_date = self._get_shift_date()
        shift_code = self.ch_codi_turno_caja
        related_dates = _shift_related_dates(shift_date)
        shift_bucket_dt = self.dt_fech_turno

        if not self.dt_fech_turno or not shift_code:
            self.nu_impo_tota_credito = ZERO
            self.nu_impo_cobr_cred = ZERO
            self.nu_impo_tota_ingr = ZERO
            self.nu_impo_egre = ZERO
            self.nu_impo_otro_ingr = ZERO
            self.nu_impo_total = _decimal_or_zero(self.nu_impo_cobr_cred) + _decimal_or_zero(self.nu_impo_tota_ingr) - _decimal_or_zero(self.nu_impo_egre) + _decimal_or_zero(self.nu_impo_otro_ingr)
            self.nu_impo_util_turno = _decimal_or_zero(self.nu_impo_tota_efectivo) + _decimal_or_zero(self.nu_impo_total)
            return

        tickets_cancelados_hoy = list(MovTicket.objects.filter(dt_fech_cancelado__date__in=related_dates))

        cobr_cred = sum(
            _decimal_or_zero(ticket.nu_impo_total)
            for ticket in tickets_cancelados_hoy
            if ticket.dt_fech_salida
            and ticket.dt_fech_cancelado
            and ticket.dt_fech_salida.date() != ticket.dt_fech_cancelado.date()
            and _matches_shift_bucket(ticket.dt_fech_cancelado, shift_date, shift_code)
        )

        total_ingr = sum(
            _decimal_or_zero(ticket.nu_impo_total)
            for ticket in tickets_cancelados_hoy
            if ticket.dt_fech_salida
            and ticket.dt_fech_cancelado
            and ticket.dt_fech_salida.date() == ticket.dt_fech_cancelado.date()
            and ticket.ch_codi_turno_sld == shift_code
        )

        total_egre = sum(
            _decimal_or_zero(egreso.nu_impo_egre)
            for egreso in CabReciboEgreso.objects.filter(dt_fech_egre__date__in=related_dates)
            if _matches_shift_bucket(egreso.dt_fech_egre, shift_date, shift_code)
        )

        total_otro_ingr = sum(
            _decimal_or_zero(ingreso.nu_impo_ingr)
            for ingreso in CabReciboIngreso.objects.filter(dt_fech_ingr__date__in=related_dates)
            if _matches_shift_bucket(ingreso.dt_fech_ingr, shift_date, shift_code)
        )

        total_credito = sum(
            _decimal_or_zero(ticket.nu_impo_total)
            for ticket in _credit_tracking_tickets_queryset()
            if _ticket_credit_applies_to_shift(ticket, shift_bucket_dt)
        )

        self.nu_impo_cobr_cred = _decimal_or_zero(cobr_cred)
        self.nu_impo_tota_ingr = _decimal_or_zero(total_ingr)
        self.nu_impo_egre = _decimal_or_zero(total_egre)
        self.nu_impo_otro_ingr = _decimal_or_zero(total_otro_ingr)
        self.nu_impo_tota_credito = _decimal_or_zero(total_credito)
        self.nu_impo_total = (
            self.nu_impo_cobr_cred
            + self.nu_impo_tota_ingr
            - self.nu_impo_egre
            + self.nu_impo_otro_ingr
        )
        self.nu_impo_util_turno = _decimal_or_zero(self.nu_impo_tota_efectivo) + self.nu_impo_total

    def save(self, *args, **kwargs):
        turno_caja = _resolve_turno_caja(self.dt_fech_turno)
        if turno_caja:
            self.ch_codi_turno_caja = turno_caja
        if not self.ch_codi_garita:
            self.ch_codi_garita = _default_garita_code()
        _validate_personal_cajero_code(self.ch_codi_cajero, 'ch_codi_cajero')
        if self.pk:
            _preserve_existing_fields(self, ['ch_seri_cierre', 'ch_nume_cierre'])
        elif not self.ch_seri_cierre or not self.ch_nume_cierre:
            self.ch_seri_cierre, self.ch_nume_cierre = _next_series_and_number(
                type(self),
                'ch_seri_cierre',
                'ch_nume_cierre',
                default_series='CT01',
                number_width=7,
            )
        self._recalculate_amounts()
        super().save(*args, **kwargs)


# ---------------------------------------------------------------------------
# EGRESOS E INGRESOS
# ---------------------------------------------------------------------------

class CabReciboEgreso(AuditFieldsMixin, models.Model):
    """Recibo de egreso de caja."""
    nu_codi_recibo = models.AutoField(primary_key=True)
    dt_fech_egre = models.DateTimeField(null=True, blank=True)
    dt_fech_turno = models.DateTimeField(null=True, blank=True)
    vc_obse_egre = models.CharField(max_length=100, null=True, blank=True)
    ch_seri_egre = models.CharField(max_length=4, null=True, blank=True)
    ch_nume_egre = models.CharField(max_length=10, null=True, blank=True)
    nu_impo_egre = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    ch_codi_tipo_egreso = models.ForeignKey(
        MaeTipoEgreso,
        on_delete=models.PROTECT,
        db_column='CH_CODI_TIPO_EGRESO',
        to_field='ch_codi_tipo_egreso',
        null=True, blank=True,
        related_name='recibos_egreso',
    )
    ch_codi_proveedor = models.ForeignKey(
        MaeProveedor,
        on_delete=models.PROTECT,
        db_column='CH_CODI_PROVEEDOR',
        to_field='ch_codi_proveedor',
        null=True, blank=True,
        related_name='recibos_egreso',
    )
    ch_codi_cajero = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_garita = models.CharField(max_length=3, null=True, blank=True)
    ch_codi_turno_caja = models.CharField(max_length=5, null=True, blank=True)
    ch_codi_autoriza = models.CharField(max_length=15, null=True, blank=True)
    ch_esta_activo = models.CharField(max_length=1, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'CAB_RECIBO_EGRESO'
        verbose_name = 'Recibo de Egreso'

    def __str__(self):
        return f'Egreso #{self.nu_codi_recibo}'

    def save(self, *args, **kwargs):
        turno_caja, bucket_datetime = _resolve_turno_bucket(self.dt_fech_egre or self.dt_fech_turno)
        if turno_caja:
            self.ch_codi_turno_caja = turno_caja
        if bucket_datetime:
            self.dt_fech_turno = bucket_datetime
        if not self.ch_codi_garita:
            self.ch_codi_garita = _default_garita_code()
        _validate_personal_cajero_code(self.ch_codi_cajero, 'ch_codi_cajero')
        if self.pk:
            _preserve_existing_fields(self, ['ch_seri_egre', 'ch_nume_egre'])
        elif not self.ch_seri_egre or not self.ch_nume_egre:
            self.ch_seri_egre, self.ch_nume_egre = _next_series_and_number(
                type(self),
                'ch_seri_egre',
                'ch_nume_egre',
                default_series='RE01',
                number_width=7,
            )
        super().save(*args, **kwargs)
        _ensure_daily_cierre_turno(
            self.dt_fech_egre or self.dt_fech_turno,
            defaults={
                'ch_esta_activo': '1',
                'ch_tipo_cierre': 'T',
                'ch_codi_turno_caja': self.ch_codi_turno_caja,
                'ch_codi_cajero': self.ch_codi_cajero,
                'ch_codi_garita': self.ch_codi_garita,
            },
        )


class CabReciboIngreso(AuditFieldsMixin, models.Model):
    """Recibo de ingreso de caja."""
    nu_codi_recibo = models.AutoField(primary_key=True)
    dt_fech_ingr = models.DateTimeField(null=True, blank=True)
    dt_fech_turno = models.DateTimeField(null=True, blank=True)
    vc_obse_ingr = models.CharField(max_length=100, null=True, blank=True)
    ch_seri_ingr = models.CharField(max_length=4, null=True, blank=True)
    ch_nume_ingr = models.CharField(max_length=10, null=True, blank=True)
    nu_impo_ingr = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)
    ch_codi_cliente = models.ForeignKey(
        MaeCliente,
        on_delete=models.PROTECT,
        db_column='CH_CODI_CLIENTE',
        to_field='ch_codi_cliente',
        null=True, blank=True,
        related_name='recibos_ingreso',
    )
    ch_codi_tipo_ingreso = models.ForeignKey(
        MaeTipoIngreso,
        on_delete=models.PROTECT,
        db_column='CH_CODI_TIPO_INGRESO',
        to_field='ch_codi_tipo_ingreso',
        null=True, blank=True,
        related_name='recibos_ingreso',
    )
    ch_codi_cajero = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_garita = models.CharField(max_length=3, null=True, blank=True)
    ch_codi_turno_caja = models.CharField(max_length=5, null=True, blank=True)
    ch_esta_activo = models.CharField(max_length=1, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'CAB_RECIBO_INGRESO'
        verbose_name = 'Recibo de Ingreso'

    def __str__(self):
        return f'Ingreso #{self.nu_codi_recibo}'

    def save(self, *args, **kwargs):
        turno_caja, bucket_datetime = _resolve_turno_bucket(self.dt_fech_ingr or self.dt_fech_turno)
        if turno_caja:
            self.ch_codi_turno_caja = turno_caja
        if bucket_datetime:
            self.dt_fech_turno = bucket_datetime
        if not self.ch_codi_garita:
            self.ch_codi_garita = _default_garita_code()
        _validate_personal_cajero_code(self.ch_codi_cajero, 'ch_codi_cajero')
        if self.pk:
            _preserve_existing_fields(self, ['ch_seri_ingr', 'ch_nume_ingr'])
        elif not self.ch_seri_ingr or not self.ch_nume_ingr:
            self.ch_seri_ingr, self.ch_nume_ingr = _next_series_and_number(
                type(self),
                'ch_seri_ingr',
                'ch_nume_ingr',
                default_series='RI01',
                number_width=7,
            )
        super().save(*args, **kwargs)
        _ensure_daily_cierre_turno(
            self.dt_fech_ingr or self.dt_fech_turno,
            defaults={
                'ch_esta_activo': '1',
                'ch_tipo_cierre': 'T',
                'ch_codi_turno_caja': self.ch_codi_turno_caja,
                'ch_codi_cajero': self.ch_codi_cajero,
                'ch_codi_garita': self.ch_codi_garita,
            },
        )

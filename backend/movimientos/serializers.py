from rest_framework import serializers
from maestros.models import MaeUsuario
from .models import (
    DetTarifario, ConfiguracionTurno, MovTicket,
    CabCobranzaCredito, DetCobranzaCredito, CabDocumentoVenta,
    CabCierreTurno, CabReciboEgreso, CabReciboIngreso,
)
from .models import _resolve_turno_caja


def validate_personal_cajero(codigo):
    if codigo in (None, ''):
        return codigo

    exists = MaeUsuario.objects.filter(
        ch_codi_usuario=codigo,
        ch_esta_activo=True,
        perfiles__ch_esta_perfil_usua='1',
        perfiles__ch_codi_perfil_id='PER',
    ).distinct().exists()

    if not exists:
        raise serializers.ValidationError('El cajero debe ser un usuario activo con perfil Personal.')

    return codigo


class DetTarifarioSerializer(serializers.ModelSerializer):
    tipo_vehiculo_desc = serializers.CharField(
        source='ch_tipo_vehiculo.vc_desc_tipo_vehiculo', read_only=True)
    cliente_desc = serializers.CharField(
        source='ch_codi_cliente.vc_razo_soci_cliente', read_only=True)

    class Meta:
        model = DetTarifario
        fields = '__all__'
        read_only_fields = ('ch_codi_tarifario',)


class ConfiguracionTurnoSerializer(serializers.ModelSerializer):
    class Meta:
        model = ConfiguracionTurno
        fields = '__all__'


class MovTicketSerializer(serializers.ModelSerializer):
    garita_desc    = serializers.CharField(
        source='ch_codi_garita.vc_desc_garita',       read_only=True)
    vehiculo_placa = serializers.CharField(
        source='ch_codi_vehiculo.ch_plac_vehiculo',    read_only=True)
    cliente_desc   = serializers.CharField(
        source='ch_codi_cliente.vc_razo_soci_cliente', read_only=True)
    chofer_desc    = serializers.CharField(
        source='ch_codi_chofer.vc_desc_chofer',        read_only=True)
    tarifario_desc = serializers.CharField(
        source='ch_codi_tarifario.vc_desc_tarifario',  read_only=True)

    class Meta:
        model = MovTicket
        fields = '__all__'

    def validate_ch_codi_cajero(self, value):
        return validate_personal_cajero(value)


class MovTicketListSerializer(serializers.ModelSerializer):
    cliente_desc = serializers.CharField(
        source='ch_codi_cliente.vc_razo_soci_cliente', read_only=True)
    garita_desc  = serializers.CharField(
        source='ch_codi_garita.vc_desc_garita',        read_only=True)
    vehiculo_placa = serializers.CharField(
        source='ch_codi_vehiculo.ch_plac_vehiculo', read_only=True)
    chofer_desc = serializers.CharField(
        source='ch_codi_chofer.vc_desc_chofer', read_only=True)
    incidente_desc = serializers.CharField(
        source='ch_codi_tipo_incidente.vc_desc_tipo_incidente', read_only=True)

    class Meta:
        model = MovTicket
        fields = [
            'nu_codi_ticket', 'dt_fech_emision', 'dt_fech_ingreso', 'dt_fech_salida',
            'ch_seri_tckt', 'ch_nume_tckt', 'nu_impo_total',
            'nu_impo_saldo', 'vehiculo_placa',
            'ch_esta_ticket', 'ch_tipo_comprobante',
            'ch_esta_cancelado', 'dt_fech_cancelado',
            'cliente_desc', 'garita_desc',
            'ch_codi_turno_caja', 'ch_codi_cajero',
            'ch_codi_cliente', 'ch_codi_garita', 'ch_codi_vehiculo',
            'ch_codi_tarifario', 'ch_codi_chofer', 'ch_tipo_vehiculo',
            'ch_codi_tipo_incidente', 'ch_esta_condicion',
            'chofer_desc', 'incidente_desc', 'nu_impo_dscto', 'vc_desc_dscto',
        ]


class DetCobranzaCreditoSerializer(serializers.ModelSerializer):
    ticket_serie = serializers.CharField(
        source='nu_codi_ticket.ch_seri_tckt', read_only=True)
    ticket_numero = serializers.CharField(
        source='nu_codi_ticket.ch_nume_tckt', read_only=True)

    class Meta:
        model = DetCobranzaCredito
        fields = '__all__'


class CabCobranzaCreditoSerializer(serializers.ModelSerializer):
    cliente_desc = serializers.CharField(
        source='ch_codi_cliente.vc_razo_soci_cliente', read_only=True)
    detalles = DetCobranzaCreditoSerializer(many=True, read_only=True)

    class Meta:
        model = CabCobranzaCredito
        fields = '__all__'

    def validate_ch_codi_cajero(self, value):
        return validate_personal_cajero(value)


class CabCobranzaCreditoListSerializer(serializers.ModelSerializer):
    cliente_desc = serializers.CharField(
        source='ch_codi_cliente.vc_razo_soci_cliente', read_only=True)

    class Meta:
        model = CabCobranzaCredito
        fields = [
            'nu_codi_cobr_cred', 'dt_fech_cobr',
            'ch_seri_cobr', 'ch_nume_cobr',
            'nu_impo_total', 'ch_esta_activo',
            'cliente_desc', 'ch_codi_cliente', 'ch_codi_garita', 'ch_codi_cajero', 'ch_codi_turno_caja',
        ]


class CabDocumentoVentaSerializer(serializers.ModelSerializer):
    cliente_desc = serializers.CharField(
        source='ch_codi_cliente.vc_razo_soci_cliente', read_only=True)
    cliente_ruc = serializers.CharField(
        source='ch_codi_cliente.ch_ruc_cliente', read_only=True)

    class Meta:
        model = CabDocumentoVenta
        fields = '__all__'


class CabCierreTurnoSerializer(serializers.ModelSerializer):
    def validate_ch_codi_cajero(self, value):
        return validate_personal_cajero(value)

    def validate(self, attrs):
        instance = self.instance or CabCierreTurno()

        for field_name in (
            'dt_fech_turno',
            'ch_codi_turno_caja',
            'ch_codi_cajero',
            'ch_codi_garita',
            'nu_impo_tota_efectivo',
            'ch_tipo_cierre',
            'ch_esta_activo',
            'vc_obse_cierre',
        ):
            if field_name in attrs:
                setattr(instance, field_name, attrs[field_name])

        if not instance.dt_fech_turno:
            raise serializers.ValidationError({
                'dt_fech_turno': 'La fecha de turno es obligatoria para registrar el cierre.'
            })

        turno_caja = _resolve_turno_caja(instance.dt_fech_turno)
        if turno_caja:
            instance.ch_codi_turno_caja = turno_caja

        if instance.has_duplicate_shift_date():
            raise serializers.ValidationError({
                'dt_fech_turno': 'Solo se permite un CabCierreTurno por fecha y turno.'
            })

        if not instance.has_source_activity():
            raise serializers.ValidationError({
                'dt_fech_turno': (
                    'Solo se puede registrar el cierre si ese día tiene tickets cancelados, '
                    'egresos, ingresos, o si el crédito pendiente es mayor a 0.'
                )
            })

        return attrs

    class Meta:
        model = CabCierreTurno
        fields = '__all__'
        read_only_fields = (
            'ch_seri_cierre',
            'ch_nume_cierre',
            'nu_impo_tota_credito',
            'nu_impo_cobr_cred',
            'nu_impo_tota_ingr',
            'nu_impo_egre',
            'nu_impo_otro_ingr',
            'nu_impo_total',
            'nu_impo_util_turno',
        )


class CabReciboEgresoSerializer(serializers.ModelSerializer):
    tipo_egreso_desc = serializers.CharField(
        source='ch_codi_tipo_egreso.vc_desc_tipo_egreso', read_only=True)
    proveedor_desc   = serializers.CharField(
        source='ch_codi_proveedor.vc_razo_soci_prov',     read_only=True)

    class Meta:
        model = CabReciboEgreso
        fields = '__all__'

    def validate_ch_codi_cajero(self, value):
        return validate_personal_cajero(value)


class CabReciboIngresoSerializer(serializers.ModelSerializer):
    tipo_ingreso_desc = serializers.CharField(
        source='ch_codi_tipo_ingreso.vc_desc_tipo_ingreso', read_only=True)
    cliente_desc      = serializers.CharField(
        source='ch_codi_cliente.vc_razo_soci_cliente',       read_only=True)

    class Meta:
        model = CabReciboIngreso
        fields = '__all__'

    def validate_ch_codi_cajero(self, value):
        return validate_personal_cajero(value)

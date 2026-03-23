from rest_framework import serializers
from .models import (
    DetTarifario, MovTicket,
    CabCobranzaCredito, DetCobranzaCredito, CabDocumentoVenta,
    CabCierreTurno, CabReciboEgreso, CabReciboIngreso,
)


class DetTarifarioSerializer(serializers.ModelSerializer):
    tipo_vehiculo_desc = serializers.CharField(
        source='ch_tipo_vehiculo.vc_desc_tipo_vehiculo', read_only=True)
    cliente_desc = serializers.CharField(
        source='ch_codi_cliente.vc_razo_soci_cliente', read_only=True)

    class Meta:
        model = DetTarifario
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


class MovTicketListSerializer(serializers.ModelSerializer):
    cliente_desc = serializers.CharField(
        source='ch_codi_cliente.vc_razo_soci_cliente', read_only=True)
    garita_desc  = serializers.CharField(
        source='ch_codi_garita.vc_desc_garita',        read_only=True)

    class Meta:
        model = MovTicket
        fields = [
            'nu_codi_ticket', 'dt_fech_ingreso', 'dt_fech_salida',
            'ch_seri_tckt', 'ch_nume_tckt', 'nu_impo_total',
            'ch_esta_ticket', 'ch_tipo_comprobante',
            'cliente_desc', 'garita_desc',
            'ch_codi_turno_caja', 'ch_codi_cajero',
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


class CabCobranzaCreditoListSerializer(serializers.ModelSerializer):
    cliente_desc = serializers.CharField(
        source='ch_codi_cliente.vc_razo_soci_cliente', read_only=True)

    class Meta:
        model = CabCobranzaCredito
        fields = [
            'nu_codi_cobr_cred', 'dt_fech_cobr',
            'ch_seri_cobr', 'ch_nume_cobr',
            'nu_impo_total', 'ch_esta_activo',
            'cliente_desc', 'ch_codi_garita', 'ch_codi_cajero',
        ]


class CabDocumentoVentaSerializer(serializers.ModelSerializer):
    cliente_desc = serializers.CharField(
        source='ch_codi_cliente.vc_razo_soci_cliente', read_only=True)

    class Meta:
        model = CabDocumentoVenta
        fields = '__all__'


class CabCierreTurnoSerializer(serializers.ModelSerializer):
    class Meta:
        model = CabCierreTurno
        fields = '__all__'


class CabReciboEgresoSerializer(serializers.ModelSerializer):
    tipo_egreso_desc = serializers.CharField(
        source='ch_codi_tipo_egreso.vc_desc_tipo_egreso', read_only=True)
    proveedor_desc   = serializers.CharField(
        source='ch_codi_proveedor.vc_razo_soci_prov',     read_only=True)

    class Meta:
        model = CabReciboEgreso
        fields = '__all__'


class CabReciboIngresoSerializer(serializers.ModelSerializer):
    tipo_ingreso_desc = serializers.CharField(
        source='ch_codi_tipo_ingreso.vc_desc_tipo_ingreso', read_only=True)
    cliente_desc      = serializers.CharField(
        source='ch_codi_cliente.vc_razo_soci_cliente',       read_only=True)

    class Meta:
        model = CabReciboIngreso
        fields = '__all__'
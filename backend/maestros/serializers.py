from django.core.exceptions import ValidationError as DjangoValidationError
from rest_framework import serializers
from .models import (
    MaeCliente, MaeChofer, MaeTipoVehiculo, MaeVehiculo, MaeProveedor,
    MaeTipoEgreso, MaeTipoIngreso, MaeTipoIncidente, MaeTipoDocumento, MaeGarita,
    MaeUsuario, MaePerfil, normalize_vehicle_plate,
)


class MaeClienteSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaeCliente
        fields = '__all__'
        read_only_fields = ('ch_codi_cliente',)


class MaeChoferSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaeChofer
        fields = '__all__'
        read_only_fields = ('ch_codi_chofer',)


class MaeTipoVehiculoSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaeTipoVehiculo
        fields = '__all__'
        read_only_fields = ('ch_tipo_vehiculo',)


class MaeVehiculoSerializer(serializers.ModelSerializer):
    # Campos de solo lectura para mostrar descripción de FKs
    tipo_vehiculo_desc = serializers.CharField(
        source='ch_tipo_vehiculo.vc_desc_tipo_vehiculo', read_only=True)
    cliente_desc = serializers.CharField(
        source='ch_codi_cliente.vc_razo_soci_cliente', read_only=True)
    chofer_desc = serializers.CharField(
        source='ch_codi_chofer.vc_desc_chofer', read_only=True)

    def validate_ch_plac_vehiculo(self, value):
        try:
            return normalize_vehicle_plate(value)
        except DjangoValidationError as exc:
            message = getattr(exc, 'messages', [str(exc)])[0]
            raise serializers.ValidationError(message) from exc

    class Meta:
        model = MaeVehiculo
        fields = '__all__'
        read_only_fields = ('ch_codi_vehiculo',)
        extra_kwargs = {
            'ch_plac_vehiculo': {'required': True, 'allow_blank': False},
        }


class MaeProveedorSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaeProveedor
        fields = '__all__'
        read_only_fields = ('ch_codi_proveedor',)


class MaeTipoEgresoSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaeTipoEgreso
        fields = '__all__'
        read_only_fields = ('ch_codi_tipo_egreso',)


class MaeTipoIngresoSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaeTipoIngreso
        fields = '__all__'
        read_only_fields = ('ch_codi_tipo_ingreso',)


class MaeTipoIncidenteSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaeTipoIncidente
        fields = '__all__'
        read_only_fields = ('ch_codi_tipo_incidente',)


class MaeTipoDocumentoSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaeTipoDocumento
        fields = '__all__'


class MaeGaritaSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaeGarita
        fields = '__all__'


class MaeUsuarioSerializer(serializers.ModelSerializer):
    ch_codi_usua = serializers.CharField(read_only=True)
    dt_fech_ulti_actu = serializers.DateTimeField(read_only=True)

    def validate(self, attrs):
        password = attrs.get('ch_pass_usua')
        password_admin = attrs.get('ch_pass_usua2')
        if password_admin and not password:
            raise serializers.ValidationError({'ch_pass_usua': 'Debe registrar la contrasena principal antes de la contrasena ADM.'})
        return attrs

    class Meta:
        model = MaeUsuario
        fields = '__all__'
        extra_kwargs = {
            'ch_pass_usua': {'write_only': True},
            'ch_pass_usua2': {'write_only': True},
            'ch_codi_usua': {'read_only': True},
            'dt_fech_ulti_actu': {'read_only': True},
        }


class MaePerfilSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaePerfil
        fields = '__all__'

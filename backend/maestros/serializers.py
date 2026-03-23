from rest_framework import serializers
from .models import (
    MaeCliente, MaeChofer, MaeTipoVehiculo, MaeVehiculo, MaeProveedor,
    MaeTipoEgreso, MaeTipoIngreso, MaeTipoIncidente, MaeTipoDocumento, MaeGarita,
    MaeUsuario, MaePerfil,
)


class MaeClienteSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaeCliente
        fields = '__all__'


class MaeChoferSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaeChofer
        fields = '__all__'


class MaeTipoVehiculoSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaeTipoVehiculo
        fields = '__all__'


class MaeVehiculoSerializer(serializers.ModelSerializer):
    # Campos de solo lectura para mostrar descripción de FKs
    tipo_vehiculo_desc = serializers.CharField(
        source='ch_tipo_vehiculo.vc_desc_tipo_vehiculo', read_only=True)
    cliente_desc = serializers.CharField(
        source='ch_codi_cliente.vc_razo_soci_cliente', read_only=True)
    chofer_desc = serializers.CharField(
        source='ch_codi_chofer.vc_desc_chofer', read_only=True)

    class Meta:
        model = MaeVehiculo
        fields = '__all__'


class MaeProveedorSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaeProveedor
        fields = '__all__'


class MaeTipoEgresoSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaeTipoEgreso
        fields = '__all__'


class MaeTipoIngresoSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaeTipoIngreso
        fields = '__all__'


class MaeTipoIncidenteSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaeTipoIncidente
        fields = '__all__'


class MaeTipoDocumentoSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaeTipoDocumento
        fields = '__all__'


class MaeGaritaSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaeGarita
        fields = '__all__'


class MaeUsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaeUsuario
        fields = '__all__'
        extra_kwargs = {
            'ch_pass_usua': {'write_only': True},
            'ch_pass_usua2': {'write_only': True},
        }


class MaePerfilSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaePerfil
        fields = '__all__'
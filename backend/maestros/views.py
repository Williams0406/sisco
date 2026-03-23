from rest_framework import viewsets
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter

from .models import (
    MaeCliente, MaeChofer, MaeTipoVehiculo, MaeVehiculo, MaeProveedor,
    MaeTipoEgreso, MaeTipoIngreso, MaeTipoIncidente, MaeTipoDocumento, MaeGarita,
    MaeUsuario, MaePerfil,
)
from .serializers import (
    MaeClienteSerializer, MaeChoferSerializer, MaeTipoVehiculoSerializer,
    MaeVehiculoSerializer, MaeProveedorSerializer, MaeTipoEgresoSerializer,
    MaeTipoIngresoSerializer, MaeTipoIncidenteSerializer, MaeTipoDocumentoSerializer,
    MaeGaritaSerializer, MaeUsuarioSerializer, MaePerfilSerializer,
)


class MaeClienteViewSet(viewsets.ModelViewSet):
    queryset = MaeCliente.objects.all()
    serializer_class = MaeClienteSerializer
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['ch_esta_activo', 'ch_esta_cliente_vip']
    search_fields = ['vc_razo_soci_cliente', 'ch_ruc_cliente', 'ch_codi_cliente']
    ordering_fields = ['vc_razo_soci_cliente', 'ch_codi_cliente']
    ordering = ['vc_razo_soci_cliente']


class MaeChoferViewSet(viewsets.ModelViewSet):
    queryset = MaeChofer.objects.all()
    serializer_class = MaeChoferSerializer
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['ch_esta_activo']
    search_fields = ['vc_desc_chofer', 'ch_nume_dni', 'ch_codi_chofer']
    ordering = ['vc_desc_chofer']


class MaeTipoVehiculoViewSet(viewsets.ModelViewSet):
    queryset = MaeTipoVehiculo.objects.all()
    serializer_class = MaeTipoVehiculoSerializer
    filter_backends = [DjangoFilterBackend, SearchFilter]
    filterset_fields = ['ch_esta_activo']
    search_fields = ['vc_desc_tipo_vehiculo']


class MaeVehiculoViewSet(viewsets.ModelViewSet):
    queryset = MaeVehiculo.objects.select_related(
        'ch_tipo_vehiculo', 'ch_codi_cliente', 'ch_codi_chofer'
    ).all()
    serializer_class = MaeVehiculoSerializer
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['ch_esta_activo', 'ch_esta_parqueado', 'ch_tipo_vehiculo']
    search_fields = ['ch_plac_vehiculo', 'ch_codi_vehiculo']
    ordering = ['ch_plac_vehiculo']


class MaeProveedorViewSet(viewsets.ModelViewSet):
    queryset = MaeProveedor.objects.all()
    serializer_class = MaeProveedorSerializer
    filter_backends = [DjangoFilterBackend, SearchFilter]
    filterset_fields = ['ch_esta_activo']
    search_fields = ['vc_razo_soci_prov', 'ch_ruc_prov']


class MaeTipoEgresoViewSet(viewsets.ModelViewSet):
    queryset = MaeTipoEgreso.objects.all()
    serializer_class = MaeTipoEgresoSerializer
    filterset_fields = ['ch_esta_activo']


class MaeTipoIngresoViewSet(viewsets.ModelViewSet):
    queryset = MaeTipoIngreso.objects.all()
    serializer_class = MaeTipoIngresoSerializer
    filterset_fields = ['ch_esta_activo']


class MaeTipoIncidenteViewSet(viewsets.ModelViewSet):
    queryset = MaeTipoIncidente.objects.all()
    serializer_class = MaeTipoIncidenteSerializer
    filterset_fields = ['ch_esta_activo']


class MaeTipoDocumentoViewSet(viewsets.ModelViewSet):
    queryset = MaeTipoDocumento.objects.all()
    serializer_class = MaeTipoDocumentoSerializer


class MaeGaritaViewSet(viewsets.ModelViewSet):
    queryset = MaeGarita.objects.all()
    serializer_class = MaeGaritaSerializer
    filterset_fields = ['ch_esta_activo']
    search_fields = ['vc_desc_garita']


class MaeUsuarioViewSet(viewsets.ModelViewSet):
    queryset = MaeUsuario.objects.all()
    serializer_class = MaeUsuarioSerializer
    filter_backends = [DjangoFilterBackend, SearchFilter]
    filterset_fields = ['ch_esta_activo', 'ch_tipo_usuario']
    search_fields = ['vc_desc_nomb_usuario', 'ch_codi_usuario', 'vc_desc_email_usuario']


class MaePerfilViewSet(viewsets.ModelViewSet):
    queryset = MaePerfil.objects.all()
    serializer_class = MaePerfilSerializer
    filterset_fields = ['ch_esta_perfil']
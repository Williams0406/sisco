from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
import django_filters
from django.utils import timezone

from .models import (
    DetTarifario, ConfiguracionTurno, MovTicket,
    CabCobranzaCredito, DetCobranzaCredito, CabDocumentoVenta,
    CabCierreTurno, CabReciboEgreso, CabReciboIngreso,
)
from .serializers import (
    DetTarifarioSerializer, ConfiguracionTurnoSerializer,
    MovTicketSerializer, MovTicketListSerializer,
    CabCobranzaCreditoSerializer, CabCobranzaCreditoListSerializer,
    DetCobranzaCreditoSerializer, CabDocumentoVentaSerializer,
    CabCierreTurnoSerializer, CabReciboEgresoSerializer,
    CabReciboIngresoSerializer,
)


# ---------------------------------------------------------------------------
# FILTROS
# ---------------------------------------------------------------------------

class TicketFilter(django_filters.FilterSet):
    fecha_desde = django_filters.DateTimeFilter(
        field_name='dt_fech_ingreso', lookup_expr='gte')
    fecha_hasta = django_filters.DateTimeFilter(
        field_name='dt_fech_ingreso', lookup_expr='lte')

    class Meta:
        model = MovTicket
        fields = [
            'ch_esta_ticket', 'ch_tipo_comprobante',
            'ch_codi_garita', 'ch_codi_cliente',
            'ch_codi_turno_caja', 'ch_esta_activo', 'ch_esta_cancelado',
            'fecha_desde', 'fecha_hasta',
        ]


class CobranzaFilter(django_filters.FilterSet):
    fecha_desde = django_filters.DateTimeFilter(
        field_name='dt_fech_cobr', lookup_expr='gte')
    fecha_hasta = django_filters.DateTimeFilter(
        field_name='dt_fech_cobr', lookup_expr='lte')

    class Meta:
        model = CabCobranzaCredito
        fields = ['ch_codi_cliente', 'ch_esta_activo',
                  'ch_codi_garita', 'fecha_desde', 'fecha_hasta']


class EgresoFilter(django_filters.FilterSet):
    fecha_desde = django_filters.DateTimeFilter(
        field_name='dt_fech_egre', lookup_expr='gte')
    fecha_hasta = django_filters.DateTimeFilter(
        field_name='dt_fech_egre', lookup_expr='lte')

    class Meta:
        model = CabReciboEgreso
        fields = ['ch_codi_tipo_egreso', 'ch_esta_activo',
                  'ch_codi_garita', 'fecha_desde', 'fecha_hasta']


class IngresoFilter(django_filters.FilterSet):
    fecha_desde = django_filters.DateTimeFilter(
        field_name='dt_fech_ingr', lookup_expr='gte')
    fecha_hasta = django_filters.DateTimeFilter(
        field_name='dt_fech_ingr', lookup_expr='lte')

    class Meta:
        model = CabReciboIngreso
        fields = ['ch_codi_tipo_ingreso', 'ch_esta_activo',
                  'ch_codi_garita', 'fecha_desde', 'fecha_hasta']


# ---------------------------------------------------------------------------
# VIEWSETS
# ---------------------------------------------------------------------------

class DetTarifarioViewSet(viewsets.ModelViewSet):
    queryset = DetTarifario.objects.select_related(
        'ch_tipo_vehiculo', 'ch_codi_cliente'
    ).all()
    serializer_class = DetTarifarioSerializer
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['ch_esta_activo', 'ch_tipo_vehiculo', 'ch_codi_cliente']
    ordering = ['ch_tipo_vehiculo']


class ConfiguracionTurnoViewSet(viewsets.ModelViewSet):
    queryset = ConfiguracionTurno.objects.all().order_by('nu_codi_config_turno')
    serializer_class = ConfiguracionTurnoSerializer
    http_method_names = ['get', 'post', 'put', 'patch']


class MovTicketViewSet(viewsets.ModelViewSet):
    queryset = MovTicket.objects.select_related(
        'ch_codi_garita', 'ch_codi_vehiculo',
        'ch_codi_cliente', 'ch_codi_chofer',
        'ch_codi_tarifario',
    ).all()
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_class = TicketFilter
    search_fields = ['ch_seri_tckt', 'ch_nume_tckt']
    ordering_fields = ['dt_fech_ingreso', 'nu_codi_ticket']
    ordering = ['-dt_fech_ingreso']

    def get_serializer_class(self):
        if self.action == 'list':
            return MovTicketListSerializer
        return MovTicketSerializer

    @action(detail=True, methods=['post'], url_path='cerrar')
    def cerrar_ticket(self, request, pk=None):
        """Registra la salida del vehículo."""
        ticket = self.get_object()
        ticket.dt_fech_salida  = timezone.now()
        ticket.ch_esta_ticket  = '1'   # 1 = cerrado/salida registrada
        ticket.ch_esta_cancelado = '0'
        ticket.save()
        return Response(MovTicketSerializer(ticket).data)


class CabCobranzaCreditoViewSet(viewsets.ModelViewSet):
    queryset = CabCobranzaCredito.objects.select_related(
        'ch_codi_cliente'
    ).prefetch_related('detalles').all()
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_class = CobranzaFilter
    search_fields = ['ch_seri_cobr', 'ch_nume_cobr']
    ordering = ['-dt_fech_cobr']

    def get_serializer_class(self):
        if self.action == 'list':
            return CabCobranzaCreditoListSerializer
        return CabCobranzaCreditoSerializer


class DetCobranzaCreditoViewSet(viewsets.ModelViewSet):
    queryset = DetCobranzaCredito.objects.select_related(
        'nu_codi_cobr_cred', 'nu_codi_ticket'
    ).all()
    serializer_class = DetCobranzaCreditoSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['nu_codi_cobr_cred', 'ch_esta_activo']


class CabDocumentoVentaViewSet(viewsets.ModelViewSet):
    queryset = CabDocumentoVenta.objects.select_related(
        'nu_codi_ticket', 'ch_codi_cliente', 'nu_codi_cobr_cred'
    ).all()
    serializer_class = CabDocumentoVentaSerializer
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['ch_tipo_cmprbnt', 'ch_esta_activo', 'ch_codi_cliente']
    search_fields = ['ch_seri_cmprbt', 'ch_nume_cmprbt', 'ch_ruc_cliente']
    ordering = ['-dt_fech_emision']


class CabCierreTurnoViewSet(viewsets.ModelViewSet):
    queryset = CabCierreTurno.objects.all()
    serializer_class = CabCierreTurnoSerializer
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['ch_esta_activo', 'ch_tipo_cierre',
                        'ch_codi_garita', 'ch_codi_cajero']
    ordering = ['-dt_fech_turno']


class CabReciboEgresoViewSet(viewsets.ModelViewSet):
    queryset = CabReciboEgreso.objects.select_related(
        'ch_codi_tipo_egreso', 'ch_codi_proveedor'
    ).all()
    serializer_class = CabReciboEgresoSerializer
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_class = EgresoFilter
    search_fields = ['ch_seri_egre', 'ch_nume_egre']
    ordering = ['-dt_fech_egre']


class CabReciboIngresoViewSet(viewsets.ModelViewSet):
    queryset = CabReciboIngreso.objects.select_related(
        'ch_codi_tipo_ingreso', 'ch_codi_cliente'
    ).all()
    serializer_class = CabReciboIngresoSerializer
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_class = IngresoFilter
    search_fields = ['ch_seri_ingr', 'ch_nume_ingr']
    ordering = ['-dt_fech_ingr']

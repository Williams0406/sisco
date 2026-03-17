from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import viewsets
import django_filters
from django.db.models import Sum, Count
from django.utils.dateparse import parse_date

from movimientos.models import (
    MovTicket, CabDocumentoVenta,
    CabCobranzaCredito, CabReciboEgreso, CabReciboIngreso,
)
from movimientos.serializers import (
    MovTicketListSerializer, CabDocumentoVentaSerializer,
    CabCobranzaCreditoListSerializer, CabReciboEgresoSerializer,
    CabReciboIngresoSerializer,
)


class ListaTicketSalidaView(APIView):
    """Reporte: Lista de Ticket de Salida con filtros."""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        qs = MovTicket.objects.select_related(
            'ch_codi_cliente', 'ch_codi_garita'
        ).filter(ch_esta_ticket='CE')

        fecha_desde = request.query_params.get('fecha_desde')
        fecha_hasta = request.query_params.get('fecha_hasta')
        garita      = request.query_params.get('garita')
        cliente     = request.query_params.get('cliente')
        placa       = request.query_params.get('placa')

        if fecha_desde:
            qs = qs.filter(dt_fech_salid__date__gte=fecha_desde)
        if fecha_hasta:
            qs = qs.filter(dt_fech_salid__date__lte=fecha_hasta)
        if garita:
            qs = qs.filter(ch_codi_garita=garita)
        if cliente:
            qs = qs.filter(ch_codi_cliente=cliente)
        if placa:
            qs = qs.filter(ch_plac_vehiculo__icontains=placa)

        serializer = MovTicketListSerializer(qs, many=True)
        return Response({'count': qs.count(), 'results': serializer.data})


class RelacionComprobanteVentaView(APIView):
    """Reporte: Relación de Comprobantes de Venta."""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        qs = CabDocumentoVenta.objects.select_related('ch_codi_cliente')

        fecha_desde  = request.query_params.get('fecha_desde')
        fecha_hasta  = request.query_params.get('fecha_hasta')
        tipo_comp    = request.query_params.get('tipo_comprobante')
        cliente      = request.query_params.get('cliente')

        if fecha_desde:
            qs = qs.filter(dt_fech_docu_vent__date__gte=fecha_desde)
        if fecha_hasta:
            qs = qs.filter(dt_fech_docu_vent__date__lte=fecha_hasta)
        if tipo_comp:
            qs = qs.filter(ch_tipo_cmprbnt=tipo_comp)
        if cliente:
            qs = qs.filter(ch_codi_cliente=cliente)

        totales = qs.aggregate(
            total_afecto=Sum('nu_impo_afecto'),
            total_igv=Sum('nu_impo_igv'),
            total_general=Sum('nu_impo_total'),
        )
        serializer = CabDocumentoVentaSerializer(qs, many=True)
        return Response({
            'count': qs.count(),
            'totales': totales,
            'results': serializer.data,
        })


class ListaCobranzaDiariaView(APIView):
    """Reporte: Lista de Cobranza Diaria."""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        qs = CabCobranzaCredito.objects.select_related('ch_codi_cliente')

        fecha_desde = request.query_params.get('fecha_desde')
        fecha_hasta = request.query_params.get('fecha_hasta')
        cliente     = request.query_params.get('cliente')

        if fecha_desde:
            qs = qs.filter(dt_fech_cobr_cred__date__gte=fecha_desde)
        if fecha_hasta:
            qs = qs.filter(dt_fech_cobr_cred__date__lte=fecha_hasta)
        if cliente:
            qs = qs.filter(ch_codi_cliente=cliente)

        total = qs.aggregate(total=Sum('nu_impo_total'))
        serializer = CabCobranzaCreditoListSerializer(qs, many=True)
        return Response({
            'count': qs.count(),
            'total_cobranza': total['total'],
            'results': serializer.data,
        })


class IngresoEgresoMesView(APIView):
    """Reporte: Ingresos y Egresos por Mes."""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        anio  = request.query_params.get('anio')
        mes   = request.query_params.get('mes')
        garita = request.query_params.get('garita')

        filtros_i = {}
        filtros_e = {}
        if anio:
            filtros_i['dt_fech_ingr__year'] = anio
            filtros_e['dt_fech_egre__year']  = anio
        if mes:
            filtros_i['dt_fech_ingr__month'] = mes
            filtros_e['dt_fech_egre__month']  = mes
        if garita:
            filtros_i['ch_codi_garita'] = garita
            filtros_e['ch_codi_garita']  = garita

        ingresos = CabReciboIngreso.objects.filter(**filtros_i)
        egresos  = CabReciboEgreso.objects.filter(**filtros_e)

        total_ingresos = ingresos.aggregate(t=Sum('nu_impo_ingr'))['t'] or 0
        total_egresos  = egresos.aggregate(t=Sum('nu_impo_egre'))['t'] or 0

        return Response({
            'total_ingresos': total_ingresos,
            'total_egresos':  total_egresos,
            'utilidad':       total_ingresos - total_egresos,
            'ingresos': CabReciboIngresoSerializer(ingresos, many=True).data,
            'egresos':  CabReciboEgresoSerializer(egresos,  many=True).data,
        })


class ConsultaIngresoDiarioView(APIView):
    """Cierre General: Consulta de Ingreso Diario."""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        fecha  = request.query_params.get('fecha')
        garita = request.query_params.get('garita')

        qs_tickets = MovTicket.objects.filter(ch_esta_ticket='CE', ch_esta_activo='1')
        if fecha:
            qs_tickets = qs_tickets.filter(dt_fech_salid__date=fecha)
        if garita:
            qs_tickets = qs_tickets.filter(ch_codi_garita=garita)

        resumen = qs_tickets.aggregate(
            total_efectivo=Sum('nu_impo_cobro'),
            total_credito=Sum('nu_impo_cobro_cred'),
            cantidad_tickets=Count('nu_codi_ticket'),
        )
        return Response({
            'fecha':  fecha,
            'garita': garita,
            **resumen,
        })
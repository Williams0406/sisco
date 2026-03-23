from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.db.models import Sum, Count

from movimientos.models import (
    MovTicket, CabDocumentoVenta,
    CabCobranzaCredito, CabReciboEgreso, CabReciboIngreso,
)
from movimientos.serializers import (
    MovTicketListSerializer, CabDocumentoVentaSerializer,
    CabCobranzaCreditoListSerializer,
    CabReciboEgresoSerializer, CabReciboIngresoSerializer,
)


class ListaTicketSalidaView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        qs = MovTicket.objects.select_related(
            'ch_codi_cliente', 'ch_codi_garita'
        ).filter(ch_esta_ticket='1')   # 1 = con salida registrada

        if v := request.query_params.get('fecha_desde'):
            qs = qs.filter(dt_fech_salida__date__gte=v)
        if v := request.query_params.get('fecha_hasta'):
            qs = qs.filter(dt_fech_salida__date__lte=v)
        if v := request.query_params.get('garita'):
            qs = qs.filter(ch_codi_garita=v)
        if v := request.query_params.get('cliente'):
            qs = qs.filter(ch_codi_cliente=v)

        return Response({
            'count': qs.count(),
            'results': MovTicketListSerializer(qs, many=True).data,
        })


class RelacionComprobanteVentaView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        qs = CabDocumentoVenta.objects.select_related('ch_codi_cliente')

        if v := request.query_params.get('fecha_desde'):
            qs = qs.filter(dt_fech_emision__date__gte=v)
        if v := request.query_params.get('fecha_hasta'):
            qs = qs.filter(dt_fech_emision__date__lte=v)
        if v := request.query_params.get('tipo_comprobante'):
            qs = qs.filter(ch_tipo_cmprbnt=v)
        if v := request.query_params.get('cliente'):
            qs = qs.filter(ch_codi_cliente=v)

        totales = qs.aggregate(
            total_afecto=Sum('nu_impo_afecto'),
            total_igv=Sum('nu_impo_igv'),
            total_general=Sum('nu_impo_total'),
        )
        return Response({
            'count': qs.count(),
            'totales': totales,
            'results': CabDocumentoVentaSerializer(qs, many=True).data,
        })


class ListaCobranzaDiariaView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        qs = CabCobranzaCredito.objects.select_related('ch_codi_cliente')

        if v := request.query_params.get('fecha_desde'):
            qs = qs.filter(dt_fech_cobr__date__gte=v)
        if v := request.query_params.get('fecha_hasta'):
            qs = qs.filter(dt_fech_cobr__date__lte=v)
        if v := request.query_params.get('cliente'):
            qs = qs.filter(ch_codi_cliente=v)

        total = qs.aggregate(total=Sum('nu_impo_total'))
        return Response({
            'count': qs.count(),
            'total_cobranza': total['total'],
            'results': CabCobranzaCreditoListSerializer(qs, many=True).data,
        })


class IngresoEgresoMesView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        anio   = request.query_params.get('anio')
        mes    = request.query_params.get('mes')
        garita = request.query_params.get('garita')

        fi, fe = {}, {}
        if anio:
            fi['dt_fech_ingr__year'] = anio
            fe['dt_fech_egre__year'] = anio
        if mes:
            fi['dt_fech_ingr__month'] = mes
            fe['dt_fech_egre__month'] = mes
        if garita:
            fi['ch_codi_garita'] = garita
            fe['ch_codi_garita'] = garita

        ingresos = CabReciboIngreso.objects.filter(**fi)
        egresos  = CabReciboEgreso.objects.filter(**fe)

        ti = ingresos.aggregate(t=Sum('nu_impo_ingr'))['t'] or 0
        te = egresos.aggregate(t=Sum('nu_impo_egre'))['t'] or 0

        return Response({
            'total_ingresos': ti,
            'total_egresos':  te,
            'utilidad':       ti - te,
            'ingresos': CabReciboIngresoSerializer(ingresos, many=True).data,
            'egresos':  CabReciboEgresoSerializer(egresos,  many=True).data,
        })


class ConsultaIngresoDiarioView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        fecha  = request.query_params.get('fecha')
        garita = request.query_params.get('garita')

        qs = MovTicket.objects.filter(ch_esta_ticket='1', ch_esta_activo='1')
        if fecha:
            qs = qs.filter(dt_fech_salida__date=fecha)
        if garita:
            qs = qs.filter(ch_codi_garita=garita)

        resumen = qs.aggregate(
            total_efectivo=Sum('nu_impo_total'),
            cantidad_tickets=Count('nu_codi_ticket'),
        )
        return Response({'fecha': fecha, 'garita': garita, **resumen})
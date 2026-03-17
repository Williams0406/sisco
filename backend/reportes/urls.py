from django.urls import path
from .views import (
    ListaTicketSalidaView, RelacionComprobanteVentaView,
    ListaCobranzaDiariaView, IngresoEgresoMesView,
    ConsultaIngresoDiarioView,
)

urlpatterns = [
    path('ticket-salida/',       ListaTicketSalidaView.as_view()),
    path('comprobantes-venta/',  RelacionComprobanteVentaView.as_view()),
    path('cobranza-diaria/',     ListaCobranzaDiariaView.as_view()),
    path('ingreso-egreso-mes/',  IngresoEgresoMesView.as_view()),
    path('ingreso-diario/',      ConsultaIngresoDiarioView.as_view()),
]
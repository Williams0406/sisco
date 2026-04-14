from rest_framework.routers import DefaultRouter
from .views import (
    DetTarifarioViewSet, ConfiguracionTurnoViewSet, MovTicketViewSet,
    CabCobranzaCreditoViewSet, DetCobranzaCreditoViewSet,
    CabDocumentoVentaViewSet, CabCierreTurnoViewSet,
    CabReciboEgresoViewSet, CabReciboIngresoViewSet,
)

router = DefaultRouter()
router.register(r'tarifario',          DetTarifarioViewSet,        basename='tarifario')
router.register(r'config-turnos',      ConfiguracionTurnoViewSet,  basename='config-turnos')
router.register(r'tickets',            MovTicketViewSet,           basename='ticket')
router.register(r'cobranza-credito',   CabCobranzaCreditoViewSet,  basename='cobranza-credito')
router.register(r'det-cobranza',       DetCobranzaCreditoViewSet,  basename='det-cobranza')
router.register(r'documentos-venta',   CabDocumentoVentaViewSet,   basename='documento-venta')
router.register(r'cierres-turno',      CabCierreTurnoViewSet,      basename='cierre-turno')
router.register(r'recibos-egreso',     CabReciboEgresoViewSet,     basename='recibo-egreso')
router.register(r'recibos-ingreso',    CabReciboIngresoViewSet,    basename='recibo-ingreso')

urlpatterns = router.urls

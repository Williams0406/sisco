from rest_framework.routers import DefaultRouter
from .views import (
    MaeClienteViewSet, MaeChoferViewSet, MaeTipoVehiculoViewSet,
    MaeVehiculoViewSet, MaeProveedorViewSet, MaeTipoEgresoViewSet,
    MaeTipoIngresoViewSet, MaeTipoDocumentoViewSet, MaeGaritaViewSet,
    MaeUsuarioViewSet, MaePerfilViewSet,
)

router = DefaultRouter()
router.register(r'clientes',        MaeClienteViewSet,       basename='cliente')
router.register(r'choferes',        MaeChoferViewSet,        basename='chofer')
router.register(r'tipo-vehiculos',  MaeTipoVehiculoViewSet,  basename='tipo-vehiculo')
router.register(r'vehiculos',       MaeVehiculoViewSet,      basename='vehiculo')
router.register(r'proveedores',     MaeProveedorViewSet,     basename='proveedor')
router.register(r'tipo-egresos',    MaeTipoEgresoViewSet,    basename='tipo-egreso')
router.register(r'tipo-ingresos',   MaeTipoIngresoViewSet,   basename='tipo-ingreso')
router.register(r'tipo-documentos', MaeTipoDocumentoViewSet, basename='tipo-documento')
router.register(r'garitas',         MaeGaritaViewSet,        basename='garita')
router.register(r'usuarios',        MaeUsuarioViewSet,       basename='usuario')
router.register(r'perfiles',        MaePerfilViewSet,        basename='perfil')

urlpatterns = router.urls
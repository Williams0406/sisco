from rest_framework.routers import DefaultRouter
from django.urls import path
from .data_exchange import DataSyncCatalogView, DataSyncClearTableView, DataSyncExportView, DataSyncImportView
from .views import UsuarioViewSet, PerfilViewSet, PerfilUsuarioViewSet, MeView, CajeroOptionsView

router = DefaultRouter()
router.register(r'usuarios',        UsuarioViewSet,       basename='seg-usuario')
router.register(r'perfiles',        PerfilViewSet,        basename='seg-perfil')
router.register(r'perfil-usuario',  PerfilUsuarioViewSet, basename='perfil-usuario')

urlpatterns = [
    path('me/', MeView.as_view()),
    path('cajeros/', CajeroOptionsView.as_view()),
    path('data-sync/catalog/', DataSyncCatalogView.as_view()),
    path('data-sync/import/', DataSyncImportView.as_view()),
    path('data-sync/clear/', DataSyncClearTableView.as_view()),
    path('data-sync/export/', DataSyncExportView.as_view()),
] + router.urls

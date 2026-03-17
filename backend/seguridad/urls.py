from rest_framework.routers import DefaultRouter
from django.urls import path
from .views import UsuarioViewSet, PerfilViewSet, PerfilUsuarioViewSet, MeView

router = DefaultRouter()
router.register(r'usuarios',        UsuarioViewSet,       basename='seg-usuario')
router.register(r'perfiles',        PerfilViewSet,        basename='seg-perfil')
router.register(r'perfil-usuario',  PerfilUsuarioViewSet, basename='perfil-usuario')

urlpatterns = [
    path('me/', MeView.as_view()),
] + router.urls
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter

from maestros.models import MaeUsuario, MaePerfil, MaePerfilMaeUsuario
from maestros.serializers import (
    MaeUsuarioSerializer, MaePerfilSerializer,
)
from rest_framework import serializers


class MaePerfilMaeUsuarioSerializer(serializers.ModelSerializer):
    usuario_nombre = serializers.CharField(
        source='ch_codi_usuario.vc_desc_nomb_usuario', read_only=True)
    perfil_nombre  = serializers.CharField(
        source='ch_codi_perfil.vc_desc_perfil', read_only=True)

    class Meta:
        model = MaePerfilMaeUsuario
        fields = '__all__'


class UsuarioViewSet(viewsets.ModelViewSet):
    queryset = MaeUsuario.objects.all()
    serializer_class = MaeUsuarioSerializer
    filter_backends = [DjangoFilterBackend, SearchFilter]
    filterset_fields = ['ch_esta_activo', 'ch_tipo_usuario']
    search_fields = ['vc_desc_nomb_usuario', 'ch_codi_usuario', 'vc_desc_email_usuario']

    @action(detail=True, methods=['post'], url_path='asignar-perfil')
    def asignar_perfil(self, request, pk=None):
        """Asigna un perfil al usuario."""
        usuario = self.get_object()
        perfil_id = request.data.get('ch_codi_perfil')
        if not perfil_id:
            return Response(
                {'error': 'Se requiere ch_codi_perfil'},
                status=status.HTTP_400_BAD_REQUEST
            )
        try:
            perfil = MaePerfil.objects.get(pk=perfil_id)
        except MaePerfil.DoesNotExist:
            return Response(
                {'error': 'Perfil no encontrado'},
                status=status.HTTP_404_NOT_FOUND
            )
        asignacion, created = MaePerfilMaeUsuario.objects.get_or_create(
            ch_codi_usuario=usuario,
            ch_codi_perfil=perfil,
            defaults={'ch_nume_asigna': '001', 'ch_esta_perfil_usua': '1'}
        )
        return Response(
            MaePerfilMaeUsuarioSerializer(asignacion).data,
            status=status.HTTP_201_CREATED if created else status.HTTP_200_OK
        )


class PerfilViewSet(viewsets.ModelViewSet):
    queryset = MaePerfil.objects.all()
    serializer_class = MaePerfilSerializer
    filter_backends = [DjangoFilterBackend, SearchFilter]
    filterset_fields = ['ch_esta_perfil']
    search_fields = ['vc_desc_perfil']


class PerfilUsuarioViewSet(viewsets.ModelViewSet):
    queryset = MaePerfilMaeUsuario.objects.select_related(
        'ch_codi_usuario', 'ch_codi_perfil'
    ).all()
    serializer_class = MaePerfilMaeUsuarioSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['ch_codi_usuario', 'ch_codi_perfil', 'ch_esta_perfil_usua']


class MeView(APIView):
    """Devuelve los datos del usuario autenticado."""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        # El usuario de Django (admin) — en producción enlazar con MaeUsuario
        user = request.user
        return Response({
            'id':       user.id,
            'username': user.username,
            'email':    user.email,
            'is_staff': user.is_staff,
        })
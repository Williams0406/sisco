from rest_framework import serializers, status, viewsets
from rest_framework.decorators import action
from rest_framework.filters import SearchFilter
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from django_filters.rest_framework import DjangoFilterBackend

from maestros.models import MaePerfil, MaePerfilMaeUsuario, MaeUsuario
from maestros.serializers import MaePerfilSerializer, MaeUsuarioSerializer

from .access import resolve_allowed_modules, resolve_user_role
from .permissions import IsAdministrador
from .serializers import MaeUsuarioTokenObtainPairSerializer


class MaePerfilMaeUsuarioSerializer(serializers.ModelSerializer):
    usuario_nombre = serializers.CharField(source='ch_codi_usuario.vc_desc_nomb_usuario', read_only=True)
    perfil_nombre = serializers.CharField(source='ch_codi_perfil.vc_desc_perfil', read_only=True)

    class Meta:
        model = MaePerfilMaeUsuario
        fields = '__all__'


class UsuarioViewSet(viewsets.ModelViewSet):
    queryset = MaeUsuario.objects.all()
    serializer_class = MaeUsuarioSerializer
    permission_classes = [IsAdministrador]
    filter_backends = [DjangoFilterBackend, SearchFilter]
    filterset_fields = ['ch_esta_activo', 'ch_tipo_usuario']
    search_fields = ['vc_desc_nomb_usuario', 'ch_codi_usuario', 'vc_desc_email_usuario']

    @action(detail=True, methods=['post'], url_path='asignar-perfil')
    def asignar_perfil(self, request, pk=None):
        usuario = self.get_object()
        perfil_id = request.data.get('ch_codi_perfil')
        if not perfil_id:
            return Response({'error': 'Se requiere ch_codi_perfil'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            perfil = MaePerfil.objects.get(pk=perfil_id)
        except MaePerfil.DoesNotExist:
            return Response({'error': 'Perfil no encontrado'}, status=status.HTTP_404_NOT_FOUND)

        asignacion, created = MaePerfilMaeUsuario.objects.get_or_create(
            ch_codi_usuario=usuario,
            ch_codi_perfil=perfil,
            defaults={'ch_nume_asigna': '001', 'ch_esta_perfil_usua': '1'},
        )
        return Response(
            MaePerfilMaeUsuarioSerializer(asignacion).data,
            status=status.HTTP_201_CREATED if created else status.HTTP_200_OK,
        )


class PerfilViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MaePerfil.objects.all()
    serializer_class = MaePerfilSerializer
    permission_classes = [IsAdministrador]
    filter_backends = [DjangoFilterBackend, SearchFilter]
    filterset_fields = ['ch_esta_perfil']
    search_fields = ['vc_desc_perfil']


class PerfilUsuarioViewSet(viewsets.ModelViewSet):
    queryset = MaePerfilMaeUsuario.objects.select_related('ch_codi_usuario', 'ch_codi_perfil').all()
    serializer_class = MaePerfilMaeUsuarioSerializer
    permission_classes = [IsAdministrador]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['ch_codi_usuario', 'ch_codi_perfil', 'ch_esta_perfil_usua']


class MeView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        return Response({
            'id': user.ch_codi_usuario,
            'username': user.ch_codi_usuario,
            'codigo_interno': user.ch_codi_usua,
            'nombre': user.vc_desc_nomb_usuario,
            'apellido_paterno': user.vc_desc_apell_paterno,
            'apellido_materno': user.vc_desc_apell_materno,
            'email': user.vc_desc_email_usuario,
            'is_active': user.ch_esta_activo,
            'role': resolve_user_role(user),
            'allowed_modules': resolve_allowed_modules(user),
        })


class CajeroOptionsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        usuarios = (
            MaeUsuario.objects.filter(
                ch_esta_activo=True,
                perfiles__ch_esta_perfil_usua='1',
                perfiles__ch_codi_perfil_id='PER',
            )
            .order_by('vc_desc_nomb_usuario', 'vc_desc_apell_paterno', 'ch_codi_usuario')
            .distinct()
        )
        return Response([
            {
                'codigo': usuario.ch_codi_usuario,
                'nombre': ' '.join(filter(None, [
                    usuario.vc_desc_nomb_usuario,
                    usuario.vc_desc_apell_paterno,
                    usuario.vc_desc_apell_materno,
                ])).strip() or usuario.ch_codi_usuario,
            }
            for usuario in usuarios
        ])


class LoginView(APIView):
    authentication_classes = []
    permission_classes = []

    def post(self, request):
        serializer = MaeUsuarioTokenObtainPairSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        return Response(serializer.validated_data, status=status.HTTP_200_OK)

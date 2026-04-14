from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenRefreshSerializer
from rest_framework_simplejwt.tokens import RefreshToken

from maestros.models import MaeUsuario
from .access import resolve_allowed_modules, resolve_user_role


class MaeUsuarioTokenObtainPairSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField()

    default_error_messages = {
        'invalid_credentials': 'Usuario o contrasena incorrectos.',
        'inactive_user': 'El usuario esta inactivo.',
    }

    def validate(self, attrs):
        username = (attrs.get('username') or '').strip()
        password = attrs.get('password') or ''

        try:
            usuario = MaeUsuario.objects.get(ch_codi_usuario=username)
        except MaeUsuario.DoesNotExist:
            self.fail('invalid_credentials')

        if usuario.ch_esta_activo is False:
            self.fail('inactive_user')

        if (usuario.ch_pass_usua or '') != password:
            self.fail('invalid_credentials')

        refresh = RefreshToken()
        refresh['mae_usuario'] = usuario.ch_codi_usuario
        refresh['username'] = usuario.ch_codi_usuario

        return {
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'user': {
                'id': usuario.ch_codi_usuario,
                'username': usuario.ch_codi_usuario,
                'codigo_interno': usuario.ch_codi_usua,
                'nombre': usuario.vc_desc_nomb_usuario,
                'apellidos': ' '.join(filter(None, [usuario.vc_desc_apell_paterno, usuario.vc_desc_apell_materno])),
                'email': usuario.vc_desc_email_usuario,
                'is_active': usuario.ch_esta_activo,
                'role': resolve_user_role(usuario),
                'allowed_modules': resolve_allowed_modules(usuario),
            },
        }


class MaeUsuarioTokenRefreshSerializer(TokenRefreshSerializer):
    @classmethod
    def get_token(cls, user):
        return super().get_token(user)

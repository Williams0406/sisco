from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.exceptions import InvalidToken

from maestros.models import MaeUsuario
from .current_user import set_current_user


class MaeUsuarioJWTAuthentication(JWTAuthentication):
    def get_user(self, validated_token):
        codigo_usuario = validated_token.get('mae_usuario')
        if not codigo_usuario:
            raise InvalidToken('Token sin usuario MaeUsuario.')

        try:
            user = MaeUsuario.objects.get(ch_codi_usuario=codigo_usuario)
            set_current_user(user)
            return user
        except MaeUsuario.DoesNotExist as exc:
            raise InvalidToken('El usuario asociado al token ya no existe.') from exc

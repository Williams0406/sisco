from rest_framework.permissions import BasePermission

from .access import resolve_user_role


class IsAdministrador(BasePermission):
    message = 'Este recurso solo esta disponible para el perfil Administrador.'

    def has_permission(self, request, view):
        return bool(request.user and getattr(request.user, 'is_authenticated', False) and resolve_user_role(request.user) == 'Administrador')

ADMIN_PROFILE_CODE = 'ADM'
PERSONAL_PROFILE_CODE = 'PER'

ADMIN_MODULES = ['MAESTROS', 'MOVIMIENTOS', 'REPORTES', 'SEGURIDAD']
PERSONAL_MODULES = ['MAESTROS', 'MOVIMIENTOS']


def get_active_profile_codes(user):
    if not getattr(user, 'pk', None):
        return []

    return list(
        user.perfiles.filter(ch_esta_perfil_usua='1')
        .values_list('ch_codi_perfil__ch_codi_perfil', flat=True)
    )


def resolve_user_role(user):
    profile_codes = set(get_active_profile_codes(user))
    if ADMIN_PROFILE_CODE in profile_codes:
        return 'Administrador'
    return 'Personal'


def resolve_allowed_modules(user):
    return ADMIN_MODULES if resolve_user_role(user) == 'Administrador' else PERSONAL_MODULES

from django.db import migrations


ADMIN_PROFILE_CODE = 'ADM'
PERSONAL_PROFILE_CODE = 'PER'


def _next_assignment_number(assignment_model, user_id, profile_id):
    used_numbers = set(
        assignment_model.objects.filter(
            ch_codi_usuario_id=user_id,
            ch_codi_perfil_id=profile_id,
        ).values_list('ch_nume_asigna', flat=True)
    )
    for number in range(1, 1000):
        candidate = str(number).zfill(3)
        if candidate not in used_numbers:
            return candidate
    return '999'


def normalize_profiles(apps, schema_editor):
    MaePerfil = apps.get_model('maestros', 'MaePerfil')
    MaePerfilMaeUsuario = apps.get_model('maestros', 'MaePerfilMaeUsuario')

    admin_profile, _ = MaePerfil.objects.update_or_create(
        ch_codi_perfil=ADMIN_PROFILE_CODE,
        defaults={
            'vc_desc_perfil': 'Administrador',
            'ch_esta_perfil': '1',
        },
    )
    personal_profile, _ = MaePerfil.objects.update_or_create(
        ch_codi_perfil=PERSONAL_PROFILE_CODE,
        defaults={
            'vc_desc_perfil': 'Personal',
            'ch_esta_perfil': '1',
        },
    )

    extra_profiles = MaePerfil.objects.exclude(ch_codi_perfil__in=[ADMIN_PROFILE_CODE, PERSONAL_PROFILE_CODE])
    for profile in extra_profiles:
        description = (profile.vc_desc_perfil or '').strip().lower()
        target_profile = admin_profile if 'admin' in description else personal_profile

        assignments = MaePerfilMaeUsuario.objects.filter(ch_codi_perfil_id=profile.ch_codi_perfil).order_by('ch_codi_usuario_id', 'ch_nume_asigna')
        for assignment in assignments:
            if MaePerfilMaeUsuario.objects.filter(
                ch_codi_usuario_id=assignment.ch_codi_usuario_id,
                ch_codi_perfil_id=target_profile.ch_codi_perfil,
                ch_nume_asigna=assignment.ch_nume_asigna,
            ).exclude(pk=assignment.pk).exists():
                assignment.ch_nume_asigna = _next_assignment_number(
                    MaePerfilMaeUsuario,
                    assignment.ch_codi_usuario_id,
                    target_profile.ch_codi_perfil,
                )
            assignment.ch_codi_perfil_id = target_profile.ch_codi_perfil
            assignment.save(update_fields=['ch_codi_perfil', 'ch_nume_asigna'])

    MaePerfil.objects.exclude(ch_codi_perfil__in=[ADMIN_PROFILE_CODE, PERSONAL_PROFILE_CODE]).delete()


class Migration(migrations.Migration):
    dependencies = [
        ('maestros', '0001_initial'),
    ]

    operations = [
        migrations.RunPython(normalize_profiles, migrations.RunPython.noop),
    ]

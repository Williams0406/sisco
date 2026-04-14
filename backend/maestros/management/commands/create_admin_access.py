from django.core.management import BaseCommand
from django.db import transaction
from django.utils import timezone

from maestros.models import MaePerfil, MaePerfilMaeUsuario, MaeUsuario
from seguridad.access import ADMIN_PROFILE_CODE, PERSONAL_PROFILE_CODE


class Command(BaseCommand):
    help = 'Crea o actualiza un usuario MaeUsuario con perfil Administrador listo para iniciar sesion.'

    def add_arguments(self, parser):
        parser.add_argument('--username', required=True, help='Valor para ch_codi_usuario.')
        parser.add_argument('--password', required=True, help='Valor para ch_pass_usua.')
        parser.add_argument('--nombre', default='Administrador', help='Nombres del usuario.')
        parser.add_argument('--apellido-paterno', default='Sistema', help='Apellido paterno.')
        parser.add_argument('--apellido-materno', default='', help='Apellido materno.')
        parser.add_argument('--email', default='', help='Correo del usuario.')

    def handle(self, *args, **options):
        username = options['username'].strip()
        password = options['password']

        with transaction.atomic():
            MaePerfil.objects.update_or_create(
                ch_codi_perfil=ADMIN_PROFILE_CODE,
                defaults={'vc_desc_perfil': 'Administrador', 'ch_esta_perfil': '1'},
            )
            MaePerfil.objects.update_or_create(
                ch_codi_perfil=PERSONAL_PROFILE_CODE,
                defaults={'vc_desc_perfil': 'Personal', 'ch_esta_perfil': '1'},
            )

            usuario, created = MaeUsuario.objects.update_or_create(
                ch_codi_usuario=username,
                defaults={
                    'vc_desc_nomb_usuario': options['nombre'],
                    'vc_desc_apell_paterno': options['apellido_paterno'],
                    'vc_desc_apell_materno': options['apellido_materno'],
                    'vc_desc_email_usuario': options['email'],
                    'ch_pass_usua': password,
                    'ch_esta_activo': True,
                    'ch_esta_autoriza': '1',
                    'ch_esta_horas_extra': '1',
                    'ch_esta_programa_todos': '1',
                },
            )

            MaePerfilMaeUsuario.objects.filter(ch_codi_usuario=usuario).exclude(ch_codi_perfil_id=ADMIN_PROFILE_CODE).delete()

            asignacion, _ = MaePerfilMaeUsuario.objects.update_or_create(
                ch_codi_usuario=usuario,
                ch_codi_perfil_id=ADMIN_PROFILE_CODE,
                ch_nume_asigna='001',
                defaults={
                    'dt_fech_asigna': timezone.now(),
                    'ch_codi_usua_asigna': usuario.ch_codi_usua,
                    'ch_esta_perfil_usua': '1',
                    'dt_fech_revoca': None,
                    'ch_codi_usua_revoca': None,
                },
            )

        action = 'creado' if created else 'actualizado'
        self.stdout.write(
            self.style.SUCCESS(
                f'Usuario administrador {action}: {usuario.ch_codi_usuario} | codigo interno: {usuario.ch_codi_usua} | perfil: {asignacion.ch_codi_perfil_id}'
            )
        )

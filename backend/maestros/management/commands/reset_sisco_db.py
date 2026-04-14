from django.core.management import BaseCommand, call_command, CommandError
from django.db import transaction

from maestros.models import MaePerfil
from seguridad.access import ADMIN_PROFILE_CODE, PERSONAL_PROFILE_CODE


class Command(BaseCommand):
    help = 'Limpia completamente la base de datos y recrea los perfiles base del sistema.'

    def add_arguments(self, parser):
        parser.add_argument(
            '--yes',
            action='store_true',
            help='Confirma la limpieza sin pedir validacion interactiva.',
        )

    def handle(self, *args, **options):
        if not options['yes']:
            raise CommandError('Este comando elimina todos los datos. Ejecuta nuevamente con --yes para confirmar.')

        self.stdout.write(self.style.WARNING('Limpiando completamente la base de datos...'))
        call_command('flush', interactive=False, verbosity=0)

        with transaction.atomic():
            MaePerfil.objects.update_or_create(
                ch_codi_perfil=ADMIN_PROFILE_CODE,
                defaults={
                    'vc_desc_perfil': 'Administrador',
                    'ch_esta_perfil': '1',
                },
            )
            MaePerfil.objects.update_or_create(
                ch_codi_perfil=PERSONAL_PROFILE_CODE,
                defaults={
                    'vc_desc_perfil': 'Personal',
                    'ch_esta_perfil': '1',
                },
            )

        self.stdout.write(self.style.SUCCESS('Base de datos limpia. Perfiles base recreados: Administrador y Personal.'))

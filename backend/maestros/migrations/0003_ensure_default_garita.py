from django.db import migrations


DEFAULT_GARITA_CODE = 'GAR'
DEFAULT_GARITA_DESC = 'Garita'


def ensure_default_garita(apps, schema_editor):
    MaeGarita = apps.get_model('maestros', 'MaeGarita')
    garita, created = MaeGarita.objects.get_or_create(
        ch_codi_garita=DEFAULT_GARITA_CODE,
        defaults={
            'vc_desc_garita': DEFAULT_GARITA_DESC,
            'ch_esta_activo': True,
        },
    )
    updates = []
    if garita.vc_desc_garita != DEFAULT_GARITA_DESC:
        garita.vc_desc_garita = DEFAULT_GARITA_DESC
        updates.append('vc_desc_garita')
    if garita.ch_esta_activo is not True:
        garita.ch_esta_activo = True
        updates.append('ch_esta_activo')
    if updates:
        garita.save(update_fields=updates)


class Migration(migrations.Migration):

    dependencies = [
        ('maestros', '0002_normalize_perfiles'),
    ]

    operations = [
        migrations.RunPython(ensure_default_garita, migrations.RunPython.noop),
    ]

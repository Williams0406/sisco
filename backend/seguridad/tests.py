from django.core.files.uploadedfile import SimpleUploadedFile
from django.test import TestCase
from rest_framework.test import APIClient

from maestros.models import (
    MaeChofer,
    MaeCliente,
    MaeModulo,
    MaeOpcion,
    MaePerfil,
    MaePerfilMaeUsuario,
    MaeSistema,
    MaeTipoVehiculo,
    MaeUsuario,
    MaeVehiculo,
)


def csv_file(name, rows):
    payload = '\n'.join(rows).encode('utf-8')
    return SimpleUploadedFile(name, payload, content_type='text/csv')


class DataSyncApiTests(TestCase):
    def setUp(self):
        self.client = APIClient()

        self.user = MaeUsuario.objects.create(
            ch_codi_usuario='TESTADMIN',
            vc_desc_nomb_usuario='Administrador',
            ch_pass_usua='1234',
            ch_esta_activo=True,
        )
        self.admin_profile, _ = MaePerfil.objects.get_or_create(
            ch_codi_perfil='ADM',
            defaults={
                'vc_desc_perfil': 'Administrador',
                'ch_esta_perfil': 'A',
            },
        )
        MaePerfilMaeUsuario.objects.create(
            ch_codi_usuario=self.user,
            ch_codi_perfil=self.admin_profile,
            ch_nume_asigna='001',
            ch_esta_perfil_usua='1',
        )
        self.client.force_authenticate(user=self.user)

    def test_import_orders_dependencies_before_child_tables(self):
        response = self.client.post(
            '/api/seguridad/data-sync/import/',
            {
                'dry_run': 'false',
                'files': [
                    csv_file(
                        'MAE_VEHICULO.csv',
                        [
                            'CH_CODI_VEHICULO,CH_PLAC_VEHICULO,CH_TIPO_VEHICULO,CH_CODI_CLIENTE,CH_CODI_CHOFER,CH_ESTA_ACTIVO,CH_ESTA_PARQUEADO',
                            '000001,ABC123,01,0001,0001,A,N',
                        ],
                    ),
                    csv_file(
                        'MAE_CLIENTE.csv',
                        [
                            'CH_CODI_CLIENTE,VC_RAZO_SOCI_CLIENTE,CH_ESTA_ACTIVO',
                            '0001,Cliente demo,A',
                        ],
                    ),
                    csv_file(
                        'MAE_CHOFER.csv',
                        [
                            'CH_CODI_CHOFER,VC_DESC_CHOFER,CH_ESTA_ACTIVO',
                            '0001,Chofer demo,A',
                        ],
                    ),
                    csv_file(
                        'MAE_TIPO_VEHICULO.csv',
                        [
                            'CH_TIPO_VEHICULO,VC_DESC_TIPO_VEHICULO,CH_ESTA_ACTIVO',
                            '01,Camion,A',
                        ],
                    ),
                ],
            },
            format='multipart',
        )

        self.assertEqual(response.status_code, 200, response.data)

        ordered = response.data['ordered_tables']
        self.assertGreater(ordered.index('MAE_VEHICULO'), ordered.index('MAE_CLIENTE'))
        self.assertGreater(ordered.index('MAE_VEHICULO'), ordered.index('MAE_CHOFER'))
        self.assertGreater(ordered.index('MAE_VEHICULO'), ordered.index('MAE_TIPO_VEHICULO'))

        self.assertTrue(MaeCliente.objects.filter(ch_codi_cliente='0001', ch_esta_activo=True).exists())
        self.assertTrue(MaeChofer.objects.filter(ch_codi_chofer='0001', ch_esta_activo=True).exists())
        self.assertTrue(MaeTipoVehiculo.objects.filter(ch_tipo_vehiculo='01', ch_esta_activo=True).exists())

        vehiculo = MaeVehiculo.objects.get(ch_codi_vehiculo='000001')
        self.assertEqual(vehiculo.ch_codi_cliente_id, '0001')
        self.assertEqual(vehiculo.ch_codi_chofer_id, '0001')
        self.assertEqual(vehiculo.ch_tipo_vehiculo_id, '01')
        self.assertTrue(vehiculo.ch_esta_activo)
        self.assertFalse(vehiculo.ch_esta_parqueado)

    def test_import_resolves_legacy_mae_opcion_module_reference(self):
        response = self.client.post(
            '/api/seguridad/data-sync/import/',
            {
                'dry_run': 'false',
                'files': [
                    csv_file(
                        'MAE_OPCION.csv',
                        [
                            'CH_CODI_SISTEMA,CH_CODI_MODULO,CH_CODI_OPCION,VC_DESC_OPCION,VC_DESC_NOM_VENTANA,VC_TIPO_OPCION,CH_ESTA_PARAMETRO,CH_ESTA_OPCION',
                            '100,001,01,Clientes,w_mae_mto_cliente,OPC,N,A',
                        ],
                    ),
                    csv_file(
                        'MAE_MODULO.csv',
                        [
                            'CH_CODI_SISTEMA,CH_CODI_MODULO,VC_DESC_MODULO,CH_ESTA_MODULO',
                            '100,001,MAESTROS,A',
                        ],
                    ),
                    csv_file(
                        'MAE_SISTEMA.csv',
                        [
                            'CH_CODI_SISTEMA,VC_DESC_SISTEMA,CH_ESTA_ACTIVO',
                            '100,SISCO,A',
                        ],
                    ),
                ],
            },
            format='multipart',
        )

        self.assertEqual(response.status_code, 200, response.data)
        self.assertTrue(MaeSistema.objects.filter(ch_codi_sistema='100').exists())
        self.assertTrue(MaeModulo.objects.filter(ch_codi_sistema_id='100', ch_codi_modulo='001').exists())

        opcion = MaeOpcion.objects.select_related('ch_codi_modulo_fk').get(
            ch_codi_sistema='100',
            ch_codi_opcion='01',
        )
        self.assertEqual(opcion.ch_codi_modulo_fk.ch_codi_modulo, '001')
        self.assertEqual(opcion.vc_desc_opcion, 'Clientes')

    def test_export_csv_uses_legacy_headers(self):
        MaeCliente.objects.create(
            ch_codi_cliente='0001',
            vc_razo_soci_cliente='Cliente exportado',
            ch_esta_activo=True,
        )

        response = self.client.post(
            '/api/seguridad/data-sync/export/',
            {'tables': ['MAE_CLIENTE'], 'format': 'csv'},
            format='json',
        )

        self.assertEqual(response.status_code, 200)
        self.assertIn('attachment; filename="MAE_CLIENTE_', response['Content-Disposition'])

        body = response.content.decode('utf-8-sig')
        header, row = body.strip().split('\n', 1)

        self.assertTrue(header.startswith('CH_CODI_CLIENTE,CH_RUC_CLIENTE,VC_RAZO_SOCI_CLIENTE'))
        self.assertIn('0001', row)
        self.assertIn('Cliente exportado', row)
        self.assertIn('A', row)

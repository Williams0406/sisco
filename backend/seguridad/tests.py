from unittest.mock import patch

from django.core.files.uploadedfile import SimpleUploadedFile
from django.db import DatabaseError
from django.test import TestCase
from rest_framework.test import APIClient

from maestros.models import (
    MaeChofer,
    MaeCliente,
    MaeGarita,
    MaeModulo,
    MaeOpcion,
    MaePerfil,
    MaePerfilMaeUsuario,
    MaeSistema,
    MaeTipoVehiculo,
    MaeUsuario,
    MaeVehiculo,
)
from movimientos.models import DetTarifario, MovTicket


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

    @patch('seguridad.data_exchange.DELIMITED_STREAM_CHUNK_SIZE', 1)
    def test_import_streams_single_large_csv_for_explicit_pk_table(self):
        response = self.client.post(
            '/api/seguridad/data-sync/import/',
            {
                'dry_run': 'false',
                'files': [
                    csv_file(
                        'MOV_TICKET.csv',
                        [
                            'NU_CODI_TICKET,CH_ESTA_TICKET,CH_TIPO_COMPROBANTE',
                            '1,A,01',
                            '2,C,02',
                        ],
                    ),
                ],
            },
            format='multipart',
        )

        self.assertEqual(response.status_code, 200, response.data)
        self.assertEqual(response.data['ordered_tables'], ['MOV_TICKET'])
        self.assertEqual(response.data['total_rows'], 2)
        self.assertEqual(response.data['total_created'], 2)
        self.assertTrue(MovTicket.objects.filter(nu_codi_ticket=1, ch_esta_ticket='A').exists())
        self.assertTrue(MovTicket.objects.filter(nu_codi_ticket=2, ch_esta_ticket='C').exists())

    def test_import_streams_semicolon_delimited_csv_for_explicit_pk_table(self):
        response = self.client.post(
            '/api/seguridad/data-sync/import/',
            {
                'dry_run': 'false',
                'files': [
                    csv_file(
                        'MOV_TICKET.csv',
                        [
                            'NU_CODI_TICKET;CH_ESTA_TICKET;CH_TIPO_COMPROBANTE',
                            '1;A;01',
                            '2;C;02',
                        ],
                    ),
                ],
            },
            format='multipart',
        )

        self.assertEqual(response.status_code, 200, response.data)
        self.assertEqual(response.data['ordered_tables'], ['MOV_TICKET'])
        self.assertEqual(response.data['total_rows'], 2)
        self.assertEqual(response.data['total_created'], 2)
        self.assertTrue(MovTicket.objects.filter(nu_codi_ticket=1, ch_esta_ticket='A').exists())
        self.assertTrue(MovTicket.objects.filter(nu_codi_ticket=2, ch_esta_ticket='C').exists())

    def test_import_normalizes_legacy_turno_codes_to_numeric_values(self):
        response = self.client.post(
            '/api/seguridad/data-sync/import/',
            {
                'dry_run': 'false',
                'files': [
                    csv_file(
                        'MOV_TICKET.csv',
                        [
                            'NU_CODI_TICKET,CH_CODI_TURNO_CAJA,CH_CODI_TURNO_SLD,CH_ESTA_TICKET,CH_TIPO_COMPROBANTE',
                            '1,01,noche,A,01',
                        ],
                    ),
                ],
            },
            format='multipart',
        )

        self.assertEqual(response.status_code, 200, response.data)
        ticket = MovTicket.objects.get(nu_codi_ticket=1)
        self.assertEqual(ticket.ch_codi_turno_caja, '1')
        self.assertEqual(ticket.ch_codi_turno_sld, '2')

    def test_import_rejects_overlong_mov_ticket_char_values_before_hitting_db(self):
        response = self.client.post(
            '/api/seguridad/data-sync/import/',
            {
                'dry_run': 'false',
                'files': [
                    csv_file(
                        'MOV_TICKET.csv',
                        [
                            'NU_CODI_TICKET,CH_ESTA_TICKET,CH_TIPO_COMPROBANTE',
                            '1,AB,01',
                        ],
                    ),
                ],
            },
            format='multipart',
        )

        self.assertEqual(response.status_code, 400, response.data)
        self.assertEqual(response.data['detail'], 'No se pudo completar la importacion.')
        self.assertIn(
            'MOV_TICKET.csv fila 1: La columna CH_ESTA_TICKET excede la longitud maxima de 1 caracteres.',
            response.data['errors'],
        )

    @patch('seguridad.data_exchange._execute_upsert', side_effect=DatabaseError('error simulado de base de datos'))
    def test_import_surfaces_database_write_errors_as_import_errors(self, _mock_execute_upsert):
        response = self.client.post(
            '/api/seguridad/data-sync/import/',
            {
                'dry_run': 'false',
                'files': [
                    csv_file(
                        'MOV_TICKET.csv',
                        [
                            'NU_CODI_TICKET,CH_ESTA_TICKET,CH_TIPO_COMPROBANTE',
                            '1,A,01',
                        ],
                    ),
                ],
            },
            format='multipart',
        )

        self.assertEqual(response.status_code, 400, response.data)
        self.assertEqual(response.data['detail'], 'No se pudo completar la importacion.')
        self.assertEqual(
            response.data['errors'],
            ['MOV_TICKET: error al guardar los registros. error simulado de base de datos'],
        )

    def test_import_normalizes_numeric_char_codes_for_mov_ticket_dependencies(self):
        response = self.client.post(
            '/api/seguridad/data-sync/import/',
            {
                'dry_run': 'false',
                'files': [
                    csv_file(
                        'MOV_TICKET.csv',
                        [
                            'NU_CODI_TICKET,CH_CODI_GARITA,CH_CODI_VEHICULO,CH_CODI_CLIENTE,CH_CODI_CHOFER,CH_CODI_TARIFARIO,CH_ESTA_TICKET,CH_TIPO_COMPROBANTE',
                            '1,GAR,1,1,1.0,1.0,A,1.0',
                        ],
                    ),
                    csv_file(
                        'DET_TARIFARIO.csv',
                        [
                            'CH_CODI_TARIFARIO,CH_TIPO_VEHICULO,CH_CODI_CLIENTE,NU_IMPO_DIA,NU_IMPO_NOCHE,CH_ESTA_ACTIVO',
                            '1,1,1,10,20,A',
                        ],
                    ),
                    csv_file(
                        'MAE_VEHICULO.csv',
                        [
                            'CH_CODI_VEHICULO,CH_PLAC_VEHICULO,CH_TIPO_VEHICULO,CH_CODI_CLIENTE,CH_CODI_CHOFER,CH_ESTA_ACTIVO,CH_ESTA_PARQUEADO',
                            '1,ABC123,1,1,1,A,N',
                        ],
                    ),
                    csv_file(
                        'MAE_GARITA.csv',
                        [
                            'CH_CODI_GARITA,VC_DESC_GARITA,CH_ESTA_ACTIVO',
                            'GAR,Garita demo,A',
                        ],
                    ),
                    csv_file(
                        'MAE_CLIENTE.csv',
                        [
                            'CH_CODI_CLIENTE,VC_RAZO_SOCI_CLIENTE,CH_ESTA_ACTIVO',
                            '1,Cliente demo,A',
                        ],
                    ),
                    csv_file(
                        'MAE_CHOFER.csv',
                        [
                            'CH_CODI_CHOFER,VC_DESC_CHOFER,CH_ESTA_ACTIVO',
                            '1,Chofer demo,A',
                        ],
                    ),
                    csv_file(
                        'MAE_TIPO_VEHICULO.csv',
                        [
                            'CH_TIPO_VEHICULO,VC_DESC_TIPO_VEHICULO,CH_ESTA_ACTIVO',
                            '1,Camion,A',
                        ],
                    ),
                ],
            },
            format='multipart',
        )

        self.assertEqual(response.status_code, 200, response.data)
        self.assertTrue(MaeGarita.objects.filter(ch_codi_garita='GAR').exists())
        self.assertTrue(MaeCliente.objects.filter(ch_codi_cliente='0001').exists())
        self.assertTrue(MaeChofer.objects.filter(ch_codi_chofer='0001').exists())
        self.assertTrue(MaeTipoVehiculo.objects.filter(ch_tipo_vehiculo='01').exists())
        self.assertTrue(MaeVehiculo.objects.filter(ch_codi_vehiculo='000001').exists())
        self.assertTrue(DetTarifario.objects.filter(ch_codi_tarifario='000001').exists())

        ticket = MovTicket.objects.get(nu_codi_ticket=1)
        self.assertEqual(ticket.ch_codi_garita_id, 'GAR')
        self.assertEqual(ticket.ch_codi_vehiculo_id, '000001')
        self.assertEqual(ticket.ch_codi_cliente_id, '0001')
        self.assertEqual(ticket.ch_codi_chofer_id, '0001')
        self.assertEqual(ticket.ch_codi_tarifario_id, '000001')
        self.assertEqual(ticket.ch_tipo_comprobante, '1')

    def test_import_reports_missing_provider_dependency_for_cab_recibo_egreso(self):
        response = self.client.post(
            '/api/seguridad/data-sync/import/',
            {
                'dry_run': 'false',
                'files': [
                    csv_file(
                        'MAE_TIPO_EGRESO.csv',
                        [
                            'CH_CODI_TIPO_EGRESO,VC_DESC_TIPO_EGRESO,CH_ESTA_ACTIVO',
                            '011,Viaticos,A',
                        ],
                    ),
                    csv_file(
                        'CAB_RECIBO_EGRESO.csv',
                        [
                            'NU_CODI_RECIBO,CH_CODI_TIPO_EGRESO,CH_CODI_PROVEEDOR,CH_ESTA_ACTIVO',
                            '1,011,0001,A',
                        ],
                    ),
                ],
            },
            format='multipart',
        )

        self.assertEqual(response.status_code, 400, response.data)
        self.assertEqual(response.data['detail'], 'No se pudo completar la importacion.')
        self.assertIn(
            'CAB_RECIBO_EGRESO: faltan referencias para ch_codi_proveedor_id en MAE_PROVEEDOR: 0001. Importa MAE_PROVEEDOR antes o junto con CAB_RECIBO_EGRESO.',
            response.data['errors'],
        )

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

    def test_clear_table_removes_rows_when_no_dependents_exist(self):
        MaeCliente.objects.create(
            ch_codi_cliente='0001',
            vc_razo_soci_cliente='Cliente limpio',
            ch_esta_activo=True,
        )

        response = self.client.post(
            '/api/seguridad/data-sync/clear/',
            {'table': 'MAE_CLIENTE'},
            format='json',
        )

        self.assertEqual(response.status_code, 200, response.data)
        self.assertEqual(response.data['table'], 'MAE_CLIENTE')
        self.assertEqual(response.data['deleted_rows'], 1)
        self.assertFalse(MaeCliente.objects.filter(ch_codi_cliente='0001').exists())

    def test_clear_table_rejects_when_supported_dependents_have_rows(self):
        cliente = MaeCliente.objects.create(
            ch_codi_cliente='0001',
            vc_razo_soci_cliente='Cliente con vehiculo',
            ch_esta_activo=True,
        )
        chofer = MaeChofer.objects.create(
            ch_codi_chofer='0001',
            vc_desc_chofer='Chofer demo',
            ch_esta_activo=True,
        )
        tipo = MaeTipoVehiculo.objects.create(
            ch_tipo_vehiculo='01',
            vc_desc_tipo_vehiculo='Camion',
            ch_esta_activo=True,
        )
        MaeVehiculo.objects.create(
            ch_codi_vehiculo='000001',
            ch_plac_vehiculo='ABC-123',
            ch_tipo_vehiculo=tipo,
            ch_codi_cliente=cliente,
            ch_codi_chofer=chofer,
            ch_esta_activo=True,
            ch_esta_parqueado=False,
        )

        response = self.client.post(
            '/api/seguridad/data-sync/clear/',
            {'table': 'MAE_CLIENTE'},
            format='json',
        )

        self.assertEqual(response.status_code, 400, response.data)
        self.assertEqual(
            response.data['detail'],
            'No se puede limpiar la tabla mientras existan registros en tablas dependientes.',
        )
        self.assertEqual(response.data['blocking_tables'][0]['key'], 'MAE_VEHICULO')
        self.assertTrue(MaeCliente.objects.filter(ch_codi_cliente='0001').exists())

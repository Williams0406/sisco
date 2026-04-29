from datetime import datetime

from django.test import TestCase

from .models import CabCierreTurno, SHIFT_DAY, SHIFT_NIGHT, _normalize_turno_code


class TurnoCodeTests(TestCase):
    def test_normalize_turno_code_accepts_legacy_aliases(self):
        self.assertEqual(_normalize_turno_code('1'), SHIFT_DAY)
        self.assertEqual(_normalize_turno_code('01'), SHIFT_DAY)
        self.assertEqual(_normalize_turno_code('dia'), SHIFT_DAY)
        self.assertEqual(_normalize_turno_code('2'), SHIFT_NIGHT)
        self.assertEqual(_normalize_turno_code('02'), SHIFT_NIGHT)
        self.assertEqual(_normalize_turno_code('noche'), SHIFT_NIGHT)
        self.assertIsNone(_normalize_turno_code('3'))

    def test_cierre_turno_save_persists_numeric_shift_code(self):
        cierre = CabCierreTurno.objects.create(
            dt_fech_turno=datetime(2026, 4, 29, 8, 30),
            ch_codi_turno_caja='02',
            ch_esta_activo='1',
            ch_tipo_cierre='T',
        )

        self.assertEqual(cierre.ch_codi_turno_caja, SHIFT_DAY)


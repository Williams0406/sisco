from django.core.exceptions import ValidationError
from django.test import TestCase

from .models import normalize_vehicle_plate
from .serializers import MaeVehiculoSerializer


class MaeVehiculoPlateTests(TestCase):
    def test_normalize_vehicle_plate_formats_uppercase_values(self):
        self.assertEqual(normalize_vehicle_plate('er8 45g'), 'ER8-45G')

    def test_serializer_rejects_invalid_plate_format(self):
        serializer = MaeVehiculoSerializer(data={'ch_plac_vehiculo': 'ABC-12'})

        self.assertFalse(serializer.is_valid())
        self.assertEqual(
            serializer.errors['ch_plac_vehiculo'][0],
            'La placa debe tener el formato ABC-123 usando solo letras mayusculas y numeros.',
        )

    def test_serializer_requires_plate(self):
        serializer = MaeVehiculoSerializer(data={})

        self.assertFalse(serializer.is_valid())
        self.assertEqual(serializer.errors['ch_plac_vehiculo'][0], 'Este campo es requerido.')

    def test_serializer_saves_plate_with_normalized_format(self):
        serializer = MaeVehiculoSerializer(data={'ch_plac_vehiculo': 'ab7879'})

        self.assertTrue(serializer.is_valid(), serializer.errors)
        vehiculo = serializer.save()

        self.assertEqual(vehiculo.ch_plac_vehiculo, 'AB7-879')

    def test_normalize_vehicle_plate_rejects_empty_value(self):
        with self.assertRaises(ValidationError):
            normalize_vehicle_plate('')

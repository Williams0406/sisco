import { useEffect, useState } from 'react';
import api from '../../api/axios';
import MasterSplitView from './MasterSplitView';
import { isTrueValue, toBooleanOrNull } from './booleanUtils';

const VEHICLE_PLATE_REGEX = /^[A-Z0-9]{3}-[A-Z0-9]{3}$/;

const formatVehiclePlateInput = (value) => {
  const compactValue = String(value ?? '')
    .toUpperCase()
    .replace(/[^A-Z0-9]/g, '')
    .slice(0, 6);

  if (compactValue.length <= 3) return compactValue;
  return `${compactValue.slice(0, 3)}-${compactValue.slice(3)}`;
};

const normalizeVehiclePlate = (value) => {
  const rawValue = String(value ?? '').trim().toUpperCase();
  const compactValue = rawValue.replace(/[-\s]/g, '');

  if (!/^[A-Z0-9]{6}$/.test(compactValue)) return null;
  return `${compactValue.slice(0, 3)}-${compactValue.slice(3)}`;
};

const createEmptyForm = () => ({
  ch_codi_vehiculo: '',
  ch_plac_vehiculo: '',
  ch_tipo_vehiculo: '',
  ch_codi_cliente: '',
  ch_codi_chofer: '',
  ch_esta_parqueado: 'false',
  ch_esta_activo: 'true',
});

const columns = [
  { key: 'ch_codi_vehiculo', label: 'Codigo' },
  { key: 'ch_plac_vehiculo', label: 'Placa' },
  { key: 'tipo_vehiculo_desc', label: 'Tipo' },
  { key: 'cliente_desc', label: 'Cliente' },
  { key: 'chofer_desc', label: 'Chofer' },
  { key: 'ch_esta_parqueado', label: 'Parqueado', render: (value) => (isTrueValue(value) ? 'Si' : 'No') },
  { key: 'ch_esta_activo', label: 'Estado', render: (value) => (isTrueValue(value) ? 'Activo' : 'Inactivo') },
];

export default function Vehiculos() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [editId, setEditId] = useState(null);
  const [form, setForm] = useState(createEmptyForm());
  const [tiposVeh, setTiposVeh] = useState([]);
  const [clientes, setClientes] = useState([]);
  const [choferes, setChoferes] = useState([]);

  const fetchData = async () => {
    setLoading(true);
    try {
      const [vehiculosRes, tiposRes, clientesRes, choferesRes] = await Promise.all([
        api.get('/maestros/vehiculos/?page_size=200'),
        api.get('/maestros/tipo-vehiculos/?page_size=200'),
        api.get('/maestros/clientes/?page_size=200'),
        api.get('/maestros/choferes/?page_size=200'),
      ]);

      setData(vehiculosRes.data.results || vehiculosRes.data);
      setTiposVeh(tiposRes.data.results || tiposRes.data);
      setClientes(clientesRes.data.results || clientesRes.data);
      setChoferes(choferesRes.data.results || choferesRes.data);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const handleChange = (key, value) => {
    setForm((prev) => ({
      ...prev,
      [key]: key === 'ch_plac_vehiculo' ? formatVehiclePlateInput(value) : value,
    }));
  };

  const handleNew = () => {
    setEditId(null);
    setForm(createEmptyForm());
  };

  const handleSelect = (row) => {
    setEditId(row.ch_codi_vehiculo);
    setForm({
      ch_codi_vehiculo: row.ch_codi_vehiculo ?? '',
      ch_plac_vehiculo: normalizeVehiclePlate(row.ch_plac_vehiculo) ?? String(row.ch_plac_vehiculo ?? '').toUpperCase(),
      ch_tipo_vehiculo: row.ch_tipo_vehiculo ?? '',
      ch_codi_cliente: row.ch_codi_cliente ?? '',
      ch_codi_chofer: row.ch_codi_chofer ?? '',
      ch_esta_parqueado: isTrueValue(row.ch_esta_parqueado) ? 'true' : 'false',
      ch_esta_activo: isTrueValue(row.ch_esta_activo) ? 'true' : 'false',
    });
  };

  const fields = [
    { key: 'ch_codi_vehiculo', label: 'Codigo', readOnly: true, placeholder: 'Generado automaticamente' },
    { key: 'ch_plac_vehiculo', label: 'Placa', placeholder: 'ABC-123', maxLength: 7 },
    {
      key: 'ch_tipo_vehiculo',
      label: 'Tipo de vehiculo',
      type: 'select',
      options: tiposVeh.map((item) => ({ value: item.ch_tipo_vehiculo, label: item.vc_desc_tipo_vehiculo })),
      placeholder: 'Seleccionar tipo',
    },
    {
      key: 'ch_codi_cliente',
      label: 'Cliente',
      type: 'select',
      options: clientes.map((item) => ({ value: item.ch_codi_cliente, label: item.vc_razo_soci_cliente })),
      placeholder: 'Seleccionar cliente',
    },
    {
      key: 'ch_codi_chofer',
      label: 'Chofer',
      type: 'select',
      options: choferes.map((item) => ({ value: item.ch_codi_chofer, label: item.vc_desc_chofer })),
      placeholder: 'Seleccionar chofer',
    },
    {
      key: 'ch_esta_parqueado',
      label: 'Parqueado',
      type: 'select',
      options: [
        { value: 'true', label: 'Si' },
        { value: 'false', label: 'No' },
      ],
    },
    {
      key: 'ch_esta_activo',
      label: 'Estado',
      type: 'select',
      options: [
        { value: 'true', label: 'Activo' },
        { value: 'false', label: 'Inactivo' },
      ],
    },
  ];

  const handleSave = async () => {
    const normalizedPlate = normalizeVehiclePlate(form.ch_plac_vehiculo);
    if (!normalizedPlate || !VEHICLE_PLATE_REGEX.test(normalizedPlate)) {
      alert('La placa debe tener el formato ABC-123 usando solo letras mayusculas y numeros.');
      return;
    }

    setSaving(true);
    try {
      const payload = {
        ...form,
        ch_plac_vehiculo: normalizedPlate,
        ch_esta_activo: toBooleanOrNull(form.ch_esta_activo),
        ch_esta_parqueado: toBooleanOrNull(form.ch_esta_parqueado),
      };

      if (!editId) delete payload.ch_codi_vehiculo;

      if (editId) await api.put(`/maestros/vehiculos/${editId}/`, payload);
      else await api.post('/maestros/vehiculos/', payload);

      await fetchData();
      handleNew();
    } catch (err) {
      alert(`Error al guardar: ${JSON.stringify(err.response?.data || err.message)}`);
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async () => {
    if (!editId) return;
    if (!confirm(`Eliminar vehiculo ${form.ch_plac_vehiculo || editId}?`)) return;
    await api.delete(`/maestros/vehiculos/${editId}/`);
    await fetchData();
    handleNew();
  };

  return (
    <MasterSplitView
      title="Vehiculos"
      singularTitle="vehiculo"
      subtitle="Registra y consulta vehiculos con acceso directo al detalle sin abrir modales."
      columns={columns}
      data={data}
      loading={loading}
      form={form}
      fields={fields}
      editId={editId}
      saving={saving}
      onChange={handleChange}
      onNew={handleNew}
      onSelect={handleSelect}
      onSave={handleSave}
      onDelete={handleDelete}
      getRowId={(row) => row.ch_codi_vehiculo}
      getRowTitle={() => 'vehiculo'}
    />
  );
}

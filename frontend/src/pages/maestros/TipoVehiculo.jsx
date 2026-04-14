import { useEffect, useState } from 'react';
import api from '../../api/axios';
import MasterSplitView from './MasterSplitView';
import { isTrueValue, toBooleanOrNull } from './booleanUtils';

const createEmptyForm = () => ({
  ch_tipo_vehiculo: '',
  vc_desc_tipo_vehiculo: '',
  ch_esta_activo: 'true',
});

const columns = [
  { key: 'ch_tipo_vehiculo', label: 'Codigo' },
  { key: 'vc_desc_tipo_vehiculo', label: 'Descripcion' },
  { key: 'ch_esta_activo', label: 'Estado', render: (value) => (isTrueValue(value) ? 'Activo' : 'Inactivo') },
];

const fields = [
  { key: 'ch_tipo_vehiculo', label: 'Codigo', readOnly: true, placeholder: 'Generado automaticamente' },
  { key: 'vc_desc_tipo_vehiculo', label: 'Descripcion', placeholder: 'Ejemplo: Sedan' },
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

export default function TipoVehiculo() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [editId, setEditId] = useState(null);
  const [form, setForm] = useState(createEmptyForm());

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await api.get('/maestros/tipo-vehiculos/?page_size=200');
      setData(res.data.results || res.data);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const handleNew = () => {
    setEditId(null);
    setForm(createEmptyForm());
  };

  const handleSelect = (row) => {
    setEditId(row.ch_tipo_vehiculo);
    setForm({
      ch_tipo_vehiculo: row.ch_tipo_vehiculo ?? '',
      vc_desc_tipo_vehiculo: row.vc_desc_tipo_vehiculo ?? '',
      ch_esta_activo: isTrueValue(row.ch_esta_activo) ? 'true' : 'false',
    });
  };

  const handleSave = async () => {
    setSaving(true);
    try {
      const payload = {
        ...form,
        ch_esta_activo: toBooleanOrNull(form.ch_esta_activo),
      };

      if (!editId) delete payload.ch_tipo_vehiculo;

      if (editId) await api.put(`/maestros/tipo-vehiculos/${editId}/`, payload);
      else await api.post('/maestros/tipo-vehiculos/', payload);

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
    if (!confirm(`Eliminar tipo de vehiculo ${form.vc_desc_tipo_vehiculo || editId}?`)) return;
    await api.delete(`/maestros/tipo-vehiculos/${editId}/`);
    await fetchData();
    handleNew();
  };

  return (
    <MasterSplitView
      title="Tipos de vehiculo"
      singularTitle="tipo de vehiculo"
      subtitle="Gestiona categorias de vehiculos con una vista unificada de consulta y mantenimiento."
      columns={columns}
      data={data}
      loading={loading}
      form={form}
      fields={fields}
      editId={editId}
      saving={saving}
      onChange={(key, value) => setForm((prev) => ({ ...prev, [key]: value }))}
      onNew={handleNew}
      onSelect={handleSelect}
      onSave={handleSave}
      onDelete={handleDelete}
      getRowId={(row) => row.ch_tipo_vehiculo}
      getRowTitle={() => 'tipo de vehiculo'}
    />
  );
}

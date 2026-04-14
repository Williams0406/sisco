import { useEffect, useState } from 'react';
import api from '../../api/axios';
import MasterSplitView from './MasterSplitView';
import { isTrueValue, toBooleanOrNull } from './booleanUtils';

const createEmptyForm = () => ({
  ch_codi_tipo_incidente: '',
  vc_desc_tipo_incidente: '',
  ch_esta_activo: 'true',
});

const columns = [
  { key: 'ch_codi_tipo_incidente', label: 'Codigo' },
  { key: 'vc_desc_tipo_incidente', label: 'Descripcion' },
  { key: 'ch_esta_activo', label: 'Estado', render: (value) => (isTrueValue(value) ? 'Activo' : 'Inactivo') },
];

const fields = [
  { key: 'ch_codi_tipo_incidente', label: 'Codigo', readOnly: true, placeholder: 'Generado automaticamente' },
  { key: 'vc_desc_tipo_incidente', label: 'Descripcion', placeholder: 'Tipo de incidente' },
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

export default function TipoIncidente() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [editId, setEditId] = useState(null);
  const [form, setForm] = useState(createEmptyForm());

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await api.get('/maestros/tipo-incidentes/?page_size=200');
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
    setEditId(row.ch_codi_tipo_incidente);
    setForm({
      ch_codi_tipo_incidente: row.ch_codi_tipo_incidente ?? '',
      vc_desc_tipo_incidente: row.vc_desc_tipo_incidente ?? '',
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

      if (!editId) delete payload.ch_codi_tipo_incidente;

      if (editId) await api.put(`/maestros/tipo-incidentes/${editId}/`, payload);
      else await api.post('/maestros/tipo-incidentes/', payload);

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
    if (!confirm(`Eliminar tipo de incidente ${form.vc_desc_tipo_incidente || editId}?`)) return;
    await api.delete(`/maestros/tipo-incidentes/${editId}/`);
    await fetchData();
    handleNew();
  };

  return (
    <MasterSplitView
      title="Tipos de incidente"
      singularTitle="tipo de incidente"
      subtitle="Organiza incidentes operativos en una pantalla mas clara y continua."
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
      getRowId={(row) => row.ch_codi_tipo_incidente}
      getRowTitle={() => 'tipo de incidente'}
    />
  );
}

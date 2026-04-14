import { useEffect, useState } from 'react';
import api from '../../api/axios';
import MasterSplitView from './MasterSplitView';
import { isTrueValue, toBooleanOrNull } from './booleanUtils';

const createEmptyForm = () => ({
  ch_codi_chofer: '',
  vc_desc_chofer: '',
  ch_nume_dni: '',
  ch_nume_celu: '',
  vc_dire_chofer: '',
  ch_esta_activo: 'true',
});

const columns = [
  { key: 'ch_codi_chofer', label: 'Codigo' },
  { key: 'vc_desc_chofer', label: 'Nombre' },
  { key: 'ch_nume_dni', label: 'DNI' },
  { key: 'ch_nume_celu', label: 'Celular' },
  { key: 'vc_dire_chofer', label: 'Direccion' },
  { key: 'ch_esta_activo', label: 'Estado', render: (value) => (isTrueValue(value) ? 'Activo' : 'Inactivo') },
];

const fields = [
  { key: 'ch_codi_chofer', label: 'Codigo', readOnly: true, placeholder: 'Generado automaticamente' },
  { key: 'vc_desc_chofer', label: 'Nombre completo', placeholder: 'Nombre del chofer' },
  { key: 'ch_nume_dni', label: 'DNI', placeholder: '8 digitos' },
  { key: 'ch_nume_celu', label: 'Celular', placeholder: 'Telefono de contacto' },
  { key: 'vc_dire_chofer', label: 'Direccion', placeholder: 'Direccion' },
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

export default function Choferes() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [editId, setEditId] = useState(null);
  const [form, setForm] = useState(createEmptyForm());

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await api.get('/maestros/choferes/?page_size=200');
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
    setEditId(row.ch_codi_chofer);
    setForm({
      ch_codi_chofer: row.ch_codi_chofer ?? '',
      vc_desc_chofer: row.vc_desc_chofer ?? '',
      ch_nume_dni: row.ch_nume_dni ?? '',
      ch_nume_celu: row.ch_nume_celu ?? '',
      vc_dire_chofer: row.vc_dire_chofer ?? '',
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

      if (!editId) delete payload.ch_codi_chofer;

      if (editId) await api.put(`/maestros/choferes/${editId}/`, payload);
      else await api.post('/maestros/choferes/', payload);

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
    if (!confirm(`Eliminar chofer ${form.vc_desc_chofer || editId}?`)) return;
    await api.delete(`/maestros/choferes/${editId}/`);
    await fetchData();
    handleNew();
  };

  return (
    <MasterSplitView
      title="Choferes"
      singularTitle="chofer"
      subtitle="Consulta y registra choferes desde una vista continua de listado y detalle."
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
      getRowId={(row) => row.ch_codi_chofer}
      getRowTitle={() => 'chofer'}
    />
  );
}

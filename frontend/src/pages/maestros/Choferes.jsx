import { useEffect, useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';
import FormModal from '../../components/FormModal';

const COLUMNS = [
  { key: 'ch_codi_chofer',  label: 'Código' },
  { key: 'vc_desc_chofer',  label: 'Nombre' },
  { key: 'ch_nume_dni',     label: 'DNI' },
  { key: 'ch_nume_celu',    label: 'Celular' },
  { key: 'vc_dire_chofer',  label: 'Dirección' },
  { key: 'ch_esta_activo',  label: 'Estado',
    render: (v) => v === '1' ? '✅ Activo' : '❌ Inactivo' },
];

const FIELDS = [
  { key: 'ch_codi_chofer', label: 'Código',    placeholder: 'Ej: C001' },
  { key: 'vc_desc_chofer', label: 'Nombre completo' },
  { key: 'ch_nume_dni',    label: 'DNI',        placeholder: '8 dígitos' },
  { key: 'ch_nume_celu',   label: 'Celular' },
  { key: 'vc_dire_chofer', label: 'Dirección' },
  { key: 'ch_esta_activo', label: 'Estado', type: 'select',
    options: [{ value: '1', label: 'Activo' }, { value: '0', label: 'Inactivo' }] },
];

export default function Choferes() {
  const [data, setData]     = useState([]);
  const [loading, setLoading] = useState(true);
  const [modal, setModal]   = useState(false);
  const [form, setForm]     = useState({});
  const [saving, setSaving] = useState(false);
  const [editId, setEditId] = useState(null);

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await api.get('/maestros/choferes/?page_size=200');
      setData(res.data.results || res.data);
    } finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  const handleNew  = () => { setForm({}); setEditId(null); setModal(true); };
  const handleEdit = (row) => { setForm({ ...row }); setEditId(row.ch_codi_chofer); setModal(true); };
  const handleDelete = async (row) => {
    if (!confirm(`¿Eliminar chofer ${row.vc_desc_chofer}?`)) return;
    await api.delete(`/maestros/choferes/${row.ch_codi_chofer}/`);
    fetchData();
  };
  const handleSave = async () => {
    setSaving(true);
    try {
      editId
        ? await api.put(`/maestros/choferes/${editId}/`, form)
        : await api.post('/maestros/choferes/', form);
      setModal(false); fetchData();
    } catch (err) {
      alert('Error: ' + JSON.stringify(err.response?.data));
    } finally { setSaving(false); }
  };

  return (
    <>
      <DataTable title="Choferes" columns={COLUMNS} data={data}
        loading={loading} onNew={handleNew} onEdit={handleEdit} onDelete={handleDelete} />
      {modal && (
        <FormModal
          title={editId ? 'Editar Chofer' : 'Nuevo Chofer'}
          fields={editId ? FIELDS.map(f => f.key === 'ch_codi_chofer' ? { ...f, readOnly: true } : f) : FIELDS}
          values={form} onChange={(k, v) => setForm(p => ({ ...p, [k]: v }))}
          onSave={handleSave} onClose={() => setModal(false)} loading={saving} />
      )}
    </>
  );
}
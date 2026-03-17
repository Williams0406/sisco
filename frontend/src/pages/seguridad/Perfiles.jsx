import { useEffect, useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';
import FormModal from '../../components/FormModal';

const COLUMNS = [
  { key: 'ch_codi_perfil',  label: 'Código' },
  { key: 'vc_desc_perfil',  label: 'Descripción' },
  { key: 'ch_esta_perfil',  label: 'Estado',
    render: (v) => v === '1' ? '✅ Activo' : '❌ Inactivo' },
];

const FIELDS = [
  { key: 'ch_codi_perfil', label: 'Código',      placeholder: 'Ej: ADM' },
  { key: 'vc_desc_perfil', label: 'Descripción', placeholder: 'Ej: Administrador' },
  { key: 'ch_esta_perfil', label: 'Estado', type: 'select',
    options: [{ value: '1', label: 'Activo' }, { value: '0', label: 'Inactivo' }] },
];

export default function Perfiles() {
  const [data, setData]     = useState([]);
  const [loading, setLoading] = useState(true);
  const [modal, setModal]   = useState(false);
  const [form, setForm]     = useState({});
  const [saving, setSaving] = useState(false);
  const [editId, setEditId] = useState(null);

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await api.get('/seguridad/perfiles/?page_size=100');
      setData(res.data.results || res.data);
    } finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  const handleNew    = () => { setForm({ ch_esta_perfil: '1' }); setEditId(null); setModal(true); };
  const handleEdit   = (row) => { setForm({ ...row }); setEditId(row.ch_codi_perfil); setModal(true); };
  const handleDelete = async (row) => {
    if (!confirm(`¿Eliminar perfil ${row.vc_desc_perfil}?`)) return;
    await api.delete(`/seguridad/perfiles/${row.ch_codi_perfil}/`);
    fetchData();
  };
  const handleSave = async () => {
    setSaving(true);
    try {
      editId
        ? await api.put(`/seguridad/perfiles/${editId}/`, form)
        : await api.post('/seguridad/perfiles/', form);
      setModal(false); fetchData();
    } catch (err) {
      alert('Error: ' + JSON.stringify(err.response?.data));
    } finally { setSaving(false); }
  };

  return (
    <>
      <DataTable title="Perfiles de Usuario" columns={COLUMNS} data={data}
        loading={loading} onNew={handleNew} onEdit={handleEdit} onDelete={handleDelete} />
      {modal && (
        <FormModal
          title={editId ? 'Editar Perfil' : 'Nuevo Perfil'}
          fields={editId
            ? FIELDS.map(f => f.key === 'ch_codi_perfil' ? { ...f, readOnly: true } : f)
            : FIELDS}
          values={form} onChange={(k, v) => setForm(p => ({ ...p, [k]: v }))}
          onSave={handleSave} onClose={() => setModal(false)} loading={saving} />
      )}
    </>
  );
}
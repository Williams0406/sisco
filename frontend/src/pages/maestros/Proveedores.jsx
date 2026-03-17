import { useEffect, useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';
import FormModal from '../../components/FormModal';

const COLUMNS = [
  { key: 'ch_codi_proveedor',  label: 'Código' },
  { key: 'ch_ruc_prov',        label: 'RUC' },
  { key: 'vc_razo_soci_prov',  label: 'Razón Social' },
  { key: 'vc_dire_prov',       label: 'Dirección' },
  { key: 'ch_esta_activo',     label: 'Estado',
    render: (v) => v === '1' ? '✅ Activo' : '❌ Inactivo' },
];

const FIELDS = [
  { key: 'ch_codi_proveedor', label: 'Código',       placeholder: 'Ej: P001' },
  { key: 'ch_ruc_prov',       label: 'RUC',          placeholder: '11 dígitos' },
  { key: 'vc_razo_soci_prov', label: 'Razón Social' },
  { key: 'vc_dire_prov',      label: 'Dirección' },
  { key: 'ch_esta_activo',    label: 'Estado', type: 'select',
    options: [{ value: '1', label: 'Activo' }, { value: '0', label: 'Inactivo' }] },
];

export default function Proveedores() {
  const [data, setData]     = useState([]);
  const [loading, setLoading] = useState(true);
  const [modal, setModal]   = useState(false);
  const [form, setForm]     = useState({});
  const [saving, setSaving] = useState(false);
  const [editId, setEditId] = useState(null);

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await api.get('/maestros/proveedores/?page_size=200');
      setData(res.data.results || res.data);
    } finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  const handleNew    = () => { setForm({}); setEditId(null); setModal(true); };
  const handleEdit   = (row) => { setForm({ ...row }); setEditId(row.ch_codi_proveedor); setModal(true); };
  const handleDelete = async (row) => {
    if (!confirm(`¿Eliminar proveedor ${row.vc_razo_soci_prov}?`)) return;
    await api.delete(`/maestros/proveedores/${row.ch_codi_proveedor}/`);
    fetchData();
  };
  const handleSave = async () => {
    setSaving(true);
    try {
      editId
        ? await api.put(`/maestros/proveedores/${editId}/`, form)
        : await api.post('/maestros/proveedores/', form);
      setModal(false); fetchData();
    } catch (err) {
      alert('Error: ' + JSON.stringify(err.response?.data));
    } finally { setSaving(false); }
  };

  return (
    <>
      <DataTable title="Proveedores" columns={COLUMNS} data={data}
        loading={loading} onNew={handleNew} onEdit={handleEdit} onDelete={handleDelete} />
      {modal && (
        <FormModal
          title={editId ? 'Editar Proveedor' : 'Nuevo Proveedor'}
          fields={editId ? FIELDS.map(f => f.key === 'ch_codi_proveedor' ? { ...f, readOnly: true } : f) : FIELDS}
          values={form} onChange={(k, v) => setForm(p => ({ ...p, [k]: v }))}
          onSave={handleSave} onClose={() => setModal(false)} loading={saving} />
      )}
    </>
  );
}
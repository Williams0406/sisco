import { useEffect, useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';
import FormModal from '../../components/FormModal';

const COLUMNS = [
  { key: 'ch_codi_usuario',        label: 'Código' },
  { key: 'vc_desc_nomb_usuario',   label: 'Nombre' },
  { key: 'vc_desc_apell_paterno',  label: 'Ap. Paterno' },
  { key: 'vc_desc_apell_materno',  label: 'Ap. Materno' },
  { key: 'vc_desc_email_usuario',  label: 'Email' },
  { key: 'ch_tipo_usuario',        label: 'Tipo' },
  { key: 'ch_esta_activo',         label: 'Estado',
    render: (v) => v === '1' ? '✅ Activo' : '❌ Inactivo' },
];

const FIELDS = [
  { key: 'ch_codi_usuario',       label: 'Código de Usuario', placeholder: 'Ej: USR001' },
  { key: 'vc_desc_nomb_usuario',  label: 'Nombres' },
  { key: 'vc_desc_apell_paterno', label: 'Apellido Paterno' },
  { key: 'vc_desc_apell_materno', label: 'Apellido Materno' },
  { key: 'vc_desc_email_usuario', label: 'Email', type: 'email' },
  { key: 'ch_pass_usua',          label: 'Contraseña', type: 'password' },
  { key: 'ch_tipo_usuario',       label: 'Tipo', type: 'select',
    options: [
      { value: 'A', label: 'Administrador' },
      { value: 'O', label: 'Operador' },
      { value: 'C', label: 'Cajero' },
    ]},
  { key: 'ch_esta_activo',        label: 'Estado', type: 'select',
    options: [{ value: '1', label: 'Activo' }, { value: '0', label: 'Inactivo' }] },
];

export default function Usuarios() {
  const [data, setData]     = useState([]);
  const [loading, setLoading] = useState(true);
  const [modal, setModal]   = useState(false);
  const [form, setForm]     = useState({});
  const [saving, setSaving] = useState(false);
  const [editId, setEditId] = useState(null);

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await api.get('/seguridad/usuarios/?page_size=200');
      setData(res.data.results || res.data);
    } finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  const handleNew    = () => { setForm({ ch_esta_activo: '1' }); setEditId(null); setModal(true); };
  const handleEdit   = (row) => { setForm({ ...row }); setEditId(row.ch_codi_usuario); setModal(true); };
  const handleDelete = async (row) => {
    if (!confirm(`¿Desactivar usuario ${row.ch_codi_usuario}?`)) return;
    await api.patch(`/seguridad/usuarios/${row.ch_codi_usuario}/`, { ch_esta_activo: '0' });
    fetchData();
  };
  const handleSave = async () => {
    setSaving(true);
    try {
      editId
        ? await api.put(`/seguridad/usuarios/${editId}/`, form)
        : await api.post('/seguridad/usuarios/', form);
      setModal(false); fetchData();
    } catch (err) {
      alert('Error: ' + JSON.stringify(err.response?.data));
    } finally { setSaving(false); }
  };

  return (
    <>
      <DataTable title="Usuarios del Sistema" columns={COLUMNS} data={data}
        loading={loading} onNew={handleNew} onEdit={handleEdit} onDelete={handleDelete} />
      {modal && (
        <FormModal
          title={editId ? 'Editar Usuario' : 'Nuevo Usuario'}
          fields={editId
            ? FIELDS.map(f => f.key === 'ch_codi_usuario' ? { ...f, readOnly: true } : f)
            : FIELDS}
          values={form} onChange={(k, v) => setForm(p => ({ ...p, [k]: v }))}
          onSave={handleSave} onClose={() => setModal(false)} loading={saving} />
      )}
    </>
  );
}
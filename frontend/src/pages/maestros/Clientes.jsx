import { useEffect, useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';
import FormModal from '../../components/FormModal';

const COLUMNS = [
  { key: 'ch_codi_cliente',      label: 'Código' },
  { key: 'ch_ruc_cliente',       label: 'RUC' },
  { key: 'vc_razo_soci_cliente', label: 'Razón Social' },
  { key: 'vc_dire_cliente',      label: 'Dirección' },
  { key: 'ch_esta_activo',       label: 'Estado',
    render: (v) => v === '1' ? '✅ Activo' : '❌ Inactivo' },
  { key: 'ch_esta_cliente_vip',  label: 'VIP',
    render: (v) => v === '1' ? '⭐ VIP' : '' },
];

const FIELDS = [
  { key: 'ch_codi_cliente',      label: 'Código',       placeholder: 'Ej: C001' },
  { key: 'ch_ruc_cliente',       label: 'RUC',          placeholder: '11 dígitos' },
  { key: 'vc_razo_soci_cliente', label: 'Razón Social', placeholder: 'Nombre o empresa' },
  { key: 'vc_dire_cliente',      label: 'Dirección' },
  { key: 'ch_esta_activo',       label: 'Estado', type: 'select',
    options: [{ value: '1', label: 'Activo' }, { value: '0', label: 'Inactivo' }] },
  { key: 'ch_esta_cliente_vip',  label: 'Cliente VIP', type: 'select',
    options: [{ value: '1', label: 'Sí' }, { value: '0', label: 'No' }] },
];

export default function Clientes() {
  const [data, setData]       = useState([]);
  const [loading, setLoading] = useState(true);
  const [modal, setModal]     = useState(false);
  const [form, setForm]       = useState({});
  const [saving, setSaving]   = useState(false);
  const [editId, setEditId]   = useState(null);

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await api.get('/maestros/clientes/?page_size=200');
      setData(res.data.results || res.data);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchData(); }, []);

  const handleNew = () => {
    setForm({});
    setEditId(null);
    setModal(true);
  };

  const handleEdit = (row) => {
    setForm({ ...row });
    setEditId(row.ch_codi_cliente);
    setModal(true);
  };

  const handleDelete = async (row) => {
    if (!confirm(`¿Eliminar cliente ${row.vc_razo_soci_cliente}?`)) return;
    await api.delete(`/maestros/clientes/${row.ch_codi_cliente}/`);
    fetchData();
  };

  const handleSave = async () => {
    setSaving(true);
    try {
      if (editId) {
        await api.put(`/maestros/clientes/${editId}/`, form);
      } else {
        await api.post('/maestros/clientes/', form);
      }
      setModal(false);
      fetchData();
    } catch (err) {
      alert('Error al guardar: ' + JSON.stringify(err.response?.data));
    } finally {
      setSaving(false);
    }
  };

  return (
    <>
      <DataTable
        title="Clientes"
        columns={COLUMNS}
        data={data}
        loading={loading}
        onNew={handleNew}
        onEdit={handleEdit}
        onDelete={handleDelete}
      />
      {modal && (
        <FormModal
          title={editId ? 'Editar Cliente' : 'Nuevo Cliente'}
          fields={editId
            ? FIELDS.map(f => f.key === 'ch_codi_cliente' ? { ...f, readOnly: true } : f)
            : FIELDS}
          values={form}
          onChange={(k, v) => setForm(prev => ({ ...prev, [k]: v }))}
          onSave={handleSave}
          onClose={() => setModal(false)}
          loading={saving}
        />
      )}
    </>
  );
}
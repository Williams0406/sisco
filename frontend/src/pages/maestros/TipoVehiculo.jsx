import { useEffect, useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';
import FormModal from '../../components/FormModal';

const COLUMNS = [
  { key: 'ch_tipo_vehiculo',      label: 'Código' },
  { key: 'vc_desc_tipo_vehiculo', label: 'Descripción' },
  { key: 'ch_esta_activo', label: 'Estado',
    render: (v) => v === '1' ? '✅ Activo' : '❌ Inactivo' },
];

const FIELDS = [
  { key: 'ch_tipo_vehiculo',      label: 'Código',      placeholder: 'Ej: 01' },
  { key: 'vc_desc_tipo_vehiculo', label: 'Descripción', placeholder: 'Ej: Sedan' },
  { key: 'ch_esta_activo', label: 'Estado', type: 'select',
    options: [{ value: '1', label: 'Activo' }, { value: '0', label: 'Inactivo' }] },
];

export default function TipoVehiculo() {
  const [data, setData]     = useState([]);
  const [loading, setLoading] = useState(true);
  const [modal, setModal]   = useState(false);
  const [form, setForm]     = useState({});
  const [saving, setSaving] = useState(false);
  const [editId, setEditId] = useState(null);

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await api.get('/maestros/tipo-vehiculos/?page_size=200');
      setData(res.data.results || res.data);
    } finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  const handleNew    = () => { setForm({}); setEditId(null); setModal(true); };
  const handleEdit   = (row) => { setForm({ ...row }); setEditId(row.ch_tipo_vehiculo); setModal(true); };
  const handleDelete = async (row) => {
    if (!confirm(`¿Eliminar tipo ${row.vc_desc_tipo_vehiculo}?`)) return;
    await api.delete(`/maestros/tipo-vehiculos/${row.ch_tipo_vehiculo}/`);
    fetchData();
  };
  const handleSave = async () => {
    setSaving(true);
    try {
      editId
        ? await api.put(`/maestros/tipo-vehiculos/${editId}/`, form)
        : await api.post('/maestros/tipo-vehiculos/', form);
      setModal(false); fetchData();
    } catch (err) {
      alert('Error: ' + JSON.stringify(err.response?.data));
    } finally { setSaving(false); }
  };

  return (
    <>
      <DataTable title="Tipos de Vehículo" columns={COLUMNS} data={data}
        loading={loading} onNew={handleNew} onEdit={handleEdit} onDelete={handleDelete} />
      {modal && (
        <FormModal
          title={editId ? 'Editar Tipo' : 'Nuevo Tipo de Vehículo'}
          fields={editId ? FIELDS.map(f => f.key === 'ch_tipo_vehiculo' ? { ...f, readOnly: true } : f) : FIELDS}
          values={form} onChange={(k, v) => setForm(p => ({ ...p, [k]: v }))}
          onSave={handleSave} onClose={() => setModal(false)} loading={saving} />
      )}
    </>
  );
}
import { useEffect, useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';
import FormModal from '../../components/FormModal';
import { isTrueValue, toBooleanOrNull } from './booleanUtils';

const COLUMNS = [
  { key: 'ch_codi_cliente', label: 'Código' },
  { key: 'ch_ruc_cliente', label: 'RUC' },
  { key: 'vc_razo_soci_cliente', label: 'Razón Social' },
  { key: 'vc_dire_cliente', label: 'Dirección' },
  { key: 'ch_esta_activo', label: 'Estado', render: (v) => isTrueValue(v) ? '✅ Activo' : '❌ Inactivo' },
  { key: 'ch_esta_cliente_vip', label: 'VIP', render: (v) => isTrueValue(v) ? '⭐ VIP' : '' },
];

const FIELDS = [
  { key: 'ch_codi_cliente', label: 'Código', placeholder: 'Ej: C001' },
  { key: 'ch_ruc_cliente', label: 'RUC', placeholder: '11 dígitos' },
  { key: 'vc_razo_soci_cliente', label: 'Razón Social', placeholder: 'Nombre o empresa' },
  { key: 'vc_dire_cliente', label: 'Dirección' },
  { key: 'ch_esta_activo', label: 'Estado', type: 'select', options: [{ value: 'true', label: 'Activo' }, { value: 'false', label: 'Inactivo' }] },
  { key: 'ch_esta_cliente_vip', label: 'Cliente VIP', type: 'select', options: [{ value: 'true', label: 'Sí' }, { value: 'false', label: 'No' }] },
];

const normalizeForm = (payload) => ({
  ...payload,
  ch_esta_activo: toBooleanOrNull(payload.ch_esta_activo),
  ch_esta_cliente_vip: toBooleanOrNull(payload.ch_esta_cliente_vip),
});

export default function Clientes() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [modal, setModal] = useState(false);
  const [form, setForm] = useState({});
  const [saving, setSaving] = useState(false);
  const [editId, setEditId] = useState(null);

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await api.get('/maestros/clientes/?page_size=200');
      setData(res.data.results || res.data);
    } finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  const handleSave = async () => {
    setSaving(true);
    try {
      const payload = normalizeForm(form);
      if (editId) await api.put(`/maestros/clientes/${editId}/`, payload);
      else await api.post('/maestros/clientes/', payload);
      setModal(false);
      fetchData();
    } catch (err) {
      alert('Error al guardar: ' + JSON.stringify(err.response?.data));
    } finally { setSaving(false); }
  };

  return (
    <>
      <DataTable title="Clientes" columns={COLUMNS} data={data} loading={loading}
        onNew={() => { setForm({}); setEditId(null); setModal(true); }}
        onEdit={(row) => { setForm({ ...row }); setEditId(row.ch_codi_cliente); setModal(true); }}
        onDelete={async (row) => {
          if (!confirm(`¿Eliminar cliente ${row.vc_razo_soci_cliente}?`)) return;
          await api.delete(`/maestros/clientes/${row.ch_codi_cliente}/`);
          fetchData();
        }}
      />
      {modal && (
        <FormModal
          title={editId ? 'Editar Cliente' : 'Nuevo Cliente'}
          fields={editId ? FIELDS.map((f) => (f.key === 'ch_codi_cliente' ? { ...f, readOnly: true } : f)) : FIELDS}
          values={form}
          onChange={(k, v) => setForm((prev) => ({ ...prev, [k]: v }))}
          onSave={handleSave}
          onClose={() => setModal(false)}
          loading={saving}
        />
      )}
    </>
  );
}
import { useEffect, useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';
import FormModal from '../../components/FormModal';
import { isTrueValue, toBooleanOrNull } from './booleanUtils';

const COLUMNS = [
  { key: 'ch_codi_proveedor', label: 'Código' },
  { key: 'ch_ruc_prov', label: 'RUC' },
  { key: 'vc_razo_soci_prov', label: 'Razón Social' },
  { key: 'vc_dire_prov', label: 'Dirección' },
  { key: 'ch_esta_activo', label: 'Estado', render: (v) => isTrueValue(v) ? '✅ Activo' : '❌ Inactivo' },
];

const FIELDS = [
  { key: 'ch_codi_proveedor', label: 'Código', placeholder: 'Ej: P001' },
  { key: 'ch_ruc_prov', label: 'RUC', placeholder: '11 dígitos' },
  { key: 'vc_razo_soci_prov', label: 'Razón Social' },
  { key: 'vc_dire_prov', label: 'Dirección' },
  { key: 'ch_esta_activo', label: 'Estado', type: 'select', options: [{ value: 'true', label: 'Activo' }, { value: 'false', label: 'Inactivo' }] },
];

const normalizeForm = (payload) => ({ ...payload, ch_esta_activo: toBooleanOrNull(payload.ch_esta_activo) });

export default function Proveedores() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [modal, setModal] = useState(false);
  const [form, setForm] = useState({});
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

  const handleSave = async () => {
    setSaving(true);
    try {
      const payload = normalizeForm(form);
      if (editId) await api.put(`/maestros/proveedores/${editId}/`, payload);
      else await api.post('/maestros/proveedores/', payload);
      setModal(false);
      fetchData();
    } catch (err) {
      alert('Error: ' + JSON.stringify(err.response?.data));
    } finally { setSaving(false); }
  };

  return (
    <>
      <DataTable title="Proveedores" columns={COLUMNS} data={data} loading={loading}
        onNew={() => { setForm({}); setEditId(null); setModal(true); }}
        onEdit={(row) => { setForm({ ...row }); setEditId(row.ch_codi_proveedor); setModal(true); }}
        onDelete={async (row) => {
          if (!confirm(`¿Eliminar proveedor ${row.vc_razo_soci_prov}?`)) return;
          await api.delete(`/maestros/proveedores/${row.ch_codi_proveedor}/`);
          fetchData();
        }}
      />
      {modal && (
        <FormModal
          title={editId ? 'Editar Proveedor' : 'Nuevo Proveedor'}
          fields={editId ? FIELDS.map((f) => (f.key === 'ch_codi_proveedor' ? { ...f, readOnly: true } : f)) : FIELDS}
          values={form}
          onChange={(k, v) => setForm((p) => ({ ...p, [k]: v }))}
          onSave={handleSave}
          onClose={() => setModal(false)}
          loading={saving}
        />
      )}
    </>
  );
}
import { useEffect, useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';
import FormModal from '../../components/FormModal';
import { isTrueValue, toBooleanOrNull } from './booleanUtils';

const COLUMNS = [
  { key: 'ch_codi_chofer', label: 'Código' },
  { key: 'vc_desc_chofer', label: 'Nombre' },
  { key: 'ch_nume_dni', label: 'DNI' },
  { key: 'ch_nume_celu', label: 'Celular' },
  { key: 'vc_dire_chofer', label: 'Dirección' },
  { key: 'ch_esta_activo', label: 'Estado', render: (v) => isTrueValue(v) ? '✅ Activo' : '❌ Inactivo' },
];

const FIELDS = [
  { key: 'ch_codi_chofer', label: 'Código', placeholder: 'Ej: C001' },
  { key: 'vc_desc_chofer', label: 'Nombre completo' },
  { key: 'ch_nume_dni', label: 'DNI', placeholder: '8 dígitos' },
  { key: 'ch_nume_celu', label: 'Celular' },
  { key: 'vc_dire_chofer', label: 'Dirección' },
  { key: 'ch_esta_activo', label: 'Estado', type: 'select', options: [{ value: 'true', label: 'Activo' }, { value: 'false', label: 'Inactivo' }] },
];

const normalizeForm = (payload) => ({ ...payload, ch_esta_activo: toBooleanOrNull(payload.ch_esta_activo) });

export default function Choferes() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [modal, setModal] = useState(false);
  const [form, setForm] = useState({});
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

  const handleSave = async () => {
    setSaving(true);
    try {
      const payload = normalizeForm(form);
      if (editId) await api.put(`/maestros/choferes/${editId}/`, payload);
      else await api.post('/maestros/choferes/', payload);
      setModal(false);
      fetchData();
    } catch (err) {
      alert('Error: ' + JSON.stringify(err.response?.data));
    } finally { setSaving(false); }
  };

  return (
    <>
      <DataTable title="Choferes" columns={COLUMNS} data={data} loading={loading}
        onNew={() => { setForm({}); setEditId(null); setModal(true); }}
        onEdit={(row) => { setForm({ ...row }); setEditId(row.ch_codi_chofer); setModal(true); }}
        onDelete={async (row) => {
          if (!confirm(`¿Eliminar chofer ${row.vc_desc_chofer}?`)) return;
          await api.delete(`/maestros/choferes/${row.ch_codi_chofer}/`);
          fetchData();
        }}
      />
      {modal && (
        <FormModal
          title={editId ? 'Editar Chofer' : 'Nuevo Chofer'}
          fields={editId ? FIELDS.map((f) => (f.key === 'ch_codi_chofer' ? { ...f, readOnly: true } : f)) : FIELDS}
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
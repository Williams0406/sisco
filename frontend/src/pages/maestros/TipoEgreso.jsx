import { useEffect, useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';
import FormModal from '../../components/FormModal';
import { isTrueValue, toBooleanOrNull } from './booleanUtils';

const COLUMNS = [
  { key: 'ch_codi_tipo_egreso', label: 'Código' },
  { key: 'vc_desc_tipo_egreso', label: 'Descripción' },
  { key: 'ch_esta_activo', label: 'Estado', render: (v) => isTrueValue(v) ? '✅ Activo' : '❌ Inactivo' },
];

const FIELDS = [
  { key: 'ch_codi_tipo_egreso', label: 'Código', placeholder: 'Ej: E01' },
  { key: 'vc_desc_tipo_egreso', label: 'Descripción' },
  { key: 'ch_esta_activo', label: 'Estado', type: 'select', options: [{ value: 'true', label: 'Activo' }, { value: 'false', label: 'Inactivo' }] },
];

export default function TipoEgreso() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [modal, setModal] = useState(false);
  const [form, setForm] = useState({});
  const [saving, setSaving] = useState(false);
  const [editId, setEditId] = useState(null);

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await api.get('/maestros/tipo-egresos/?page_size=200');
      setData(res.data.results || res.data);
    } finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  const handleSave = async () => {
    setSaving(true);
    try {
      const payload = { ...form, ch_esta_activo: toBooleanOrNull(form.ch_esta_activo) };
      if (editId) await api.put(`/maestros/tipo-egresos/${editId}/`, payload);
      else await api.post('/maestros/tipo-egresos/', payload);
      setModal(false);
      fetchData();
    } finally { setSaving(false); }
  };

  return (
    <>
      <DataTable title="Tipos de Egreso" columns={COLUMNS} data={data} loading={loading}
        onNew={() => { setForm({}); setEditId(null); setModal(true); }}
        onEdit={(row) => { setForm({ ...row }); setEditId(row.ch_codi_tipo_egreso); setModal(true); }}
        onDelete={async (row) => {
          if (!confirm(`¿Eliminar tipo de egreso ${row.vc_desc_tipo_egreso}?`)) return;
          await api.delete(`/maestros/tipo-egresos/${row.ch_codi_tipo_egreso}/`);
          fetchData();
        }}
      />
      {modal && (
        <FormModal
          title={editId ? 'Editar Tipo Egreso' : 'Nuevo Tipo Egreso'}
          fields={editId ? FIELDS.map((f) => (f.key === 'ch_codi_tipo_egreso' ? { ...f, readOnly: true } : f)) : FIELDS}
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
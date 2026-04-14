import { useEffect, useState } from 'react';
import api from '../../api/axios';
import MasterSplitView from './MasterSplitView';
import { isTrueValue, toBooleanOrNull } from './booleanUtils';

const createEmptyForm = () => ({
  ch_codi_proveedor: '',
  ch_ruc_prov: '',
  vc_razo_soci_prov: '',
  vc_dire_prov: '',
  ch_esta_activo: 'true',
});

const columns = [
  { key: 'ch_codi_proveedor', label: 'Codigo' },
  { key: 'ch_ruc_prov', label: 'RUC' },
  { key: 'vc_razo_soci_prov', label: 'Razon social' },
  { key: 'vc_dire_prov', label: 'Direccion' },
  { key: 'ch_esta_activo', label: 'Estado', render: (value) => (isTrueValue(value) ? 'Activo' : 'Inactivo') },
];

const fields = [
  { key: 'ch_codi_proveedor', label: 'Codigo', readOnly: true, placeholder: 'Generado automaticamente' },
  { key: 'ch_ruc_prov', label: 'RUC', placeholder: '11 digitos' },
  { key: 'vc_razo_soci_prov', label: 'Razon social', placeholder: 'Proveedor o empresa' },
  { key: 'vc_dire_prov', label: 'Direccion', placeholder: 'Direccion fiscal' },
  {
    key: 'ch_esta_activo',
    label: 'Estado',
    type: 'select',
    options: [
      { value: 'true', label: 'Activo' },
      { value: 'false', label: 'Inactivo' },
    ],
  },
];

export default function Proveedores() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [editId, setEditId] = useState(null);
  const [form, setForm] = useState(createEmptyForm());

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await api.get('/maestros/proveedores/?page_size=200');
      setData(res.data.results || res.data);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const handleNew = () => {
    setEditId(null);
    setForm(createEmptyForm());
  };

  const handleSelect = (row) => {
    setEditId(row.ch_codi_proveedor);
    setForm({
      ch_codi_proveedor: row.ch_codi_proveedor ?? '',
      ch_ruc_prov: row.ch_ruc_prov ?? '',
      vc_razo_soci_prov: row.vc_razo_soci_prov ?? '',
      vc_dire_prov: row.vc_dire_prov ?? '',
      ch_esta_activo: isTrueValue(row.ch_esta_activo) ? 'true' : 'false',
    });
  };

  const handleSave = async () => {
    setSaving(true);
    try {
      const payload = {
        ...form,
        ch_esta_activo: toBooleanOrNull(form.ch_esta_activo),
      };

      if (!editId) delete payload.ch_codi_proveedor;

      if (editId) await api.put(`/maestros/proveedores/${editId}/`, payload);
      else await api.post('/maestros/proveedores/', payload);

      await fetchData();
      handleNew();
    } catch (err) {
      alert(`Error al guardar: ${JSON.stringify(err.response?.data || err.message)}`);
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async () => {
    if (!editId) return;
    if (!confirm(`Eliminar proveedor ${form.vc_razo_soci_prov || editId}?`)) return;
    await api.delete(`/maestros/proveedores/${editId}/`);
    await fetchData();
    handleNew();
  };

  return (
    <MasterSplitView
      title="Proveedores"
      singularTitle="proveedor"
      subtitle="Mantiene proveedores en una vista continua con tabla y formulario lateral."
      columns={columns}
      data={data}
      loading={loading}
      form={form}
      fields={fields}
      editId={editId}
      saving={saving}
      onChange={(key, value) => setForm((prev) => ({ ...prev, [key]: value }))}
      onNew={handleNew}
      onSelect={handleSelect}
      onSave={handleSave}
      onDelete={handleDelete}
      getRowId={(row) => row.ch_codi_proveedor}
      getRowTitle={() => 'proveedor'}
    />
  );
}

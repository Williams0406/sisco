import { useEffect, useState } from 'react';
import api from '../../api/axios';
import MasterSplitView from './MasterSplitView';
import { isTrueValue, toBooleanOrNull } from './booleanUtils';

const createEmptyForm = () => ({
  ch_codi_cliente: '',
  ch_ruc_cliente: '',
  vc_razo_soci_cliente: '',
  vc_dire_cliente: '',
  ch_esta_activo: 'true',
  ch_esta_cliente_vip: 'false',
});

const columns = [
  { key: 'ch_codi_cliente', label: 'Codigo' },
  { key: 'ch_ruc_cliente', label: 'RUC' },
  { key: 'vc_razo_soci_cliente', label: 'Razon social' },
  { key: 'vc_dire_cliente', label: 'Direccion' },
  { key: 'ch_esta_activo', label: 'Estado', render: (value) => (isTrueValue(value) ? 'Activo' : 'Inactivo') },
];

const fields = [
  { key: 'ch_codi_cliente', label: 'Codigo', readOnly: true, placeholder: 'Generado automaticamente' },
  { key: 'ch_ruc_cliente', label: 'RUC', placeholder: '11 digitos' },
  { key: 'vc_razo_soci_cliente', label: 'Razon social', placeholder: 'Nombre o empresa' },
  { key: 'vc_dire_cliente', label: 'Direccion', placeholder: 'Direccion fiscal' },
  {
    key: 'ch_esta_activo',
    label: 'Estado',
    type: 'select',
    options: [
      { value: 'true', label: 'Activo' },
      { value: 'false', label: 'Inactivo' },
    ],
  },
  {
    key: 'ch_esta_cliente_vip',
    label: 'Cliente VIP',
    type: 'select',
    options: [
      { value: 'true', label: 'Si' },
      { value: 'false', label: 'No' },
    ],
  },
];

export default function Clientes() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [editId, setEditId] = useState(null);
  const [form, setForm] = useState(createEmptyForm());

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await api.get('/maestros/clientes/?page_size=200');
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
    setEditId(row.ch_codi_cliente);
    setForm({
      ch_codi_cliente: row.ch_codi_cliente ?? '',
      ch_ruc_cliente: row.ch_ruc_cliente ?? '',
      vc_razo_soci_cliente: row.vc_razo_soci_cliente ?? '',
      vc_dire_cliente: row.vc_dire_cliente ?? '',
      ch_esta_activo: isTrueValue(row.ch_esta_activo) ? 'true' : 'false',
      ch_esta_cliente_vip: isTrueValue(row.ch_esta_cliente_vip) ? 'true' : 'false',
    });
  };

  const handleSave = async () => {
    setSaving(true);
    try {
      const payload = {
        ...form,
        ch_esta_activo: toBooleanOrNull(form.ch_esta_activo),
        ch_esta_cliente_vip: toBooleanOrNull(form.ch_esta_cliente_vip),
      };

      if (!editId) delete payload.ch_codi_cliente;

      if (editId) await api.put(`/maestros/clientes/${editId}/`, payload);
      else await api.post('/maestros/clientes/', payload);

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
    if (!confirm(`Eliminar cliente ${form.vc_razo_soci_cliente || editId}?`)) return;
    await api.delete(`/maestros/clientes/${editId}/`);
    await fetchData();
    handleNew();
  };

  return (
    <MasterSplitView
      title="Clientes"
      singularTitle="cliente"
      subtitle="Administra clientes y consulta sus datos principales sin salir del listado."
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
      getRowId={(row) => row.ch_codi_cliente}
      getRowTitle={() => 'cliente'}
    />
  );
}

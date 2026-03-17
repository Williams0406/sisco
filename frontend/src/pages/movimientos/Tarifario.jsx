import { useEffect, useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';
import FormModal from '../../components/FormModal';

const COLUMNS = [
  { key: 'nu_codi_tarifario',   label: '# Tarifa' },
  { key: 'tipo_vehiculo_desc',  label: 'Tipo Vehículo' },
  { key: 'cliente_desc',        label: 'Cliente VIP' },
  { key: 'nu_impo_tarifa',      label: 'Tarifa (S/)',
    render: (v) => v ? `S/ ${parseFloat(v).toFixed(3)}` : '—' },
  { key: 'nu_minu_tolerancia',  label: 'Tolerancia (min)' },
  { key: 'ch_esta_activo',      label: 'Estado',
    render: (v) => v === '1' ? '✅ Activo' : '❌ Inactivo' },
];

export default function Tarifario() {
  const [data, setData]         = useState([]);
  const [loading, setLoading]   = useState(true);
  const [modal, setModal]       = useState(false);
  const [form, setForm]         = useState({});
  const [saving, setSaving]     = useState(false);
  const [editId, setEditId]     = useState(null);
  const [tiposVeh, setTiposVeh] = useState([]);
  const [clientes, setClientes] = useState([]);

  const fetchData = async () => {
    setLoading(true);
    try {
      const [tRes, tvRes, cRes] = await Promise.all([
        api.get('/movimientos/tarifario/?page_size=200'),
        api.get('/maestros/tipo-vehiculos/?page_size=100'),
        api.get('/maestros/clientes/?ch_esta_cliente_vip=1&page_size=200'),
      ]);
      setData(tRes.data.results    || tRes.data);
      setTiposVeh(tvRes.data.results || tvRes.data);
      setClientes(cRes.data.results  || cRes.data);
    } finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  const getFields = () => [
    { key: 'ch_tipo_vehiculo', label: 'Tipo de Vehículo', type: 'select',
      options: tiposVeh.map(t => ({ value: t.ch_tipo_vehiculo, label: t.vc_desc_tipo_vehiculo })) },
    { key: 'ch_codi_cliente',  label: 'Cliente VIP (opcional)', type: 'select',
      options: [{ value: '', label: '— Tarifa general —' },
        ...clientes.map(c => ({ value: c.ch_codi_cliente, label: c.vc_razo_soci_cliente }))] },
    { key: 'nu_impo_tarifa',      label: 'Tarifa (S/)',         type: 'number', placeholder: '0.000' },
    { key: 'nu_minu_tolerancia',  label: 'Tolerancia (minutos)', type: 'number', placeholder: '0' },
    { key: 'ch_esta_activo',      label: 'Estado', type: 'select',
      options: [{ value: '1', label: 'Activo' }, { value: '0', label: 'Inactivo' }] },
  ];

  const handleNew    = () => { setForm({ ch_esta_activo: '1' }); setEditId(null); setModal(true); };
  const handleEdit   = (row) => { setForm({ ...row }); setEditId(row.nu_codi_tarifario); setModal(true); };
  const handleDelete = async (row) => {
    if (!confirm(`¿Eliminar tarifa #${row.nu_codi_tarifario}?`)) return;
    await api.delete(`/movimientos/tarifario/${row.nu_codi_tarifario}/`);
    fetchData();
  };
  const handleSave = async () => {
    setSaving(true);
    try {
      editId
        ? await api.put(`/movimientos/tarifario/${editId}/`, form)
        : await api.post('/movimientos/tarifario/', form);
      setModal(false); fetchData();
    } catch (err) {
      alert('Error: ' + JSON.stringify(err.response?.data));
    } finally { setSaving(false); }
  };

  return (
    <>
      <DataTable title="Tarifario de Cochera" columns={COLUMNS} data={data}
        loading={loading} onNew={handleNew} onEdit={handleEdit} onDelete={handleDelete} />
      {modal && (
        <FormModal
          title={editId ? 'Editar Tarifa' : 'Nueva Tarifa'}
          fields={getFields()} values={form}
          onChange={(k, v) => setForm(p => ({ ...p, [k]: v }))}
          onSave={handleSave} onClose={() => setModal(false)} loading={saving} />
      )}
    </>
  );
}
import { useEffect, useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';
import FormModal from '../../components/FormModal';

const COLUMNS = [
  { key: 'nu_codi_recibo',     label: '# Recibo' },
  { key: 'dt_fech_ingr',       label: 'Fecha',
    render: (v) => v ? new Date(v).toLocaleDateString('es-PE') : '—' },
  { key: 'ch_seri_ingr',       label: 'Serie' },
  { key: 'ch_nume_ingr',       label: 'Número' },
  { key: 'tipo_ingreso_desc',  label: 'Tipo Ingreso' },
  { key: 'cliente_desc',       label: 'Cliente' },
  { key: 'nu_impo_ingr',       label: 'Importe',
    render: (v) => v ? `S/ ${parseFloat(v).toFixed(2)}` : '—' },
  { key: 'ch_esta_activo',     label: 'Estado',
    render: (v) => v === '1' ? '✅' : '❌' },
];

export default function RecibosIngreso() {
  const [data, setData]           = useState([]);
  const [loading, setLoading]     = useState(true);
  const [modal, setModal]         = useState(false);
  const [form, setForm]           = useState({});
  const [saving, setSaving]       = useState(false);
  const [editId, setEditId]       = useState(null);
  const [tiposIngreso, setTiposIngreso] = useState([]);
  const [clientes, setClientes]   = useState([]);

  const fetchData = async () => {
    setLoading(true);
    try {
      const [rRes, tRes, cRes] = await Promise.all([
        api.get('/movimientos/recibos-ingreso/?page_size=200'),
        api.get('/maestros/tipo-ingresos/?page_size=100'),
        api.get('/maestros/clientes/?page_size=200'),
      ]);
      setData(rRes.data.results       || rRes.data);
      setTiposIngreso(tRes.data.results || tRes.data);
      setClientes(cRes.data.results   || cRes.data);
    } finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  const getFields = () => [
    { key: 'dt_fech_ingr',        label: 'Fecha',         type: 'datetime-local' },
    { key: 'ch_seri_ingr',        label: 'Serie',         placeholder: 'Ej: IN01' },
    { key: 'ch_nume_ingr',        label: 'Número',        placeholder: 'Ej: 0000001' },
    { key: 'ch_codi_tipo_ingreso',label: 'Tipo Ingreso',  type: 'select',
      options: tiposIngreso.map(t => ({ value: t.ch_codi_tipo_ingreso, label: t.vc_desc_tipo_ingreso })) },
    { key: 'ch_codi_cliente',     label: 'Cliente',       type: 'select',
      options: [{ value: '', label: '— Sin cliente —' },
        ...clientes.map(c => ({ value: c.ch_codi_cliente, label: c.vc_razo_soci_cliente }))] },
    { key: 'nu_impo_ingr',        label: 'Importe (S/)',  type: 'number', placeholder: '0.000' },
    { key: 'vc_obse_ingr',        label: 'Observación' },
    { key: 'ch_esta_activo',      label: 'Estado',        type: 'select',
      options: [{ value: '1', label: 'Activo' }, { value: '0', label: 'Anulado' }] },
  ];

  const handleNew    = () => { setForm({ ch_esta_activo: '1' }); setEditId(null); setModal(true); };
  const handleEdit   = (row) => { setForm({ ...row }); setEditId(row.nu_codi_recibo); setModal(true); };
  const handleDelete = async (row) => {
    if (!confirm(`¿Anular recibo #${row.nu_codi_recibo}?`)) return;
    await api.patch(`/movimientos/recibos-ingreso/${row.nu_codi_recibo}/`, { ch_esta_activo: '0' });
    fetchData();
  };
  const handleSave = async () => {
    setSaving(true);
    try {
      editId
        ? await api.put(`/movimientos/recibos-ingreso/${editId}/`, form)
        : await api.post('/movimientos/recibos-ingreso/', form);
      setModal(false); fetchData();
    } catch (err) {
      alert('Error: ' + JSON.stringify(err.response?.data));
    } finally { setSaving(false); }
  };

  return (
    <>
      <DataTable title="Recibos de Ingreso" columns={COLUMNS} data={data}
        loading={loading} onNew={handleNew} onEdit={handleEdit} onDelete={handleDelete} />
      {modal && (
        <FormModal
          title={editId ? 'Editar Recibo Ingreso' : 'Nuevo Recibo de Ingreso'}
          fields={getFields()} values={form}
          onChange={(k, v) => setForm(p => ({ ...p, [k]: v }))}
          onSave={handleSave} onClose={() => setModal(false)} loading={saving} />
      )}
    </>
  );
}
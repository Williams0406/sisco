import { useEffect, useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';
import FormModal from '../../components/FormModal';

const COLUMNS = [
  { key: 'nu_codi_recibo',    label: '# Recibo' },
  { key: 'dt_fech_egre',      label: 'Fecha',
    render: (v) => v ? new Date(v).toLocaleDateString('es-PE') : '—' },
  { key: 'ch_seri_egre',      label: 'Serie' },
  { key: 'ch_nume_egre',      label: 'Número' },
  { key: 'tipo_egreso_desc',  label: 'Tipo Egreso' },
  { key: 'proveedor_desc',    label: 'Proveedor' },
  { key: 'nu_impo_egre',      label: 'Importe',
    render: (v) => v ? `S/ ${parseFloat(v).toFixed(2)}` : '—' },
  { key: 'ch_esta_activo',    label: 'Estado',
    render: (v) => v === '1' ? '✅' : '❌' },
];

export default function RecibosEgreso() {
  const [data, setData]         = useState([]);
  const [loading, setLoading]   = useState(true);
  const [modal, setModal]       = useState(false);
  const [form, setForm]         = useState({});
  const [saving, setSaving]     = useState(false);
  const [editId, setEditId]     = useState(null);
  const [tiposEgreso, setTiposEgreso] = useState([]);
  const [proveedores, setProveedores] = useState([]);

  const fetchData = async () => {
    setLoading(true);
    try {
      const [rRes, tRes, pRes] = await Promise.all([
        api.get('/movimientos/recibos-egreso/?page_size=200'),
        api.get('/maestros/tipo-egresos/?page_size=100'),
        api.get('/maestros/proveedores/?page_size=200'),
      ]);
      setData(rRes.data.results      || rRes.data);
      setTiposEgreso(tRes.data.results || tRes.data);
      setProveedores(pRes.data.results || pRes.data);
    } finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  const getFields = () => [
    { key: 'dt_fech_egre',       label: 'Fecha',        type: 'datetime-local' },
    { key: 'ch_seri_egre',       label: 'Serie',        placeholder: 'Ej: EG01' },
    { key: 'ch_nume_egre',       label: 'Número',       placeholder: 'Ej: 0000001' },
    { key: 'ch_codi_tipo_egreso',label: 'Tipo Egreso',  type: 'select',
      options: tiposEgreso.map(t => ({ value: t.ch_codi_tipo_egreso, label: t.vc_desc_tipo_egreso })) },
    { key: 'ch_codi_proveedor',  label: 'Proveedor',    type: 'select',
      options: [{ value: '', label: '— Sin proveedor —' },
        ...proveedores.map(p => ({ value: p.ch_codi_proveedor, label: p.vc_razo_soci_prov }))] },
    { key: 'nu_impo_egre',       label: 'Importe (S/)', type: 'number', placeholder: '0.000' },
    { key: 'vc_obse_egre',       label: 'Observación' },
    { key: 'ch_esta_activo',     label: 'Estado',       type: 'select',
      options: [{ value: '1', label: 'Activo' }, { value: '0', label: 'Anulado' }] },
  ];

  const handleNew    = () => { setForm({ ch_esta_activo: '1' }); setEditId(null); setModal(true); };
  const handleEdit   = (row) => { setForm({ ...row }); setEditId(row.nu_codi_recibo); setModal(true); };
  const handleDelete = async (row) => {
    if (!confirm(`¿Anular recibo #${row.nu_codi_recibo}?`)) return;
    await api.patch(`/movimientos/recibos-egreso/${row.nu_codi_recibo}/`, { ch_esta_activo: '0' });
    fetchData();
  };
  const handleSave = async () => {
    setSaving(true);
    try {
      editId
        ? await api.put(`/movimientos/recibos-egreso/${editId}/`, form)
        : await api.post('/movimientos/recibos-egreso/', form);
      setModal(false); fetchData();
    } catch (err) {
      alert('Error: ' + JSON.stringify(err.response?.data));
    } finally { setSaving(false); }
  };

  return (
    <>
      <DataTable title="Recibos de Egreso" columns={COLUMNS} data={data}
        loading={loading} onNew={handleNew} onEdit={handleEdit} onDelete={handleDelete} />
      {modal && (
        <FormModal
          title={editId ? 'Editar Recibo Egreso' : 'Nuevo Recibo de Egreso'}
          fields={getFields()} values={form}
          onChange={(k, v) => setForm(p => ({ ...p, [k]: v }))}
          onSave={handleSave} onClose={() => setModal(false)} loading={saving} />
      )}
    </>
  );
}
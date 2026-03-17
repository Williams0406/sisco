import { useEffect, useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';
import FormModal from '../../components/FormModal';

const COLUMNS = [
  { key: 'nu_codi_cierre',         label: '# Cierre' },
  { key: 'dt_fech_turno',          label: 'Fecha Turno',
    render: (v) => v ? new Date(v).toLocaleString('es-PE') : '—' },
  { key: 'ch_codi_turno_caja',     label: 'Turno' },
  { key: 'ch_codi_cajero',         label: 'Cajero' },
  { key: 'ch_codi_garita',         label: 'Garita' },
  { key: 'nu_impo_tota_efectivo',  label: 'Efectivo',
    render: (v) => v ? `S/ ${parseFloat(v).toFixed(2)}` : '—' },
  { key: 'nu_impo_tota_credito',   label: 'Crédito',
    render: (v) => v ? `S/ ${parseFloat(v).toFixed(2)}` : '—' },
  { key: 'nu_impo_total',          label: 'Total',
    render: (v) => v ? `S/ ${parseFloat(v).toFixed(2)}` : '—' },
  { key: 'nu_impo_util_turno',     label: 'Utilidad',
    render: (v) => v ? `S/ ${parseFloat(v).toFixed(2)}` : '—' },
  { key: 'ch_esta_activo',         label: 'Estado',
    render: (v) => v === '1' ? '✅' : '❌' },
];

const FIELDS = [
  { key: 'dt_fech_turno',          label: 'Fecha de Turno',    type: 'datetime-local' },
  { key: 'ch_codi_turno_caja',     label: 'Turno de Caja',     placeholder: 'Ej: T1' },
  { key: 'ch_codi_cajero',         label: 'Código Cajero',     placeholder: 'Ej: USR01' },
  { key: 'ch_codi_garita',         label: 'Garita',            placeholder: 'Ej: G01' },
  { key: 'ch_seri_cierre',         label: 'Serie',             placeholder: 'Ej: CI01' },
  { key: 'ch_nume_cierre',         label: 'Número',            placeholder: 'Ej: 0000001' },
  { key: 'nu_impo_tota_efectivo',  label: 'Total Efectivo',    type: 'number' },
  { key: 'nu_impo_tota_credito',   label: 'Total Crédito',     type: 'number' },
  { key: 'nu_impo_cobr_cred',      label: 'Cobranza Crédito',  type: 'number' },
  { key: 'nu_impo_tota_ingr',      label: 'Total Ingresos',    type: 'number' },
  { key: 'nu_impo_egre',           label: 'Total Egresos',     type: 'number' },
  { key: 'nu_impo_total',          label: 'Total General',     type: 'number' },
  { key: 'nu_impo_util_turno',     label: 'Utilidad',          type: 'number' },
  { key: 'vc_obse_cierre',         label: 'Observaciones' },
  { key: 'ch_tipo_cierre',         label: 'Tipo Cierre', type: 'select',
    options: [{ value: 'T', label: 'Turno' }, { value: 'G', label: 'General' }] },
  { key: 'ch_esta_activo',         label: 'Estado', type: 'select',
    options: [{ value: '1', label: 'Activo' }, { value: '0', label: 'Anulado' }] },
];

export default function CierreTurno() {
  const [data, setData]     = useState([]);
  const [loading, setLoading] = useState(true);
  const [modal, setModal]   = useState(false);
  const [form, setForm]     = useState({});
  const [saving, setSaving] = useState(false);
  const [editId, setEditId] = useState(null);

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await api.get('/movimientos/cierres-turno/?page_size=200');
      setData(res.data.results || res.data);
    } finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  const handleNew    = () => { setForm({ ch_esta_activo: '1', ch_tipo_cierre: 'T' }); setEditId(null); setModal(true); };
  const handleEdit   = (row) => { setForm({ ...row }); setEditId(row.nu_codi_cierre); setModal(true); };
  const handleDelete = async (row) => {
    if (!confirm(`¿Anular cierre #${row.nu_codi_cierre}?`)) return;
    await api.patch(`/movimientos/cierres-turno/${row.nu_codi_cierre}/`, { ch_esta_activo: '0' });
    fetchData();
  };
  const handleSave = async () => {
    setSaving(true);
    try {
      editId
        ? await api.put(`/movimientos/cierres-turno/${editId}/`, form)
        : await api.post('/movimientos/cierres-turno/', form);
      setModal(false); fetchData();
    } catch (err) {
      alert('Error: ' + JSON.stringify(err.response?.data));
    } finally { setSaving(false); }
  };

  return (
    <>
      <DataTable title="Cierre de Turno" columns={COLUMNS} data={data}
        loading={loading} onNew={handleNew} onEdit={handleEdit} onDelete={handleDelete} />
      {modal && (
        <FormModal
          title={editId ? 'Editar Cierre' : 'Nuevo Cierre de Turno'}
          fields={FIELDS} values={form}
          onChange={(k, v) => setForm(p => ({ ...p, [k]: v }))}
          onSave={handleSave} onClose={() => setModal(false)} loading={saving} />
      )}
    </>
  );
}
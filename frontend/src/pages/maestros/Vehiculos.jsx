import { useEffect, useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';
import FormModal from '../../components/FormModal';
import { isTrueValue, toBooleanOrNull } from './booleanUtils';

const COLUMNS = [
  { key: 'ch_codi_vehiculo', label: 'Código' },
  { key: 'ch_plac_vehiculo', label: 'Placa' },
  { key: 'tipo_vehiculo_desc', label: 'Tipo' },
  { key: 'cliente_desc', label: 'Cliente' },
  { key: 'chofer_desc', label: 'Chofer' },
  { key: 'ch_esta_parqueado', label: 'Parqueado', render: (v) => isTrueValue(v) ? '🚗 Sí' : '—' },
  { key: 'ch_esta_activo', label: 'Estado', render: (v) => isTrueValue(v) ? '✅ Activo' : '❌ Inactivo' },
];

const normalizeForm = (payload) => ({
  ...payload,
  ch_esta_activo: toBooleanOrNull(payload.ch_esta_activo),
  ch_esta_parqueado: toBooleanOrNull(payload.ch_esta_parqueado),
});

export default function Vehiculos() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [modal, setModal] = useState(false);
  const [form, setForm] = useState({});
  const [saving, setSaving] = useState(false);
  const [editId, setEditId] = useState(null);
  const [tiposVeh, setTiposVeh] = useState([]);
  const [clientes, setClientes] = useState([]);
  const [choferes, setChoferes] = useState([]);

  const fetchData = async () => {
    setLoading(true);
    try {
      const [vRes, tRes, cRes, chRes] = await Promise.all([
        api.get('/maestros/vehiculos/?page_size=200'),
        api.get('/maestros/tipo-vehiculos/?page_size=200'),
        api.get('/maestros/clientes/?page_size=200'),
        api.get('/maestros/choferes/?page_size=200'),
      ]);
      setData(vRes.data.results || vRes.data);
      setTiposVeh(tRes.data.results || tRes.data);
      setClientes(cRes.data.results || cRes.data);
      setChoferes(chRes.data.results || chRes.data);
    } finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  const getFields = () => [
    { key: 'ch_codi_vehiculo', label: 'Código', placeholder: 'Ej: V00001' },
    { key: 'ch_plac_vehiculo', label: 'Placa', placeholder: 'Ej: ABC-123' },
    { key: 'ch_tipo_vehiculo', label: 'Tipo de Vehículo', type: 'select', options: tiposVeh.map((t) => ({ value: t.ch_tipo_vehiculo, label: t.vc_desc_tipo_vehiculo })) },
    { key: 'ch_codi_cliente', label: 'Cliente', type: 'select', options: clientes.map((c) => ({ value: c.ch_codi_cliente, label: c.vc_razo_soci_cliente })) },
    { key: 'ch_codi_chofer', label: 'Chofer', type: 'select', options: choferes.map((c) => ({ value: c.ch_codi_chofer, label: c.vc_desc_chofer })) },
    { key: 'ch_esta_parqueado', label: 'Parqueado', type: 'select', options: [{ value: 'true', label: 'Sí' }, { value: 'false', label: 'No' }] },
    { key: 'ch_esta_activo', label: 'Estado', type: 'select', options: [{ value: 'true', label: 'Activo' }, { value: 'false', label: 'Inactivo' }] },
  ];

  const handleSave = async () => {
    setSaving(true);
    try {
      const payload = normalizeForm(form);
      if (editId) await api.put(`/maestros/vehiculos/${editId}/`, payload);
      else await api.post('/maestros/vehiculos/', payload);
      setModal(false);
      fetchData();
    } catch (err) {
      alert('Error: ' + JSON.stringify(err.response?.data));
    } finally { setSaving(false); }
  };

  return (
    <>
      <DataTable title="Vehículos" columns={COLUMNS} data={data} loading={loading}
        onNew={() => { setForm({}); setEditId(null); setModal(true); }}
        onEdit={(row) => { setForm({ ...row }); setEditId(row.ch_codi_vehiculo); setModal(true); }}
        onDelete={async (row) => {
          if (!confirm(`¿Eliminar vehículo ${row.ch_plac_vehiculo}?`)) return;
          await api.delete(`/maestros/vehiculos/${row.ch_codi_vehiculo}/`);
          fetchData();
        }}
      />
      {modal && (
        <FormModal
          title={editId ? 'Editar Vehículo' : 'Nuevo Vehículo'}
          fields={editId ? getFields().map((f) => (f.key === 'ch_codi_vehiculo' ? { ...f, readOnly: true } : f)) : getFields()}
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
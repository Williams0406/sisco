import { useEffect, useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';
import FormModal from '../../components/FormModal';

const COLUMNS = [
  { key: 'nu_codi_ticket',  label: '# Ticket' },
  { key: 'ch_plac_vehiculo',label: 'Placa' },
  { key: 'dt_fech_ingre',   label: 'Ingreso',
    render: (v) => v ? new Date(v).toLocaleString('es-PE') : '—' },
  { key: 'dt_fech_salid',   label: 'Salida',
    render: (v) => v ? new Date(v).toLocaleString('es-PE') : '⏳ En curso' },
  { key: 'cliente_desc',    label: 'Cliente' },
  { key: 'garita_desc',     label: 'Garita' },
  { key: 'nu_impo_cobro',   label: 'Importe',
    render: (v) => v ? `S/ ${parseFloat(v).toFixed(2)}` : '—' },
  { key: 'ch_tipo_pago',    label: 'Pago',
    render: (v) => v === 'E' ? '💵 Efectivo' : v === 'C' ? '📋 Crédito' : v },
  { key: 'ch_esta_ticket',  label: 'Estado',
    render: (v) => v === 'CE' ? '✅ Cerrado' : '🟡 Abierto' },
];

export default function Tickets() {
  const [data, setData]       = useState([]);
  const [loading, setLoading] = useState(true);
  const [modal, setModal]     = useState(false);
  const [form, setForm]       = useState({});
  const [saving, setSaving]   = useState(false);
  const [garitas, setGaritas] = useState([]);
  const [clientes, setClientes] = useState([]);
  const [choferes, setChoferes] = useState([]);
  const [vehiculos, setVehiculos] = useState([]);
  // Filtros
  const [filtroPlaca, setFiltroPlaca]   = useState('');
  const [filtroEstado, setFiltroEstado] = useState('');

  const fetchData = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams({ page_size: 100 });
      if (filtroPlaca)  params.append('placa', filtroPlaca);
      if (filtroEstado) params.append('ch_esta_ticket', filtroEstado);

      const [tRes, gRes, cRes, chRes, vRes] = await Promise.all([
        api.get(`/movimientos/tickets/?${params}`),
        api.get('/maestros/garitas/?page_size=50'),
        api.get('/maestros/clientes/?page_size=200'),
        api.get('/maestros/choferes/?page_size=200'),
        api.get('/maestros/vehiculos/?page_size=200'),
      ]);
      setData(tRes.data.results     || tRes.data);
      setGaritas(gRes.data.results  || gRes.data);
      setClientes(cRes.data.results || cRes.data);
      setChoferes(chRes.data.results || chRes.data);
      setVehiculos(vRes.data.results || vRes.data);
    } finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, [filtroPlaca, filtroEstado]);

  const getFields = () => [
    { key: 'ch_plac_vehiculo',  label: 'Placa',      placeholder: 'Ej: ABC-123' },
    { key: 'ch_codi_vehiculo',  label: 'Vehículo',   type: 'select',
      options: vehiculos.map(v => ({ value: v.ch_codi_vehiculo, label: `${v.ch_plac_vehiculo}` })) },
    { key: 'ch_codi_cliente',   label: 'Cliente',    type: 'select',
      options: [{ value: '', label: '— Sin cliente —' },
        ...clientes.map(c => ({ value: c.ch_codi_cliente, label: c.vc_razo_soci_cliente }))] },
    { key: 'ch_codi_chofer',    label: 'Chofer',     type: 'select',
      options: [{ value: '', label: '— Sin chofer —' },
        ...choferes.map(c => ({ value: c.ch_codi_chofer, label: c.vc_desc_chofer }))] },
    { key: 'ch_codi_garita',    label: 'Garita',     type: 'select',
      options: garitas.map(g => ({ value: g.ch_codi_garita, label: g.vc_desc_garita })) },
    { key: 'ch_tipo_pago',      label: 'Tipo de Pago', type: 'select',
      options: [{ value: 'E', label: 'Efectivo' }, { value: 'C', label: 'Crédito' }] },
    { key: 'nu_impo_cobro',     label: 'Importe',    type: 'number', placeholder: '0.00' },
    { key: 'vc_obse_ticket',    label: 'Observación' },
  ];

  const handleNew = () => {
    const now = new Date().toISOString();
    setForm({ dt_fech_ingre: now, ch_esta_ticket: 'AB', ch_esta_activo: '1' });
    setModal(true);
  };

  const handleCerrar = async (row) => {
    if (!confirm(`¿Registrar salida del ticket #${row.nu_codi_ticket} (${row.ch_plac_vehiculo})?`)) return;
    try {
      await api.post(`/movimientos/tickets/${row.nu_codi_ticket}/cerrar/`);
      fetchData();
    } catch (err) {
      alert('Error al cerrar ticket: ' + JSON.stringify(err.response?.data));
    }
  };

  const handleSave = async () => {
    setSaving(true);
    try {
      await api.post('/movimientos/tickets/', form);
      setModal(false);
      fetchData();
    } catch (err) {
      alert('Error: ' + JSON.stringify(err.response?.data));
    } finally { setSaving(false); }
  };

  return (
    <div>
      {/* Barra de filtros */}
      <div style={styles.filtros}>
        <input
          style={styles.inputFiltro}
          placeholder="🔍 Buscar por placa..."
          value={filtroPlaca}
          onChange={(e) => setFiltroPlaca(e.target.value)}
        />
        <select
          style={styles.inputFiltro}
          value={filtroEstado}
          onChange={(e) => setFiltroEstado(e.target.value)}
        >
          <option value="">Todos los estados</option>
          <option value="AB">🟡 Abiertos</option>
          <option value="CE">✅ Cerrados</option>
        </select>
        <button style={styles.btnRefresh} onClick={fetchData}>🔄 Actualizar</button>
      </div>

      <DataTable
        title="Alquiler de Cochera — Tickets"
        columns={[
          ...COLUMNS,
          {
            key: '_acciones',
            label: 'Salida',
            render: (_, row) =>
              row.ch_esta_ticket !== 'CE' ? (
                <button style={styles.btnCerrar} onClick={() => handleCerrar(row)}>
                  🚪 Registrar Salida
                </button>
              ) : '—',
          },
        ]}
        data={data}
        loading={loading}
        onNew={handleNew}
      />

      {modal && (
        <FormModal
          title="Nuevo Ticket de Ingreso"
          fields={getFields()}
          values={form}
          onChange={(k, v) => setForm(p => ({ ...p, [k]: v }))}
          onSave={handleSave}
          onClose={() => setModal(false)}
          loading={saving}
        />
      )}
    </div>
  );
}

const styles = {
  filtros: { display: 'flex', gap: 12, marginBottom: 16, alignItems: 'center' },
  inputFiltro: { padding: '8px 12px', border: '1px solid #d1d5db', borderRadius: 6, fontSize: 13 },
  btnRefresh: { padding: '8px 14px', background: '#f3f4f6', border: '1px solid #d1d5db', borderRadius: 6, cursor: 'pointer' },
  btnCerrar: { padding: '5px 10px', background: '#dc2626', color: '#fff', border: 'none', borderRadius: 4, cursor: 'pointer', fontSize: 12 },
};
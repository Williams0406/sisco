import { useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';

const COLUMNS = [
  { key: 'nu_codi_ticket',  label: '# Ticket' },
  { key: 'ch_plac_vehiculo',label: 'Placa' },
  { key: 'dt_fech_ingre',   label: 'Ingreso',
    render: (v) => v ? new Date(v).toLocaleString('es-PE') : '—' },
  { key: 'dt_fech_salid',   label: 'Salida',
    render: (v) => v ? new Date(v).toLocaleString('es-PE') : '—' },
  { key: 'cliente_desc',    label: 'Cliente' },
  { key: 'garita_desc',     label: 'Garita' },
  { key: 'nu_impo_cobro',   label: 'Importe',
    render: (v) => v ? `S/ ${parseFloat(v).toFixed(2)}` : '—' },
  { key: 'ch_tipo_pago',    label: 'Pago',
    render: (v) => v === 'E' ? 'Efectivo' : v === 'C' ? 'Crédito' : v },
];

export default function TicketSalida() {
  const [data, setData]         = useState([]);
  const [loading, setLoading]   = useState(false);
  const [total, setTotal]       = useState(0);
  const [filtros, setFiltros]   = useState({
    fecha_desde: '', fecha_hasta: '', placa: '',
  });

  const handleBuscar = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (filtros.fecha_desde) params.append('fecha_desde', filtros.fecha_desde);
      if (filtros.fecha_hasta) params.append('fecha_hasta', filtros.fecha_hasta);
      if (filtros.placa)       params.append('placa', filtros.placa);
      const res = await api.get(`/reportes/ticket-salida/?${params}`);
      setData(res.data.results || []);
      setTotal(res.data.count  || 0);
    } finally { setLoading(false); }
  };

  return (
    <div>
      {/* Panel de filtros */}
      <div style={styles.filtrosCard}>
        <h3 style={styles.filtrosTitle}>🔍 Filtros de Búsqueda</h3>
        <div style={styles.filtrosRow}>
          <div style={styles.filtroItem}>
            <label style={styles.label}>Fecha Desde</label>
            <input type="date" style={styles.input}
              value={filtros.fecha_desde}
              onChange={(e) => setFiltros(p => ({ ...p, fecha_desde: e.target.value }))} />
          </div>
          <div style={styles.filtroItem}>
            <label style={styles.label}>Fecha Hasta</label>
            <input type="date" style={styles.input}
              value={filtros.fecha_hasta}
              onChange={(e) => setFiltros(p => ({ ...p, fecha_hasta: e.target.value }))} />
          </div>
          <div style={styles.filtroItem}>
            <label style={styles.label}>Placa</label>
            <input type="text" style={styles.input} placeholder="Ej: ABC-123"
              value={filtros.placa}
              onChange={(e) => setFiltros(p => ({ ...p, placa: e.target.value }))} />
          </div>
          <div style={styles.filtroItem}>
            <label style={{ visibility: 'hidden' }}>-</label>
            <button style={styles.btnBuscar} onClick={handleBuscar}>
              🔍 Generar Reporte
            </button>
          </div>
        </div>
        {total > 0 && (
          <p style={styles.totalBadge}>Total de registros: <strong>{total}</strong></p>
        )}
      </div>

      <DataTable title="Lista de Ticket de Salida"
        columns={COLUMNS} data={data} loading={loading} />
    </div>
  );
}

const styles = {
  filtrosCard: { background: '#fff', borderRadius: 10, padding: '18px 24px',
    marginBottom: 16, boxShadow: '0 1px 4px rgba(0,0,0,0.08)' },
  filtrosTitle: { margin: '0 0 14px', fontSize: 15, color: '#1f2937' },
  filtrosRow: { display: 'flex', gap: 16, flexWrap: 'wrap', alignItems: 'flex-end' },
  filtroItem: { display: 'flex', flexDirection: 'column', gap: 4 },
  label: { fontSize: 12, fontWeight: 600, color: '#374151' },
  input: { padding: '8px 10px', border: '1px solid #d1d5db', borderRadius: 6, fontSize: 13 },
  btnBuscar: { padding: '8px 20px', background: '#2563eb', color: '#fff',
    border: 'none', borderRadius: 6, cursor: 'pointer', fontWeight: 600 },
  totalBadge: { margin: '10px 0 0', fontSize: 13, color: '#6b7280' },
};
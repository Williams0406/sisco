import { useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';

const COLUMNS = [
  { key: 'nu_codi_cobr_cred',  label: '# Cobranza' },
  { key: 'dt_fech_cobr_cred',  label: 'Fecha',
    render: (v) => v ? new Date(v).toLocaleDateString('es-PE') : '—' },
  { key: 'ch_seri_cobr_cred',  label: 'Serie' },
  { key: 'ch_nume_cobr_cred',  label: 'Número' },
  { key: 'cliente_desc',       label: 'Cliente' },
  { key: 'nu_impo_total',      label: 'Total',
    render: (v) => v ? `S/ ${parseFloat(v).toFixed(2)}` : '—' },
  { key: 'ch_esta_activo',     label: 'Estado',
    render: (v) => v === '1' ? '✅ Activo' : '❌ Anulado' },
];

export default function CobranzaDiaria() {
  const [data, setData]         = useState([]);
  const [loading, setLoading]   = useState(false);
  const [totalCobranza, setTotalCobranza] = useState(null);
  const [count, setCount]       = useState(0);
  const [filtros, setFiltros]   = useState({ fecha_desde: '', fecha_hasta: '' });

  const handleBuscar = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (filtros.fecha_desde) params.append('fecha_desde', filtros.fecha_desde);
      if (filtros.fecha_hasta) params.append('fecha_hasta', filtros.fecha_hasta);
      const res = await api.get(`/reportes/cobranza-diaria/?${params}`);
      setData(res.data.results || []);
      setTotalCobranza(res.data.total_cobranza);
      setCount(res.data.count || 0);
    } finally { setLoading(false); }
  };

  const set = (k, v) => setFiltros(p => ({ ...p, [k]: v }));

  return (
    <div>
      <div style={styles.card}>
        <h3 style={styles.cardTitle}>🔍 Filtros — Lista de Cobranza Diaria</h3>
        <div style={styles.row}>
          <div style={styles.col}>
            <label style={styles.label}>Fecha Desde</label>
            <input type="date" style={styles.input}
              value={filtros.fecha_desde} onChange={e => set('fecha_desde', e.target.value)} />
          </div>
          <div style={styles.col}>
            <label style={styles.label}>Fecha Hasta</label>
            <input type="date" style={styles.input}
              value={filtros.fecha_hasta} onChange={e => set('fecha_hasta', e.target.value)} />
          </div>
          <div style={styles.col}>
            <label style={styles.label}>&nbsp;</label>
            <button style={styles.btnBuscar} onClick={handleBuscar}>
              🔍 Generar Reporte
            </button>
          </div>
        </div>

        {totalCobranza !== null && (
          <div style={styles.totalesRow}>
            <div style={styles.totalBox}>
              <span style={styles.totalLabel}>Registros</span>
              <span style={styles.totalValor}>{count}</span>
            </div>
            <div style={{ ...styles.totalBox, background: '#059669' }}>
              <span style={{ ...styles.totalLabel, color: '#a7f3d0' }}>Total Cobranza</span>
              <span style={{ ...styles.totalValor, color: '#fff' }}>
                S/ {parseFloat(totalCobranza || 0).toFixed(2)}
              </span>
            </div>
          </div>
        )}
      </div>

      <DataTable
        title="Lista de Cobranza Diaria"
        columns={COLUMNS}
        data={data}
        loading={loading}
      />
    </div>
  );
}

const styles = {
  card: { background: '#fff', borderRadius: 10, padding: '18px 24px',
    marginBottom: 16, boxShadow: '0 1px 4px rgba(0,0,0,0.08)' },
  cardTitle: { margin: '0 0 16px', fontSize: 15, color: '#1f2937' },
  row: { display: 'flex', gap: 16, flexWrap: 'wrap', alignItems: 'flex-end' },
  col: { display: 'flex', flexDirection: 'column', gap: 4 },
  label: { fontSize: 12, fontWeight: 600, color: '#374151' },
  input: { padding: '8px 10px', border: '1px solid #d1d5db', borderRadius: 6, fontSize: 13 },
  btnBuscar: { padding: '8px 20px', background: '#2563eb', color: '#fff',
    border: 'none', borderRadius: 6, cursor: 'pointer', fontWeight: 600 },
  totalesRow: { display: 'flex', gap: 12, marginTop: 16 },
  totalBox: { background: '#f3f4f6', borderRadius: 8, padding: '10px 20px',
    display: 'flex', flexDirection: 'column', minWidth: 140 },
  totalLabel: { fontSize: 11, color: '#6b7280', fontWeight: 600, textTransform: 'uppercase' },
  totalValor: { fontSize: 20, fontWeight: 700, color: '#1f2937', marginTop: 2 },
};
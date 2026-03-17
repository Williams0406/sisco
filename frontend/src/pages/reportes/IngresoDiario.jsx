import { useState } from 'react';
import api from '../../api/axios';

export default function IngresoDiario() {
  const hoy = new Date().toISOString().split('T')[0];
  const [loading, setLoading] = useState(false);
  const [resumen, setResumen] = useState(null);
  const [filtros, setFiltros] = useState({ fecha: hoy, garita: '' });

  const handleBuscar = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (filtros.fecha)  params.append('fecha',  filtros.fecha);
      if (filtros.garita) params.append('garita', filtros.garita);
      const res = await api.get(`/reportes/ingreso-diario/?${params}`);
      setResumen(res.data);
    } finally { setLoading(false); }
  };

  const set = (k, v) => setFiltros(p => ({ ...p, [k]: v }));

  return (
    <div>
      <div style={styles.card}>
        <h3 style={styles.cardTitle}>🔍 Consulta de Ingreso Diario</h3>
        <div style={styles.row}>
          <div style={styles.col}>
            <label style={styles.label}>Fecha</label>
            <input type="date" style={styles.input}
              value={filtros.fecha} onChange={e => set('fecha', e.target.value)} />
          </div>
          <div style={styles.col}>
            <label style={styles.label}>Garita (opcional)</label>
            <input type="text" style={styles.input} placeholder="Ej: G01"
              value={filtros.garita} onChange={e => set('garita', e.target.value)} />
          </div>
          <div style={styles.col}>
            <label style={styles.label}>&nbsp;</label>
            <button style={styles.btnBuscar} onClick={handleBuscar} disabled={loading}>
              {loading ? 'Consultando...' : '🔍 Consultar'}
            </button>
          </div>
        </div>
      </div>

      {resumen && (
        <div style={styles.resumenGrid}>
          <div style={{ ...styles.resumenCard, borderTop: '4px solid #2563eb' }}>
            <span style={styles.resumenIcon}>🎫</span>
            <span style={styles.resumenValor}>{resumen.cantidad_tickets || 0}</span>
            <span style={styles.resumenLabel}>Tickets del día</span>
          </div>
          <div style={{ ...styles.resumenCard, borderTop: '4px solid #059669' }}>
            <span style={styles.resumenIcon}>💵</span>
            <span style={styles.resumenValor}>
              S/ {parseFloat(resumen.total_efectivo || 0).toFixed(2)}
            </span>
            <span style={styles.resumenLabel}>Cobrado en Efectivo</span>
          </div>
          <div style={{ ...styles.resumenCard, borderTop: '4px solid #d97706' }}>
            <span style={styles.resumenIcon}>📋</span>
            <span style={styles.resumenValor}>
              S/ {parseFloat(resumen.total_credito || 0).toFixed(2)}
            </span>
            <span style={styles.resumenLabel}>Cobrado a Crédito</span>
          </div>
          <div style={{ ...styles.resumenCard, borderTop: '4px solid #7c3aed' }}>
            <span style={styles.resumenIcon}>💰</span>
            <span style={styles.resumenValor}>
              S/ {(parseFloat(resumen.total_efectivo || 0) +
                   parseFloat(resumen.total_credito  || 0)).toFixed(2)}
            </span>
            <span style={styles.resumenLabel}>Total del Día</span>
          </div>
        </div>
      )}

      {resumen && (
        <div style={styles.infoCard}>
          <p style={styles.infoText}>
            📅 Fecha consultada: <strong>{filtros.fecha}</strong>
            {filtros.garita && <> &nbsp;|&nbsp; 🏠 Garita: <strong>{filtros.garita}</strong></>}
          </p>
        </div>
      )}
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
  resumenGrid: { display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)',
    gap: 16, marginBottom: 16 },
  resumenCard: { background: '#fff', borderRadius: 10, padding: '24px 20px',
    display: 'flex', flexDirection: 'column', alignItems: 'center',
    boxShadow: '0 1px 4px rgba(0,0,0,0.08)', textAlign: 'center' },
  resumenIcon: { fontSize: 28, marginBottom: 8 },
  resumenValor: { fontSize: 26, fontWeight: 700, color: '#1f2937', marginBottom: 4 },
  resumenLabel: { fontSize: 12, color: '#6b7280', fontWeight: 600, textTransform: 'uppercase' },
  infoCard: { background: '#fff', borderRadius: 10, padding: '14px 20px',
    boxShadow: '0 1px 4px rgba(0,0,0,0.08)' },
  infoText: { margin: 0, color: '#6b7280', fontSize: 13 },
};
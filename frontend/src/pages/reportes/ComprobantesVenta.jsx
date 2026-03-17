import { useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';

const COLUMNS = [
  { key: 'nu_codi_docu_vent',  label: '# Doc' },
  { key: 'dt_fech_docu_vent',  label: 'Fecha',
    render: (v) => v ? new Date(v).toLocaleDateString('es-PE') : '—' },
  { key: 'ch_seri_cmprbt',     label: 'Serie' },
  { key: 'ch_nume_cmprbt',     label: 'Número' },
  { key: 'ch_tipo_cmprbnt',    label: 'Tipo',
    render: (v) => v === 'BO' ? '📄 Boleta' : v === 'FA' ? '🧾 Factura' : v },
  { key: 'cliente_desc',       label: 'Cliente' },
  { key: 'ch_ruc_cliente',     label: 'RUC' },
  { key: 'nu_impo_afecto',     label: 'Afecto',
    render: (v) => v ? `S/ ${parseFloat(v).toFixed(2)}` : '—' },
  { key: 'nu_impo_igv',        label: 'IGV',
    render: (v) => v ? `S/ ${parseFloat(v).toFixed(2)}` : '—' },
  { key: 'nu_impo_total',      label: 'Total',
    render: (v) => v ? `S/ ${parseFloat(v).toFixed(2)}` : '—' },
  { key: 'ch_esta_activo',     label: 'Estado',
    render: (v) => v === '1' ? '✅' : '❌ Anulado' },
];

export default function ComprobantesVenta() {
  const [data, setData]       = useState([]);
  const [loading, setLoading] = useState(false);
  const [totales, setTotales] = useState(null);
  const [count, setCount]     = useState(0);
  const [filtros, setFiltros] = useState({
    fecha_desde: '', fecha_hasta: '', tipo_comprobante: '', cliente: '',
  });

  const handleBuscar = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (filtros.fecha_desde)       params.append('fecha_desde',       filtros.fecha_desde);
      if (filtros.fecha_hasta)       params.append('fecha_hasta',       filtros.fecha_hasta);
      if (filtros.tipo_comprobante)  params.append('tipo_comprobante',  filtros.tipo_comprobante);
      if (filtros.cliente)           params.append('cliente',           filtros.cliente);
      const res = await api.get(`/reportes/comprobantes-venta/?${params}`);
      setData(res.data.results  || []);
      setTotales(res.data.totales || null);
      setCount(res.data.count   || 0);
    } finally { setLoading(false); }
  };

  const set = (k, v) => setFiltros(p => ({ ...p, [k]: v }));

  return (
    <div>
      <div style={styles.card}>
        <h3 style={styles.cardTitle}>🔍 Filtros — Relación Comprobante de Venta</h3>
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
            <label style={styles.label}>Tipo Comprobante</label>
            <select style={styles.input}
              value={filtros.tipo_comprobante} onChange={e => set('tipo_comprobante', e.target.value)}>
              <option value="">— Todos —</option>
              <option value="BO">Boleta</option>
              <option value="FA">Factura</option>
            </select>
          </div>
          <div style={styles.col}>
            <label style={styles.label}>&nbsp;</label>
            <button style={styles.btnBuscar} onClick={handleBuscar}>
              🔍 Generar Reporte
            </button>
          </div>
        </div>

        {totales && (
          <div style={styles.totalesRow}>
            <div style={styles.totalBox}>
              <span style={styles.totalLabel}>Registros</span>
              <span style={styles.totalValor}>{count}</span>
            </div>
            <div style={styles.totalBox}>
              <span style={styles.totalLabel}>Total Afecto</span>
              <span style={styles.totalValor}>
                S/ {parseFloat(totales.total_afecto || 0).toFixed(2)}
              </span>
            </div>
            <div style={styles.totalBox}>
              <span style={styles.totalLabel}>Total IGV</span>
              <span style={styles.totalValor}>
                S/ {parseFloat(totales.total_igv || 0).toFixed(2)}
              </span>
            </div>
            <div style={{ ...styles.totalBox, background: '#2563eb' }}>
              <span style={{ ...styles.totalLabel, color: '#bfdbfe' }}>Total General</span>
              <span style={{ ...styles.totalValor, color: '#fff' }}>
                S/ {parseFloat(totales.total_general || 0).toFixed(2)}
              </span>
            </div>
          </div>
        )}
      </div>

      <DataTable
        title="Relación Comprobante de Venta"
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
  totalesRow: { display: 'flex', gap: 12, marginTop: 16, flexWrap: 'wrap' },
  totalBox: { background: '#f3f4f6', borderRadius: 8, padding: '10px 20px',
    display: 'flex', flexDirection: 'column', minWidth: 140 },
  totalLabel: { fontSize: 11, color: '#6b7280', fontWeight: 600, textTransform: 'uppercase' },
  totalValor: { fontSize: 20, fontWeight: 700, color: '#1f2937', marginTop: 2 },
};
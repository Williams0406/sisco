import { useEffect, useMemo, useState } from 'react';
import api from '../../api/axios';
import { theme } from '../../styles/tokens';

const MONTHS = [
  { key: 0, label: 'Enero' },
  { key: 1, label: 'Febrero' },
  { key: 2, label: 'Marzo' },
  { key: 3, label: 'Abril' },
  { key: 4, label: 'Mayo' },
  { key: 5, label: 'Junio' },
  { key: 6, label: 'Julio' },
  { key: 7, label: 'Agosto' },
  { key: 8, label: 'Septiembre' },
  { key: 9, label: 'Octubre' },
  { key: 10, label: 'Noviembre' },
  { key: 11, label: 'Diciembre' },
];

const formatMoney = (value) => {
  const amount = Number(value);
  return Number.isFinite(amount) ? `S/ ${amount.toFixed(2)}` : 'S/ 0.00';
};

const emptyMonths = () => Array(12).fill(0);
const normalizeList = (payload) => payload?.results || payload || [];

const parseDateParts = (value) => {
  if (!value || typeof value !== 'string') return null;
  const match = value.match(/^(\d{4})-(\d{2})-(\d{2})/);
  if (!match) return null;
  return {
    year: match[1],
    monthIndex: Number(match[2]) - 1,
    day: match[3],
  };
};

export default function IngresoEgresoMes() {
  const anioActual = new Date().getFullYear();
  const [loading, setLoading] = useState(false);
  const [cierres, setCierres] = useState([]);
  const [anio, setAnio] = useState(String(anioActual));

  const anios = Array.from({ length: 8 }, (_, i) => String(anioActual - i));

  const handleBuscar = async () => {
    setLoading(true);
    try {
      const res = await api.get('/movimientos/cierres-turno/?page_size=2000&ch_esta_activo=1');
      setCierres(normalizeList(res.data));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    handleBuscar();
  }, []);

  const rows = useMemo(() => {
    const ingresoMonths = emptyMonths();
    const egresoMonths = emptyMonths();
    const otroIngresoMonths = emptyMonths();
    const cobranzaMonths = emptyMonths();

    cierres.forEach((item) => {
      const parts = parseDateParts(item.dt_fech_turno);
      if (!parts || parts.year !== anio || parts.monthIndex < 0 || parts.monthIndex > 11) return;

      const monthIndex = parts.monthIndex;
      ingresoMonths[monthIndex] += Number(item.nu_impo_tota_ingr || 0);
      egresoMonths[monthIndex] += Number(item.nu_impo_egre || 0);
      otroIngresoMonths[monthIndex] += Number(item.nu_impo_otro_ingr || 0);
      cobranzaMonths[monthIndex] += Number(item.nu_impo_cobr_cred || 0);
    });

    const totalMonths = emptyMonths().map((_, index) =>
      ingresoMonths[index] + otroIngresoMonths[index] + cobranzaMonths[index] - egresoMonths[index],
    );

    return [
      {
        nro: 1,
        concepto: 'Ingreso',
        months: ingresoMonths,
        total: ingresoMonths.reduce((sum, value) => sum + value, 0),
      },
      {
        nro: 2,
        concepto: 'Egreso',
        months: egresoMonths,
        total: egresoMonths.reduce((sum, value) => sum + value, 0),
      },
      {
        nro: 3,
        concepto: 'Otro ingreso',
        months: otroIngresoMonths,
        total: otroIngresoMonths.reduce((sum, value) => sum + value, 0),
      },
      {
        nro: 4,
        concepto: 'Cobranza Credito',
        months: cobranzaMonths,
        total: cobranzaMonths.reduce((sum, value) => sum + value, 0),
      },
      {
        nro: '',
        concepto: 'Total',
        months: totalMonths,
        total: totalMonths.reduce((sum, value) => sum + value, 0),
        isTotal: true,
      },
    ];
  }, [cierres, anio]);

  const totalAnual = useMemo(() => rows.find((row) => row.isTotal)?.total || 0, [rows]);

  return (
    <div style={styles.page}>
      <section style={styles.heroCard}>
        <div>
          <p style={styles.eyebrow}>Reporte financiero</p>
          <h1 style={styles.title}>Ingresos y egresos mensuales</h1>
          <p style={styles.subtitle}>
            Resumen anual basado en CabCierreTurno con los conceptos operativos del cierre y una fila total por mes.
          </p>
        </div>

        <div style={styles.filters}>
          <div style={styles.filterGroup}>
            <label style={styles.label}>Ano</label>
            <select style={styles.input} value={anio} onChange={(e) => setAnio(e.target.value)}>
              {anios.map((item) => (
                <option key={item} value={item}>{item}</option>
              ))}
            </select>
          </div>
        </div>
      </section>

      <section style={styles.metricsGrid}>
        <MetricCard label="Conceptos" value={String(rows.filter((row) => !row.isTotal).length)} />
        <MetricCard label="Total anual" value={formatMoney(totalAnual)} highlight />
      </section>

      <section style={styles.tableCard}>
        <div style={styles.tableHeader}>
          <div>
            <h2 style={styles.tableTitle}>Detalle mensual</h2>
            <p style={styles.tableSubtitle}>
              Las columnas de enero a diciembre consolidan los montos de CabCierreTurno segun el mes de dt_fech_turno.
            </p>
          </div>
          <span style={styles.counter}>{rows.length} registro(s)</span>
        </div>

        <div style={styles.tableWrapper}>
          <table style={styles.table}>
            <thead>
              <tr>
                <th style={styles.th}>N°</th>
                <th style={styles.th}>Concepto</th>
                {MONTHS.map((month) => (
                  <th key={month.key} style={styles.th}>{month.label}</th>
                ))}
                <th style={styles.th}>TOTAL</th>
              </tr>
            </thead>
            <tbody>
              {loading && <tr><td colSpan={15} style={styles.empty}>Cargando datos...</td></tr>}
              {!loading && rows.length === 0 && <tr><td colSpan={15} style={styles.empty}>No hay datos para el ano seleccionado.</td></tr>}
              {!loading && rows.map((row, index) => (
                <tr key={`${row.concepto}-${index}`} style={row.isTotal ? styles.totalRow : (index % 2 !== 0 ? styles.trOdd : undefined)}>
                  <td style={styles.td}>{row.nro || '-'}</td>
                  <td style={{ ...styles.td, ...(row.isTotal ? styles.totalConcept : {}) }}>{row.concepto}</td>
                  {row.months.map((value, monthIndex) => (
                    <td key={`${row.concepto}-${monthIndex}`} style={{ ...styles.td, ...styles.amountCell }}>
                      {formatMoney(value)}
                    </td>
                  ))}
                  <td style={{ ...styles.td, ...styles.amountCell, ...styles.totalConcept }}>{formatMoney(row.total)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>
    </div>
  );
}

function MetricCard({ label, value, highlight = false }) {
  return (
    <div style={{ ...styles.metricCard, ...(highlight ? styles.metricCardHighlight : {}) }}>
      <span style={{ ...styles.metricLabel, ...(highlight ? styles.metricLabelHighlight : {}) }}>{label}</span>
      <strong style={{ ...styles.metricValue, ...(highlight ? styles.metricValueHighlight : {}) }}>{value}</strong>
    </div>
  );
}

const styles = {
  page: { display: 'flex', flexDirection: 'column', gap: 18 },
  heroCard: { background: theme.colors.panel, borderRadius: theme.radius.lg, border: `1px solid ${theme.colors.border}`, boxShadow: theme.shadow.card, padding: 22, display: 'flex', justifyContent: 'space-between', gap: 16, alignItems: 'flex-end', flexWrap: 'wrap' },
  eyebrow: { margin: 0, color: theme.colors.textSoft, fontSize: theme.typography.small, textTransform: 'uppercase', letterSpacing: 1, fontWeight: 800 },
  title: { margin: '6px 0 0', fontSize: 26, fontWeight: 900, color: theme.colors.text },
  subtitle: { margin: '8px 0 0', fontSize: theme.typography.body, color: theme.colors.textMuted, maxWidth: 720 },
  filters: { display: 'flex', gap: 12, alignItems: 'end', flexWrap: 'wrap' },
  filterGroup: { display: 'flex', flexDirection: 'column', gap: 6 },
  label: { fontSize: theme.typography.label, fontWeight: 700, color: theme.colors.textMuted },
  input: { minWidth: 150, padding: '10px 12px', border: `1px solid ${theme.colors.borderStrong}`, borderRadius: theme.radius.sm, fontSize: theme.typography.body, background: theme.colors.panel, color: theme.colors.text, outline: 'none' },
  metricsGrid: { display: 'grid', gridTemplateColumns: 'repeat(2, minmax(0, 1fr))', gap: 12 },
  metricCard: { background: theme.colors.panel, borderRadius: theme.radius.md, border: `1px solid ${theme.colors.border}`, boxShadow: theme.shadow.card, padding: '16px 18px', display: 'flex', flexDirection: 'column', gap: 6 },
  metricCardHighlight: { background: theme.colors.brandTint, borderColor: '#bfdbfe' },
  metricLabel: { color: theme.colors.textMuted, fontSize: theme.typography.small, textTransform: 'uppercase', letterSpacing: 0.8, fontWeight: 700 },
  metricLabelHighlight: { color: theme.colors.brandDark },
  metricValue: { color: theme.colors.text, fontSize: 24, fontWeight: 800 },
  metricValueHighlight: { color: theme.colors.brandDark },
  tableCard: { background: theme.colors.panel, borderRadius: theme.radius.lg, border: `1px solid ${theme.colors.border}`, boxShadow: theme.shadow.card, padding: 20 },
  tableHeader: { display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 12, marginBottom: 16 },
  tableTitle: { margin: 0, fontSize: 20, color: theme.colors.text, fontWeight: 800 },
  tableSubtitle: { margin: '6px 0 0', color: theme.colors.textMuted, fontSize: theme.typography.body },
  counter: { background: theme.colors.panelMuted, color: theme.colors.textMuted, border: `1px solid ${theme.colors.border}`, padding: '8px 12px', borderRadius: theme.radius.pill, fontSize: theme.typography.small, fontWeight: 700, whiteSpace: 'nowrap' },
  tableWrapper: { overflow: 'auto', border: `1px solid ${theme.colors.border}`, borderRadius: theme.radius.md },
  table: { width: '100%', borderCollapse: 'collapse', fontSize: theme.typography.body },
  th: { background: theme.colors.panelMuted, padding: '12px 14px', textAlign: 'left', borderBottom: `1px solid ${theme.colors.border}`, color: theme.colors.textMuted, fontWeight: 700, whiteSpace: 'nowrap', textTransform: 'uppercase', letterSpacing: 0.4, fontSize: theme.typography.small },
  td: { padding: '12px 14px', borderBottom: '1px solid #edf2f7', color: theme.colors.text, whiteSpace: 'nowrap' },
  trOdd: { background: '#fbfdff' },
  totalRow: { background: theme.colors.brandTint },
  totalConcept: { fontWeight: 800, color: theme.colors.brandDark },
  amountCell: { textAlign: 'right', fontWeight: 700 },
  empty: { textAlign: 'center', padding: 28, color: theme.colors.textMuted },
};

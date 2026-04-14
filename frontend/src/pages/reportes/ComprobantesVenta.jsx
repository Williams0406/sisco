import { useEffect, useMemo, useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';
import { theme } from '../../styles/tokens';

const formatDate = (value) => {
  if (!value) return '-';
  const date = new Date(value);
  return Number.isNaN(date.getTime()) ? '-' : date.toLocaleDateString('es-PE');
};

const formatMoney = (value) => {
  const amount = Number(value);
  return Number.isFinite(amount) ? `S/ ${amount.toFixed(2)}` : '-';
};

const normalizeList = (payload) => payload?.results || payload || [];

const COLUMNS = [
  { key: 'dt_fech_emision', label: 'Fecha de emision', render: (v) => formatDate(v) },
  {
    key: 'ch_tipo_cmprbnt',
    label: 'Tipo',
    render: (v) => v || '-',
  },
  {
    key: 'numero_comprobante',
    label: 'Numero',
    render: (_, row) => `${row.ch_seri_cmprbt || '-'} - ${row.ch_nume_cmprbt || '-'}`,
  },
  { key: 'cliente_desc', label: 'Cliente' },
  { key: 'cliente_ruc', label: 'RUC' },
  { key: 'nu_impo_afecto', label: 'Afecto', render: (v) => formatMoney(v) },
  { key: 'nu_impo_igv', label: 'IGV', render: (v) => formatMoney(v) },
  { key: 'nu_impo_total', label: 'Total', render: (v) => formatMoney(v) },
  { key: 'ch_esta_activo', label: 'Estado', render: (v) => String(v ?? '-') },
];

export default function ComprobantesVenta() {
  const [data, setData] = useState([]);
  const [clientes, setClientes] = useState([]);
  const [loading, setLoading] = useState(false);
  const [count, setCount] = useState(0);
  const [filtros, setFiltros] = useState({
    fecha_desde: '',
    fecha_hasta: '',
    cliente: '',
    tipo_comprobante: '',
  });

  const totals = useMemo(
    () =>
      data.reduce(
        (acc, row) => {
          acc.afecto += Number(row.nu_impo_afecto || 0);
          acc.igv += Number(row.nu_impo_igv || 0);
          acc.total += Number(row.nu_impo_total || 0);
          return acc;
        },
        { afecto: 0, igv: 0, total: 0 },
      ),
    [data],
  );

  const fetchClientes = async () => {
    const res = await api.get('/maestros/clientes/?page_size=300');
    setClientes(normalizeList(res.data));
  };

  useEffect(() => {
    fetchClientes();
  }, []);

  const fetchComprobantes = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (filtros.fecha_desde) params.append('fecha_desde', filtros.fecha_desde);
      if (filtros.fecha_hasta) params.append('fecha_hasta', filtros.fecha_hasta);
      if (filtros.cliente) params.append('cliente', filtros.cliente);
      if (filtros.tipo_comprobante) params.append('tipo_comprobante', filtros.tipo_comprobante);

      const res = await api.get(`/reportes/comprobantes-venta/?${params}`);
      setData(res.data.results || []);
      setCount(res.data.count || 0);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchComprobantes();
  }, [filtros.fecha_desde, filtros.fecha_hasta, filtros.cliente, filtros.tipo_comprobante]);

  const set = (key, value) => {
    setFiltros((prev) => ({ ...prev, [key]: value }));
  };

  return (
    <div style={styles.page}>
      <section style={styles.heroCard}>
        <div>
          <p style={styles.eyebrow}>Reporte financiero</p>
          <h1 style={styles.title}>Relacion de comprobante de venta</h1>
          <p style={styles.subtitle}>Filtra por fechas, cliente o tipo de documento y revisa los importes con mas claridad.</p>
        </div>

        <div style={styles.filtersGrid}>
          <FilterField label="Fecha desde">
            <input type="date" style={styles.input} value={filtros.fecha_desde} onChange={(e) => set('fecha_desde', e.target.value)} />
          </FilterField>
          <FilterField label="Fecha hasta">
            <input type="date" style={styles.input} value={filtros.fecha_hasta} onChange={(e) => set('fecha_hasta', e.target.value)} />
          </FilterField>
          <FilterField label="Cliente">
            <select style={styles.input} value={filtros.cliente} onChange={(e) => set('cliente', e.target.value)}>
              <option value="">Todos</option>
              {clientes.map((cliente) => (
                <option key={cliente.ch_codi_cliente} value={cliente.ch_codi_cliente}>
                  {cliente.vc_razo_soci_cliente}
                </option>
              ))}
            </select>
          </FilterField>
          <FilterField label="Tipo de documento">
            <select style={styles.input} value={filtros.tipo_comprobante} onChange={(e) => set('tipo_comprobante', e.target.value)}>
              <option value="">Todos</option>
              <option value="BO">Boleta</option>
              <option value="FA">Factura</option>
            </select>
          </FilterField>
        </div>
      </section>

      <section style={styles.metricsGrid}>
        <MetricCard label="Registros" value={String(count)} />
        <MetricCard label="Afecto" value={formatMoney(totals.afecto)} />
        <MetricCard label="IGV" value={formatMoney(totals.igv)} />
        <MetricCard label="Total" value={formatMoney(totals.total)} highlight />
      </section>

      <DataTable
        title="Relacion de comprobante de venta"
        subtitle="Detalle completo de documentos emitidos para seguimiento y control."
        columns={COLUMNS}
        data={data}
        loading={loading}
      />
    </div>
  );
}

function FilterField({ label, children }) {
  return (
    <div style={styles.filterField}>
      <label style={styles.label}>{label}</label>
      {children}
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
  page: {
    display: 'flex',
    flexDirection: 'column',
    gap: 18,
    background: theme.colors.appBg,
    minWidth: 'max-content',
    width: '100%',
    paddingBottom: 4,
  },
  heroCard: {
    background: theme.colors.panel,
    borderRadius: theme.radius.lg,
    border: `1px solid ${theme.colors.border}`,
    boxShadow: theme.shadow.card,
    padding: 22,
    display: 'flex',
    flexDirection: 'column',
    gap: 18,
  },
  eyebrow: { margin: 0, color: theme.colors.textSoft, fontSize: theme.typography.small, textTransform: 'uppercase', letterSpacing: 1, fontWeight: 800 },
  title: { margin: '6px 0 0', fontSize: 26, fontWeight: 900, color: theme.colors.text },
  subtitle: { margin: '8px 0 0', fontSize: theme.typography.body, color: theme.colors.textMuted, maxWidth: 760 },
  filtersGrid: { display: 'grid', gridTemplateColumns: 'repeat(4, minmax(180px, 1fr))', gap: 12, alignItems: 'end' },
  filterField: { display: 'flex', flexDirection: 'column', gap: 6 },
  label: { fontSize: theme.typography.label, fontWeight: 700, color: theme.colors.textMuted },
  input: { width: '100%', boxSizing: 'border-box', padding: '10px 12px', border: `1px solid ${theme.colors.borderStrong}`, borderRadius: theme.radius.sm, fontSize: theme.typography.body, background: theme.colors.panel, color: theme.colors.text, outline: 'none' },
  metricsGrid: { display: 'grid', gridTemplateColumns: 'repeat(4, minmax(0, 1fr))', gap: 12 },
  metricCard: { background: theme.colors.panel, borderRadius: theme.radius.md, border: `1px solid ${theme.colors.border}`, boxShadow: theme.shadow.card, padding: '16px 18px', display: 'flex', flexDirection: 'column', gap: 6 },
  metricCardHighlight: { background: theme.colors.brandTint, borderColor: '#bfdbfe' },
  metricLabel: { color: theme.colors.textMuted, fontSize: theme.typography.small, textTransform: 'uppercase', letterSpacing: 0.8, fontWeight: 700 },
  metricLabelHighlight: { color: theme.colors.brandDark },
  metricValue: { color: theme.colors.text, fontSize: 24, fontWeight: 800 },
  metricValueHighlight: { color: theme.colors.brandDark },
};

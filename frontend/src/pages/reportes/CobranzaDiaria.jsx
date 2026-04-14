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

const conditionLabel = (value) => {
  if (value === '1') return 'Credito';
  if (value === '0') return 'Contado';
  return value || '-';
};

const statusLabel = (value) => (value === '1' ? 'Activo' : 'Anulado');

const COLUMNS = [
  { key: 'ticket', label: 'Ticket' },
  { key: 'fecha', label: 'Fecha', render: (v) => formatDate(v) },
  { key: 'turno', label: 'Turno' },
  { key: 'comprobante', label: 'Comprobante' },
  { key: 'vehiculo', label: 'Vehiculo' },
  { key: 'cliente', label: 'Cliente' },
  { key: 'condicion', label: 'Cond.' },
  { key: 'monto', label: 'Monto', render: (v) => formatMoney(v) },
  { key: 'estado', label: 'Estado' },
];

export default function CobranzaDiaria() {
  const [cobranzas, setCobranzas] = useState([]);
  const [detalles, setDetalles] = useState([]);
  const [tickets, setTickets] = useState([]);
  const [loading, setLoading] = useState(false);
  const [fecha, setFecha] = useState('');

  const fetchData = async () => {
    setLoading(true);
    try {
      const [cobrRes, detRes, ticketRes] = await Promise.all([
        api.get('/movimientos/cobranza-credito/?page_size=500'),
        api.get('/movimientos/det-cobranza/?page_size=1000'),
        api.get('/movimientos/tickets/?page_size=500&ch_esta_activo=1'),
      ]);

      setCobranzas(normalizeList(cobrRes.data));
      setDetalles(normalizeList(detRes.data));
      setTickets(normalizeList(ticketRes.data));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const rows = useMemo(() => {
    const cobranzasMap = new Map();
    const ticketsMap = new Map();

    cobranzas.forEach((item) => {
      cobranzasMap.set(item.nu_codi_cobr_cred, item);
    });

    tickets.forEach((item) => {
      ticketsMap.set(item.nu_codi_ticket, item);
    });

    return detalles
      .map((detalle) => {
        const cobranza = cobranzasMap.get(detalle.nu_codi_cobr_cred);
        const ticket = ticketsMap.get(detalle.nu_codi_ticket);
        if (!cobranza) return null;

        return {
          id: `${detalle.nu_codi_cobr_cred}-${detalle.nu_codi_detalle}`,
          ticket: `${detalle.ticket_serie || detalle.ch_seri_tckt || '-'}-${detalle.ticket_numero || detalle.ch_nume_tckt || '-'}`,
          fecha: cobranza.dt_fech_cobr,
          turno: cobranza.ch_codi_turno_caja || '-',
          comprobante: `${cobranza.ch_seri_cobr || '-'}-${cobranza.ch_nume_cobr || '-'}`,
          vehiculo: detalle.ch_plac_vehiculo || ticket?.vehiculo_placa || '-',
          cliente: cobranza.cliente_desc || '-',
          condicion: conditionLabel(ticket?.ch_esta_condicion),
          monto: detalle.nu_impo_cobr,
          estado: statusLabel(cobranza.ch_esta_activo),
        };
      })
      .filter(Boolean)
      .filter((row) => {
        if (!fecha) return true;
        const rowDate = row.fecha ? new Date(row.fecha) : null;
        if (!rowDate || Number.isNaN(rowDate.getTime())) return false;
        return rowDate.toISOString().slice(0, 10) === fecha;
      })
      .sort((a, b) => new Date(b.fecha || 0) - new Date(a.fecha || 0));
  }, [cobranzas, detalles, tickets, fecha]);

  const totalMonto = useMemo(() => rows.reduce((sum, row) => sum + Number(row.monto || 0), 0), [rows]);

  return (
    <div style={styles.page}>
      <section style={styles.heroCard}>
        <div>
          <p style={styles.eyebrow}>Reporte financiero</p>
          <h1 style={styles.title}>Cobranza diaria</h1>
          <p style={styles.subtitle}>Consulta los cobros realizados por fecha con una lectura mas rapida del movimiento diario.</p>
        </div>

        <div style={styles.filterBar}>
          <div style={styles.filterField}>
            <label style={styles.label}>Fecha</label>
            <input type="date" style={styles.input} value={fecha} onChange={(e) => setFecha(e.target.value)} />
          </div>
          <button style={styles.btnPrimary} type="button" onClick={fetchData} disabled={loading}>
            {loading ? 'Consultando...' : 'Actualizar'}
          </button>
        </div>
      </section>

      <section style={styles.metricsGrid}>
        <MetricCard label="Cobros" value={String(rows.length)} />
        <MetricCard label="Monto total" value={formatMoney(totalMonto)} highlight />
      </section>

      <DataTable
        title="Cobranza diaria"
        subtitle="Detalle consolidado de tickets cobrados, condicion y monto asociado."
        columns={COLUMNS}
        data={rows}
        loading={loading}
      />
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
  heroCard: {
    background: theme.colors.panel,
    borderRadius: theme.radius.lg,
    border: `1px solid ${theme.colors.border}`,
    boxShadow: theme.shadow.card,
    padding: 22,
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'flex-end',
    gap: 16,
    flexWrap: 'wrap',
  },
  eyebrow: { margin: 0, color: theme.colors.textSoft, fontSize: theme.typography.small, textTransform: 'uppercase', letterSpacing: 1, fontWeight: 800 },
  title: { margin: '6px 0 0', fontSize: 26, fontWeight: 900, color: theme.colors.text },
  subtitle: { margin: '8px 0 0', fontSize: theme.typography.body, color: theme.colors.textMuted, maxWidth: 680 },
  filterBar: { display: 'flex', gap: 12, alignItems: 'end', flexWrap: 'wrap' },
  filterField: { display: 'flex', flexDirection: 'column', gap: 6 },
  label: { fontSize: theme.typography.label, fontWeight: 700, color: theme.colors.textMuted },
  input: { minWidth: 180, padding: '10px 12px', border: `1px solid ${theme.colors.borderStrong}`, borderRadius: theme.radius.sm, fontSize: theme.typography.body, background: theme.colors.panel, color: theme.colors.text, outline: 'none' },
  btnPrimary: { background: theme.colors.brand, color: '#fff', border: 'none', padding: '10px 18px', borderRadius: theme.radius.sm, cursor: 'pointer', fontWeight: 700, boxShadow: theme.shadow.soft },
  metricsGrid: { display: 'grid', gridTemplateColumns: 'repeat(2, minmax(0, 1fr))', gap: 12 },
  metricCard: { background: theme.colors.panel, borderRadius: theme.radius.md, border: `1px solid ${theme.colors.border}`, boxShadow: theme.shadow.card, padding: '16px 18px', display: 'flex', flexDirection: 'column', gap: 6 },
  metricCardHighlight: { background: '#fff7ed', borderColor: '#fed7aa' },
  metricLabel: { color: theme.colors.textMuted, fontSize: theme.typography.small, textTransform: 'uppercase', letterSpacing: 0.8, fontWeight: 700 },
  metricLabelHighlight: { color: theme.colors.warning },
  metricValue: { color: theme.colors.text, fontSize: 24, fontWeight: 800 },
  metricValueHighlight: { color: theme.colors.warning },
};

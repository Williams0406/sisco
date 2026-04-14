import { useEffect, useMemo, useState } from 'react';
import api from '../../api/axios';
import { theme } from '../../styles/tokens';

const formatDateTime = (value) => {
  if (!value) return '-';
  const date = new Date(value);
  return Number.isNaN(date.getTime()) ? '-' : date.toLocaleString('es-PE');
};

const formatMoney = (value) => {
  const amount = Number(value);
  return Number.isFinite(amount) ? `S/ ${amount.toFixed(2)}` : 'S/ 0.00';
};

const normalizeList = (payload) => payload?.results || payload || [];

export default function ConsultaTicketCredito() {
  const [tickets, setTickets] = useState([]);
  const [loading, setLoading] = useState(true);
  const [cancelingId, setCancelingId] = useState(null);
  const [fechaDesde, setFechaDesde] = useState('');
  const [fechaHasta, setFechaHasta] = useState('');

  const fetchTickets = async () => {
    setLoading(true);
    try {
      const res = await api.get('/movimientos/tickets/?page_size=500&ch_esta_activo=1&ch_esta_cancelado=0');
      setTickets(normalizeList(res.data));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchTickets();
  }, []);

  const cuentasPorCobrar = useMemo(() => {
    const desde = fechaDesde ? new Date(`${fechaDesde}T00:00:00`) : null;
    const hasta = fechaHasta ? new Date(`${fechaHasta}T23:59:59`) : null;

    return tickets
      .filter((ticket) => !(ticket.ch_esta_cancelado === '1' || ticket.ch_esta_cancelado === true))
      .filter((ticket) => Number(ticket.nu_impo_saldo || 0) > 0)
      .filter((ticket) => {
        if (!desde && !hasta) return true;
        const fecha = ticket.dt_fech_emision ? new Date(ticket.dt_fech_emision) : null;
        if (!fecha || Number.isNaN(fecha.getTime())) return false;
        if (desde && fecha < desde) return false;
        if (hasta && fecha > hasta) return false;
        return true;
      })
      .sort((a, b) => new Date(b.dt_fech_emision || 0) - new Date(a.dt_fech_emision || 0));
  }, [tickets, fechaDesde, fechaHasta]);

  const totalSaldo = useMemo(() => cuentasPorCobrar.reduce((sum, ticket) => sum + Number(ticket.nu_impo_saldo || 0), 0), [cuentasPorCobrar]);

  const handleCancelarTicket = async (ticket) => {
    setCancelingId(ticket.nu_codi_ticket);
    try {
      await api.patch(`/movimientos/tickets/${ticket.nu_codi_ticket}/`, {
        ch_esta_cancelado: '1',
      });
      setTickets((prev) => prev.filter((item) => item.nu_codi_ticket !== ticket.nu_codi_ticket));
    } catch (error) {
      alert(`Error: ${JSON.stringify(error.response?.data || error.message)}`);
    } finally {
      setCancelingId(null);
    }
  };

  return (
    <div style={styles.page}>
      <section style={styles.heroCard}>
        <div>
          <p style={styles.eyebrow}>Movimientos</p>
          <h1 style={styles.title}>Cuentas por cobrar</h1>
          <p style={styles.subtitle}>Consulta los tickets con saldo pendiente y revisa rapidamente su emision, movimiento y saldo restante.</p>
        </div>

        <div style={styles.filters}>
          <div style={styles.filterGroup}>
            <label style={styles.label}>Desde</label>
            <input type="date" style={styles.input} value={fechaDesde} onChange={(e) => setFechaDesde(e.target.value)} />
          </div>
          <div style={styles.filterGroup}>
            <label style={styles.label}>Hasta</label>
            <input type="date" style={styles.input} value={fechaHasta} onChange={(e) => setFechaHasta(e.target.value)} />
          </div>
          <button style={styles.btnPrimary} type="button" onClick={fetchTickets} disabled={loading}>
            {loading ? 'Buscando...' : 'Buscar'}
          </button>
        </div>
      </section>

      <section style={styles.metricsGrid}>
        <MetricCard label="Tickets" value={String(cuentasPorCobrar.length)} />
        <MetricCard label="Saldo pendiente" value={formatMoney(totalSaldo)} highlight />
      </section>

      <section style={styles.tableCard}>
        <div style={styles.tableHeader}>
          <div>
            <h2 style={styles.tableTitle}>Detalle de cuentas por cobrar</h2>
            <p style={styles.tableSubtitle}>Tickets con deuda pendiente ordenados por fecha de emision.</p>
          </div>
          <span style={styles.counter}>{cuentasPorCobrar.length} registro(s)</span>
        </div>

        <div style={styles.tableWrapper}>
          <table style={styles.table}>
            <thead>
              <tr>
                <th style={styles.th}>Nro</th>
                <th style={styles.th}>Nro de ticket</th>
                <th style={styles.th}>Fecha de emision</th>
                <th style={styles.th}>Vehiculo</th>
                <th style={styles.th}>Cajero</th>
                <th style={styles.th}>Turno</th>
                <th style={styles.th}>Ingreso</th>
                <th style={styles.th}>Salida</th>
                <th style={styles.th}>Total</th>
                <th style={styles.th}>Saldo</th>
                <th style={styles.th}>Cancelar</th>
              </tr>
            </thead>
            <tbody>
              {loading && <tr><td colSpan={11} style={styles.empty}>Cargando cuentas por cobrar...</td></tr>}
              {!loading && cuentasPorCobrar.length === 0 && <tr><td colSpan={11} style={styles.empty}>No hay tickets con saldo pendiente.</td></tr>}
              {!loading && cuentasPorCobrar.map((ticket, index) => (
                <tr key={ticket.nu_codi_ticket} style={index % 2 !== 0 ? styles.trOdd : undefined}>
                  <td style={styles.td}>{index + 1}</td>
                  <td style={styles.td}>{ticket.ch_seri_tckt || '-'}-{ticket.ch_nume_tckt || ticket.nu_codi_ticket}</td>
                  <td style={styles.td}>{formatDateTime(ticket.dt_fech_emision)}</td>
                  <td style={styles.td}>{ticket.vehiculo_placa || '-'}</td>
                  <td style={styles.td}>{ticket.ch_codi_cajero || '-'}</td>
                  <td style={styles.td}>{ticket.ch_codi_turno_caja || '-'}</td>
                  <td style={styles.td}>{formatDateTime(ticket.dt_fech_ingreso)}</td>
                  <td style={styles.td}>{formatDateTime(ticket.dt_fech_salida)}</td>
                  <td style={{ ...styles.td, ...styles.amountCell }}>{formatMoney(ticket.nu_impo_total)}</td>
                  <td style={{ ...styles.td, ...styles.amountCell, ...styles.saldoCell }}>{formatMoney(ticket.nu_impo_saldo)}</td>
                  <td style={{ ...styles.td, ...styles.checkboxCell }}>
                    <input
                      type="checkbox"
                      checked={false}
                      disabled={cancelingId === ticket.nu_codi_ticket}
                      onChange={() => handleCancelarTicket(ticket)}
                    />
                  </td>
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
  return <div style={{ ...styles.metricCard, ...(highlight ? styles.metricCardHighlight : {}) }}><span style={{ ...styles.metricLabel, ...(highlight ? styles.metricLabelHighlight : {}) }}>{label}</span><strong style={{ ...styles.metricValue, ...(highlight ? styles.metricValueHighlight : {}) }}>{value}</strong></div>;
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
  btnPrimary: { padding: '10px 18px', border: 'none', borderRadius: theme.radius.sm, background: theme.colors.brand, color: '#fff', fontWeight: 700, cursor: 'pointer', boxShadow: theme.shadow.soft },
  metricsGrid: { display: 'grid', gridTemplateColumns: 'repeat(2, minmax(0, 1fr))', gap: 12 },
  metricCard: { background: theme.colors.panel, borderRadius: theme.radius.md, border: `1px solid ${theme.colors.border}`, boxShadow: theme.shadow.card, padding: '16px 18px', display: 'flex', flexDirection: 'column', gap: 6 },
  metricCardHighlight: { background: '#fff7ed', borderColor: '#fed7aa' },
  metricLabel: { color: theme.colors.textMuted, fontSize: theme.typography.small, textTransform: 'uppercase', letterSpacing: 0.8, fontWeight: 700 },
  metricLabelHighlight: { color: theme.colors.warning },
  metricValue: { color: theme.colors.text, fontSize: 24, fontWeight: 800 },
  metricValueHighlight: { color: theme.colors.warning },
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
  amountCell: { textAlign: 'right', fontWeight: 700 },
  saldoCell: { color: theme.colors.warning },
  checkboxCell: { textAlign: 'center' },
  empty: { textAlign: 'center', padding: 28, color: theme.colors.textMuted },
};

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

const conditionLabel = (value) => {
  if (value === '1') return 'Credito';
  if (value === '0') return 'Contado';
  return value || '-';
};

const statusLabel = (value) => {
  if (value === '1') return 'Salida';
  if (value === '0') return 'Pendiente';
  return value || '-';
};

export default function TicketSalida() {
  const [tickets, setTickets] = useState([]);
  const [clientes, setClientes] = useState([]);
  const [garitas, setGaritas] = useState([]);
  const [tiposVehiculo, setTiposVehiculo] = useState([]);
  const [incidentes, setIncidentes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filtros, setFiltros] = useState({
    fecha_desde: '',
    fecha_hasta: '',
    turno: '',
    cliente: '',
    garita: '',
    vehiculo: '',
    cajero: '',
    tipo_vehiculo: '',
    incidente: '',
    descuento: '',
  });

  const fetchData = async () => {
    setLoading(true);
    try {
      const [tRes, cRes, gRes, tvRes, iRes] = await Promise.all([
        api.get('/movimientos/tickets/?page_size=500&ch_esta_ticket=1&ch_esta_activo=1'),
        api.get('/maestros/clientes/?page_size=300'),
        api.get('/maestros/garitas/?page_size=100'),
        api.get('/maestros/tipo-vehiculos/?page_size=100'),
        api.get('/maestros/tipo-incidentes/?page_size=100'),
      ]);

      setTickets(normalizeList(tRes.data));
      setClientes(normalizeList(cRes.data));
      setGaritas(normalizeList(gRes.data));
      setTiposVehiculo(normalizeList(tvRes.data));
      setIncidentes(normalizeList(iRes.data));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const rows = useMemo(() => {
    const desde = filtros.fecha_desde ? new Date(`${filtros.fecha_desde}T00:00:00`) : null;
    const hasta = filtros.fecha_hasta ? new Date(`${filtros.fecha_hasta}T23:59:59`) : null;

    return tickets
      .filter((row) => {
        const fecha = row.dt_fech_salida ? new Date(row.dt_fech_salida) : null;
        if (desde && (!fecha || fecha < desde)) return false;
        if (hasta && (!fecha || fecha > hasta)) return false;
        if (filtros.turno && row.ch_codi_turno_caja !== filtros.turno) return false;
        if (filtros.cliente && String(row.ch_codi_cliente || '') !== filtros.cliente) return false;
        if (filtros.garita && String(row.ch_codi_garita || '') !== filtros.garita) return false;
        if (filtros.vehiculo && !String(row.vehiculo_placa || '').toLowerCase().includes(filtros.vehiculo.toLowerCase())) return false;
        if (filtros.cajero && !String(row.ch_codi_cajero || '').toLowerCase().includes(filtros.cajero.toLowerCase())) return false;
        if (filtros.tipo_vehiculo && String(row.ch_tipo_vehiculo || '') !== filtros.tipo_vehiculo) return false;
        if (filtros.incidente && String(row.ch_codi_tipo_incidente || '') !== filtros.incidente) return false;
        if (filtros.descuento === 'con' && !(Number(row.nu_impo_dscto || 0) > 0 || row.vc_desc_dscto)) return false;
        if (filtros.descuento === 'sin' && (Number(row.nu_impo_dscto || 0) > 0 || row.vc_desc_dscto)) return false;
        return true;
      })
      .sort((a, b) => new Date(b.dt_fech_salida || 0) - new Date(a.dt_fech_salida || 0));
  }, [tickets, filtros]);

  const totalMonto = useMemo(() => rows.reduce((sum, row) => sum + Number(row.nu_impo_total || 0), 0), [rows]);
  const conIncidente = useMemo(() => rows.filter((row) => row.incidente_desc).length, [rows]);

  return (
    <div style={styles.page}>
      <section style={styles.heroCard}>
        <div>
          <p style={styles.eyebrow}>Reporte operativo</p>
          <h1 style={styles.title}>Lista de ticket de salida</h1>
          <p style={styles.subtitle}>Consulta tickets cerrados por fecha, turno, cliente, vehiculo, cajero, incidente y descuento.</p>
        </div>

        <div style={styles.filtersGrid}>
          <FilterField label="Fecha desde"><input type="date" style={styles.input} value={filtros.fecha_desde} onChange={(e) => setFiltros((p) => ({ ...p, fecha_desde: e.target.value }))} /></FilterField>
          <FilterField label="Fecha hasta"><input type="date" style={styles.input} value={filtros.fecha_hasta} onChange={(e) => setFiltros((p) => ({ ...p, fecha_hasta: e.target.value }))} /></FilterField>
          <FilterField label="Turno"><input type="text" style={styles.input} value={filtros.turno} onChange={(e) => setFiltros((p) => ({ ...p, turno: e.target.value }))} placeholder="Ej: T1" /></FilterField>
          <FilterField label="Cliente">
            <select style={styles.input} value={filtros.cliente} onChange={(e) => setFiltros((p) => ({ ...p, cliente: e.target.value }))}>
              <option value="">Todos</option>
              {clientes.map((cliente) => <option key={cliente.ch_codi_cliente} value={cliente.ch_codi_cliente}>{cliente.vc_razo_soci_cliente}</option>)}
            </select>
          </FilterField>
          <FilterField label="Garita">
            <select style={styles.input} value={filtros.garita} onChange={(e) => setFiltros((p) => ({ ...p, garita: e.target.value }))}>
              <option value="">Todas</option>
              {garitas.map((garita) => <option key={garita.ch_codi_garita} value={garita.ch_codi_garita}>{garita.vc_desc_garita}</option>)}
            </select>
          </FilterField>
          <FilterField label="Vehiculo"><input type="text" style={styles.input} value={filtros.vehiculo} onChange={(e) => setFiltros((p) => ({ ...p, vehiculo: e.target.value }))} placeholder="Placa" /></FilterField>
          <FilterField label="Cajero"><input type="text" style={styles.input} value={filtros.cajero} onChange={(e) => setFiltros((p) => ({ ...p, cajero: e.target.value }))} placeholder="Codigo cajero" /></FilterField>
          <FilterField label="Tipo de vehiculo">
            <select style={styles.input} value={filtros.tipo_vehiculo} onChange={(e) => setFiltros((p) => ({ ...p, tipo_vehiculo: e.target.value }))}>
              <option value="">Todos</option>
              {tiposVehiculo.map((tipo) => <option key={tipo.ch_tipo_vehiculo} value={tipo.ch_tipo_vehiculo}>{tipo.vc_desc_tipo_vehiculo}</option>)}
            </select>
          </FilterField>
          <FilterField label="Incidente">
            <select style={styles.input} value={filtros.incidente} onChange={(e) => setFiltros((p) => ({ ...p, incidente: e.target.value }))}>
              <option value="">Todos</option>
              {incidentes.map((incidente) => <option key={incidente.ch_codi_tipo_incidente} value={incidente.ch_codi_tipo_incidente}>{incidente.vc_desc_tipo_incidente}</option>)}
            </select>
          </FilterField>
          <FilterField label="Descuento">
            <select style={styles.input} value={filtros.descuento} onChange={(e) => setFiltros((p) => ({ ...p, descuento: e.target.value }))}>
              <option value="">Todos</option>
              <option value="con">Con descuento</option>
              <option value="sin">Sin descuento</option>
            </select>
          </FilterField>
        </div>

        <div style={styles.actionsRow}>
          <div style={styles.metricsRow}>
            <MetricCard label="Tickets" value={String(rows.length)} />
            <MetricCard label="Con incidente" value={String(conIncidente)} />
            <MetricCard label="Total monto" value={formatMoney(totalMonto)} highlight />
          </div>
          <button style={styles.btnPrimary} type="button" onClick={fetchData} disabled={loading}>{loading ? 'Actualizando...' : 'Actualizar'}</button>
        </div>
      </section>

      <section style={styles.tableCard}>
        <div style={styles.tableHeader}>
          <div>
            <h2 style={styles.tableTitle}>Detalle de tickets de salida</h2>
            <p style={styles.tableSubtitle}>Vista completa para control operativo y revision de descuentos o incidentes.</p>
          </div>
          <span style={styles.counter}>{rows.length} registro(s)</span>
        </div>

        <div style={styles.tableWrapper}>
          <table style={styles.table}>
            <thead>
              <tr>
                <th style={styles.th}>N° de serie</th>
                <th style={styles.th}>Numero</th>
                <th style={styles.th}>Fecha</th>
                <th style={styles.th}>Turno</th>
                <th style={styles.th}>Cliente</th>
                <th style={styles.th}>Chofer</th>
                <th style={styles.th}>Ingreso</th>
                <th style={styles.th}>Salida</th>
                <th style={styles.th}>Cond.</th>
                <th style={styles.th}>Monto</th>
                <th style={styles.th}>Estado</th>
                <th style={styles.th}>Incidente</th>
                <th style={styles.th}>Descuento</th>
              </tr>
            </thead>
            <tbody>
              {loading && <tr><td colSpan={13} style={styles.empty}>Cargando tickets...</td></tr>}
              {!loading && rows.length === 0 && <tr><td colSpan={13} style={styles.empty}>No hay tickets para los filtros seleccionados.</td></tr>}
              {!loading && rows.map((row, index) => (
                <tr key={row.nu_codi_ticket} style={index % 2 !== 0 ? styles.trOdd : undefined}>
                  <td style={styles.td}>{row.ch_seri_tckt || '-'}</td>
                  <td style={styles.td}>{row.ch_nume_tckt || '-'}</td>
                  <td style={styles.td}>{formatDateTime(row.dt_fech_emision || row.dt_fech_salida)}</td>
                  <td style={styles.td}>{row.ch_codi_turno_caja || '-'}</td>
                  <td style={styles.td}>{row.cliente_desc || '-'}</td>
                  <td style={styles.td}>{row.chofer_desc || '-'}</td>
                  <td style={styles.td}>{formatDateTime(row.dt_fech_ingreso)}</td>
                  <td style={styles.td}>{formatDateTime(row.dt_fech_salida)}</td>
                  <td style={styles.td}>{conditionLabel(row.ch_esta_condicion)}</td>
                  <td style={{ ...styles.td, ...styles.amountCell }}>{formatMoney(row.nu_impo_total)}</td>
                  <td style={styles.td}>{statusLabel(row.ch_esta_ticket)}</td>
                  <td style={styles.td}>{row.incidente_desc || '-'}</td>
                  <td style={{ ...styles.td, ...styles.amountCell }}>{Number(row.nu_impo_dscto || 0) > 0 ? formatMoney(row.nu_impo_dscto) : row.vc_desc_dscto || '-'}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>
    </div>
  );
}

function FilterField({ label, children }) {
  return <div style={styles.filterItem}><label style={styles.label}>{label}</label>{children}</div>;
}

function MetricCard({ label, value, highlight = false }) {
  return <div style={{ ...styles.metricCard, ...(highlight ? styles.metricCardHighlight : {}) }}><span style={{ ...styles.metricLabel, ...(highlight ? styles.metricLabelHighlight : {}) }}>{label}</span><strong style={{ ...styles.metricValue, ...(highlight ? styles.metricValueHighlight : {}) }}>{value}</strong></div>;
}

const styles = {
  page: { display: 'flex', flexDirection: 'column', gap: 18 },
  heroCard: { background: theme.colors.panel, borderRadius: theme.radius.lg, border: `1px solid ${theme.colors.border}`, boxShadow: theme.shadow.card, padding: 22, display: 'flex', flexDirection: 'column', gap: 18 },
  eyebrow: { margin: 0, color: theme.colors.textSoft, fontSize: theme.typography.small, textTransform: 'uppercase', letterSpacing: 1, fontWeight: 800 },
  title: { margin: '6px 0 0', fontSize: 26, fontWeight: 900, color: theme.colors.text },
  subtitle: { margin: '8px 0 0', fontSize: theme.typography.body, color: theme.colors.textMuted, maxWidth: 760 },
  filtersGrid: { display: 'grid', gridTemplateColumns: 'repeat(5, minmax(0, 1fr))', gap: 12 },
  filterItem: { display: 'flex', flexDirection: 'column', gap: 6 },
  label: { fontSize: theme.typography.label, fontWeight: 700, color: theme.colors.textMuted },
  input: { width: '100%', boxSizing: 'border-box', padding: '10px 12px', border: `1px solid ${theme.colors.borderStrong}`, borderRadius: theme.radius.sm, fontSize: theme.typography.body, background: theme.colors.panel, color: theme.colors.text, outline: 'none' },
  actionsRow: { display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 12, flexWrap: 'wrap' },
  metricsRow: { display: 'grid', gridTemplateColumns: 'repeat(3, minmax(140px, 1fr))', gap: 12, flex: 1 },
  metricCard: { background: theme.colors.panelMuted, border: `1px solid ${theme.colors.border}`, borderRadius: theme.radius.md, padding: '14px 16px', display: 'flex', flexDirection: 'column', gap: 6 },
  metricCardHighlight: { background: theme.colors.brandTint, borderColor: '#bfdbfe' },
  metricLabel: { color: theme.colors.textMuted, fontSize: theme.typography.small, textTransform: 'uppercase', letterSpacing: 0.8, fontWeight: 700 },
  metricLabelHighlight: { color: theme.colors.brandDark },
  metricValue: { color: theme.colors.text, fontSize: 24, fontWeight: 800 },
  metricValueHighlight: { color: theme.colors.brandDark },
  btnPrimary: { padding: '10px 18px', background: theme.colors.brand, color: '#fff', border: 'none', borderRadius: theme.radius.sm, cursor: 'pointer', fontWeight: 700, boxShadow: theme.shadow.soft },
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
  empty: { textAlign: 'center', padding: 28, color: theme.colors.textMuted },
};

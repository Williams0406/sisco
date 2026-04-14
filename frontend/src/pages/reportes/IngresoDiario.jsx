import { useEffect, useMemo, useState } from 'react';
import api from '../../api/axios';
import { theme } from '../../styles/tokens';

const formatDate = (value) => {
  if (!value) return '-';
  const date = new Date(value);
  return Number.isNaN(date.getTime()) ? '-' : date.toLocaleDateString('es-PE');
};

const formatMoney = (value) => {
  const amount = Number(value);
  return Number.isFinite(amount) ? `S/ ${amount.toFixed(2)}` : 'S/ 0.00';
};

const normalizeList = (payload) => payload?.results || payload || [];

export default function IngresoDiario() {
  const hoy = new Date().toISOString().split('T')[0];
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [fechaDesde, setFechaDesde] = useState(hoy);
  const [fechaHasta, setFechaHasta] = useState(hoy);

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await api.get('/movimientos/cierres-turno/?page_size=500&ch_esta_activo=1');
      setData(normalizeList(res.data));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const cierres = useMemo(() => {
    const desde = fechaDesde ? new Date(`${fechaDesde}T00:00:00`) : null;
    const hasta = fechaHasta ? new Date(`${fechaHasta}T23:59:59`) : null;

    return data
      .filter((item) => {
        if (!desde && !hasta) return true;
        const fecha = item.dt_fech_turno ? new Date(item.dt_fech_turno) : null;
        if (!fecha || Number.isNaN(fecha.getTime())) return false;
        if (desde && fecha < desde) return false;
        if (hasta && fecha > hasta) return false;
        return true;
      })
      .sort((a, b) => new Date(b.dt_fech_turno || 0) - new Date(a.dt_fech_turno || 0));
  }, [data, fechaDesde, fechaHasta]);

  const metrics = useMemo(() => {
    const totals = cierres.reduce(
      (acc, row) => {
        const margen = Number(row.nu_impo_util_turno ?? (Number(row.nu_impo_tota_ingr || 0) - Number(row.nu_impo_egre || 0)));
        acc.totalIngresos += Number(row.nu_impo_tota_ingr || 0);
        acc.totalEgresos += Number(row.nu_impo_egre || 0);
        acc.totalMargen += margen;
        acc.totalTickets += Number(row.nu_impo_total || 0);
        return acc;
      },
      { totalIngresos: 0, totalEgresos: 0, totalMargen: 0, totalTickets: 0 },
    );

    return totals;
  }, [cierres]);

  return (
    <div style={styles.page}>
      <section style={styles.heroCard}>
        <div>
          <p style={styles.eyebrow}>Reporte operativo</p>
          <h1 style={styles.title}>Cierre diario</h1>
          <p style={styles.subtitle}>
            Consulta de cierres por rango de fechas con foco en ingresos, egresos y margen diario.
          </p>
        </div>

        <div style={styles.filterBar}>
          <FilterField label="Desde" value={fechaDesde} onChange={setFechaDesde} />
          <FilterField label="Hasta" value={fechaHasta} onChange={setFechaHasta} />
          <button style={styles.btnPrimary} type="button" onClick={fetchData} disabled={loading}>
            {loading ? 'Consultando...' : 'Actualizar'}
          </button>
        </div>
      </section>

      <section style={styles.metricsGrid}>
        <MetricCard label="Cierres" value={String(cierres.length)} />
        <MetricCard label="Total ticket" value={formatMoney(metrics.totalTickets)} />
        <MetricCard label="Total ingreso" value={formatMoney(metrics.totalIngresos)} highlight="blue" />
        <MetricCard label="Margen" value={formatMoney(metrics.totalMargen)} highlight={metrics.totalMargen >= 0 ? 'green' : 'red'} />
      </section>

      <section style={styles.tableCard}>
        <div style={styles.tableHeader}>
          <div>
            <h2 style={styles.tableTitle}>Detalle del cierre</h2>
            <p style={styles.tableSubtitle}>La tabla conserva el detalle completo para validacion operativa.</p>
          </div>
          <span style={styles.counter}>{cierres.length} registro(s)</span>
        </div>

        <div style={styles.tableWrapper}>
          <table style={styles.table}>
            <thead>
              <tr>
                <th style={styles.th}>Fecha</th>
                <th style={styles.th}>Turno</th>
                <th style={styles.th}>N° de serie</th>
                <th style={styles.th}>Numero</th>
                <th style={styles.th}>Cajero</th>
                <th style={styles.th}>Efectivo</th>
                <th style={styles.th}>Credito</th>
                <th style={styles.th}>Total ticket</th>
                <th style={styles.th}>Cobranza</th>
                <th style={styles.th}>Otro ingreso</th>
                <th style={styles.th}>Total ingreso</th>
                <th style={styles.th}>Egreso</th>
                <th style={styles.th}>Margen</th>
              </tr>
            </thead>
            <tbody>
              {loading && (
                <tr>
                  <td colSpan={13} style={styles.empty}>
                    Cargando cierre diario...
                  </td>
                </tr>
              )}
              {!loading && cierres.length === 0 && (
                <tr>
                  <td colSpan={13} style={styles.empty}>
                    No hay cierres para el rango seleccionado.
                  </td>
                </tr>
              )}
              {!loading &&
                cierres.map((row, index) => {
                  const margen =
                    row.nu_impo_util_turno ?? (Number(row.nu_impo_tota_ingr || 0) - Number(row.nu_impo_egre || 0));

                  return (
                    <tr key={row.nu_codi_cierre || index} style={index % 2 !== 0 ? styles.trOdd : undefined}>
                      <td style={styles.td}>{formatDate(row.dt_fech_turno)}</td>
                      <td style={styles.td}>{row.ch_codi_turno_caja || '-'}</td>
                      <td style={styles.td}>{row.ch_seri_cierre || '-'}</td>
                      <td style={styles.td}>{row.ch_nume_cierre || '-'}</td>
                      <td style={styles.td}>{row.ch_codi_cajero || '-'}</td>
                      <td style={{ ...styles.td, ...styles.amountCell }}>{formatMoney(row.nu_impo_tota_efectivo)}</td>
                      <td style={{ ...styles.td, ...styles.amountCell }}>{formatMoney(row.nu_impo_tota_credito)}</td>
                      <td style={{ ...styles.td, ...styles.amountCell }}>{formatMoney(row.nu_impo_total)}</td>
                      <td style={{ ...styles.td, ...styles.amountCell }}>{formatMoney(row.nu_impo_cobr_cred)}</td>
                      <td style={{ ...styles.td, ...styles.amountCell }}>{formatMoney(row.nu_impo_otro_ingr)}</td>
                      <td style={{ ...styles.td, ...styles.amountCell }}>{formatMoney(row.nu_impo_tota_ingr)}</td>
                      <td style={{ ...styles.td, ...styles.amountCell }}>{formatMoney(row.nu_impo_egre)}</td>
                      <td
                        style={{
                          ...styles.td,
                          ...styles.amountCell,
                          ...(Number(margen || 0) >= 0 ? styles.amountPositive : styles.amountNegative),
                        }}
                      >
                        {formatMoney(margen)}
                      </td>
                    </tr>
                  );
                })}
            </tbody>
          </table>
        </div>
      </section>
    </div>
  );
}

function FilterField({ label, value, onChange }) {
  return (
    <div style={styles.filterGroup}>
      <label style={styles.label}>{label}</label>
      <input type="date" style={styles.input} value={value} onChange={(e) => onChange(e.target.value)} />
    </div>
  );
}

function MetricCard({ label, value, highlight }) {
  const highlightStyles = {
    blue: styles.metricCardBlue,
    green: styles.metricCardGreen,
    red: styles.metricCardRed,
  };

  return (
    <div style={{ ...styles.metricCard, ...(highlight ? highlightStyles[highlight] : {}) }}>
      <span style={styles.metricLabel}>{label}</span>
      <strong style={styles.metricValue}>{value}</strong>
    </div>
  );
}

const styles = {
  page: {
    display: 'flex',
    flexDirection: 'column',
    gap: 18,
  },
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
  eyebrow: {
    margin: 0,
    color: theme.colors.textSoft,
    fontSize: theme.typography.small,
    textTransform: 'uppercase',
    letterSpacing: 1,
    fontWeight: 800,
  },
  title: {
    margin: '6px 0 0',
    fontSize: 26,
    fontWeight: 900,
    color: theme.colors.text,
  },
  subtitle: {
    margin: '8px 0 0',
    fontSize: theme.typography.body,
    color: theme.colors.textMuted,
    maxWidth: 640,
  },
  filterBar: {
    display: 'flex',
    gap: 12,
    alignItems: 'flex-end',
    flexWrap: 'wrap',
  },
  filterGroup: {
    display: 'flex',
    flexDirection: 'column',
    gap: 6,
  },
  label: {
    fontSize: theme.typography.label,
    fontWeight: 700,
    color: theme.colors.textMuted,
  },
  input: {
    minWidth: 150,
    padding: '10px 12px',
    border: `1px solid ${theme.colors.borderStrong}`,
    borderRadius: theme.radius.sm,
    fontSize: theme.typography.body,
    background: theme.colors.panel,
    color: theme.colors.text,
    outline: 'none',
  },
  btnPrimary: {
    background: theme.colors.brand,
    color: '#fff',
    border: 'none',
    padding: '10px 18px',
    borderRadius: theme.radius.sm,
    cursor: 'pointer',
    fontWeight: 700,
    boxShadow: theme.shadow.soft,
  },
  metricsGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(4, minmax(0, 1fr))',
    gap: 12,
  },
  metricCard: {
    background: theme.colors.panel,
    borderRadius: theme.radius.md,
    border: `1px solid ${theme.colors.border}`,
    boxShadow: theme.shadow.card,
    padding: '16px 18px',
    display: 'flex',
    flexDirection: 'column',
    gap: 6,
  },
  metricCardBlue: {
    background: theme.colors.brandTint,
    borderColor: '#bfdbfe',
  },
  metricCardGreen: {
    background: theme.colors.successTint,
    borderColor: '#bbf7d0',
  },
  metricCardRed: {
    background: theme.colors.dangerTint,
    borderColor: '#fecaca',
  },
  metricLabel: {
    color: theme.colors.textMuted,
    fontSize: theme.typography.small,
    textTransform: 'uppercase',
    letterSpacing: 0.8,
    fontWeight: 700,
  },
  metricValue: {
    color: theme.colors.text,
    fontSize: 24,
    fontWeight: 800,
  },
  tableCard: {
    background: theme.colors.panel,
    borderRadius: theme.radius.lg,
    border: `1px solid ${theme.colors.border}`,
    boxShadow: theme.shadow.card,
    padding: 20,
  },
  tableHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    gap: 12,
    marginBottom: 16,
  },
  tableTitle: {
    margin: 0,
    fontSize: 20,
    color: theme.colors.text,
    fontWeight: 800,
  },
  tableSubtitle: {
    margin: '6px 0 0',
    color: theme.colors.textMuted,
    fontSize: theme.typography.body,
  },
  counter: {
    background: theme.colors.panelMuted,
    color: theme.colors.textMuted,
    border: `1px solid ${theme.colors.border}`,
    padding: '8px 12px',
    borderRadius: theme.radius.pill,
    fontSize: theme.typography.small,
    fontWeight: 700,
    whiteSpace: 'nowrap',
  },
  tableWrapper: {
    overflow: 'auto',
    border: `1px solid ${theme.colors.border}`,
    borderRadius: theme.radius.md,
  },
  table: {
    width: '100%',
    borderCollapse: 'collapse',
    fontSize: theme.typography.body,
  },
  th: {
    background: theme.colors.panelMuted,
    padding: '12px 14px',
    textAlign: 'left',
    borderBottom: `1px solid ${theme.colors.border}`,
    color: theme.colors.textMuted,
    fontWeight: 700,
    whiteSpace: 'nowrap',
    textTransform: 'uppercase',
    letterSpacing: 0.4,
    fontSize: theme.typography.small,
  },
  td: {
    padding: '12px 14px',
    borderBottom: '1px solid #edf2f7',
    color: theme.colors.text,
    whiteSpace: 'nowrap',
  },
  trOdd: {
    background: '#fbfdff',
  },
  amountCell: {
    textAlign: 'right',
    fontWeight: 700,
  },
  amountPositive: {
    color: theme.colors.success,
  },
  amountNegative: {
    color: theme.colors.danger,
  },
  empty: {
    textAlign: 'center',
    padding: 28,
    color: theme.colors.textMuted,
  },
};

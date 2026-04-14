import { useEffect, useMemo, useState } from 'react';
import api from '../../api/axios';

const formatDate = (value) => {
  if (!value) return '—';
  const date = new Date(value);
  return Number.isNaN(date.getTime())
    ? '—'
    : date.toLocaleDateString('es-PE');
};

const formatDateTime = (value) => {
  if (!value) return '—';
  const date = new Date(value);
  return Number.isNaN(date.getTime())
    ? '—'
    : date.toLocaleString('es-PE');
};

const formatMoney = (value) => {
  const amount = Number(value);
  return Number.isFinite(amount)
    ? `S/ ${amount.toFixed(2)}`
    : 'S/ 0.00';
};

const normalizeList = (payload) => payload?.results || payload || [];

export default function CobranzaCredito() {
  const [cobranzas, setCobranzas] = useState([]);
  const [detallesCobranza, setDetallesCobranza] = useState([]);
  const [loading, setLoading] = useState(true);
  const [fechaDesde, setFechaDesde] = useState('');
  const [fechaHasta, setFechaHasta] = useState('');
  const [selectedId, setSelectedId] = useState(null);

  const fetchData = async () => {
    setLoading(true);
    try {
      const [cobrRes, detRes] = await Promise.all([
        api.get('/movimientos/cobranza-credito/?page_size=500'),
        api.get('/movimientos/det-cobranza/?page_size=1000'),
      ]);

      setCobranzas(normalizeList(cobrRes.data));
      setDetallesCobranza(normalizeList(detRes.data));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const cobranzasMap = useMemo(() => {
    const map = new Map();
    cobranzas.forEach((item) => {
      map.set(item.nu_codi_cobr_cred, item);
    });
    return map;
  }, [cobranzas]);

  const deudas = useMemo(() => {
    const desde = fechaDesde ? new Date(`${fechaDesde}T00:00:00`) : null;
    const hasta = fechaHasta ? new Date(`${fechaHasta}T23:59:59`) : null;

    return cobranzas
      .filter((item) => item.ch_esta_activo === '1' || item.ch_esta_activo == null)
      .filter((item) => item.ch_codi_cliente)
      .filter((item) => {
        if (!desde && !hasta) return true;
        const fecha = item.dt_fech_cobr ? new Date(item.dt_fech_cobr) : null;
        if (!fecha || Number.isNaN(fecha.getTime())) return false;
        if (desde && fecha < desde) return false;
        if (hasta && fecha > hasta) return false;
        return true;
      })
      .map((item) => {
        const total = Number(item.nu_impo_total || 0);
        const saldo = Number(item.nu_impo_total || 0);

        return {
          id: item.nu_codi_cobr_cred,
          codigo: item.nu_codi_cobr_cred,
          fecha: item.dt_fech_cobr,
          cliente: item.cliente_desc || item.vc_desc_cliente || '—',
          serie: item.ch_seri_cobr || '—',
          numero: item.ch_nume_cobr || '—',
          total,
          saldo,
          raw: item,
        };
      })
      .sort((a, b) => new Date(b.fecha || 0) - new Date(a.fecha || 0));
  }, [cobranzas, fechaDesde, fechaHasta]);

  useEffect(() => {
    if (!deudas.length) {
      setSelectedId(null);
      return;
    }

    if (!selectedId || !deudas.some((item) => item.id === selectedId)) {
      setSelectedId(deudas[0].id);
    }
  }, [deudas, selectedId]);

  const selectedDeuda = deudas.find((item) => item.id === selectedId) || null;

  const abonosSeleccionados = useMemo(() => {
    if (!selectedDeuda) return [];

    return detallesCobranza
      .filter((detalle) => detalle.ch_esta_activo === '1' || detalle.ch_esta_activo == null)
      .filter((detalle) => detalle.nu_codi_cobr_cred === selectedDeuda.id)
      .map((detalle) => {
        const cobranza = cobranzasMap.get(detalle.nu_codi_cobr_cred);
        return {
          id: `${detalle.nu_codi_cobr_cred}-${detalle.nu_codi_detalle}`,
          codigoCobranza: detalle.nu_codi_cobr_cred,
          fecha: cobranza?.dt_fech_cobr,
          serie: cobranza?.ch_seri_cobr || '—',
          numero: cobranza?.ch_nume_cobr || '—',
          importe: Number(detalle.nu_impo_cobr || 0),
          importeOriginal: Number(detalle.nu_impo_original || 0),
          ticketSerie: detalle.ticket_serie || detalle.ch_seri_tckt || '—',
          ticketNumero: detalle.ticket_numero || detalle.ch_nume_tckt || '—',
          observacion: cobranza?.vc_obse_cobr || '',
        };
      })
      .sort((a, b) => new Date(b.fecha || 0) - new Date(a.fecha || 0));
  }, [selectedDeuda, detallesCobranza, cobranzasMap]);

  return (
    <div style={styles.page}>
      <div style={styles.leftPanel}>
        <div style={styles.panelHeader}>
          <div>
            <h2 style={styles.panelTitle}>Cobranzas a credito</h2>
            <p style={styles.panelSubtitle}>
              Visualiza las cabeceras de cobranza a credito y sus tickets asociados.
            </p>
          </div>
          <div style={styles.counterCard}>
            <span style={styles.counterValue}>{deudas.length}</span>
            <span style={styles.counterLabel}>Cobranzas</span>
          </div>
        </div>

        <div style={styles.filters}>
          <div style={styles.filterGroup}>
            <label style={styles.label}>Desde</label>
            <input
              type="date"
              style={styles.input}
              value={fechaDesde}
              onChange={(e) => setFechaDesde(e.target.value)}
            />
          </div>
          <div style={styles.filterGroup}>
            <label style={styles.label}>Hasta</label>
            <input
              type="date"
              style={styles.input}
              value={fechaHasta}
              onChange={(e) => setFechaHasta(e.target.value)}
            />
          </div>
          <button style={styles.btnBuscar} onClick={fetchData}>
            Buscar
          </button>
        </div>

        <div style={styles.tableWrapper}>
          <table style={styles.table}>
            <thead>
              <tr>
                <th style={styles.th}>Código</th>
                <th style={styles.th}>Fecha</th>
                <th style={styles.th}>Cliente</th>
                <th style={styles.th}>Serie</th>
                <th style={styles.th}>Número</th>
                <th style={styles.th}>Total</th>
              </tr>
            </thead>
            <tbody>
              {loading && (
                <tr>
                  <td colSpan={6} style={styles.empty}>
                    Cargando cobranzas...
                  </td>
                </tr>
              )}
              {!loading && deudas.length === 0 && (
                <tr>
                  <td colSpan={6} style={styles.empty}>
                    No se encontraron cobranzas para los filtros seleccionados.
                  </td>
                </tr>
              )}
              {!loading && deudas.map((deuda, index) => {
                const selected = deuda.id === selectedId;
                return (
                  <tr
                    key={deuda.id}
                    onClick={() => setSelectedId(deuda.id)}
                    style={{
                      ...styles.tr,
                      ...(index % 2 !== 0 && !selected ? styles.trOdd : {}),
                      ...(selected ? styles.trSelected : {}),
                    }}
                  >
                    <td style={styles.td}>{deuda.codigo}</td>
                    <td style={styles.td}>{formatDate(deuda.fecha)}</td>
                    <td style={styles.td}>{deuda.cliente}</td>
                    <td style={styles.td}>{deuda.serie}</td>
                    <td style={styles.td}>{deuda.numero}</td>
                    <td style={{ ...styles.td, ...styles.amountCell }}>
                      {formatMoney(deuda.total)}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>

      <div style={styles.rightPanel}>
        {!selectedDeuda ? (
          <div style={styles.placeholder}>
            <p style={styles.placeholderTitle}>Sin selección</p>
            <p style={styles.placeholderText}>
              Haz clic en una cobranza para ver sus datos y el detalle de tickets asociados.
            </p>
          </div>
        ) : (
          <>
            <div style={styles.detailHeader}>
              <div>
                <h3 style={styles.detailTitle}>Detalle de la cobranza</h3>
                <p style={styles.detailSubtitle}>
                  Cobranza #{selectedDeuda.codigo} del cliente {selectedDeuda.cliente}
                </p>
              </div>
              <div style={styles.badge}>
                Total: {formatMoney(selectedDeuda.total)}
              </div>
            </div>

            <div style={styles.detailGrid}>
              <div style={styles.detailCard}>
                <span style={styles.detailLabel}>Código</span>
                <strong style={styles.detailValue}>{selectedDeuda.codigo}</strong>
              </div>
              <div style={styles.detailCard}>
                <span style={styles.detailLabel}>Fecha</span>
                <strong style={styles.detailValue}>{formatDateTime(selectedDeuda.fecha)}</strong>
              </div>
              <div style={styles.detailCard}>
                <span style={styles.detailLabel}>Cliente</span>
                <strong style={styles.detailValue}>{selectedDeuda.cliente}</strong>
              </div>
              <div style={styles.detailCard}>
                <span style={styles.detailLabel}>Serie</span>
                <strong style={styles.detailValue}>{selectedDeuda.serie}</strong>
              </div>
              <div style={styles.detailCard}>
                <span style={styles.detailLabel}>Número</span>
                <strong style={styles.detailValue}>{selectedDeuda.numero}</strong>
              </div>
              <div style={styles.detailCard}>
                <span style={styles.detailLabel}>Total</span>
                <strong style={styles.detailValue}>{formatMoney(selectedDeuda.total)}</strong>
              </div>
            </div>

            <div style={styles.abonosSection}>
              <div style={styles.abonosHeader}>
                <h4 style={styles.abonosTitle}>Detalle de tickets</h4>
                <span style={styles.abonosCount}>{abonosSeleccionados.length} registro(s)</span>
              </div>

              <div style={styles.abonosWrapper}>
                <table style={styles.table}>
                  <thead>
                    <tr>
                      <th style={styles.th}>Cobranza</th>
                      <th style={styles.th}>Fecha</th>
                      <th style={styles.th}>Serie</th>
                      <th style={styles.th}>Número</th>
                      <th style={styles.th}>Ticket</th>
                      <th style={styles.th}>Importe</th>
                    </tr>
                  </thead>
                  <tbody>
                    {abonosSeleccionados.length === 0 && (
                      <tr>
                        <td colSpan={6} style={styles.empty}>
                          Esta cobranza aun no tiene tickets relacionados.
                        </td>
                      </tr>
                    )}
                    {abonosSeleccionados.map((abono, index) => (
                      <tr key={abono.id} style={index % 2 !== 0 ? styles.trOdd : undefined}>
                        <td style={styles.td}>{abono.codigoCobranza}</td>
                        <td style={styles.td}>{formatDateTime(abono.fecha)}</td>
                        <td style={styles.td}>{abono.serie}</td>
                        <td style={styles.td}>{abono.numero}</td>
                        <td style={styles.td}>
                          {abono.ticketSerie}-{abono.ticketNumero}
                        </td>
                        <td style={{ ...styles.td, ...styles.amountCell }}>
                          {formatMoney(abono.importe)}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              {abonosSeleccionados.some((item) => item.observacion) && (
                <div style={styles.notesBox}>
                  <span style={styles.notesLabel}>Observaciones de cobranza</span>
                  {abonosSeleccionados
                    .filter((item) => item.observacion)
                    .map((item) => (
                      <p key={`${item.id}-obs`} style={styles.noteText}>
                        Cobranza {item.codigoCobranza}: {item.observacion}
                      </p>
                    ))}
                </div>
              )}
            </div>
          </>
        )}
      </div>
    </div>
  );
}

const styles = {
  page: {
    display: 'flex',
    gap: 16,
    alignItems: 'flex-start',
  },
  leftPanel: {
    width: '58%',
    background: '#fff',
    borderRadius: 12,
    boxShadow: '0 1px 4px rgba(0,0,0,0.08)',
    padding: 18,
  },
  rightPanel: {
    width: '42%',
    background: '#fff',
    borderRadius: 12,
    boxShadow: '0 1px 4px rgba(0,0,0,0.08)',
    padding: 18,
    minHeight: 500,
  },
  panelHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    gap: 12,
    marginBottom: 16,
  },
  panelTitle: {
    margin: 0,
    fontSize: 20,
    color: '#111827',
  },
  panelSubtitle: {
    margin: '6px 0 0',
    color: '#6b7280',
    fontSize: 13,
  },
  counterCard: {
    minWidth: 90,
    background: '#eff6ff',
    borderRadius: 10,
    padding: '10px 14px',
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
  },
  counterValue: {
    fontSize: 24,
    fontWeight: 700,
    color: '#1d4ed8',
  },
  counterLabel: {
    fontSize: 11,
    color: '#1e3a8a',
    textTransform: 'uppercase',
    letterSpacing: 0.6,
  },
  filters: {
    display: 'flex',
    gap: 12,
    alignItems: 'flex-end',
    marginBottom: 16,
    flexWrap: 'wrap',
  },
  filterGroup: {
    display: 'flex',
    flexDirection: 'column',
    gap: 6,
  },
  label: {
    fontSize: 12,
    fontWeight: 600,
    color: '#374151',
  },
  input: {
    padding: '8px 10px',
    borderRadius: 8,
    border: '1px solid #d1d5db',
    fontSize: 13,
    minWidth: 140,
  },
  btnBuscar: {
    padding: '9px 18px',
    background: '#2563eb',
    color: '#fff',
    border: 'none',
    borderRadius: 8,
    cursor: 'pointer',
    fontWeight: 600,
  },
  tableWrapper: {
    overflow: 'auto',
    maxHeight: 'calc(100vh - 270px)',
    border: '1px solid #e5e7eb',
    borderRadius: 10,
  },
  abonosWrapper: {
    overflow: 'auto',
    border: '1px solid #e5e7eb',
    borderRadius: 10,
  },
  table: {
    width: '100%',
    borderCollapse: 'collapse',
    fontSize: 13,
  },
  th: {
    background: '#f9fafb',
    padding: '10px 12px',
    textAlign: 'left',
    borderBottom: '1px solid #e5e7eb',
    color: '#374151',
    fontWeight: 700,
    position: 'sticky',
    top: 0,
    whiteSpace: 'nowrap',
  },
  td: {
    padding: '10px 12px',
    borderBottom: '1px solid #f3f4f6',
    color: '#4b5563',
    verticalAlign: 'top',
  },
  tr: {
    cursor: 'pointer',
  },
  trOdd: {
    background: '#fafafa',
  },
  trSelected: {
    background: '#dbeafe',
  },
  amountCell: {
    textAlign: 'right',
    fontWeight: 600,
    whiteSpace: 'nowrap',
  },
  empty: {
    textAlign: 'center',
    padding: 24,
    color: '#9ca3af',
  },
  placeholder: {
    minHeight: 420,
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    textAlign: 'center',
    color: '#6b7280',
  },
  placeholderTitle: {
    margin: 0,
    fontSize: 18,
    color: '#111827',
  },
  placeholderText: {
    marginTop: 8,
    lineHeight: 1.6,
    maxWidth: 300,
  },
  detailHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    gap: 12,
    marginBottom: 16,
    borderBottom: '1px solid #e5e7eb',
    paddingBottom: 14,
  },
  detailTitle: {
    margin: 0,
    fontSize: 18,
    color: '#111827',
  },
  detailSubtitle: {
    margin: '5px 0 0',
    fontSize: 13,
    color: '#6b7280',
  },
  badge: {
    background: '#ecfdf5',
    color: '#047857',
    padding: '8px 12px',
    borderRadius: 999,
    fontSize: 12,
    fontWeight: 700,
    whiteSpace: 'nowrap',
  },
  detailGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(2, minmax(0, 1fr))',
    gap: 12,
    marginBottom: 20,
  },
  detailCard: {
    background: '#f9fafb',
    borderRadius: 10,
    padding: '12px 14px',
    display: 'flex',
    flexDirection: 'column',
    gap: 6,
  },
  detailLabel: {
    fontSize: 11,
    color: '#6b7280',
    textTransform: 'uppercase',
    letterSpacing: 0.5,
  },
  detailValue: {
    color: '#111827',
    fontSize: 14,
  },
  abonosSection: {
    display: 'flex',
    flexDirection: 'column',
    gap: 12,
  },
  abonosHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    gap: 12,
  },
  abonosTitle: {
    margin: 0,
    fontSize: 16,
    color: '#111827',
  },
  abonosCount: {
    fontSize: 12,
    color: '#6b7280',
  },
  notesBox: {
    background: '#fff7ed',
    border: '1px solid #fed7aa',
    borderRadius: 10,
    padding: 12,
  },
  notesLabel: {
    display: 'block',
    marginBottom: 8,
    fontSize: 12,
    fontWeight: 700,
    color: '#9a3412',
  },
  noteText: {
    margin: '0 0 6px',
    color: '#7c2d12',
    fontSize: 13,
    lineHeight: 1.5,
  },
};

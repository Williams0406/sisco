import { useEffect, useMemo, useState } from 'react';
import api from '../../api/axios';

const GARITA_LABEL = 'Garita';
const DEFAULT_GARITA_CODE = 'GAR';

const formatDateTimeValue = (value) => {
  if (!value) return '';
  const date = value instanceof Date ? value : new Date(String(value).replace(' ', 'T'));
  if (Number.isNaN(date.getTime())) return '';
  const pad = (part) => String(part).padStart(2, '0');
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}T${pad(date.getHours())}:${pad(date.getMinutes())}`;
};

const formatDateTimeText = (value) => {
  if (!value) return 'Sin fecha';
  const date = value instanceof Date ? value : new Date(String(value).replace(' ', 'T'));
  if (Number.isNaN(date.getTime())) return 'Sin fecha';
  return date.toLocaleString('es-PE', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });
};

const toFriendlyTurno = (value) => {
  if (value === 'dia') return 'Dia';
  if (value === 'noche') return 'Noche';
  return value || 'Pendiente';
};

const toFriendlyTipo = (value) => {
  if (value === 'T') return 'Turno';
  if (value === 'G') return 'General';
  return value || 'Turno';
};

const amountValue = (value) => {
  const parsed = Number(value ?? 0);
  return Number.isFinite(parsed) ? parsed.toFixed(3) : '0.000';
};

const inferTurno = (value, configTurno) => {
  if (!value || !configTurno) return '';
  const date = value instanceof Date ? value : new Date(String(value).replace(' ', 'T'));
  if (Number.isNaN(date.getTime())) return '';

  const minutes = date.getHours() * 60 + date.getMinutes();
  const toMinutes = (timeValue) => {
    const [hours, minutesValue] = String(timeValue || '00:00').split(':').map(Number);
    return ((hours || 0) * 60) + (minutesValue || 0);
  };
  const isWithinRange = (current, start, end) => {
    if (start <= end) return current >= start && current < end;
    return current >= start || current < end;
  };

  const diaStart = toMinutes(configTurno.tm_hora_inicio_dia);
  const diaEnd = toMinutes(configTurno.tm_hora_fin_dia);
  const nocheStart = toMinutes(configTurno.tm_hora_inicio_noche);
  const nocheEnd = toMinutes(configTurno.tm_hora_fin_noche);

  if (isWithinRange(minutes, diaStart, diaEnd)) return 'dia';
  if (isWithinRange(minutes, nocheStart, nocheEnd)) return 'noche';
  return '';
};

const createEmptyForm = () => ({
  nu_codi_cierre: '',
  ch_esta_activo: '1',
  ch_tipo_cierre: 'T',
  dt_fech_turno: '',
  ch_codi_turno_caja: '',
  ch_codi_garita: DEFAULT_GARITA_CODE,
  ch_codi_cajero: '',
  ch_seri_cierre: '',
  ch_nume_cierre: '',
  nu_impo_tota_efectivo: '',
  nu_impo_tota_credito: '',
  nu_impo_total: '',
  nu_impo_cobr_cred: '',
  nu_impo_otro_ingr: '',
  nu_impo_tota_ingr: '',
  nu_impo_egre: '',
  nu_impo_util_turno: '',
  vc_obse_cierre: '',
});

function Icon({ name, size = 18, color = 'currentColor' }) {
  const paths = {
    ledger: 'M6 4.75A2.75 2.75 0 0 1 8.75 2h8.5A2.75 2.75 0 0 1 20 4.75v14.5A2.75 2.75 0 0 1 17.25 22h-8.5A2.75 2.75 0 0 1 6 19.25zM9 7.5h8m-8 4h8m-8 4h5M4 6v12',
    vault: 'M12 3 4.5 6v4.5c0 4.55 2.84 8.86 7.5 10.5 4.66-1.64 7.5-5.95 7.5-10.5V6zM9 10h6m-3-3v6',
    status: 'M12 6.5a5.5 5.5 0 1 0 0 11 5.5 5.5 0 0 0 0-11m0 2.5v3l2 2',
    user: 'M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8m-6.5 7a6.5 6.5 0 0 1 13 0',
    calendar: 'M7 3v3m10-3v3M4.75 7h14.5A1.75 1.75 0 0 1 21 8.75v9.5A1.75 1.75 0 0 1 19.25 20H4.75A1.75 1.75 0 0 1 3 18.25v-9.5A1.75 1.75 0 0 1 4.75 7zM3 10.5h18',
    branch: 'M5 7.5h14M12 7.5v9m-4 0h8',
    spark: 'M12 3.75 14.2 9l5.55.45-4.23 3.63 1.32 5.42L12 15.52 7.16 18.5l1.32-5.42L4.25 9.45 9.8 9z',
    close: 'm7 7 10 10M17 7 7 17',
    save: 'M5 4.75A1.75 1.75 0 0 1 6.75 3h8.88L19 6.37v12.88A1.75 1.75 0 0 1 17.25 21H6.75A1.75 1.75 0 0 1 5 19.25zM8 3v5h6V3m-5 18v-7h6v7',
    ban: 'M7.75 7.75 16.25 16.25M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18',
  };

  return (
    <svg viewBox="0 0 24 24" width={size} height={size} fill="none" style={{ flexShrink: 0 }}>
      <path d={paths[name]} stroke={color} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}

export default function CierreTurno() {
  const [data, setData] = useState([]);
  const [cajeros, setCajeros] = useState([]);
  const [configTurno, setConfigTurno] = useState(null);
  const [loading, setLoading] = useState(true);
  const [selected, setSelected] = useState(null);
  const [saving, setSaving] = useState(false);
  const [isNew, setIsNew] = useState(false);

  const fetchData = async () => {
    setLoading(true);
    try {
      const [cierresRes, cajerosRes, configRes] = await Promise.all([
        api.get('/movimientos/cierres-turno/?page_size=200'),
        api.get('/seguridad/cajeros/'),
        api.get('/movimientos/config-turnos/?page_size=10'),
      ]);
      setData(cierresRes.data.results || cierresRes.data);
      setCajeros(cajerosRes.data || []);
      const configs = configRes.data.results || configRes.data || [];
      setConfigTurno(configs[0] || null);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const syncReadOnlyFields = (draft) => {
    const inferredTurno = inferTurno(draft.dt_fech_turno, configTurno);
    return {
      ...draft,
      ch_tipo_cierre: 'T',
      ch_codi_turno_caja: inferredTurno || draft.ch_codi_turno_caja || '',
    };
  };

  const handleSelectRow = (row) => {
    setSelected(syncReadOnlyFields({ ...row }));
    setIsNew(false);
  };

  const handleNew = () => {
    setSelected(syncReadOnlyFields(createEmptyForm()));
    setIsNew(true);
  };

  const updateSelected = (key, value) => {
    setSelected((prev) => syncReadOnlyFields({ ...prev, [key]: value }));
  };

  const handleSave = async () => {
    if (!selected) return;
    setSaving(true);
    try {
      const payload = syncReadOnlyFields({ ...selected });

      if (isNew) {
        const res = await api.post('/movimientos/cierres-turno/', payload);
        await fetchData();
        setSelected(syncReadOnlyFields(res.data));
        setIsNew(false);
      } else {
        const res = await api.put(`/movimientos/cierres-turno/${selected.nu_codi_cierre}/`, payload);
        await fetchData();
        setSelected(syncReadOnlyFields(res.data));
      }
      alert('Guardado correctamente');
    } catch (err) {
      alert(`Error: ${JSON.stringify(err.response?.data || err.message)}`);
    } finally {
      setSaving(false);
    }
  };

  const handleAnular = async () => {
    if (!selected || !confirm(`Anular cierre #${selected.nu_codi_cierre}?`)) return;
    try {
      await api.patch(`/movimientos/cierres-turno/${selected.nu_codi_cierre}/`, { ch_esta_activo: '0' });
      await fetchData();
      setSelected((prev) => (prev ? { ...prev, ch_esta_activo: '0' } : prev));
    } catch {
      alert('Error al anular');
    }
  };

  const turnoVisible = useMemo(() => toFriendlyTurno(syncReadOnlyFields(selected || createEmptyForm()).ch_codi_turno_caja), [selected, configTurno]);

  const cajeroOptions = useMemo(() => {
    const options = cajeros.map((item) => ({
      value: item.codigo,
      label: `${item.codigo} - ${item.nombre}`,
    }));
    if (selected?.ch_codi_cajero && !options.some((item) => item.value === selected.ch_codi_cajero)) {
      options.unshift({ value: selected.ch_codi_cajero, label: selected.ch_codi_cajero });
    }
    return options;
  }, [cajeros, selected]);

  return (
    <div style={styles.page}>
      <section style={styles.listPanel}>
        <div style={styles.panelTop}>
          <div>
            <div style={styles.eyebrowRow}>
              <Icon name="ledger" size={16} color="#0f4c81" />
              <span style={styles.eyebrow}>Control financiero</span>
            </div>
            <h2 style={styles.leftTitle}>Cierres de caja por turno</h2>
            <p style={styles.leftSubtitle}>Revisa cierres por fecha y turno con una lectura más ejecutiva y clara.</p>
          </div>
          <button style={styles.btnPrimary} type="button" onClick={handleNew}>
            <Icon name="save" size={14} color="#ffffff" />
            Nuevo cierre
          </button>
        </div>

        <div style={styles.tableShell}>
          <table style={styles.table}>
            <thead>
              <tr>
                <th style={{ ...styles.th, width: 90 }}>Codigo</th>
                <th style={{ ...styles.th, width: 180 }}>Fecha</th>
                <th style={{ ...styles.th, width: 100 }}>Turno</th>
                <th style={{ ...styles.th, width: 110 }}>Tipo</th>
              </tr>
            </thead>
            <tbody>
              {loading && (
                <tr>
                  <td colSpan={4} style={styles.empty}>Cargando cierres...</td>
                </tr>
              )}
              {!loading && data.length === 0 && (
                <tr>
                  <td colSpan={4} style={styles.empty}>No hay cierres registrados.</td>
                </tr>
              )}
              {!loading && data.map((row, index) => {
                const selectedRow = selected && !isNew && selected.nu_codi_cierre === row.nu_codi_cierre;
                return (
                  <tr
                    key={row.nu_codi_cierre}
                    onClick={() => handleSelectRow(row)}
                    style={{
                      ...styles.tr,
                      ...(index % 2 !== 0 && !selectedRow ? styles.trOdd : {}),
                      ...(selectedRow ? styles.trSelected : {}),
                    }}
                  >
                    <td style={styles.tdStrong}>{row.nu_codi_cierre || '-'}</td>
                    <td style={styles.td}>{formatDateTimeText(row.dt_fech_turno)}</td>
                    <td style={styles.td}>
                      <span style={{ ...styles.miniBadge, ...styles.miniBadgeBlue }}>{toFriendlyTurno(row.ch_codi_turno_caja)}</span>
                    </td>
                    <td style={styles.td}>{toFriendlyTipo(row.ch_tipo_cierre)}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </section>

      <section style={styles.rightPanel}>
        {!selected ? (
          <div style={styles.placeholder}>
            <div style={styles.placeholderOrb}>
              <Icon name="vault" size={28} color="#0f4c81" />
            </div>
            <h3 style={styles.placeholderTitle}>Selecciona un cierre</h3>
            <p style={styles.placeholderText}>La ficha lateral muestra la posición del turno, caja y totales financieros.</p>
          </div>
        ) : (
          <>
            <div style={styles.detailHeader}>
              <div>
                <div style={styles.eyebrowRow}>
                  <Icon name="status" size={16} color="#0f4c81" />
                  <span style={styles.eyebrow}>Detalle operativo</span>
                </div>
                <h3 style={styles.detailTitle}>{isNew ? 'Nuevo cierre de turno' : `Cierre #${selected.nu_codi_cierre}`}</h3>
                <div style={styles.statusRow}>
                  <span style={{ ...styles.statusBadge, ...(selected.ch_esta_activo === '1' ? styles.statusActive : styles.statusInactive) }}>
                    {selected.ch_esta_activo === '1' ? 'Activo' : 'Anulado'}
                  </span>
                  <span style={{ ...styles.statusBadge, ...styles.statusMuted }}>{turnoVisible}</span>
                </div>
              </div>
              <div style={styles.actionRow}>
                {!isNew && selected.ch_esta_activo === '1' && (
                  <button style={styles.btnDanger} type="button" onClick={handleAnular}>
                    <Icon name="ban" size={14} color="#ffffff" />
                    Anular
                  </button>
                )}
                <button style={styles.btnPrimary} type="button" onClick={handleSave} disabled={saving}>
                  <Icon name="save" size={14} color="#ffffff" />
                  {saving ? 'Guardando...' : 'Guardar'}
                </button>
                <button style={styles.btnGhost} type="button" onClick={() => setSelected(null)}>
                  <Icon name="close" size={14} color="#0f172a" />
                </button>
              </div>
            </div>

            <div style={styles.sectionCard}>
              <SectionTitle icon="calendar" title="Identificacion del cierre" />
              <div style={styles.formGrid}>
                <Field label="Codigo" value={selected.nu_codi_cierre} readOnly />
                <Field
                  label="Fecha de turno"
                  type="datetime-local"
                  value={formatDateTimeValue(selected.dt_fech_turno)}
                  onChange={(value) => updateSelected('dt_fech_turno', value)}
                />
                <Field label="Turno caja" value={turnoVisible} readOnly />
                <Field label="Tipo cierre" value={toFriendlyTipo(selected.ch_tipo_cierre)} readOnly />
                <Field label="Garita" value={GARITA_LABEL} readOnly />
                <FieldSelect
                  label="Cajero"
                  value={selected.ch_codi_cajero || ''}
                  onChange={(value) => updateSelected('ch_codi_cajero', value)}
                  options={cajeroOptions}
                  placeholder="Seleccionar cajero"
                />
                <Field label="Serie" value={selected.ch_seri_cierre} readOnly />
                <Field label="Numero" value={selected.ch_nume_cierre} readOnly />
                <Field
                  label="Estado"
                  type="select"
                  value={selected.ch_esta_activo || '1'}
                  onChange={(value) => updateSelected('ch_esta_activo', value)}
                  options={[
                    { value: '1', label: 'Activo' },
                    { value: '0', label: 'Anulado' },
                  ]}
                />
              </div>
            </div>

            <div style={styles.sectionCard}>
              <SectionTitle icon="ledger" title="Totales financieros del turno" />
              <div style={styles.financeHeaderRow}>
                <div style={styles.financeLegend}>
                  <span style={styles.financeLegendTitle}>Resumen del movimiento</span>
                  <span style={styles.financeLegendText}>Lectura vertical del cierre con ingresos, egresos y utilidad final.</span>
                </div>
                <div style={styles.creditCorner}>
                  <span style={styles.creditCornerLabel}>Credito</span>
                  <strong style={styles.creditCornerValue}>S/ {amountValue(selected.nu_impo_tota_credito)}</strong>
                </div>
              </div>

              <div style={styles.financeStatement}>
                <StatementRow label="Cobranza Credito" value={selected.nu_impo_cobr_cred} accent="#7c3aed" />
                <StatementRow label="Otro ingreso" value={selected.nu_impo_otro_ingr} accent="#d97706" />
                <StatementRow label="Total ingreso" value={selected.nu_impo_tota_ingr} accent="#0891b2" strong />

                <div style={styles.statementDivider} />

                <StatementRow label="Restando Total Egreso" value={selected.nu_impo_egre} accent="#dc2626" negative />

                <div style={styles.statementDivider} />

                <StatementRow label="Resultado Total Turno" value={selected.nu_impo_total} accent="#111827" strong />
                <StatementInputRow
                  label="Sumando Efectivo"
                  value={selected.nu_impo_tota_efectivo}
                  onChange={(value) => updateSelected('nu_impo_tota_efectivo', value)}
                  accent="#0f766e"
                />

                <div style={styles.statementDivider} />

                <StatementRow label="Resultado Utilidad" value={selected.nu_impo_util_turno} accent="#0f4c81" emphasis />
              </div>
            </div>

            <div style={styles.sectionCard}>
              <SectionTitle icon="branch" title="Observacion operativa" />
              <textarea
                style={styles.textarea}
                rows={4}
                value={selected.vc_obse_cierre || ''}
                onChange={(event) => updateSelected('vc_obse_cierre', event.target.value)}
                placeholder="Registra notas de caja, incidencias o detalles del cierre."
              />
            </div>
          </>
        )}
      </section>
    </div>
  );
}

function SectionTitle({ icon, title }) {
  return (
    <div style={styles.sectionHeader}>
      <div style={styles.sectionIcon}>
        <Icon name={icon} size={16} color="#0f4c81" />
      </div>
      <p style={styles.sectionTitle}>{title}</p>
    </div>
  );
}

function Field({ label, value, onChange, type = 'text', readOnly = false, options = [] }) {
  if (type === 'select') {
    return (
      <div style={styles.field}>
        <label style={styles.label}>{label}</label>
        <select style={{ ...styles.input, ...(readOnly ? styles.inputReadonly : {}) }} value={value ?? ''} onChange={(event) => onChange?.(event.target.value)} disabled={readOnly}>
          {options.map((option) => (
            <option key={option.value} value={option.value}>{option.label}</option>
          ))}
        </select>
      </div>
    );
  }

  return (
    <div style={styles.field}>
      <label style={styles.label}>{label}</label>
      <input
        style={{ ...styles.input, ...(readOnly ? styles.inputReadonly : {}) }}
        type={type}
        value={value ?? ''}
        onChange={(event) => onChange?.(event.target.value)}
        readOnly={readOnly}
      />
    </div>
  );
}

function FieldSelect({ label, value, onChange, options = [], placeholder = 'Seleccionar' }) {
  return (
    <div style={styles.field}>
      <label style={styles.label}>{label}</label>
      <select style={styles.input} value={value ?? ''} onChange={(event) => onChange?.(event.target.value)}>
        <option value="">{placeholder}</option>
        {options.map((option) => (
          <option key={option.value} value={option.value}>{option.label}</option>
        ))}
      </select>
    </div>
  );
}

function StatementRow({ label, value, accent, strong = false, negative = false, emphasis = false }) {
  return (
    <div style={{ ...styles.statementRow, ...(emphasis ? styles.statementRowEmphasis : {}) }}>
      <span style={{ ...styles.statementLabel, ...(strong ? styles.statementLabelStrong : {}) }}>{label}</span>
      <strong style={{ ...styles.statementValue, color: accent, ...(emphasis ? styles.statementValueEmphasis : {}) }}>
        {negative ? '- ' : ''}S/ {amountValue(value)}
      </strong>
    </div>
  );
}

function StatementInputRow({ label, value, onChange, accent }) {
  return (
    <div style={styles.statementRow}>
      <span style={styles.statementLabel}>{label}</span>
      <div style={styles.statementInputWrap}>
        <span style={styles.statementPrefix}>S/</span>
        <input
          style={{ ...styles.statementInput, color: accent }}
          type="number"
          step="0.001"
          value={value ?? ''}
          onChange={(event) => onChange?.(event.target.value)}
          placeholder="0.000"
        />
      </div>
    </div>
  );
}

const styles = {
  page: {
    display: 'grid',
    gridTemplateColumns: 'minmax(340px, 420px) minmax(0, 1fr)',
    gap: 20,
    alignItems: 'start',
  },
  listPanel: {
    background: 'linear-gradient(180deg, #ffffff 0%, #f8fafc 100%)',
    border: '1px solid #dbe3ee',
    borderRadius: 24,
    boxShadow: '0 24px 60px rgba(15, 23, 42, 0.08)',
    overflow: 'hidden',
  },
  panelTop: {
    padding: '22px 22px 18px',
    display: 'flex',
    justifyContent: 'space-between',
    gap: 12,
    borderBottom: '1px solid #e6edf5',
  },
  eyebrowRow: {
    display: 'flex',
    alignItems: 'center',
    gap: 8,
    marginBottom: 8,
  },
  eyebrow: {
    color: '#0f4c81',
    fontSize: 11,
    fontWeight: 800,
    letterSpacing: 1,
    textTransform: 'uppercase',
  },
  leftTitle: {
    margin: 0,
    color: '#0f172a',
    fontSize: 24,
    fontWeight: 900,
    letterSpacing: -0.4,
  },
  leftSubtitle: {
    margin: '8px 0 0',
    color: '#64748b',
    fontSize: 13,
    lineHeight: 1.6,
  },
  btnPrimary: {
    border: 'none',
    background: 'linear-gradient(135deg, #0f4c81 0%, #1d4ed8 100%)',
    color: '#ffffff',
    borderRadius: 14,
    padding: '11px 16px',
    fontWeight: 700,
    fontSize: 13,
    display: 'inline-flex',
    alignItems: 'center',
    gap: 8,
    cursor: 'pointer',
    boxShadow: '0 14px 28px rgba(29, 78, 216, 0.18)',
    whiteSpace: 'nowrap',
  },
  btnDanger: {
    border: 'none',
    background: 'linear-gradient(135deg, #b91c1c 0%, #dc2626 100%)',
    color: '#ffffff',
    borderRadius: 14,
    padding: '11px 16px',
    fontWeight: 700,
    fontSize: 13,
    display: 'inline-flex',
    alignItems: 'center',
    gap: 8,
    cursor: 'pointer',
  },
  btnGhost: {
    border: '1px solid #d7e0ea',
    background: '#ffffff',
    color: '#0f172a',
    borderRadius: 14,
    width: 42,
    height: 42,
    display: 'grid',
    placeItems: 'center',
    cursor: 'pointer',
  },
  tableShell: {
    maxHeight: 'calc(100vh - 235px)',
    overflowY: 'auto',
  },
  table: {
    width: '100%',
    borderCollapse: 'collapse',
  },
  th: {
    position: 'sticky',
    top: 0,
    zIndex: 1,
    background: '#f3f7fb',
    color: '#475569',
    fontSize: 11,
    fontWeight: 800,
    letterSpacing: 0.8,
    textTransform: 'uppercase',
    textAlign: 'left',
    padding: '13px 16px',
    borderBottom: '1px solid #dbe3ee',
  },
  td: {
    padding: '14px 16px',
    borderBottom: '1px solid #eef3f8',
    color: '#475569',
    fontSize: 13,
  },
  tdStrong: {
    padding: '14px 16px',
    borderBottom: '1px solid #eef3f8',
    color: '#0f172a',
    fontSize: 13,
    fontWeight: 800,
  },
  tr: {
    cursor: 'pointer',
    transition: 'background 0.15s ease',
  },
  trOdd: {
    background: '#fbfdff',
  },
  trSelected: {
    background: '#edf5ff',
  },
  empty: {
    textAlign: 'center',
    padding: 28,
    color: '#94a3b8',
    fontStyle: 'italic',
  },
  miniBadge: {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    padding: '5px 10px',
    borderRadius: 999,
    fontSize: 11,
    fontWeight: 800,
  },
  miniBadgeBlue: {
    background: '#dbeafe',
    color: '#1d4ed8',
  },
  rightPanel: {
    background: 'linear-gradient(180deg, #ffffff 0%, #f8fafc 100%)',
    border: '1px solid #dbe3ee',
    borderRadius: 28,
    boxShadow: '0 30px 80px rgba(15, 23, 42, 0.08)',
    padding: 24,
    minHeight: 540,
  },
  placeholder: {
    height: 480,
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 10,
    color: '#64748b',
    textAlign: 'center',
  },
  placeholderOrb: {
    width: 72,
    height: 72,
    borderRadius: 24,
    display: 'grid',
    placeItems: 'center',
    background: 'linear-gradient(135deg, rgba(15,76,129,0.12), rgba(37,99,235,0.08))',
    border: '1px solid rgba(15,76,129,0.14)',
  },
  placeholderTitle: {
    margin: 0,
    color: '#0f172a',
    fontSize: 22,
    fontWeight: 900,
  },
  placeholderText: {
    margin: 0,
    maxWidth: 340,
    lineHeight: 1.7,
  },
  detailHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    gap: 16,
    paddingBottom: 18,
    borderBottom: '1px solid #e6edf5',
    marginBottom: 18,
  },
  detailTitle: {
    margin: 0,
    color: '#0f172a',
    fontSize: 28,
    fontWeight: 900,
    letterSpacing: -0.6,
  },
  statusRow: {
    display: 'flex',
    gap: 8,
    marginTop: 12,
    flexWrap: 'wrap',
  },
  statusBadge: {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    padding: '6px 12px',
    borderRadius: 999,
    fontSize: 12,
    fontWeight: 800,
  },
  statusActive: {
    background: '#dcfce7',
    color: '#15803d',
  },
  statusInactive: {
    background: '#fee2e2',
    color: '#b91c1c',
  },
  statusMuted: {
    background: '#e2e8f0',
    color: '#334155',
  },
  actionRow: {
    display: 'flex',
    gap: 10,
    alignItems: 'flex-start',
  },
  sectionCard: {
    background: '#ffffff',
    border: '1px solid #e6edf5',
    borderRadius: 22,
    padding: 18,
    marginBottom: 16,
  },
  sectionHeader: {
    display: 'flex',
    alignItems: 'center',
    gap: 10,
    marginBottom: 14,
  },
  sectionIcon: {
    width: 34,
    height: 34,
    borderRadius: 12,
    display: 'grid',
    placeItems: 'center',
    background: '#eff6ff',
  },
  sectionTitle: {
    margin: 0,
    color: '#0f172a',
    fontSize: 14,
    fontWeight: 800,
    letterSpacing: 0.2,
  },
  formGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(3, minmax(0, 1fr))',
    gap: 14,
  },
  field: {
    display: 'flex',
    flexDirection: 'column',
    gap: 6,
  },
  label: {
    color: '#64748b',
    fontSize: 11,
    fontWeight: 800,
    letterSpacing: 0.7,
    textTransform: 'uppercase',
  },
  input: {
    width: '100%',
    boxSizing: 'border-box',
    padding: '12px 13px',
    border: '1px solid #cdd9e5',
    borderRadius: 14,
    fontSize: 14,
    background: '#ffffff',
    color: '#0f172a',
    outline: 'none',
  },
  inputReadonly: {
    background: '#f8fafc',
    color: '#475569',
  },
  financeHeaderRow: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    gap: 16,
    marginBottom: 18,
  },
  financeLegend: {
    display: 'flex',
    flexDirection: 'column',
    gap: 4,
  },
  financeLegendTitle: {
    color: '#0f172a',
    fontSize: 15,
    fontWeight: 800,
  },
  financeLegendText: {
    color: '#64748b',
    fontSize: 13,
    lineHeight: 1.5,
  },
  creditCorner: {
    minWidth: 170,
    borderRadius: 18,
    padding: '14px 16px',
    background: 'linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%)',
    border: '1px solid #bfdbfe',
    textAlign: 'right',
  },
  creditCornerLabel: {
    color: '#64748b',
    fontSize: 11,
    fontWeight: 800,
    letterSpacing: 0.7,
    textTransform: 'uppercase',
  },
  creditCornerValue: {
    display: 'block',
    marginTop: 6,
    color: '#1d4ed8',
    fontSize: 24,
    fontWeight: 900,
    letterSpacing: -0.5,
  },
  financeStatement: {
    display: 'flex',
    flexDirection: 'column',
    gap: 12,
    background: '#fbfdff',
    border: '1px solid #e5edf5',
    borderRadius: 20,
    padding: 18,
  },
  statementRow: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: 16,
    minHeight: 44,
  },
  statementRowEmphasis: {
    paddingTop: 6,
  },
  statementLabel: {
    color: '#475569',
    fontSize: 13,
    fontWeight: 700,
    textTransform: 'uppercase',
    letterSpacing: 0.5,
  },
  statementLabelStrong: {
    color: '#0f172a',
    fontWeight: 900,
  },
  statementValue: {
    fontSize: 20,
    fontWeight: 900,
    letterSpacing: -0.3,
  },
  statementValueEmphasis: {
    fontSize: 26,
  },
  statementDivider: {
    height: 1,
    background: 'linear-gradient(90deg, transparent 0%, #d8e2ec 12%, #d8e2ec 88%, transparent 100%)',
  },
  statementInputWrap: {
    display: 'flex',
    alignItems: 'center',
    gap: 8,
    minWidth: 220,
    justifyContent: 'flex-end',
  },
  statementPrefix: {
    color: '#64748b',
    fontSize: 12,
    fontWeight: 800,
  },
  statementInput: {
    width: 150,
    border: '1px solid #cdd9e5',
    borderRadius: 14,
    background: '#ffffff',
    fontSize: 20,
    fontWeight: 900,
    outline: 'none',
    padding: '10px 12px',
    textAlign: 'right',
  },
  textarea: {
    width: '100%',
    boxSizing: 'border-box',
    border: '1px solid #cdd9e5',
    borderRadius: 16,
    padding: '14px 15px',
    fontSize: 14,
    color: '#0f172a',
    resize: 'vertical',
    fontFamily: 'inherit',
    outline: 'none',
    background: '#fbfdff',
  },
};

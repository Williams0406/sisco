import { useEffect, useMemo, useState } from 'react';
import api from '../../api/axios';
import { theme } from '../../styles/tokens';

const padDatePart = (value) => String(value).padStart(2, '0');

const toDateTimeInputValue = (value = new Date()) => {
  if (!value) return '';
  const normalized = typeof value === 'string' ? value.replace(' ', 'T') : value;
  const date = value instanceof Date ? new Date(value) : new Date(normalized);
  if (Number.isNaN(date.getTime())) return '';
  return `${date.getFullYear()}-${padDatePart(date.getMonth() + 1)}-${padDatePart(date.getDate())}T${padDatePart(date.getHours())}:${padDatePart(date.getMinutes())}`;
};

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

const createEmptyForm = () => ({
  nu_codi_recibo: '',
  dt_fech_egre: toDateTimeInputValue(),
  ch_seri_egre: '',
  ch_nume_egre: '',
  ch_esta_activo: '1',
  ch_codi_tipo_egreso: '',
  ch_codi_proveedor: '',
  ch_codi_autoriza: '',
  nu_impo_egre: '',
  vc_obse_egre: '',
  ch_codi_cajero: '',
});

export default function RecibosEgreso() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [editId, setEditId] = useState(null);
  const [form, setForm] = useState(createEmptyForm());
  const [tiposEgreso, setTiposEgreso] = useState([]);
  const [proveedores, setProveedores] = useState([]);
  const [cajeros, setCajeros] = useState([]);

  const fetchData = async () => {
    setLoading(true);
    try {
      const [rRes, tRes, pRes, cajerosRes] = await Promise.all([
        api.get('/movimientos/recibos-egreso/?page_size=200'),
        api.get('/maestros/tipo-egresos/?page_size=100'),
        api.get('/maestros/proveedores/?page_size=200'),
        api.get('/seguridad/cajeros/'),
      ]);

      setData(normalizeList(rRes.data));
      setTiposEgreso(normalizeList(tRes.data));
      setProveedores(normalizeList(pRes.data));
      setCajeros(normalizeList(cajerosRes.data));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const rows = useMemo(
    () =>
      data.map((item) => ({
        ...item,
        tipo_desc: item.tipo_egreso_desc || '-',
        estado_desc: item.ch_esta_activo === '1' ? 'Activo' : 'Anulado',
      })),
    [data],
  );

  const totalEgresos = useMemo(
    () => rows.reduce((sum, row) => sum + Number(row.nu_impo_egre || 0), 0),
    [rows],
  );

  const cajeroOptions = useMemo(() => {
    const options = cajeros.map((item) => ({
      value: item.codigo,
      label: `${item.codigo} - ${item.nombre}`,
    }));
    if (form.ch_codi_cajero && !options.some((item) => item.value === form.ch_codi_cajero)) {
      options.unshift({ value: form.ch_codi_cajero, label: form.ch_codi_cajero });
    }
    return options;
  }, [cajeros, form.ch_codi_cajero]);

  const handleSelect = (row) => {
    setEditId(row.nu_codi_recibo);
    setForm({
      nu_codi_recibo: row.nu_codi_recibo ?? '',
      dt_fech_egre: toDateTimeInputValue(row.dt_fech_egre),
      ch_seri_egre: row.ch_seri_egre ?? '',
      ch_nume_egre: row.ch_nume_egre ?? '',
      ch_esta_activo: row.ch_esta_activo ?? '1',
      ch_codi_tipo_egreso: row.ch_codi_tipo_egreso ?? '',
      ch_codi_proveedor: row.ch_codi_proveedor ?? '',
      ch_codi_autoriza: row.ch_codi_autoriza ?? '',
      nu_impo_egre: row.nu_impo_egre ?? '',
      vc_obse_egre: row.vc_obse_egre ?? '',
      ch_codi_cajero: row.ch_codi_cajero ?? '',
    });
  };

  const handleNew = () => {
    setEditId(null);
    setForm(createEmptyForm());
  };

  const handleChange = (key, value) => {
    setForm((prev) => ({ ...prev, [key]: value }));
  };

  const handleSave = async () => {
    setSaving(true);
    try {
      const payload = {
        ...form,
        ch_codi_proveedor: form.ch_codi_proveedor || null,
      };
      delete payload.nu_codi_recibo;

      if (editId) {
        await api.put(`/movimientos/recibos-egreso/${editId}/`, payload);
      } else {
        await api.post('/movimientos/recibos-egreso/', payload);
      }

      await fetchData();
      handleNew();
    } catch (err) {
      alert(`Error: ${JSON.stringify(err.response?.data || err.message)}`);
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async () => {
    if (!editId) return;
    if (!confirm(`Anular recibo #${editId}?`)) return;

    await api.patch(`/movimientos/recibos-egreso/${editId}/`, { ch_esta_activo: '0' });
    await fetchData();
    handleNew();
  };

  return (
    <div style={styles.page}>
      <div style={styles.contentGrid}>
        <section style={styles.listPanel}>
          <div style={styles.panelHeader}>
            <div>
              <p style={styles.eyebrow}>Operacion</p>
              <h2 style={styles.title}>Listado de egreso</h2>
              <p style={styles.subtitle}>Visualiza egresos, revisa estados y accede al detalle sin friccion.</p>
            </div>
            <button style={styles.btnPrimary} type="button" onClick={handleNew}>
              + Nuevo
            </button>
          </div>

          <div style={styles.kpiRow}>
            <MetricCard label="Registros" value={String(rows.length)} />
            <MetricCard label="Total acumulado" value={formatMoney(totalEgresos)} highlight />
          </div>

          <div style={styles.tableWrapper}>
            <table style={styles.table}>
              <thead>
                <tr>
                  <th style={styles.th}>Fecha</th>
                  <th style={styles.th}>Serie</th>
                  <th style={styles.th}>Numero</th>
                  <th style={styles.th}>Tipo</th>
                  <th style={styles.th}>Importe</th>
                  <th style={styles.th}>Estado</th>
                </tr>
              </thead>
              <tbody>
                {loading && (
                  <tr>
                    <td colSpan={6} style={styles.empty}>
                      Cargando egresos...
                    </td>
                  </tr>
                )}
                {!loading && rows.length === 0 && (
                  <tr>
                    <td colSpan={6} style={styles.empty}>
                      No hay registros disponibles.
                    </td>
                  </tr>
                )}
                {!loading &&
                  rows.map((row, index) => {
                    const selected = row.nu_codi_recibo === editId;
                    return (
                      <tr
                        key={row.nu_codi_recibo}
                        onClick={() => handleSelect(row)}
                        style={{
                          ...styles.tr,
                          ...(index % 2 !== 0 && !selected ? styles.trOdd : {}),
                          ...(selected ? styles.trSelected : {}),
                        }}
                      >
                        <td style={styles.td}>{formatDate(row.dt_fech_egre)}</td>
                        <td style={styles.td}>{row.ch_seri_egre || '-'}</td>
                        <td style={styles.td}>{row.ch_nume_egre || '-'}</td>
                        <td style={styles.td}>{row.tipo_desc}</td>
                        <td style={{ ...styles.td, ...styles.amountCell }}>{formatMoney(row.nu_impo_egre)}</td>
                        <td style={styles.td}>
                          <StatusBadge active={row.ch_esta_activo === '1'} label={row.estado_desc} />
                        </td>
                      </tr>
                    );
                  })}
              </tbody>
            </table>
          </div>
        </section>

        <section style={styles.formPanel}>
          <div style={styles.formHeader}>
            <div>
              <p style={styles.eyebrow}>Detalle</p>
              <h3 style={styles.formTitle}>{editId ? 'Editar egreso' : 'Nuevo egreso'}</h3>
              <p style={styles.formSubtitle}>Completa el formulario para registrar o actualizar el egreso.</p>
            </div>
            {editId && (
              <button style={styles.btnDanger} type="button" onClick={handleDelete}>
                Anular
              </button>
            )}
          </div>

          <div style={styles.section}>
            <p style={styles.sectionTitle}>Datos del recibo</p>
            <div style={styles.formGrid}>
              <Field label="Codigo" value={form.nu_codi_recibo} readOnly placeholder="Auto" />
              <Field label="N° Serie" value={form.ch_seri_egre} readOnly placeholder="Auto" />
              <Field label="Numero" value={form.ch_nume_egre} readOnly placeholder="Auto" />
              <Field
                label="Estado"
                type="select"
                value={form.ch_esta_activo}
                onChange={(v) => handleChange('ch_esta_activo', v)}
                options={[
                  { value: '1', label: 'Activo' },
                  { value: '0', label: 'Anulado' },
                ]}
              />
              <Field
                label="Fecha"
                type="datetime-local"
                value={form.dt_fech_egre}
                onChange={(v) => handleChange('dt_fech_egre', v)}
              />
              <Field
                label="Tipo de egreso"
                type="select"
                value={form.ch_codi_tipo_egreso}
                onChange={(v) => handleChange('ch_codi_tipo_egreso', v)}
                options={[
                  { value: '', label: 'Seleccionar' },
                  ...tiposEgreso.map((tipo) => ({
                    value: tipo.ch_codi_tipo_egreso,
                    label: tipo.vc_desc_tipo_egreso,
                  })),
                ]}
              />
            </div>
          </div>

          <div style={styles.section}>
            <p style={styles.sectionTitle}>Responsables y pago</p>
            <div style={styles.formGrid}>
              <Field
                label="Proveedor"
                type="select"
                value={form.ch_codi_proveedor}
                onChange={(v) => handleChange('ch_codi_proveedor', v)}
                options={[
                  { value: '', label: 'Seleccionar' },
                  ...proveedores.map((proveedor) => ({
                    value: proveedor.ch_codi_proveedor,
                    label: proveedor.vc_razo_soci_prov,
                  })),
                ]}
              />
              <Field
                label="Autorizado por"
                value={form.ch_codi_autoriza}
                onChange={(v) => handleChange('ch_codi_autoriza', v)}
              />
              <Field
                label="Total"
                type="number"
                value={form.nu_impo_egre}
                onChange={(v) => handleChange('nu_impo_egre', v)}
              />
              <Field
                label="Cajero"
                type="select"
                value={form.ch_codi_cajero}
                onChange={(v) => handleChange('ch_codi_cajero', v)}
                options={[
                  { value: '', label: 'Seleccionar' },
                  ...cajeroOptions,
                ]}
              />
              <Field
                label="Observacion"
                type="textarea"
                value={form.vc_obse_egre}
                onChange={(v) => handleChange('vc_obse_egre', v)}
              />
            </div>
          </div>

          <div style={styles.footer}>
            <button style={styles.btnSecondary} type="button" onClick={handleNew}>
              Limpiar
            </button>
            <button style={styles.btnPrimary} type="button" onClick={handleSave} disabled={saving}>
              {saving ? 'Guardando...' : 'Guardar'}
            </button>
          </div>
        </section>
      </div>
    </div>
  );
}

function Field({ label, value, onChange, type = 'text', readOnly = false, placeholder = '', options = [] }) {
  return (
    <div style={type === 'textarea' ? styles.fieldWide : styles.field}>
      <label style={styles.label}>{label}</label>
      {type === 'select' ? (
        <select
          style={{ ...styles.input, ...(readOnly ? styles.inputReadOnly : {}) }}
          value={value ?? ''}
          onChange={(e) => onChange?.(e.target.value)}
          disabled={readOnly}
        >
          {options.map((option) => (
            <option key={option.value} value={option.value}>
              {option.label}
            </option>
          ))}
        </select>
      ) : type === 'textarea' ? (
        <textarea
          style={{ ...styles.input, ...styles.textarea, ...(readOnly ? styles.inputReadOnly : {}) }}
          rows={4}
          value={value ?? ''}
          onChange={(e) => onChange?.(e.target.value)}
          placeholder={placeholder}
          readOnly={readOnly}
        />
      ) : (
        <input
          style={{ ...styles.input, ...(readOnly ? styles.inputReadOnly : {}) }}
          type={type}
          value={value ?? ''}
          onChange={(e) => onChange?.(e.target.value)}
          placeholder={placeholder}
          readOnly={readOnly}
        />
      )}
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

function StatusBadge({ active, label }) {
  return (
    <span
      style={{
        ...styles.badge,
        ...(active ? styles.badgeSuccess : styles.badgeDanger),
      }}
    >
      {label}
    </span>
  );
}

const cardBase = {
  background: theme.colors.panel,
  borderRadius: theme.radius.lg,
  border: `1px solid ${theme.colors.border}`,
  boxShadow: theme.shadow.card,
};

const styles = {
  page: {
    display: 'flex',
    flexDirection: 'column',
    gap: 16,
  },
  contentGrid: {
    display: 'grid',
    gridTemplateColumns: 'minmax(0, 1.25fr) minmax(360px, 0.95fr)',
    gap: 18,
    alignItems: 'start',
  },
  listPanel: {
    ...cardBase,
    padding: 20,
  },
  formPanel: {
    ...cardBase,
    padding: 20,
    position: 'sticky',
    top: 0,
  },
  panelHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    gap: 12,
    marginBottom: 16,
  },
  formHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    gap: 12,
    marginBottom: 18,
    paddingBottom: 16,
    borderBottom: `1px solid ${theme.colors.border}`,
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
    fontSize: 22,
    color: theme.colors.text,
    fontWeight: 800,
  },
  subtitle: {
    margin: '6px 0 0',
    fontSize: theme.typography.body,
    color: theme.colors.textMuted,
  },
  formTitle: {
    margin: '6px 0 0',
    fontSize: 20,
    color: theme.colors.text,
    fontWeight: 800,
  },
  formSubtitle: {
    margin: '6px 0 0',
    fontSize: theme.typography.body,
    color: theme.colors.textMuted,
  },
  kpiRow: {
    display: 'grid',
    gridTemplateColumns: 'repeat(2, minmax(0, 1fr))',
    gap: 12,
    marginBottom: 16,
  },
  metricCard: {
    background: theme.colors.panelMuted,
    border: `1px solid ${theme.colors.border}`,
    borderRadius: theme.radius.md,
    padding: '14px 16px',
    display: 'flex',
    flexDirection: 'column',
    gap: 6,
  },
  metricCardHighlight: {
    background: '#fff7ed',
    borderColor: '#fed7aa',
  },
  metricLabel: {
    color: theme.colors.textMuted,
    fontSize: theme.typography.small,
    textTransform: 'uppercase',
    letterSpacing: 0.8,
    fontWeight: 700,
  },
  metricLabelHighlight: {
    color: theme.colors.warning,
  },
  metricValue: {
    color: theme.colors.text,
    fontSize: 24,
    fontWeight: 800,
  },
  metricValueHighlight: {
    color: theme.colors.warning,
  },
  tableWrapper: {
    overflow: 'auto',
    maxHeight: 'calc(100vh - 290px)',
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
    fontWeight: 700,
    color: theme.colors.textMuted,
    borderBottom: `1px solid ${theme.colors.border}`,
    whiteSpace: 'nowrap',
    position: 'sticky',
    top: 0,
    textTransform: 'uppercase',
    letterSpacing: 0.4,
    fontSize: theme.typography.small,
  },
  td: {
    padding: '12px 14px',
    borderBottom: '1px solid #edf2f7',
    color: theme.colors.text,
  },
  tr: {
    cursor: 'pointer',
  },
  trOdd: {
    background: '#fbfdff',
  },
  trSelected: {
    background: theme.colors.brandTint,
  },
  empty: {
    textAlign: 'center',
    padding: 28,
    color: theme.colors.textMuted,
  },
  amountCell: {
    textAlign: 'right',
    fontWeight: 700,
    whiteSpace: 'nowrap',
  },
  badge: {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    padding: '5px 10px',
    borderRadius: theme.radius.pill,
    fontSize: 12,
    fontWeight: 800,
  },
  badgeSuccess: {
    background: theme.colors.successTint,
    color: theme.colors.success,
  },
  badgeDanger: {
    background: theme.colors.dangerTint,
    color: theme.colors.danger,
  },
  section: {
    marginBottom: 18,
    paddingBottom: 18,
    borderBottom: `1px solid ${theme.colors.border}`,
  },
  sectionTitle: {
    margin: '0 0 12px',
    fontSize: theme.typography.small,
    fontWeight: 800,
    color: theme.colors.textSoft,
    textTransform: 'uppercase',
    letterSpacing: 0.8,
  },
  formGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(2, minmax(0, 1fr))',
    gap: 14,
  },
  field: {
    display: 'flex',
    flexDirection: 'column',
    gap: 6,
  },
  fieldWide: {
    display: 'flex',
    flexDirection: 'column',
    gap: 6,
    gridColumn: '1 / -1',
  },
  label: {
    fontSize: theme.typography.label,
    fontWeight: 700,
    color: theme.colors.textMuted,
  },
  input: {
    width: '100%',
    boxSizing: 'border-box',
    padding: '11px 12px',
    border: `1px solid ${theme.colors.borderStrong}`,
    borderRadius: theme.radius.sm,
    fontSize: theme.typography.body,
    color: theme.colors.text,
    background: theme.colors.panel,
    outline: 'none',
  },
  inputReadOnly: {
    background: theme.colors.panelMuted,
    color: theme.colors.textMuted,
  },
  textarea: {
    resize: 'vertical',
    fontFamily: 'inherit',
    minHeight: 108,
  },
  footer: {
    display: 'flex',
    justifyContent: 'flex-end',
    gap: 10,
    paddingTop: 4,
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
  btnSecondary: {
    background: theme.colors.panelMuted,
    color: theme.colors.textMuted,
    border: `1px solid ${theme.colors.border}`,
    padding: '10px 18px',
    borderRadius: theme.radius.sm,
    cursor: 'pointer',
    fontWeight: 700,
  },
  btnDanger: {
    background: theme.colors.dangerTint,
    color: theme.colors.danger,
    border: '1px solid #fecaca',
    padding: '10px 14px',
    borderRadius: theme.radius.sm,
    cursor: 'pointer',
    fontWeight: 700,
  },
};

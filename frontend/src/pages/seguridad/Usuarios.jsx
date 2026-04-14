import { useEffect, useMemo, useState } from 'react';
import api from '../../api/axios';
import { theme } from '../../styles/tokens';

const createEmptyForm = () => ({
  vc_desc_nomb_usuario: '',
  vc_desc_apell_paterno: '',
  vc_desc_apell_materno: '',
  ch_codi_usuario: '',
  ch_pass_usua: '',
  ch_pass_usua2: '',
  ch_esta_autoriza: '0',
  ch_esta_horas_extra: '0',
  ch_esta_activo: true,
});

export default function Usuarios() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [editId, setEditId] = useState(null);
  const [form, setForm] = useState(createEmptyForm());

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await api.get('/seguridad/usuarios/?page_size=300');
      setData(res.data.results || res.data);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const rows = useMemo(
    () =>
      data.map((item, index) => ({
        ...item,
        nro: index + 1,
      })),
    [data],
  );

  const activos = useMemo(
    () => rows.filter((row) => row.ch_esta_activo).length,
    [rows],
  );

  const handleNew = () => {
    setEditId(null);
    setForm(createEmptyForm());
  };

  const handleSelect = (row) => {
    setEditId(row.ch_codi_usuario);
    setForm({
      vc_desc_nomb_usuario: row.vc_desc_nomb_usuario ?? '',
      vc_desc_apell_paterno: row.vc_desc_apell_paterno ?? '',
      vc_desc_apell_materno: row.vc_desc_apell_materno ?? '',
      ch_codi_usuario: row.ch_codi_usuario ?? '',
      ch_pass_usua: '',
      ch_pass_usua2: '',
      ch_esta_autoriza: row.ch_esta_autoriza ?? '0',
      ch_esta_horas_extra: row.ch_esta_horas_extra ?? '0',
      ch_esta_activo: row.ch_esta_activo ?? true,
    });
  };

  const handleChange = (key, value) => {
    setForm((prev) => ({ ...prev, [key]: value }));
  };

  const handleSave = async () => {
    setSaving(true);
    try {
      const payload = {
        ...form,
        ch_esta_activo: form.ch_esta_activo === true || form.ch_esta_activo === '1',
      };

      if (!payload.ch_pass_usua) delete payload.ch_pass_usua;
      if (!payload.ch_pass_usua2) delete payload.ch_pass_usua2;

      if (editId) {
        await api.put(`/seguridad/usuarios/${editId}/`, payload);
      } else {
        await api.post('/seguridad/usuarios/', payload);
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
    if (!confirm(`Desactivar usuario ${editId}?`)) return;

    await api.patch(`/seguridad/usuarios/${editId}/`, { ch_esta_activo: false });
    await fetchData();
    handleNew();
  };

  return (
    <div style={styles.page}>
      <div style={styles.contentGrid}>
        <section style={styles.listPanel}>
          <div style={styles.panelHeader}>
            <div>
              <p style={styles.eyebrow}>Seguridad</p>
              <h2 style={styles.title}>Usuarios del sistema</h2>
              <p style={styles.subtitle}>Selecciona un usuario para revisar datos, acceso y permisos.</p>
            </div>
            <button style={styles.btnPrimary} type="button" onClick={handleNew}>
              + Nuevo
            </button>
          </div>

          <div style={styles.kpiRow}>
            <MetricCard label="Usuarios" value={String(rows.length)} />
            <MetricCard label="Activos" value={String(activos)} highlight />
          </div>

          <div style={styles.tableWrapper}>
            <table style={styles.table}>
              <thead>
                <tr>
                  <th style={styles.th}>N°</th>
                  <th style={styles.th}>Usuario</th>
                  <th style={styles.th}>Nombre</th>
                  <th style={styles.th}>Apellido paterno</th>
                  <th style={styles.th}>Apellido materno</th>
                </tr>
              </thead>
              <tbody>
                {loading && (
                  <tr>
                    <td colSpan={5} style={styles.empty}>
                      Cargando usuarios...
                    </td>
                  </tr>
                )}
                {!loading && rows.length === 0 && (
                  <tr>
                    <td colSpan={5} style={styles.empty}>
                      No hay registros disponibles.
                    </td>
                  </tr>
                )}
                {!loading &&
                  rows.map((row, index) => {
                    const selected = row.ch_codi_usuario === editId;
                    return (
                      <tr
                        key={row.ch_codi_usuario}
                        onClick={() => handleSelect(row)}
                        style={{
                          ...styles.tr,
                          ...(index % 2 !== 0 && !selected ? styles.trOdd : {}),
                          ...(selected ? styles.trSelected : {}),
                        }}
                      >
                        <td style={styles.td}>{row.nro}</td>
                        <td style={styles.td}>
                          <div style={styles.userCell}>
                            <strong style={styles.userCode}>{row.ch_codi_usuario || '-'}</strong>
                            <StatusBadge active={Boolean(row.ch_esta_activo)} label={row.ch_esta_activo ? 'Activo' : 'Inactivo'} />
                          </div>
                        </td>
                        <td style={styles.td}>{row.vc_desc_nomb_usuario || '-'}</td>
                        <td style={styles.td}>{row.vc_desc_apell_paterno || '-'}</td>
                        <td style={styles.td}>{row.vc_desc_apell_materno || '-'}</td>
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
              <h3 style={styles.formTitle}>{editId ? 'Editar usuario' : 'Nuevo usuario'}</h3>
              <p style={styles.formSubtitle}>Gestiona datos personales, credenciales y permisos operativos.</p>
            </div>
            {editId && (
              <button style={styles.btnDanger} type="button" onClick={handleDelete}>
                Desactivar
              </button>
            )}
          </div>

          <div style={styles.section}>
            <p style={styles.sectionTitle}>Datos personales</p>
            <div style={styles.formGrid}>
              <Field label="Nombres" value={form.vc_desc_nomb_usuario} onChange={(v) => handleChange('vc_desc_nomb_usuario', v)} />
              <Field label="Apellido paterno" value={form.vc_desc_apell_paterno} onChange={(v) => handleChange('vc_desc_apell_paterno', v)} />
              <Field label="Apellido materno" value={form.vc_desc_apell_materno} onChange={(v) => handleChange('vc_desc_apell_materno', v)} />
            </div>
          </div>

          <div style={styles.section}>
            <p style={styles.sectionTitle}>Acceso</p>
            <div style={styles.formGrid}>
              <Field
                label="Usuario"
                value={form.ch_codi_usuario}
                onChange={(v) => handleChange('ch_codi_usuario', v)}
                readOnly={Boolean(editId)}
              />
              <Field label="Password" type="password" value={form.ch_pass_usua} onChange={(v) => handleChange('ch_pass_usua', v)} />
              <Field label="Password ADM" type="password" value={form.ch_pass_usua2} onChange={(v) => handleChange('ch_pass_usua2', v)} />
            </div>
          </div>

          <div style={styles.section}>
            <p style={styles.sectionTitle}>Permisos</p>
            <div style={styles.formGrid}>
              <Field
                label="Autoriza recibo egreso"
                type="select"
                value={form.ch_esta_autoriza}
                onChange={(v) => handleChange('ch_esta_autoriza', v)}
                options={[
                  { value: '1', label: 'Si' },
                  { value: '0', label: 'No' },
                ]}
              />
              <Field
                label="Validar cierre"
                type="select"
                value={form.ch_esta_horas_extra}
                onChange={(v) => handleChange('ch_esta_horas_extra', v)}
                options={[
                  { value: '1', label: 'Si' },
                  { value: '0', label: 'No' },
                ]}
              />
              <Field
                label="Estado"
                type="select"
                value={form.ch_esta_activo ? '1' : '0'}
                onChange={(v) => handleChange('ch_esta_activo', v === '1')}
                options={[
                  { value: '1', label: 'Activo' },
                  { value: '0', label: 'Inactivo' },
                ]}
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

function Field({ label, value, onChange, type = 'text', readOnly = false, options = [] }) {
  return (
    <div style={styles.field}>
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
      ) : (
        <input
          style={{ ...styles.input, ...(readOnly ? styles.inputReadOnly : {}) }}
          type={type}
          value={value ?? ''}
          onChange={(e) => onChange?.(e.target.value)}
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
    <span style={{ ...styles.badge, ...(active ? styles.badgeSuccess : styles.badgeMuted) }}>
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
    gridTemplateColumns: 'minmax(0, 1.15fr) minmax(360px, 0.95fr)',
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
    background: '#f0fdf4',
    borderColor: '#bbf7d0',
  },
  metricLabel: {
    color: theme.colors.textMuted,
    fontSize: theme.typography.small,
    textTransform: 'uppercase',
    letterSpacing: 0.8,
    fontWeight: 700,
  },
  metricLabelHighlight: {
    color: theme.colors.success,
  },
  metricValue: {
    color: theme.colors.text,
    fontSize: 24,
    fontWeight: 800,
  },
  metricValueHighlight: {
    color: theme.colors.success,
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
    verticalAlign: 'middle',
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
  userCell: {
    display: 'flex',
    alignItems: 'center',
    gap: 10,
    flexWrap: 'wrap',
  },
  userCode: {
    color: theme.colors.text,
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
  badgeMuted: {
    background: theme.colors.panelMuted,
    color: theme.colors.textMuted,
    border: `1px solid ${theme.colors.border}`,
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

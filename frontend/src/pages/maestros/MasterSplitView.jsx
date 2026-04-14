import { useMemo } from 'react';
import { theme } from '../../styles/tokens';

const isActiveValue = (value) => value === true || value === 'true' || value === 1 || value === '1';

export default function MasterSplitView({
  eyebrow = 'Maestros',
  title,
  singularTitle,
  subtitle,
  columns,
  data,
  loading,
  form,
  fields,
  editId,
  saving,
  onChange,
  onNew,
  onSelect,
  onSave,
  onDelete,
  getRowId,
  getRowTitle,
}) {
  const rows = useMemo(
    () =>
      data.map((item, index) => ({
        ...item,
        __nro: index + 1,
      })),
    [data],
  );

  const activos = useMemo(() => rows.filter((row) => isActiveValue(row.ch_esta_activo)).length, [rows]);

  return (
    <div style={styles.page}>
      <div style={styles.contentGrid}>
        <section style={styles.listPanel}>
          <div style={styles.panelHeader}>
            <div>
              <p style={styles.eyebrow}>{eyebrow}</p>
              <h2 style={styles.title}>{title}</h2>
              <p style={styles.subtitle}>{subtitle}</p>
            </div>
            <button style={styles.btnPrimary} type="button" onClick={onNew}>
              + Nuevo
            </button>
          </div>

          <div style={styles.kpiRow}>
            <MetricCard label="Registros" value={String(rows.length)} />
            <MetricCard label="Activos" value={String(activos)} highlight />
          </div>

          <div style={styles.tableWrapper}>
            <table style={styles.table}>
              <thead>
                <tr>
                  <th style={styles.th}>N°</th>
                  {columns.map((column) => (
                    <th key={column.key} style={styles.th}>
                      {column.label}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {loading && (
                  <tr>
                    <td colSpan={columns.length + 1} style={styles.empty}>
                      Cargando registros...
                    </td>
                  </tr>
                )}
                {!loading && rows.length === 0 && (
                  <tr>
                    <td colSpan={columns.length + 1} style={styles.empty}>
                      No hay registros disponibles.
                    </td>
                  </tr>
                )}
                {!loading &&
                  rows.map((row, index) => {
                    const rowId = getRowId(row);
                    const selected = rowId === editId;
                    return (
                      <tr
                        key={rowId}
                        onClick={() => onSelect(row)}
                        style={{
                          ...styles.tr,
                          ...(index % 2 !== 0 && !selected ? styles.trOdd : {}),
                          ...(selected ? styles.trSelected : {}),
                        }}
                      >
                        <td style={styles.td}>{row.__nro}</td>
                        {columns.map((column) => (
                          <td key={column.key} style={styles.td}>
                            {column.render ? column.render(row[column.key], row) : row[column.key] || '-'}
                          </td>
                        ))}
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
              <h3 style={styles.formTitle}>{editId ? `Editar ${getRowTitle(form)}` : `Nuevo ${singularTitle || title}`}</h3>
              <p style={styles.formSubtitle}>Completa los datos y guarda los cambios en la misma vista.</p>
            </div>
            {editId && (
              <button style={styles.btnDanger} type="button" onClick={onDelete}>
                Desactivar
              </button>
            )}
          </div>

          <div style={styles.formGrid}>
            {fields.map((field) => (
              <Field
                key={field.key}
                label={field.label}
                type={field.type}
                value={form[field.key]}
                onChange={(value) => onChange(field.key, value)}
                readOnly={Boolean(field.readOnly)}
                options={field.options || []}
                placeholder={field.placeholder}
                maxLength={field.maxLength}
              />
            ))}
          </div>

          <div style={styles.footer}>
            <button style={styles.btnSecondary} type="button" onClick={onNew}>
              Limpiar
            </button>
            <button style={styles.btnPrimary} type="button" onClick={onSave} disabled={saving}>
              {saving ? 'Guardando...' : 'Guardar'}
            </button>
          </div>
        </section>
      </div>
    </div>
  );
}

function Field({ label, value, onChange, type = 'text', readOnly = false, options = [], placeholder, maxLength }) {
  return (
    <div style={styles.field}>
      <label style={styles.label}>{label}</label>
      {type === 'select' ? (
        <select
          style={{ ...styles.input, ...(readOnly ? styles.inputReadOnly : {}) }}
          value={value ?? ''}
          onChange={(e) => onChange(e.target.value)}
          disabled={readOnly}
        >
          <option value="">{placeholder || 'Seleccionar'}</option>
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
          onChange={(e) => onChange(e.target.value)}
          readOnly={readOnly}
          placeholder={placeholder}
          maxLength={maxLength}
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
    gridTemplateColumns: 'minmax(0, 1.2fr) minmax(360px, 0.9fr)',
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
    paddingTop: 18,
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

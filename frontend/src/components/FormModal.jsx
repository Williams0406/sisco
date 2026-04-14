import { theme } from '../styles/tokens';

export default function FormModal({
  title,
  fields,
  values,
  onChange,
  onSave,
  onClose,
  loading,
}) {
  return (
    <div style={styles.overlay}>
      <div style={styles.modal}>
        <div style={styles.header}>
          <div>
            <p style={styles.eyebrow}>Registro</p>
            <h3 style={styles.title}>{title}</h3>
          </div>
          <button style={styles.closeBtn} type="button" onClick={onClose}>
            Cerrar
          </button>
        </div>

        <div style={styles.body}>
          {fields.map((field) => (
            <div key={field.key} style={styles.field}>
              <label style={styles.label}>{field.label}</label>
              {field.type === 'select' ? (
                <select
                  style={{
                    ...styles.input,
                    ...(field.readOnly ? styles.inputReadOnly : {}),
                  }}
                  value={values[field.key] ?? ''}
                  onChange={(e) => onChange(field.key, e.target.value)}
                  disabled={field.readOnly}
                >
                  <option value="">Seleccionar</option>
                  {field.options?.map((opt) => (
                    <option key={opt.value} value={opt.value}>
                      {opt.label}
                    </option>
                  ))}
                </select>
              ) : field.type === 'textarea' ? (
                <textarea
                  style={{
                    ...styles.input,
                    ...styles.textarea,
                    ...(field.readOnly ? styles.inputReadOnly : {}),
                  }}
                  value={values[field.key] ?? ''}
                  onChange={(e) => onChange(field.key, e.target.value)}
                  placeholder={field.placeholder || ''}
                  readOnly={field.readOnly}
                />
              ) : (
                <input
                  style={{
                    ...styles.input,
                    ...(field.readOnly ? styles.inputReadOnly : {}),
                  }}
                  type={field.type || 'text'}
                  value={values[field.key] ?? ''}
                  onChange={(e) => onChange(field.key, e.target.value)}
                  placeholder={field.placeholder || ''}
                  readOnly={field.readOnly}
                />
              )}
            </div>
          ))}
        </div>

        <div style={styles.footer}>
          <button style={styles.btnCancel} type="button" onClick={onClose}>
            Cancelar
          </button>
          <button style={styles.btnSave} type="button" onClick={onSave} disabled={loading}>
            {loading ? 'Guardando...' : 'Guardar'}
          </button>
        </div>
      </div>
    </div>
  );
}

const styles = {
  overlay: {
    position: 'fixed',
    inset: 0,
    background: theme.colors.overlay,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    zIndex: 200,
    padding: 20,
  },
  modal: {
    background: theme.colors.panel,
    borderRadius: theme.radius.lg,
    width: 560,
    maxWidth: '100%',
    maxHeight: '88vh',
    display: 'flex',
    flexDirection: 'column',
    boxShadow: theme.shadow.modal,
    border: `1px solid ${theme.colors.border}`,
    overflow: 'hidden',
  },
  header: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    padding: '22px 24px 18px',
    borderBottom: `1px solid ${theme.colors.border}`,
    background: theme.colors.panelMuted,
  },
  eyebrow: {
    margin: 0,
    color: theme.colors.textSoft,
    fontSize: theme.typography.small,
    textTransform: 'uppercase',
    letterSpacing: 1,
    fontWeight: 700,
  },
  title: {
    margin: '6px 0 0',
    fontSize: 20,
    color: theme.colors.text,
    fontWeight: 800,
  },
  closeBtn: {
    background: theme.colors.panel,
    border: `1px solid ${theme.colors.border}`,
    borderRadius: theme.radius.sm,
    fontSize: 12,
    cursor: 'pointer',
    color: theme.colors.textMuted,
    fontWeight: 700,
    padding: '9px 12px',
  },
  body: {
    padding: '22px 24px',
    overflowY: 'auto',
    flex: 1,
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))',
    gap: 16,
  },
  field: {
    display: 'flex',
    flexDirection: 'column',
    gap: 6,
  },
  label: {
    fontWeight: 700,
    fontSize: theme.typography.label,
    color: theme.colors.textMuted,
  },
  input: {
    width: '100%',
    padding: '11px 12px',
    border: `1px solid ${theme.colors.borderStrong}`,
    borderRadius: theme.radius.sm,
    fontSize: theme.typography.body,
    boxSizing: 'border-box',
    background: theme.colors.panel,
    color: theme.colors.text,
    outline: 'none',
  },
  inputReadOnly: {
    background: theme.colors.panelMuted,
    color: theme.colors.textMuted,
  },
  textarea: {
    minHeight: 110,
    resize: 'vertical',
    gridColumn: '1 / -1',
  },
  footer: {
    padding: '16px 24px 22px',
    borderTop: `1px solid ${theme.colors.border}`,
    display: 'flex',
    justifyContent: 'flex-end',
    gap: 10,
    background: '#fcfdff',
  },
  btnCancel: {
    padding: '10px 18px',
    background: theme.colors.panelMuted,
    border: `1px solid ${theme.colors.border}`,
    borderRadius: theme.radius.sm,
    cursor: 'pointer',
    fontWeight: 700,
    color: theme.colors.textMuted,
  },
  btnSave: {
    padding: '10px 18px',
    background: theme.colors.brand,
    color: '#fff',
    border: 'none',
    borderRadius: theme.radius.sm,
    cursor: 'pointer',
    fontWeight: 700,
    boxShadow: theme.shadow.soft,
  },
};

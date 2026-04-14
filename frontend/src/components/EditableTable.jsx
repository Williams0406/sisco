import { useState } from 'react';
import { theme } from '../styles/tokens';

export default function EditableTable({
  columns,
  data,
  loading,
  onSave,
  onDelete,
  pkField,
  title,
}) {
  const [editingId, setEditingId] = useState(null);
  const [editValues, setEditValues] = useState({});
  const [newRow, setNewRow] = useState(null);
  const [saving, setSaving] = useState(false);

  const startEdit = (row) => {
    setEditingId(row[pkField]);
    setEditValues({ ...row });
    setNewRow(null);
  };

  const cancelEdit = () => {
    setEditingId(null);
    setEditValues({});
  };

  const saveEdit = async () => {
    setSaving(true);
    try {
      await onSave(editValues);
      setEditingId(null);
      setEditValues({});
    } catch (err) {
      alert(`Error al guardar: ${JSON.stringify(err.response?.data || err.message)}`);
    } finally {
      setSaving(false);
    }
  };

  const startNewRow = () => {
    const blank = {};
    columns.forEach((c) => {
      blank[c.key] = '';
    });
    setNewRow(blank);
    setEditingId(null);
    setEditValues({});
  };

  const cancelNew = () => setNewRow(null);

  const saveNew = async () => {
    setSaving(true);
    try {
      await onSave(newRow);
      setNewRow(null);
    } catch (err) {
      alert(`Error al guardar: ${JSON.stringify(err.response?.data || err.message)}`);
    } finally {
      setSaving(false);
    }
  };

  const renderCell = (col, row, isNew = false) => {
    const vals = isNew ? newRow : editValues;
    const setVals = isNew
      ? (k, v) => setNewRow((prev) => ({ ...prev, [k]: v }))
      : (k, v) => setEditValues((prev) => ({ ...prev, [k]: v }));

    const isEditing = isNew || editingId === row[pkField];

    if (!isEditing) {
      if (col.render) return col.render(row[col.key], row);
      return row[col.key] ?? '-';
    }

    if (col.type === 'select') {
      return (
        <select
          style={styles.cellInput}
          value={vals[col.key] ?? ''}
          onChange={(e) => setVals(col.key, e.target.value)}
        >
          <option value="">Seleccionar</option>
          {col.options?.map((option) => (
            <option key={option.value} value={option.value}>
              {option.label}
            </option>
          ))}
        </select>
      );
    }

    return (
      <input
        style={styles.cellInput}
        type={col.type || 'text'}
        value={vals[col.key] ?? ''}
        onChange={(e) => setVals(col.key, e.target.value)}
        placeholder={col.placeholder || ''}
        readOnly={col.readOnly}
      />
    );
  };

  return (
    <div style={styles.container}>
      <div style={styles.header}>
        <div>
          <h2 style={styles.title}>{title}</h2>
          <p style={styles.subtitle}>Administra registros sin salir del listado.</p>
        </div>
        <button style={styles.btnNew} type="button" onClick={startNewRow} disabled={newRow !== null}>
          + Nueva fila
        </button>
      </div>

      <div style={styles.tableWrapper}>
        <table style={styles.table}>
          <thead>
            <tr>
              {columns.map((col) => (
                <th key={col.key} style={{ ...styles.th, width: col.width }}>
                  {col.label}
                </th>
              ))}
              <th style={{ ...styles.th, width: 150 }}>Acciones</th>
            </tr>
          </thead>
          <tbody>
            {newRow && (
              <tr style={styles.rowNew}>
                {columns.map((col) => (
                  <td key={col.key} style={styles.td}>
                    {renderCell(col, newRow, true)}
                  </td>
                ))}
                <td style={styles.td}>
                  <button style={styles.btnSave} type="button" onClick={saveNew} disabled={saving}>
                    {saving ? 'Guardando' : 'Guardar'}
                  </button>
                  <button style={styles.btnCancel} type="button" onClick={cancelNew}>
                    Cancelar
                  </button>
                </td>
              </tr>
            )}

            {!loading && data.length === 0 && !newRow && (
              <tr>
                <td colSpan={columns.length + 1} style={styles.empty}>
                  No hay registros. Usa "Nueva fila" para comenzar.
                </td>
              </tr>
            )}

            {loading && (
              <tr>
                <td colSpan={columns.length + 1} style={styles.empty}>
                  Cargando informacion...
                </td>
              </tr>
            )}

            {!loading &&
              data.map((row, i) => (
                <tr
                  key={row[pkField] ?? i}
                  style={
                    editingId === row[pkField]
                      ? styles.rowEditing
                      : i % 2 === 0
                        ? styles.rowEven
                        : styles.rowOdd
                  }
                >
                  {columns.map((col) => (
                    <td key={col.key} style={styles.td}>
                      {renderCell(col, row)}
                    </td>
                  ))}
                  <td style={styles.td}>
                    {editingId === row[pkField] ? (
                      <>
                        <button style={styles.btnSave} type="button" onClick={saveEdit} disabled={saving}>
                          {saving ? 'Guardando' : 'Guardar'}
                        </button>
                        <button style={styles.btnCancel} type="button" onClick={cancelEdit}>
                          Cancelar
                        </button>
                      </>
                    ) : (
                      <>
                        <button style={styles.btnEdit} type="button" onClick={() => startEdit(row)}>
                          Editar
                        </button>
                        {onDelete && (
                          <button style={styles.btnDelete} type="button" onClick={() => onDelete(row)}>
                            Eliminar
                          </button>
                        )}
                      </>
                    )}
                  </td>
                </tr>
              ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

const styles = {
  container: {
    background: theme.colors.panel,
    borderRadius: theme.radius.lg,
    padding: 20,
    border: `1px solid ${theme.colors.border}`,
    boxShadow: theme.shadow.card,
  },
  header: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    gap: 16,
    marginBottom: 16,
  },
  title: {
    margin: 0,
    fontSize: 20,
    color: theme.colors.text,
    fontWeight: 800,
  },
  subtitle: {
    margin: '4px 0 0',
    fontSize: theme.typography.body,
    color: theme.colors.textMuted,
  },
  btnNew: {
    background: theme.colors.brand,
    color: '#fff',
    border: 'none',
    padding: '9px 18px',
    borderRadius: theme.radius.sm,
    cursor: 'pointer',
    fontWeight: 700,
    boxShadow: theme.shadow.soft,
  },
  tableWrapper: {
    overflowX: 'auto',
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
    textTransform: 'uppercase',
    letterSpacing: 0.4,
    fontSize: theme.typography.small,
  },
  td: {
    padding: '10px 12px',
    borderBottom: '1px solid #edf2f7',
    color: theme.colors.text,
    verticalAlign: 'middle',
  },
  rowEven: { background: theme.colors.panel },
  rowOdd: { background: '#fbfdff' },
  rowEditing: { background: theme.colors.brandTint },
  rowNew: { background: '#f5fbff' },
  empty: {
    textAlign: 'center',
    padding: 34,
    color: theme.colors.textMuted,
  },
  cellInput: {
    width: '100%',
    padding: '8px 10px',
    border: `1px solid ${theme.colors.borderStrong}`,
    borderRadius: theme.radius.sm,
    fontSize: theme.typography.body,
    background: theme.colors.panel,
    boxSizing: 'border-box',
    outline: 'none',
    minWidth: 100,
    color: theme.colors.text,
  },
  btnEdit: {
    background: theme.colors.panelMuted,
    border: `1px solid ${theme.colors.border}`,
    cursor: 'pointer',
    fontSize: 12,
    borderRadius: 8,
    padding: '6px 10px',
    color: theme.colors.text,
    fontWeight: 700,
    marginRight: 6,
  },
  btnDelete: {
    background: theme.colors.dangerTint,
    border: '1px solid #fecaca',
    cursor: 'pointer',
    fontSize: 12,
    borderRadius: 8,
    padding: '6px 10px',
    color: theme.colors.danger,
    fontWeight: 700,
  },
  btnSave: {
    background: theme.colors.success,
    color: '#fff',
    border: 'none',
    borderRadius: 8,
    padding: '7px 12px',
    cursor: 'pointer',
    fontSize: 12,
    fontWeight: 700,
    marginRight: 6,
  },
  btnCancel: {
    background: theme.colors.panelMuted,
    color: theme.colors.textMuted,
    border: `1px solid ${theme.colors.border}`,
    borderRadius: 8,
    padding: '7px 10px',
    cursor: 'pointer',
    fontSize: 12,
    fontWeight: 700,
  },
};

import { useState } from 'react';

export default function EditableTable({
  columns, data, loading, onSave, onDelete, pkField, title,
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
      alert('Error al guardar: ' + JSON.stringify(err.response?.data || err.message));
    } finally { setSaving(false); }
  };

  const startNewRow = () => {
    const blank = {};
    columns.forEach(c => { blank[c.key] = ''; });
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
      alert('Error al guardar: ' + JSON.stringify(err.response?.data || err.message));
    } finally { setSaving(false); }
  };

  const renderCell = (col, row, isNew = false) => {
    const vals    = isNew ? newRow : editValues;
    const setVals = isNew
      ? (k, v) => setNewRow(p => ({ ...p, [k]: v }))
      : (k, v) => setEditValues(p => ({ ...p, [k]: v }));

    const isEditing = isNew || editingId === row[pkField];

    if (!isEditing) {
      if (col.render) return col.render(row[col.key], row);
      return row[col.key] ?? '—';
    }

    if (col.type === 'select') {
      return (
        <select
          style={styles.cellInput}
          value={vals[col.key] ?? ''}
          onChange={e => setVals(col.key, e.target.value)}
        >
          <option value="">—</option>
          {col.options?.map(o => (
            <option key={o.value} value={o.value}>{o.label}</option>
          ))}
        </select>
      );
    }

    return (
      <input
        style={styles.cellInput}
        type={col.type || 'text'}
        value={vals[col.key] ?? ''}
        onChange={e => setVals(col.key, e.target.value)}
        placeholder={col.placeholder || ''}
        readOnly={col.readOnly && !isNew}
      />
    );
  };

  return (
    <div style={styles.container}>
      <div style={styles.header}>
        <h2 style={styles.title}>{title}</h2>
        <button style={styles.btnNew} onClick={startNewRow} disabled={newRow !== null}>
          + Nueva fila
        </button>
      </div>

      <div style={styles.tableWrapper}>
        <table style={styles.table}>
          <thead>
            <tr>
              {columns.map(col => (
                <th key={col.key} style={{ ...styles.th, width: col.width }}>
                  {col.label}
                </th>
              ))}
              <th style={{ ...styles.th, width: 110 }}>Acciones</th>
            </tr>
          </thead>
          <tbody>

            {/* Fila nueva */}
            {newRow && (
              <tr style={styles.rowNew}>
                {columns.map(col => (
                  <td key={col.key} style={styles.td}>
                    {renderCell(col, newRow, true)}
                  </td>
                ))}
                <td style={styles.td}>
                  <button style={styles.btnSave} onClick={saveNew} disabled={saving}>
                    {saving ? '...' : '💾'}
                  </button>
                  <button style={styles.btnCancel} onClick={cancelNew}>✕</button>
                </td>
              </tr>
            )}

            {/* Sin datos */}
            {!loading && data.length === 0 && !newRow && (
              <tr>
                <td colSpan={columns.length + 1} style={styles.empty}>
                  No hay registros. Haz clic en "+ Nueva fila" para comenzar.
                </td>
              </tr>
            )}

            {/* Cargando */}
            {loading && (
              <tr>
                <td colSpan={columns.length + 1} style={styles.empty}>
                  Cargando...
                </td>
              </tr>
            )}

            {/* Filas existentes */}
            {!loading && data.map((row, i) => (
              <tr
                key={row[pkField] ?? i}
                style={
                  editingId === row[pkField]
                    ? styles.rowEditing
                    : i % 2 === 0 ? styles.rowEven : styles.rowOdd
                }
              >
                {columns.map(col => (
                  <td key={col.key} style={styles.td}>
                    {renderCell(col, row)}
                  </td>
                ))}
                <td style={styles.td}>
                  {editingId === row[pkField] ? (
                    <>
                      <button style={styles.btnSave} onClick={saveEdit} disabled={saving}>
                        {saving ? '...' : '💾'}
                      </button>
                      <button style={styles.btnCancel} onClick={cancelEdit}>✕</button>
                    </>
                  ) : (
                    <>
                      <button style={styles.btnEdit} onClick={() => startEdit(row)}
                        title="Editar">✏️</button>
                      {onDelete && (
                        <button style={styles.btnDelete}
                          onClick={() => onDelete(row)} title="Eliminar">🗑️</button>
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
    background: '#fff', borderRadius: 10, padding: 20,
    boxShadow: '0 1px 4px rgba(0,0,0,0.08)',
  },
  header: {
    display: 'flex', justifyContent: 'space-between',
    alignItems: 'center', marginBottom: 16,
  },
  title:  { margin: 0, fontSize: 18, color: '#1f2937' },
  btnNew: {
    background: '#2563eb', color: '#fff', border: 'none',
    padding: '8px 18px', borderRadius: 6, cursor: 'pointer', fontWeight: 600,
  },
  tableWrapper: { overflowX: 'auto' },
  table: { width: '100%', borderCollapse: 'collapse', fontSize: 13 },
  th: {
    background: '#f9fafb', padding: '10px 10px', textAlign: 'left',
    fontWeight: 600, color: '#374151', borderBottom: '2px solid #e5e7eb',
    whiteSpace: 'nowrap',
  },
  td: { padding: '6px 8px', borderBottom: '1px solid #f3f4f6', color: '#4b5563' },
  rowEven:    { background: '#fff' },
  rowOdd:     { background: '#fafafa' },
  rowEditing: { background: '#eff6ff' },
  rowNew:     { background: '#f0fdf4' },
  empty: {
    textAlign: 'center', padding: 32,
    color: '#9ca3af', fontStyle: 'italic',
  },
  cellInput: {
    width: '100%', padding: '5px 8px', border: '1px solid #93c5fd',
    borderRadius: 4, fontSize: 12, background: '#fff',
    boxSizing: 'border-box', outline: 'none', minWidth: 80,
  },
  btnEdit:   { background: 'none', border: 'none', cursor: 'pointer', fontSize: 14, marginRight: 4 },
  btnDelete: { background: 'none', border: 'none', cursor: 'pointer', fontSize: 14 },
  btnSave: {
    background: '#059669', color: '#fff', border: 'none',
    borderRadius: 4, padding: '4px 10px', cursor: 'pointer',
    fontSize: 12, fontWeight: 600, marginRight: 4,
  },
  btnCancel: {
    background: '#f3f4f6', color: '#374151', border: '1px solid #d1d5db',
    borderRadius: 4, padding: '4px 8px', cursor: 'pointer', fontSize: 12,
  },
};

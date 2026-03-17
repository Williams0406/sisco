import { useState } from 'react';

export default function DataTable({
  columns,      // [{ key, label, render? }]
  data,         // array de objetos
  loading,
  onEdit,       // fn(row)
  onDelete,     // fn(row)
  onNew,        // fn()
  title,
}) {
  return (
    <div style={styles.container}>
      <div style={styles.header}>
        <h2 style={styles.title}>{title}</h2>
        {onNew && (
          <button style={styles.btnNew} onClick={onNew}>+ Nuevo</button>
        )}
      </div>
      <div style={styles.tableWrapper}>
        <table style={styles.table}>
          <thead>
            <tr>
              {columns.map((col) => (
                <th key={col.key} style={styles.th}>{col.label}</th>
              ))}
              {(onEdit || onDelete) && <th style={styles.th}>Acciones</th>}
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <tr>
                <td colSpan={columns.length + 1} style={styles.center}>
                  Cargando...
                </td>
              </tr>
            ) : data.length === 0 ? (
              <tr>
                <td colSpan={columns.length + 1} style={styles.center}>
                  No hay registros
                </td>
              </tr>
            ) : (
              data.map((row, i) => (
                <tr key={i} style={i % 2 === 0 ? styles.rowEven : styles.rowOdd}>
                  {columns.map((col) => (
                    <td key={col.key} style={styles.td}>
                      {col.render ? col.render(row[col.key], row) : row[col.key]}
                    </td>
                  ))}
                  {(onEdit || onDelete) && (
                    <td style={styles.td}>
                      {onEdit && (
                        <button style={styles.btnEdit}
                          onClick={() => onEdit(row)}>✏️</button>
                      )}
                      {onDelete && (
                        <button style={styles.btnDelete}
                          onClick={() => onDelete(row)}>🗑️</button>
                      )}
                    </td>
                  )}
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}

const styles = {
  container: { background: '#fff', borderRadius: 10, padding: 20, boxShadow: '0 1px 4px rgba(0,0,0,0.08)' },
  header: { display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 },
  title: { margin: 0, fontSize: 18, color: '#1f2937' },
  btnNew: { background: '#2563eb', color: '#fff', border: 'none', padding: '8px 18px', borderRadius: 6, cursor: 'pointer', fontWeight: 600 },
  tableWrapper: { overflowX: 'auto' },
  table: { width: '100%', borderCollapse: 'collapse', fontSize: 13 },
  th: { background: '#f9fafb', padding: '10px 12px', textAlign: 'left', fontWeight: 600, color: '#374151', borderBottom: '2px solid #e5e7eb' },
  td: { padding: '9px 12px', borderBottom: '1px solid #f3f4f6', color: '#4b5563' },
  rowEven: { background: '#fff' },
  rowOdd: { background: '#fafafa' },
  center: { textAlign: 'center', padding: 24, color: '#9ca3af' },
  btnEdit: { background: 'none', border: 'none', cursor: 'pointer', marginRight: 6, fontSize: 15 },
  btnDelete: { background: 'none', border: 'none', cursor: 'pointer', fontSize: 15 },
};
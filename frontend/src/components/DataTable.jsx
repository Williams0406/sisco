import { theme } from '../styles/tokens';

export default function DataTable({
  columns,
  data,
  loading,
  onEdit,
  onDelete,
  onNew,
  title,
  subtitle,
  onRowClick,
  getRowKey,
  selectedRowKey,
}) {
  const colSpan = columns.length + ((onEdit || onDelete) ? 1 : 0);

  return (
    <div style={styles.container}>
      <div style={styles.header}>
        <div>
          <h2 style={styles.title}>{title}</h2>
          {subtitle && <p style={styles.subtitle}>{subtitle}</p>}
        </div>
        <div style={styles.headerActions}>
          <span style={styles.counter}>{data.length} registro(s)</span>
          {onNew && (
            <button style={styles.btnNew} type="button" onClick={onNew}>
              + Nuevo
            </button>
          )}
        </div>
      </div>

      <div style={styles.tableWrapper}>
        <table style={styles.table}>
          <thead>
            <tr>
              {columns.map((col) => (
                <th key={col.key} style={styles.th}>
                  {col.label}
                </th>
              ))}
              {(onEdit || onDelete) && <th style={styles.th}>Acciones</th>}
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <tr>
                <td colSpan={colSpan} style={styles.center}>
                  <div style={styles.emptyState}>
                    <strong style={styles.emptyTitle}>Cargando informacion</strong>
                    <span style={styles.emptyText}>Estamos preparando los datos para ti.</span>
                  </div>
                </td>
              </tr>
            ) : data.length === 0 ? (
              <tr>
                <td colSpan={colSpan} style={styles.center}>
                  <div style={styles.emptyState}>
                    <strong style={styles.emptyTitle}>Sin resultados</strong>
                    <span style={styles.emptyText}>Ajusta tus filtros o crea un nuevo registro.</span>
                  </div>
                </td>
              </tr>
            ) : (
              data.map((row, i) => {
                const key = getRowKey ? getRowKey(row, i) : i;

                return (
                  <tr
                    key={key}
                    style={{
                      ...(i % 2 === 0 ? styles.rowEven : styles.rowOdd),
                      ...(selectedRowKey !== undefined && selectedRowKey === key ? styles.rowSelected : {}),
                      ...(onRowClick ? styles.rowClickable : {}),
                    }}
                    onClick={onRowClick ? () => onRowClick(row, i) : undefined}
                  >
                    {columns.map((col) => (
                      <td key={col.key} style={styles.td}>
                        {col.render ? col.render(row[col.key], row) : row[col.key]}
                      </td>
                    ))}
                    {(onEdit || onDelete) && (
                      <td style={styles.td}>
                        {onEdit && (
                          <button
                            style={styles.btnEdit}
                            type="button"
                            onClick={(e) => {
                              e.stopPropagation();
                              onEdit(row);
                            }}
                          >
                            Editar
                          </button>
                        )}
                        {onDelete && (
                          <button
                            style={styles.btnDelete}
                            type="button"
                            onClick={(e) => {
                              e.stopPropagation();
                              onDelete(row);
                            }}
                          >
                            Eliminar
                          </button>
                        )}
                      </td>
                    )}
                  </tr>
                );
              })
            )}
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
  headerActions: {
    display: 'flex',
    alignItems: 'center',
    gap: 10,
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
    background: theme.colors.panel,
    border: `1px solid ${theme.colors.border}`,
    borderRadius: theme.radius.md,
  },
  table: {
    width: '100%',
    background: theme.colors.panel,
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
    textTransform: 'uppercase',
    letterSpacing: 0.4,
    fontSize: theme.typography.small,
    whiteSpace: 'nowrap',
  },
  td: {
    padding: '12px 14px',
    borderBottom: '1px solid #edf2f7',
    color: theme.colors.text,
    verticalAlign: 'middle',
  },
  rowEven: { background: theme.colors.panel },
  rowOdd: { background: '#fbfdff' },
  rowSelected: { background: theme.colors.brandTint },
  rowClickable: { cursor: 'pointer' },
  center: { textAlign: 'center', padding: 0 },
  emptyState: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 6,
    padding: 36,
  },
  emptyTitle: {
    color: theme.colors.text,
    fontSize: theme.typography.body,
  },
  emptyText: {
    color: theme.colors.textMuted,
    fontSize: theme.typography.body,
  },
  btnEdit: {
    background: theme.colors.panelMuted,
    border: `1px solid ${theme.colors.border}`,
    cursor: 'pointer',
    marginRight: 6,
    fontSize: 12,
    borderRadius: 8,
    padding: '6px 10px',
    color: theme.colors.text,
    fontWeight: 700,
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
};

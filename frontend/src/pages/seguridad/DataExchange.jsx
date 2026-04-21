import { useEffect, useMemo, useState } from 'react';
import api from '../../api/axios';
import { theme } from '../../styles/tokens';

const FILE_ACCEPT = '.csv,.tsv,.txt,.xlsx,.xlsm,.zip';

const initialFeedback = {
  kind: null,
  message: '',
  results: [],
  warnings: [],
  errors: [],
  orderedTables: [],
  totals: null,
};

function parseFilename(headers, fallback) {
  const disposition = headers?.['content-disposition'] || headers?.['Content-Disposition'] || '';
  const match = disposition.match(/filename="([^"]+)"/i);
  return match?.[1] || fallback;
}

function toMessage(error, fallback) {
  if (error?.response?.data?.detail) return error.response.data.detail;
  if (error?.message) return error.message;
  return fallback;
}

function resultTotals(payload) {
  return {
    rows: payload.total_rows ?? 0,
    created: payload.total_created ?? 0,
    updated: payload.total_updated ?? 0,
  };
}

export default function DataExchange() {
  const [catalog, setCatalog] = useState({ tables: [], safe_order: [], import_formats: [], export_formats: [] });
  const [loadingCatalog, setLoadingCatalog] = useState(true);
  const [selectedTables, setSelectedTables] = useState([]);
  const [files, setFiles] = useState([]);
  const [runningImport, setRunningImport] = useState(false);
  const [runningExport, setRunningExport] = useState(false);
  const [feedback, setFeedback] = useState(initialFeedback);

  const fetchCatalog = async () => {
    setLoadingCatalog(true);
    try {
      const response = await api.get('/seguridad/data-sync/catalog/');
      setCatalog(response.data);
    } finally {
      setLoadingCatalog(false);
    }
  };

  useEffect(() => {
    fetchCatalog();
  }, []);

  const groupedTables = useMemo(() => {
    return catalog.tables.reduce((acc, table) => {
      acc[table.group] = [...(acc[table.group] || []), table];
      return acc;
    }, {});
  }, [catalog.tables]);

  const safeSelectionOrder = useMemo(() => {
    const selected = new Set(selectedTables);
    return (catalog.safe_order || []).filter((tableKey) => selected.has(tableKey));
  }, [catalog.safe_order, selectedTables]);

  const selectedRows = useMemo(() => {
    const selected = new Set(selectedTables);
    return catalog.tables.reduce((sum, table) => sum + (selected.has(table.key) ? table.row_count : 0), 0);
  }, [catalog.tables, selectedTables]);

  const importedFilesLabel = useMemo(() => files.map((file) => file.name), [files]);

  const toggleTable = (tableKey) => {
    setSelectedTables((prev) =>
      prev.includes(tableKey) ? prev.filter((value) => value !== tableKey) : [...prev, tableKey],
    );
  };

  const selectAllTables = () => {
    setSelectedTables(catalog.tables.map((table) => table.key));
  };

  const clearSelection = () => {
    setSelectedTables([]);
  };

  const runImport = async (dryRun) => {
    if (!files.length) {
      setFeedback({
        ...initialFeedback,
        kind: 'error',
        message: 'Selecciona al menos un archivo para continuar.',
      });
      return;
    }

    const formData = new FormData();
    files.forEach((file) => formData.append('files', file));
    formData.append('dry_run', String(dryRun));

    setRunningImport(true);
    try {
      const response = await api.post('/seguridad/data-sync/import/', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
      });

      setFeedback({
        kind: dryRun ? 'info' : 'success',
        message: dryRun ? 'La validacion termino sin errores.' : 'La importacion se completo correctamente.',
        results: response.data.results || [],
        warnings: response.data.warnings || [],
        errors: [],
        orderedTables: response.data.ordered_tables || [],
        totals: resultTotals(response.data),
      });

      if (!dryRun) {
        await fetchCatalog();
      }
    } catch (error) {
      setFeedback({
        kind: 'error',
        message: toMessage(error, 'No se pudo completar la importacion.'),
        results: [],
        warnings: error?.response?.data?.warnings || [],
        errors: error?.response?.data?.errors || [],
        orderedTables: [],
        totals: null,
      });
    } finally {
      setRunningImport(false);
    }
  };

  const runExport = async (format) => {
    if (!selectedTables.length) {
      setFeedback({
        ...initialFeedback,
        kind: 'error',
        message: 'Selecciona una o mas tablas para exportar.',
      });
      return;
    }

    setRunningExport(true);
    try {
      const response = await api.post(
        '/seguridad/data-sync/export/',
        { tables: selectedTables, format },
        { responseType: 'blob' },
      );

      const filename = parseFilename(response.headers, `sisco_export.${format === 'xlsx' ? 'xlsx' : format === 'zip-csv' ? 'zip' : 'csv'}`);
      const blob = new Blob([response.data], { type: response.headers?.['content-type'] || 'application/octet-stream' });
      const url = window.URL.createObjectURL(blob);
      const anchor = document.createElement('a');
      anchor.href = url;
      anchor.download = filename;
      document.body.appendChild(anchor);
      anchor.click();
      anchor.remove();
      window.URL.revokeObjectURL(url);

      setFeedback({
        kind: 'success',
        message: `Se genero la exportacion ${filename}.`,
        results: [],
        warnings: [],
        errors: [],
        orderedTables: safeSelectionOrder,
        totals: null,
      });
    } catch (error) {
      setFeedback({
        ...initialFeedback,
        kind: 'error',
        message: toMessage(error, 'No se pudo generar la exportacion.'),
      });
    } finally {
      setRunningExport(false);
    }
  };

  return (
    <div style={styles.page}>
      <section style={styles.hero}>
        <div>
          <p style={styles.eyebrow}>Seguridad · Migracion de datos</p>
          <h2 style={styles.heroTitle}>Importacion y exportacion para tablas legacy</h2>
          <p style={styles.heroText}>
            Carga archivos de la plataforma antigua por nombre de tabla o por hoja, y exporta lotes completos sin
            romper relaciones al respetar un orden seguro de dependencias.
          </p>
        </div>
        <div style={styles.heroStats}>
          <Metric label="Tablas soportadas" value={String(catalog.tables.length)} />
          <Metric label="Seleccionadas" value={String(selectedTables.length)} />
          <Metric label="Filas actuales" value={String(selectedRows)} highlight />
        </div>
      </section>

      <div style={styles.grid}>
        <section style={styles.panel}>
          <div style={styles.panelHeader}>
            <div>
              <p style={styles.panelEyebrow}>Importar</p>
              <h3 style={styles.panelTitle}>Lote desde CSV o Excel</h3>
              <p style={styles.panelText}>
                Usa nombres como `MAE_CLIENTE.csv`, `MOV_TICKET.csv` o un Excel con hojas llamadas igual que las tablas.
              </p>
            </div>
            <label style={styles.uploadButton}>
              Seleccionar archivos
              <input
                type="file"
                accept={FILE_ACCEPT}
                multiple
                style={{ display: 'none' }}
                onChange={(event) => setFiles(Array.from(event.target.files || []))}
              />
            </label>
          </div>

          <div style={styles.dropZone}>
            <strong style={styles.dropZoneTitle}>Archivos listos para procesar</strong>
            <span style={styles.dropZoneText}>
              CSV, TXT delimitado, Excel `.xlsx/.xlsm` y ZIP con varios archivos.
            </span>
            <div style={styles.fileList}>
              {importedFilesLabel.length === 0 && <span style={styles.fileChipMuted}>No hay archivos seleccionados</span>}
              {importedFilesLabel.map((name) => (
                <span key={name} style={styles.fileChip}>
                  {name}
                </span>
              ))}
            </div>
          </div>

          <div style={styles.actionRow}>
            <button
              type="button"
              style={styles.secondaryButton}
              disabled={runningImport}
              onClick={() => runImport(true)}
            >
              {runningImport ? 'Procesando...' : 'Validar lote'}
            </button>
            <button
              type="button"
              style={styles.primaryButton}
              disabled={runningImport}
              onClick={() => runImport(false)}
            >
              {runningImport ? 'Importando...' : 'Importar a base de datos'}
            </button>
          </div>

          <div style={styles.notes}>
            <InfoPill text="Las tablas se ordenan automaticamente para respetar dependencias." tone="info" />
            <InfoPill text="La carga usa insercion/actualizacion masiva para no disparar reglas historicas." tone="success" />
          </div>
        </section>

        <section style={styles.panel}>
          <div style={styles.panelHeader}>
            <div>
              <p style={styles.panelEyebrow}>Exportar</p>
              <h3 style={styles.panelTitle}>Seleccion de tablas</h3>
              <p style={styles.panelText}>
                Exporta una sola tabla a CSV o varios conjuntos a Excel/ZIP manteniendo encabezados legacy cuando existen.
              </p>
            </div>
            <div style={styles.inlineActions}>
              <button type="button" style={styles.ghostButton} onClick={selectAllTables}>
                Seleccionar todo
              </button>
              <button type="button" style={styles.ghostButton} onClick={clearSelection}>
                Limpiar
              </button>
            </div>
          </div>

          <div style={styles.groupList}>
            {loadingCatalog && <div style={styles.emptyState}>Cargando catalogo de tablas...</div>}
            {!loadingCatalog &&
              Object.entries(groupedTables).map(([group, tables]) => (
                <div key={group} style={styles.groupCard}>
                  <div style={styles.groupHeader}>
                    <strong style={styles.groupTitle}>{group}</strong>
                    <span style={styles.groupMeta}>{tables.length} tablas</span>
                  </div>
                  <div style={styles.tableList}>
                    {tables.map((table) => {
                      const checked = selectedTables.includes(table.key);
                      return (
                        <button
                          key={table.key}
                          type="button"
                          onClick={() => toggleTable(table.key)}
                          style={{
                            ...styles.tableButton,
                            ...(checked ? styles.tableButtonActive : {}),
                          }}
                        >
                          <div>
                            <strong style={styles.tableLabel}>{table.label}</strong>
                            <div style={styles.tableCode}>{table.key}</div>
                          </div>
                          <div style={styles.tableBadgeWrap}>
                            <span style={styles.tableCount}>{table.row_count}</span>
                            {checked && <span style={styles.tableSelected}>Seleccionada</span>}
                          </div>
                        </button>
                      );
                    })}
                  </div>
                </div>
              ))}
          </div>

          <div style={styles.safeOrderBox}>
            <strong style={styles.safeOrderTitle}>Orden seguro de exportacion/importacion</strong>
            <div style={styles.safeOrderRow}>
              {safeSelectionOrder.length === 0 && <span style={styles.fileChipMuted}>Selecciona tablas para ver el orden</span>}
              {safeSelectionOrder.map((tableKey) => (
                <span key={tableKey} style={styles.safeOrderChip}>
                  {tableKey}
                </span>
              ))}
            </div>
          </div>

          <div style={styles.actionRow}>
            <button
              type="button"
              style={styles.secondaryButton}
              disabled={runningExport || selectedTables.length !== 1}
              onClick={() => runExport('csv')}
            >
              {runningExport ? 'Generando...' : 'Exportar CSV'}
            </button>
            <button
              type="button"
              style={styles.secondaryButton}
              disabled={runningExport || selectedTables.length === 0}
              onClick={() => runExport('zip-csv')}
            >
              {runningExport ? 'Generando...' : 'Exportar ZIP CSV'}
            </button>
            <button
              type="button"
              style={styles.primaryButton}
              disabled={runningExport || selectedTables.length === 0}
              onClick={() => runExport('xlsx')}
            >
              {runningExport ? 'Generando...' : 'Exportar Excel'}
            </button>
          </div>
        </section>
      </div>

      <section
        style={{
          ...styles.feedbackPanel,
          ...(feedback.kind === 'error'
            ? styles.feedbackError
            : feedback.kind === 'success'
              ? styles.feedbackSuccess
              : feedback.kind === 'info'
                ? styles.feedbackInfo
                : {}),
        }}
      >
        <div style={styles.feedbackHeader}>
          <div>
            <p style={styles.panelEyebrow}>Resultado</p>
            <h3 style={styles.panelTitle}>Estado de la ultima operacion</h3>
          </div>
          {feedback.totals && (
            <div style={styles.feedbackMetrics}>
              <Metric label="Filas" value={String(feedback.totals.rows)} compact />
              <Metric label="Creados" value={String(feedback.totals.created)} compact />
              <Metric label="Actualizados" value={String(feedback.totals.updated)} compact />
            </div>
          )}
        </div>

        <p style={styles.feedbackMessage}>
          {feedback.message || 'Todavia no se ha ejecutado ninguna validacion, importacion o exportacion.'}
        </p>

        {feedback.orderedTables.length > 0 && (
          <div style={styles.feedbackBlock}>
            <strong style={styles.feedbackBlockTitle}>Orden aplicado</strong>
            <div style={styles.safeOrderRow}>
              {feedback.orderedTables.map((tableKey) => (
                <span key={tableKey} style={styles.safeOrderChip}>
                  {tableKey}
                </span>
              ))}
            </div>
          </div>
        )}

        {feedback.results.length > 0 && (
          <div style={styles.feedbackBlock}>
            <strong style={styles.feedbackBlockTitle}>Detalle por tabla</strong>
            <div style={styles.resultGrid}>
              {feedback.results.map((item) => (
                <div key={item.table} style={styles.resultCard}>
                  <div>
                    <strong style={styles.resultTitle}>{item.label}</strong>
                    <div style={styles.tableCode}>{item.table}</div>
                  </div>
                  <div style={styles.resultStats}>
                    <span>{item.rows} filas</span>
                    <span>{item.created} creados</span>
                    <span>{item.updated} actualizados</span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {feedback.warnings.length > 0 && (
          <div style={styles.feedbackBlock}>
            <strong style={styles.feedbackBlockTitle}>Advertencias</strong>
            {feedback.warnings.map((warning) => (
              <div key={warning} style={styles.warningItem}>
                {warning}
              </div>
            ))}
          </div>
        )}

        {feedback.errors.length > 0 && (
          <div style={styles.feedbackBlock}>
            <strong style={styles.feedbackBlockTitle}>Errores</strong>
            {feedback.errors.map((error) => (
              <div key={error} style={styles.errorItem}>
                {error}
              </div>
            ))}
          </div>
        )}
      </section>
    </div>
  );
}

function Metric({ label, value, highlight = false, compact = false }) {
  return (
    <div
      style={{
        ...styles.metricCard,
        ...(highlight ? styles.metricCardHighlight : {}),
        ...(compact ? styles.metricCardCompact : {}),
      }}
    >
      <span style={{ ...styles.metricLabel, ...(highlight ? styles.metricLabelHighlight : {}) }}>{label}</span>
      <strong style={{ ...styles.metricValue, ...(compact ? styles.metricValueCompact : {}) }}>{value}</strong>
    </div>
  );
}

function InfoPill({ text, tone }) {
  const toneStyles = tone === 'success' ? styles.infoPillSuccess : styles.infoPillInfo;
  return <span style={{ ...styles.infoPill, ...toneStyles }}>{text}</span>;
}

const card = {
  background: theme.colors.panel,
  borderRadius: theme.radius.lg,
  border: `1px solid ${theme.colors.border}`,
  boxShadow: theme.shadow.card,
};

const styles = {
  page: {
    display: 'flex',
    flexDirection: 'column',
    gap: 18,
  },
  hero: {
    ...card,
    padding: 24,
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))',
    gap: 18,
    background: 'linear-gradient(135deg, #e0f2fe 0%, #eff6ff 45%, #ffffff 100%)',
  },
  eyebrow: {
    margin: 0,
    color: '#0369a1',
    textTransform: 'uppercase',
    letterSpacing: 1,
    fontSize: theme.typography.small,
    fontWeight: 800,
  },
  heroTitle: {
    margin: '8px 0 0',
    fontSize: 28,
    color: theme.colors.text,
    fontWeight: 900,
  },
  heroText: {
    margin: '10px 0 0',
    color: theme.colors.textMuted,
    maxWidth: 760,
    lineHeight: 1.6,
  },
  heroStats: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(120px, 1fr))',
    gap: 10,
    alignSelf: 'start',
  },
  grid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(340px, 1fr))',
    gap: 18,
  },
  panel: {
    ...card,
    padding: 20,
    display: 'flex',
    flexDirection: 'column',
    gap: 16,
  },
  feedbackPanel: {
    ...card,
    padding: 20,
    display: 'flex',
    flexDirection: 'column',
    gap: 14,
  },
  feedbackSuccess: {
    borderColor: '#86efac',
    background: 'linear-gradient(180deg, #f0fdf4 0%, #ffffff 100%)',
  },
  feedbackError: {
    borderColor: '#fca5a5',
    background: 'linear-gradient(180deg, #fef2f2 0%, #ffffff 100%)',
  },
  feedbackInfo: {
    borderColor: '#93c5fd',
    background: 'linear-gradient(180deg, #eff6ff 0%, #ffffff 100%)',
  },
  panelHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    gap: 16,
    alignItems: 'flex-start',
  },
  feedbackHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    gap: 16,
    alignItems: 'flex-start',
  },
  panelEyebrow: {
    margin: 0,
    color: theme.colors.textSoft,
    textTransform: 'uppercase',
    letterSpacing: 1,
    fontSize: theme.typography.small,
    fontWeight: 800,
  },
  panelTitle: {
    margin: '6px 0 0',
    color: theme.colors.text,
    fontSize: 22,
    fontWeight: 800,
  },
  panelText: {
    margin: '8px 0 0',
    color: theme.colors.textMuted,
    lineHeight: 1.5,
  },
  uploadButton: {
    background: theme.colors.brand,
    color: '#fff',
    borderRadius: theme.radius.sm,
    padding: '11px 14px',
    fontWeight: 800,
    cursor: 'pointer',
    boxShadow: theme.shadow.soft,
    whiteSpace: 'nowrap',
  },
  dropZone: {
    padding: 18,
    borderRadius: theme.radius.md,
    border: '1px dashed #93c5fd',
    background: '#f8fbff',
    display: 'flex',
    flexDirection: 'column',
    gap: 10,
  },
  dropZoneTitle: {
    color: theme.colors.text,
    fontSize: 15,
  },
  dropZoneText: {
    color: theme.colors.textMuted,
    fontSize: theme.typography.body,
  },
  fileList: {
    display: 'flex',
    flexWrap: 'wrap',
    gap: 8,
  },
  fileChip: {
    padding: '8px 10px',
    borderRadius: theme.radius.pill,
    background: '#dbeafe',
    color: '#1d4ed8',
    fontWeight: 700,
    fontSize: theme.typography.body,
  },
  fileChipMuted: {
    padding: '8px 10px',
    borderRadius: theme.radius.pill,
    background: theme.colors.panelMuted,
    color: theme.colors.textMuted,
    fontWeight: 600,
    fontSize: theme.typography.body,
  },
  actionRow: {
    display: 'flex',
    flexWrap: 'wrap',
    gap: 10,
  },
  primaryButton: {
    background: theme.colors.brand,
    color: '#fff',
    border: 'none',
    borderRadius: theme.radius.sm,
    padding: '11px 16px',
    fontWeight: 800,
    cursor: 'pointer',
  },
  secondaryButton: {
    background: theme.colors.panelMuted,
    color: theme.colors.text,
    border: `1px solid ${theme.colors.borderStrong}`,
    borderRadius: theme.radius.sm,
    padding: '11px 16px',
    fontWeight: 800,
    cursor: 'pointer',
  },
  ghostButton: {
    background: 'transparent',
    color: theme.colors.textMuted,
    border: `1px solid ${theme.colors.border}`,
    borderRadius: theme.radius.sm,
    padding: '9px 12px',
    fontWeight: 700,
    cursor: 'pointer',
  },
  notes: {
    display: 'flex',
    flexWrap: 'wrap',
    gap: 8,
  },
  infoPill: {
    borderRadius: theme.radius.pill,
    padding: '8px 12px',
    fontSize: theme.typography.body,
    fontWeight: 700,
  },
  infoPillInfo: {
    background: '#eff6ff',
    color: '#1d4ed8',
  },
  infoPillSuccess: {
    background: '#ecfdf5',
    color: '#047857',
  },
  inlineActions: {
    display: 'flex',
    gap: 8,
    flexWrap: 'wrap',
  },
  groupList: {
    display: 'flex',
    flexDirection: 'column',
    gap: 12,
    maxHeight: 430,
    overflowY: 'auto',
    paddingRight: 4,
  },
  groupCard: {
    border: `1px solid ${theme.colors.border}`,
    borderRadius: theme.radius.md,
    padding: 14,
    background: theme.colors.panelMuted,
    display: 'flex',
    flexDirection: 'column',
    gap: 12,
  },
  groupHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    gap: 12,
  },
  groupTitle: {
    color: theme.colors.text,
  },
  groupMeta: {
    color: theme.colors.textMuted,
    fontSize: theme.typography.body,
  },
  tableList: {
    display: 'flex',
    flexDirection: 'column',
    gap: 8,
  },
  tableButton: {
    border: `1px solid ${theme.colors.border}`,
    background: '#fff',
    borderRadius: theme.radius.md,
    padding: 12,
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    gap: 12,
    cursor: 'pointer',
    textAlign: 'left',
  },
  tableButtonActive: {
    borderColor: '#60a5fa',
    background: '#eff6ff',
    boxShadow: 'inset 0 0 0 1px rgba(37, 99, 235, 0.1)',
  },
  tableLabel: {
    color: theme.colors.text,
  },
  tableCode: {
    color: theme.colors.textMuted,
    fontSize: theme.typography.small,
    marginTop: 3,
  },
  tableBadgeWrap: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'flex-end',
    gap: 6,
  },
  tableCount: {
    background: '#f1f5f9',
    color: theme.colors.textMuted,
    borderRadius: theme.radius.pill,
    padding: '5px 9px',
    fontSize: theme.typography.small,
    fontWeight: 800,
  },
  tableSelected: {
    color: '#2563eb',
    fontSize: theme.typography.small,
    fontWeight: 800,
  },
  safeOrderBox: {
    padding: 16,
    borderRadius: theme.radius.md,
    border: `1px solid ${theme.colors.border}`,
    background: '#fcfdff',
    display: 'flex',
    flexDirection: 'column',
    gap: 10,
  },
  safeOrderTitle: {
    color: theme.colors.text,
  },
  safeOrderRow: {
    display: 'flex',
    flexWrap: 'wrap',
    gap: 8,
  },
  safeOrderChip: {
    padding: '8px 10px',
    borderRadius: theme.radius.pill,
    background: '#e0f2fe',
    color: '#075985',
    fontSize: theme.typography.body,
    fontWeight: 800,
  },
  emptyState: {
    color: theme.colors.textMuted,
    padding: 20,
    textAlign: 'center',
  },
  metricCard: {
    borderRadius: theme.radius.md,
    padding: '14px 16px',
    background: '#ffffff',
    border: `1px solid ${theme.colors.border}`,
    display: 'flex',
    flexDirection: 'column',
    gap: 6,
  },
  metricCardHighlight: {
    background: '#eff6ff',
    borderColor: '#93c5fd',
  },
  metricCardCompact: {
    padding: '10px 12px',
    minWidth: 92,
  },
  metricLabel: {
    color: theme.colors.textMuted,
    fontSize: theme.typography.small,
    textTransform: 'uppercase',
    letterSpacing: 0.7,
    fontWeight: 800,
  },
  metricLabelHighlight: {
    color: '#1d4ed8',
  },
  metricValue: {
    color: theme.colors.text,
    fontSize: 24,
    fontWeight: 900,
  },
  metricValueCompact: {
    fontSize: 18,
  },
  feedbackMetrics: {
    display: 'flex',
    gap: 8,
    flexWrap: 'wrap',
  },
  feedbackMessage: {
    margin: 0,
    color: theme.colors.text,
    lineHeight: 1.5,
  },
  feedbackBlock: {
    display: 'flex',
    flexDirection: 'column',
    gap: 10,
  },
  feedbackBlockTitle: {
    color: theme.colors.text,
  },
  resultGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))',
    gap: 10,
  },
  resultCard: {
    border: `1px solid ${theme.colors.border}`,
    borderRadius: theme.radius.md,
    padding: 14,
    background: '#fff',
    display: 'flex',
    flexDirection: 'column',
    gap: 12,
  },
  resultTitle: {
    color: theme.colors.text,
  },
  resultStats: {
    display: 'flex',
    flexWrap: 'wrap',
    gap: 8,
    color: theme.colors.textMuted,
    fontSize: theme.typography.body,
    fontWeight: 700,
  },
  warningItem: {
    padding: '10px 12px',
    borderRadius: theme.radius.sm,
    background: '#fffbeb',
    color: '#92400e',
    border: '1px solid #fde68a',
  },
  errorItem: {
    padding: '10px 12px',
    borderRadius: theme.radius.sm,
    background: '#fef2f2',
    color: '#b91c1c',
    border: '1px solid #fecaca',
  },
};

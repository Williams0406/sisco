import { useEffect, useState } from 'react';
import api from '../../api/axios';
import EditableTable from '../../components/EditableTable';

export default function CierreTurno() {
  const [data, setData]           = useState([]);
  const [loading, setLoading]     = useState(true);
  const [selected, setSelected]   = useState(null);
  const [saving, setSaving]       = useState(false);
  const [isNew, setIsNew]         = useState(false);

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await api.get('/movimientos/cierres-turno/?page_size=200');
      setData(res.data.results || res.data);
    } finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  // ── Seleccionar fila ────────────────────────────────────────────────────
  const handleSelectRow = (row) => {
    setSelected({ ...row });
    setIsNew(false);
  };

  // ── Nuevo cierre en blanco ──────────────────────────────────────────────
  const handleNew = () => {
    setSelected({
      nu_codi_cierre: '',
      ch_esta_activo: '1',
      ch_tipo_cierre: 'T',
      dt_fech_turno: '',
      ch_codi_turno_caja: '',
      ch_codi_garita: '',
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
    setIsNew(true);
  };

  // ── Guardar detalle ─────────────────────────────────────────────────────
  const handleSave = async () => {
    setSaving(true);
    try {
      if (isNew) {
        const res = await api.post('/movimientos/cierres-turno/', selected);
        await fetchData();
        setSelected(res.data);
        setIsNew(false);
      } else {
        await api.put(`/movimientos/cierres-turno/${selected.nu_codi_cierre}/`, selected);
        await fetchData();
      }
      alert('Guardado correctamente');
    } catch (err) {
      alert('Error: ' + JSON.stringify(err.response?.data || err.message));
    } finally { setSaving(false); }
  };

  // ── Anular ──────────────────────────────────────────────────────────────
  const handleAnular = async () => {
    if (!confirm(`¿Anular cierre #${selected.nu_codi_cierre}?`)) return;
    try {
      await api.patch(
        `/movimientos/cierres-turno/${selected.nu_codi_cierre}/`,
        { ch_esta_activo: '0' }
      );
      fetchData();
      setSelected(prev => ({ ...prev, ch_esta_activo: '0' }));
    } catch (err) {
      alert('Error al anular');
    }
  };

  const set = (k, v) => setSelected(p => ({ ...p, [k]: v }));

  // ── Columnas de la tabla resumen ────────────────────────────────────────
  const COLUMNS_TABLA = [
    { key: 'ch_codi_garita',     label: 'Garita',  width: 80 },
    { key: 'nu_codi_cierre',     label: 'Código',  width: 80 },
    { key: 'dt_fech_turno',      label: 'Fecha',   width: 150,
      render: (v) => v ? new Date(v).toLocaleString('es-PE') : '—' },
    { key: 'ch_codi_turno_caja', label: 'Turno',   width: 80 },
    { key: 'ch_tipo_cierre',     label: 'Tipo',    width: 80,
      render: (v) => v === 'T' ? '🔄 Turno' : v === 'G' ? '📋 General' : v || '—' },
  ];

  // ── Margen calculado ────────────────────────────────────────────────────
  const margen = selected
    ? (parseFloat(selected.nu_impo_tota_ingr || 0) -
       parseFloat(selected.nu_impo_egre       || 0)).toFixed(3)
    : '—';

  return (
    <div style={styles.page}>

      {/* ══ Panel izquierdo — Tabla resumen ══════════════════════════════ */}
      <div style={styles.leftPanel}>
        <div style={styles.leftHeader}>
          <h2 style={styles.leftTitle}>Cierres de Turno</h2>
          <button style={styles.btnNew} onClick={handleNew}>+ Nuevo</button>
        </div>

        {/* Tabla clickeable */}
        <div style={styles.tableWrapper}>
          <table style={styles.table}>
            <thead>
              <tr>
                {COLUMNS_TABLA.map(col => (
                  <th key={col.key} style={{ ...styles.th, width: col.width }}>
                    {col.label}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {loading && (
                <tr>
                  <td colSpan={5} style={styles.empty}>Cargando...</td>
                </tr>
              )}
              {!loading && data.length === 0 && (
                <tr>
                  <td colSpan={5} style={styles.empty}>No hay cierres registrados</td>
                </tr>
              )}
              {!loading && data.map((row, i) => {
                const isSelected = selected && !isNew &&
                  selected.nu_codi_cierre === row.nu_codi_cierre;
                return (
                  <tr
                    key={row.nu_codi_cierre}
                    style={{
                      ...styles.tr,
                      ...(isSelected ? styles.trSelected : {}),
                      ...(i % 2 !== 0 && !isSelected ? styles.trOdd : {}),
                    }}
                    onClick={() => handleSelectRow(row)}
                  >
                    {COLUMNS_TABLA.map(col => (
                      <td key={col.key} style={styles.td}>
                        {col.render ? col.render(row[col.key], row) : (row[col.key] ?? '—')}
                      </td>
                    ))}
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>

      {/* ══ Panel derecho — Detalle ══════════════════════════════════════ */}
      <div style={styles.rightPanel}>
        {!selected ? (
          <div style={styles.placeholder}>
            <span style={styles.placeholderIcon}>📋</span>
            <p style={styles.placeholderText}>
              Selecciona un cierre de la lista<br />o haz clic en "+ Nuevo"
            </p>
          </div>
        ) : (
          <>
            {/* Encabezado del detalle */}
            <div style={styles.detailHeader}>
              <div>
                <h3 style={styles.detailTitle}>
                  {isNew ? '📋 Nuevo Cierre de Turno' : `📋 Cierre #${selected.nu_codi_cierre}`}
                </h3>
                {!isNew && (
                  <span style={{
                    ...styles.badge,
                    background: selected.ch_esta_activo === '1' ? '#059669' : '#dc2626',
                  }}>
                    {selected.ch_esta_activo === '1' ? '✅ Activo' : '❌ Anulado'}
                  </span>
                )}
              </div>
              <div style={styles.detailActions}>
                {!isNew && selected.ch_esta_activo === '1' && (
                  <button style={styles.btnAnular} onClick={handleAnular}>
                    🚫 Anular
                  </button>
                )}
                <button style={styles.btnSave} onClick={handleSave} disabled={saving}>
                  {saving ? 'Guardando...' : '💾 Guardar'}
                </button>
                <button style={styles.btnClose} onClick={() => setSelected(null)}>
                  ✕
                </button>
              </div>
            </div>

            {/* ── Sección 1: Identificación ── */}
            <div style={styles.section}>
              <p style={styles.sectionTitle}>Identificación</p>
              <div style={styles.grid3}>
                <Field label="Código"
                  value={selected.nu_codi_cierre}
                  readOnly />
                <Field label="Estado"
                  type="select"
                  value={selected.ch_esta_activo}
                  onChange={v => set('ch_esta_activo', v)}
                  options={[
                    { value: '1', label: 'Activo' },
                    { value: '0', label: 'Anulado' },
                  ]} />
                <Field label="Tipo Cierre"
                  type="select"
                  value={selected.ch_tipo_cierre}
                  onChange={v => set('ch_tipo_cierre', v)}
                  options={[
                    { value: 'T', label: 'Turno' },
                    { value: 'G', label: 'General' },
                  ]} />
                <Field label="Fecha de Turno"
                  type="datetime-local"
                  value={selected.dt_fech_turno
                    ? selected.dt_fech_turno.slice(0, 16) : ''}
                  onChange={v => set('dt_fech_turno', v)} />
                <Field label="Turno Caja"
                  value={selected.ch_codi_turno_caja}
                  onChange={v => set('ch_codi_turno_caja', v)}
                  placeholder="Ej: T1" />
                <Field label="Garita"
                  value={selected.ch_codi_garita}
                  onChange={v => set('ch_codi_garita', v)}
                  placeholder="Ej: G01" />
                <Field label="Cajero"
                  value={selected.ch_codi_cajero}
                  onChange={v => set('ch_codi_cajero', v)}
                  placeholder="Código cajero" />
                <Field label="Serie"
                  value={selected.ch_seri_cierre}
                  onChange={v => set('ch_seri_cierre', v)}
                  placeholder="Ej: CI01" />
                <Field label="Número"
                  value={selected.ch_nume_cierre}
                  onChange={v => set('ch_nume_cierre', v)}
                  placeholder="Ej: 0000001" />
              </div>
            </div>

            {/* ── Sección 2: Montos ── */}
            <div style={styles.section}>
              <p style={styles.sectionTitle}>Montos del Cierre</p>
              <div style={styles.grid2}>
                <AmountField label="💵 Efectivo"
                  color="#059669"
                  value={selected.nu_impo_tota_efectivo}
                  onChange={v => set('nu_impo_tota_efectivo', v)} />
                <AmountField label="📋 Crédito"
                  color="#2563eb"
                  value={selected.nu_impo_tota_credito}
                  onChange={v => set('nu_impo_tota_credito', v)} />
                <AmountField label="🧾 Total Turno"
                  color="#1f2937"
                  value={selected.nu_impo_total}
                  onChange={v => set('nu_impo_total', v)} />
                <AmountField label="💳 Cobranza Crédito"
                  color="#7c3aed"
                  value={selected.nu_impo_cobr_cred}
                  onChange={v => set('nu_impo_cobr_cred', v)} />
                <AmountField label="➕ Otro Ingreso"
                  color="#d97706"
                  value={selected.nu_impo_otro_ingr}
                  onChange={v => set('nu_impo_otro_ingr', v)} />
                <AmountField label="📈 Total Ingreso"
                  color="#059669"
                  value={selected.nu_impo_tota_ingr}
                  onChange={v => set('nu_impo_tota_ingr', v)} />
                <AmountField label="📉 Total Egreso"
                  color="#dc2626"
                  value={selected.nu_impo_egre}
                  onChange={v => set('nu_impo_egre', v)} />

                {/* Margen calculado automáticamente */}
                <div style={{ ...styles.amountCard, borderTop: `3px solid #0f172a` }}>
                  <span style={styles.amountLabel}>📊 Margen</span>
                  <span style={{
                    ...styles.amountValor,
                    color: parseFloat(margen) >= 0 ? '#059669' : '#dc2626',
                  }}>
                    S/ {margen}
                  </span>
                  <span style={styles.amountHint}>Calculado automáticamente</span>
                </div>
              </div>
            </div>

            {/* ── Sección 3: Observación ── */}
            <div style={styles.section}>
              <p style={styles.sectionTitle}>Observación</p>
              <textarea
                style={styles.textarea}
                rows={3}
                value={selected.vc_obse_cierre || ''}
                onChange={e => set('vc_obse_cierre', e.target.value)}
                placeholder="Ingrese observaciones del cierre..."
              />
            </div>
          </>
        )}
      </div>
    </div>
  );
}

// ── Subcomponentes ──────────────────────────────────────────────────────────

function Field({ label, value, onChange, type = 'text', placeholder, readOnly, options }) {
  return (
    <div style={fieldStyles.wrapper}>
      <label style={fieldStyles.label}>{label}</label>
      {type === 'select' ? (
        <select
          style={fieldStyles.input}
          value={value ?? ''}
          onChange={e => onChange(e.target.value)}
          disabled={readOnly}
        >
          <option value="">—</option>
          {options?.map(o => (
            <option key={o.value} value={o.value}>{o.label}</option>
          ))}
        </select>
      ) : (
        <input
          style={{ ...fieldStyles.input, background: readOnly ? '#f9fafb' : '#fff' }}
          type={type}
          value={value ?? ''}
          onChange={e => onChange && onChange(e.target.value)}
          placeholder={placeholder || ''}
          readOnly={readOnly}
        />
      )}
    </div>
  );
}

function AmountField({ label, value, onChange, color }) {
  return (
    <div style={{ ...styles.amountCard, borderTop: `3px solid ${color}` }}>
      <span style={styles.amountLabel}>{label}</span>
      <input
        style={{ ...styles.amountInput, color }}
        type="number"
        step="0.001"
        value={value ?? ''}
        onChange={e => onChange(e.target.value)}
        placeholder="0.000"
      />
      <span style={styles.amountCurrency}>S/</span>
    </div>
  );
}

// ── Estilos ─────────────────────────────────────────────────────────────────

const styles = {
  page: {
    display: 'flex', gap: 16, alignItems: 'flex-start', height: '100%',
  },

  // Panel izquierdo
  leftPanel: {
    width: 420, flexShrink: 0,
    background: '#fff', borderRadius: 10,
    boxShadow: '0 1px 4px rgba(0,0,0,0.08)',
    display: 'flex', flexDirection: 'column',
  },
  leftHeader: {
    display: 'flex', justifyContent: 'space-between', alignItems: 'center',
    padding: '16px 16px 12px',
  },
  leftTitle: { margin: 0, fontSize: 16, color: '#1f2937' },
  btnNew: {
    background: '#2563eb', color: '#fff', border: 'none',
    padding: '7px 16px', borderRadius: 6, cursor: 'pointer', fontWeight: 600, fontSize: 13,
  },
  tableWrapper: { overflowY: 'auto', maxHeight: 'calc(100vh - 200px)' },
  table: { width: '100%', borderCollapse: 'collapse', fontSize: 13 },
  th: {
    background: '#f9fafb', padding: '9px 10px', textAlign: 'left',
    fontWeight: 600, color: '#374151', borderBottom: '2px solid #e5e7eb',
    position: 'sticky', top: 0, whiteSpace: 'nowrap',
  },
  td: { padding: '8px 10px', borderBottom: '1px solid #f3f4f6', color: '#4b5563' },
  tr: { cursor: 'pointer', transition: 'background 0.1s' },
  trOdd: { background: '#fafafa' },
  trSelected: { background: '#eff6ff', fontWeight: 600 },
  empty: { textAlign: 'center', padding: 24, color: '#9ca3af', fontStyle: 'italic' },

  // Panel derecho
  rightPanel: {
    flex: 1, background: '#fff', borderRadius: 10,
    boxShadow: '0 1px 4px rgba(0,0,0,0.08)',
    padding: 20, minHeight: 400,
  },
  placeholder: {
    display: 'flex', flexDirection: 'column', alignItems: 'center',
    justifyContent: 'center', height: 300, color: '#9ca3af',
  },
  placeholderIcon: { fontSize: 48, marginBottom: 12 },
  placeholderText: { textAlign: 'center', fontSize: 14, lineHeight: 1.6 },

  // Detalle header
  detailHeader: {
    display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start',
    marginBottom: 20, paddingBottom: 16, borderBottom: '1px solid #e5e7eb',
  },
  detailTitle: { margin: '0 0 6px', fontSize: 17, color: '#1f2937' },
  badge: {
    display: 'inline-block', color: '#fff', fontSize: 11,
    fontWeight: 600, padding: '2px 10px', borderRadius: 12,
  },
  detailActions: { display: 'flex', gap: 8, alignItems: 'center' },
  btnSave: {
    background: '#2563eb', color: '#fff', border: 'none',
    padding: '8px 18px', borderRadius: 6, cursor: 'pointer',
    fontWeight: 600, fontSize: 13,
  },
  btnAnular: {
    background: '#dc2626', color: '#fff', border: 'none',
    padding: '8px 14px', borderRadius: 6, cursor: 'pointer',
    fontWeight: 600, fontSize: 13,
  },
  btnClose: {
    background: '#f3f4f6', color: '#374151', border: '1px solid #d1d5db',
    padding: '7px 12px', borderRadius: 6, cursor: 'pointer', fontSize: 14,
  },

  // Secciones
  section: { marginBottom: 20 },
  sectionTitle: {
    fontSize: 11, fontWeight: 700, color: '#6b7280',
    textTransform: 'uppercase', letterSpacing: 0.8,
    margin: '0 0 10px', paddingBottom: 6, borderBottom: '1px solid #f3f4f6',
  },
  grid3: {
    display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 10,
  },
  grid2: {
    display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 10,
  },

  // Montos
  amountCard: {
    background: '#f9fafb', borderRadius: 8, padding: '10px 14px',
    display: 'flex', flexDirection: 'column', position: 'relative',
  },
  amountLabel: {
    fontSize: 11, fontWeight: 600, color: '#6b7280',
    textTransform: 'uppercase', marginBottom: 4,
  },
  amountInput: {
    border: 'none', background: 'transparent', fontSize: 18,
    fontWeight: 700, width: '100%', outline: 'none',
    padding: 0,
  },
  amountValor: { fontSize: 18, fontWeight: 700 },
  amountCurrency: {
    position: 'absolute', top: 10, right: 14,
    fontSize: 11, color: '#9ca3af',
  },
  amountHint: {
    fontSize: 10, color: '#9ca3af', marginTop: 2,
  },

  // Textarea
  textarea: {
    width: '100%', border: '1px solid #d1d5db', borderRadius: 6,
    padding: '10px 12px', fontSize: 13, resize: 'vertical',
    fontFamily: 'inherit', boxSizing: 'border-box', outline: 'none',
  },
};

const fieldStyles = {
  wrapper: { display: 'flex', flexDirection: 'column', gap: 4 },
  label: { fontSize: 11, fontWeight: 600, color: '#6b7280', textTransform: 'uppercase' },
  input: {
    padding: '7px 10px', border: '1px solid #d1d5db', borderRadius: 6,
    fontSize: 13, outline: 'none', boxSizing: 'border-box', width: '100%',
  },
};
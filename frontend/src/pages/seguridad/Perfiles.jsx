import { useEffect, useMemo, useState } from 'react';
import api from '../../api/axios';
import { theme } from '../../styles/tokens';

const createEmptyForm = () => ({
  ch_codi_usuario: '',
  ch_codi_perfil: '',
  ch_nume_asigna: '001',
  ch_esta_perfil_usua: '1',
});

export default function Perfiles() {
  const [asignaciones, setAsignaciones] = useState([]);
  const [usuarios, setUsuarios] = useState([]);
  const [perfiles, setPerfiles] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [selectedKey, setSelectedKey] = useState(null);
  const [form, setForm] = useState(createEmptyForm());

  const fetchData = async () => {
    setLoading(true);
    try {
      const [aRes, uRes, pRes] = await Promise.all([
        api.get('/seguridad/perfil-usuario/?page_size=300'),
        api.get('/seguridad/usuarios/?page_size=300'),
        api.get('/seguridad/perfiles/?page_size=200'),
      ]);
      setAsignaciones(aRes.data.results || aRes.data);
      setUsuarios(uRes.data.results || uRes.data);
      setPerfiles(pRes.data.results || pRes.data);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const usuarioMap = useMemo(() => {
    const map = new Map();
    usuarios.forEach((user) => map.set(user.ch_codi_usuario, user));
    return map;
  }, [usuarios]);

  const rows = useMemo(
    () =>
      asignaciones.map((item, index) => {
        const usuario = usuarioMap.get(item.ch_codi_usuario) || {};
        return {
          ...item,
          rowKey: item.id,
          usuario_codigo: item.ch_codi_usuario,
          nombres: usuario.vc_desc_nomb_usuario || item.usuario_nombre || '-',
          apellido_paterno: usuario.vc_desc_apell_paterno || '-',
          perfil_nombre: item.perfil_nombre || item.ch_codi_perfil || '-',
          index: index + 1,
        };
      }),
    [asignaciones, usuarioMap],
  );

  const activas = useMemo(() => rows.filter((row) => row.ch_esta_perfil_usua === '1').length, [rows]);

  const handleNew = () => {
    setSelectedKey(null);
    setForm(createEmptyForm());
  };

  const handleSelect = (row) => {
    setSelectedKey(row.rowKey);
    setForm({
      ch_codi_usuario: row.ch_codi_usuario ?? '',
      ch_codi_perfil: row.ch_codi_perfil ?? '',
      ch_nume_asigna: row.ch_nume_asigna ?? '001',
      ch_esta_perfil_usua: row.ch_esta_perfil_usua ?? '1',
    });
  };

  const handleChange = (key, value) => {
    setForm((prev) => ({ ...prev, [key]: value }));
  };

  const handleSave = async () => {
    setSaving(true);
    try {
      if (selectedKey) {
        await api.put(`/seguridad/perfil-usuario/${selectedKey}/`, form);
      } else {
        await api.post('/seguridad/perfil-usuario/', form);
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
    if (!selectedKey) return;
    if (!confirm('Desactivar esta asignacion de perfil?')) return;

    await api.patch(`/seguridad/perfil-usuario/${selectedKey}/`, { ch_esta_perfil_usua: '0' });
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
              <h2 style={styles.title}>Asignacion de perfiles</h2>
              <p style={styles.subtitle}>Relaciona usuarios con perfiles de acceso de forma clara y rapida.</p>
            </div>
            <button style={styles.btnPrimary} type="button" onClick={handleNew}>
              + Nuevo
            </button>
          </div>

          <div style={styles.kpiRow}>
            <MetricCard label="Asignaciones" value={String(rows.length)} />
            <MetricCard label="Activas" value={String(activas)} highlight />
          </div>

          <div style={styles.tableWrapper}>
            <table style={styles.table}>
              <thead>
                <tr>
                  <th style={styles.th}>Usuario</th>
                  <th style={styles.th}>Perfil</th>
                  <th style={styles.th}>Nombres</th>
                  <th style={styles.th}>Apellido paterno</th>
                </tr>
              </thead>
              <tbody>
                {loading && (
                  <tr>
                    <td colSpan={4} style={styles.empty}>Cargando asignaciones...</td>
                  </tr>
                )}
                {!loading && rows.length === 0 && (
                  <tr>
                    <td colSpan={4} style={styles.empty}>No hay registros disponibles.</td>
                  </tr>
                )}
                {!loading && rows.map((row, index) => {
                  const selected = row.rowKey === selectedKey;
                  return (
                    <tr
                      key={row.rowKey}
                      onClick={() => handleSelect(row)}
                      style={{
                        ...styles.tr,
                        ...(index % 2 !== 0 && !selected ? styles.trOdd : {}),
                        ...(selected ? styles.trSelected : {}),
                      }}
                    >
                      <td style={styles.td}>{row.usuario_codigo || '-'}</td>
                      <td style={styles.td}>
                        <div style={styles.profileCell}>
                          <strong>{row.perfil_nombre}</strong>
                          <StatusBadge active={row.ch_esta_perfil_usua === '1'} label={row.ch_esta_perfil_usua === '1' ? 'Activo' : 'Inactivo'} />
                        </div>
                      </td>
                      <td style={styles.td}>{row.nombres}</td>
                      <td style={styles.td}>{row.apellido_paterno}</td>
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
              <h3 style={styles.formTitle}>Definir perfil</h3>
              <p style={styles.formSubtitle}>Asigna un perfil a un usuario y controla el estado de la relacion.</p>
            </div>
            {selectedKey && (
              <button style={styles.btnDanger} type="button" onClick={handleDelete}>
                Desactivar
              </button>
            )}
          </div>

          <div style={styles.section}>
            <p style={styles.sectionTitle}>Configuracion</p>
            <div style={styles.formGrid}>
              <Field
                label="Usuario"
                type="select"
                value={form.ch_codi_usuario}
                onChange={(v) => handleChange('ch_codi_usuario', v)}
                options={[
                  { value: '', label: 'Seleccionar' },
                  ...usuarios.map((user) => ({
                    value: user.ch_codi_usuario,
                    label: `${user.ch_codi_usuario} - ${user.vc_desc_nomb_usuario || ''}`,
                  })),
                ]}
              />
              <Field
                label="Perfil"
                type="select"
                value={form.ch_codi_perfil}
                onChange={(v) => handleChange('ch_codi_perfil', v)}
                options={[
                  { value: '', label: 'Seleccionar' },
                  ...perfiles.map((perfil) => ({
                    value: perfil.ch_codi_perfil,
                    label: perfil.vc_desc_perfil || perfil.ch_codi_perfil,
                  })),
                ]}
              />
              <Field label="Numero de asignacion" value={form.ch_nume_asigna} onChange={(v) => handleChange('ch_nume_asigna', v)} />
              <Field
                label="Estado"
                type="select"
                value={form.ch_esta_perfil_usua}
                onChange={(v) => handleChange('ch_esta_perfil_usua', v)}
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

function Field({ label, value, onChange, type = 'text', options = [] }) {
  return (
    <div style={styles.field}>
      <label style={styles.label}>{label}</label>
      {type === 'select' ? (
        <select style={styles.input} value={value ?? ''} onChange={(e) => onChange(e.target.value)}>
          {options.map((option) => (
            <option key={option.value} value={option.value}>{option.label}</option>
          ))}
        </select>
      ) : (
        <input style={styles.input} value={value ?? ''} onChange={(e) => onChange(e.target.value)} />
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
  return <span style={{ ...styles.badge, ...(active ? styles.badgeSuccess : styles.badgeMuted) }}>{label}</span>;
}

const cardBase = {
  background: theme.colors.panel,
  borderRadius: theme.radius.lg,
  border: `1px solid ${theme.colors.border}`,
  boxShadow: theme.shadow.card,
};

const styles = {
  page: { display: 'flex', flexDirection: 'column', gap: 16 },
  contentGrid: { display: 'grid', gridTemplateColumns: 'minmax(0, 1.1fr) minmax(320px, 0.9fr)', gap: 18, alignItems: 'start' },
  listPanel: { ...cardBase, padding: 20 },
  formPanel: { ...cardBase, padding: 20, position: 'sticky', top: 0 },
  panelHeader: { display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 12, marginBottom: 16 },
  formHeader: { display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 12, marginBottom: 18, paddingBottom: 16, borderBottom: `1px solid ${theme.colors.border}` },
  eyebrow: { margin: 0, color: theme.colors.textSoft, fontSize: theme.typography.small, textTransform: 'uppercase', letterSpacing: 1, fontWeight: 800 },
  title: { margin: '6px 0 0', fontSize: 22, color: theme.colors.text, fontWeight: 800 },
  subtitle: { margin: '6px 0 0', fontSize: theme.typography.body, color: theme.colors.textMuted },
  formTitle: { margin: '6px 0 0', fontSize: 20, color: theme.colors.text, fontWeight: 800 },
  formSubtitle: { margin: '6px 0 0', fontSize: theme.typography.body, color: theme.colors.textMuted },
  kpiRow: { display: 'grid', gridTemplateColumns: 'repeat(2, minmax(0, 1fr))', gap: 12, marginBottom: 16 },
  metricCard: { background: theme.colors.panelMuted, border: `1px solid ${theme.colors.border}`, borderRadius: theme.radius.md, padding: '14px 16px', display: 'flex', flexDirection: 'column', gap: 6 },
  metricCardHighlight: { background: '#f0fdf4', borderColor: '#bbf7d0' },
  metricLabel: { color: theme.colors.textMuted, fontSize: theme.typography.small, textTransform: 'uppercase', letterSpacing: 0.8, fontWeight: 700 },
  metricLabelHighlight: { color: theme.colors.success },
  metricValue: { color: theme.colors.text, fontSize: 24, fontWeight: 800 },
  metricValueHighlight: { color: theme.colors.success },
  tableWrapper: { overflow: 'auto', maxHeight: 'calc(100vh - 290px)', border: `1px solid ${theme.colors.border}`, borderRadius: theme.radius.md },
  table: { width: '100%', borderCollapse: 'collapse', fontSize: theme.typography.body },
  th: { background: theme.colors.panelMuted, padding: '12px 14px', textAlign: 'left', fontWeight: 700, color: theme.colors.textMuted, borderBottom: `1px solid ${theme.colors.border}`, whiteSpace: 'nowrap', position: 'sticky', top: 0, textTransform: 'uppercase', letterSpacing: 0.4, fontSize: theme.typography.small },
  td: { padding: '12px 14px', borderBottom: '1px solid #edf2f7', color: theme.colors.text, verticalAlign: 'middle' },
  tr: { cursor: 'pointer' },
  trOdd: { background: '#fbfdff' },
  trSelected: { background: theme.colors.brandTint },
  empty: { textAlign: 'center', padding: 28, color: theme.colors.textMuted },
  profileCell: { display: 'flex', alignItems: 'center', gap: 10, flexWrap: 'wrap' },
  badge: { display: 'inline-flex', alignItems: 'center', justifyContent: 'center', padding: '5px 10px', borderRadius: theme.radius.pill, fontSize: 12, fontWeight: 800 },
  badgeSuccess: { background: theme.colors.successTint, color: theme.colors.success },
  badgeMuted: { background: theme.colors.panelMuted, color: theme.colors.textMuted, border: `1px solid ${theme.colors.border}` },
  section: { marginBottom: 18, paddingBottom: 18, borderBottom: `1px solid ${theme.colors.border}` },
  sectionTitle: { margin: '0 0 12px', fontSize: theme.typography.small, fontWeight: 800, color: theme.colors.textSoft, textTransform: 'uppercase', letterSpacing: 0.8 },
  formGrid: { display: 'grid', gridTemplateColumns: '1fr', gap: 14 },
  field: { display: 'flex', flexDirection: 'column', gap: 6 },
  label: { fontSize: theme.typography.label, fontWeight: 700, color: theme.colors.textMuted },
  input: { width: '100%', boxSizing: 'border-box', padding: '11px 12px', border: `1px solid ${theme.colors.borderStrong}`, borderRadius: theme.radius.sm, fontSize: theme.typography.body, color: theme.colors.text, background: theme.colors.panel, outline: 'none' },
  footer: { display: 'flex', justifyContent: 'flex-end', gap: 10, paddingTop: 4 },
  btnPrimary: { background: theme.colors.brand, color: '#fff', border: 'none', padding: '10px 18px', borderRadius: theme.radius.sm, cursor: 'pointer', fontWeight: 700, boxShadow: theme.shadow.soft },
  btnSecondary: { background: theme.colors.panelMuted, color: theme.colors.textMuted, border: `1px solid ${theme.colors.border}`, padding: '10px 18px', borderRadius: theme.radius.sm, cursor: 'pointer', fontWeight: 700 },
  btnDanger: { background: theme.colors.dangerTint, color: theme.colors.danger, border: '1px solid #fecaca', padding: '10px 14px', borderRadius: theme.radius.sm, cursor: 'pointer', fontWeight: 700 },
};

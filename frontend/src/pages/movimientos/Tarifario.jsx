import { useEffect, useMemo, useState } from 'react';
import api from '../../api/axios';
import EditableTable from '../../components/EditableTable';
import { theme } from '../../styles/tokens';

const formatMoney = (value) => {
  const amount = Number(value);
  return Number.isFinite(amount) ? `S/ ${amount.toFixed(3)}` : '-';
};

export default function Tarifario() {
  const [tarifas, setTarifas] = useState([]);
  const [tiposVeh, setTiposVeh] = useState([]);
  const [configTurno, setConfigTurno] = useState({
    nu_codi_config_turno: '',
    tm_hora_inicio_dia: '07:00',
    tm_hora_fin_dia: '19:00',
    tm_hora_inicio_noche: '19:00',
    tm_hora_fin_noche: '07:00',
    ch_esta_activo: '1',
  });
  const [loading, setLoading] = useState(true);
  const [savingConfig, setSavingConfig] = useState(false);

  const fetchAll = async () => {
    setLoading(true);
    try {
      const [tRes, tvRes, cRes] = await Promise.all([
        api.get('/movimientos/tarifario/?page_size=200'),
        api.get('/maestros/tipo-vehiculos/?page_size=100'),
        api.get('/movimientos/config-turnos/?page_size=10'),
      ]);
      setTarifas(tRes.data.results || tRes.data);
      setTiposVeh(tvRes.data.results || tvRes.data);

      const configs = cRes.data.results || cRes.data || [];
      if (configs.length > 0) {
        const first = configs[0];
        setConfigTurno({
          nu_codi_config_turno: first.nu_codi_config_turno,
          tm_hora_inicio_dia: first.tm_hora_inicio_dia || '07:00',
          tm_hora_fin_dia: first.tm_hora_fin_dia || '19:00',
          tm_hora_inicio_noche: first.tm_hora_inicio_noche || '19:00',
          tm_hora_fin_noche: first.tm_hora_fin_noche || '07:00',
          ch_esta_activo: first.ch_esta_activo || '1',
        });
      }
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchAll();
  }, []);

  const tarifasActivas = useMemo(() => tarifas.filter((t) => t.ch_esta_activo === '1').length, [tarifas]);

  const columns = useMemo(
    () => [
      { key: 'ch_codi_tarifario', label: 'Codigo', placeholder: 'Auto', width: 90, readOnly: true },
      {
        key: 'ch_tipo_cmprbnt',
        label: 'Tipo Comprobante',
        type: 'select',
        width: 130,
        options: [
          { value: '', label: 'Ninguno' },
          { value: 'BO', label: 'Boleta' },
          { value: 'FA', label: 'Factura' },
        ],
        render: (v) => (v === 'BO' ? 'Boleta' : v === 'FA' ? 'Factura' : '-'),
      },
      {
        key: 'ch_tipo_vehiculo',
        label: 'Tipo Vehiculo',
        type: 'select',
        width: 140,
        options: tiposVeh.map((t) => ({ value: t.ch_tipo_vehiculo, label: t.vc_desc_tipo_vehiculo })),
        render: (_, row) => row.tipo_vehiculo_desc || row.ch_tipo_vehiculo || '-',
      },
      {
        key: 'nu_nume_hora_tlrnc',
        label: 'Tolerancia (h)',
        type: 'number',
        width: 110,
        placeholder: '0',
        render: (v) => (v != null && v !== '' ? `${v} h` : '-'),
      },
      {
        key: 'nu_impo_dia',
        label: 'T.Completo Dia',
        type: 'number',
        width: 130,
        placeholder: '0.000',
        render: (v) => formatMoney(v),
      },
      {
        key: 'nu_impo_noche',
        label: 'T.Completo Noche',
        type: 'number',
        width: 135,
        placeholder: '0.000',
        render: (v) => formatMoney(v),
      },
      {
        key: 'nu_nume_hora_frccn',
        label: 'Limite Fraccion (h)',
        type: 'number',
        width: 145,
        placeholder: '0',
        render: (v) => (v != null && v !== '' ? `${v} h` : '-'),
      },
      {
        key: 'nu_impo_frccn_dia',
        label: 'Fraccion Dia',
        type: 'number',
        width: 125,
        placeholder: '0.000',
        render: (v) => formatMoney(v),
      },
      {
        key: 'nu_impo_frccn_noche',
        label: 'Fraccion Noche',
        type: 'number',
        width: 135,
        placeholder: '0.000',
        render: (v) => formatMoney(v),
      },
      {
        key: 'ch_esta_activo',
        label: 'Estado',
        type: 'select',
        width: 90,
        options: [
          { value: '1', label: 'Activo' },
          { value: '0', label: 'Inactivo' },
        ],
        render: (v) => (v === '1' ? 'Activo' : 'Inactivo'),
      },
    ],
    [tiposVeh],
  );

  const handleSaveTarifa = async (row) => {
    const payload = { ...row };
    delete payload.tipo_vehiculo_desc;
    delete payload.cliente_desc;

    const existe = tarifas.find((t) => t.ch_codi_tarifario === row.ch_codi_tarifario);
    if (row.ch_codi_tarifario && existe) {
      await api.put(`/movimientos/tarifario/${row.ch_codi_tarifario}/`, payload);
    } else {
      delete payload.ch_codi_tarifario;
      await api.post('/movimientos/tarifario/', payload);
    }
    fetchAll();
  };

  const handleDeleteTarifa = async (row) => {
    if (!confirm(`Eliminar tarifa "${row.ch_codi_tarifario}"?`)) return;
    await api.delete(`/movimientos/tarifario/${row.ch_codi_tarifario}/`);
    fetchAll();
  };

  const handleSaveConfig = async () => {
    setSavingConfig(true);
    try {
      const payload = {
        ...configTurno,
        ch_esta_activo: '1',
      };

      if (configTurno.nu_codi_config_turno) {
        await api.put(`/movimientos/config-turnos/${configTurno.nu_codi_config_turno}/`, payload);
      } else {
        const res = await api.post('/movimientos/config-turnos/', payload);
        setConfigTurno((prev) => ({ ...prev, nu_codi_config_turno: res.data.nu_codi_config_turno }));
      }
      await fetchAll();
    } finally {
      setSavingConfig(false);
    }
  };

  return (
    <div style={styles.page}>
      <section style={styles.heroCard}>
        <div>
          <p style={styles.eyebrow}>Movimientos</p>
          <h1 style={styles.title}>Tarifario</h1>
          <p style={styles.subtitle}>Define los horarios globales de turno y administra el detalle de tarifas por tipo de vehiculo y comprobante.</p>
        </div>
      </section>

      <section style={styles.metricsGrid}>
        <MetricCard label="Tarifas" value={String(tarifas.length)} />
        <MetricCard label="Activas" value={String(tarifasActivas)} />
        <MetricCard label="Turno global" value={`${configTurno.tm_hora_inicio_dia || '--:--'} / ${configTurno.tm_hora_inicio_noche || '--:--'}`} highlight />
      </section>

      <section style={styles.configCard}>
        <div style={styles.cardHeader}>
          <div>
            <h2 style={styles.sectionTitle}>Horario de turnos</h2>
            <p style={styles.sectionSubtitle}>Estos horarios se aplican globalmente al calculo automatico de todos los tickets.</p>
          </div>
        </div>

        <div style={styles.configGrid}>
          <Field label="Inicio turno dia" type="time" value={configTurno.tm_hora_inicio_dia} onChange={(v) => setConfigTurno((p) => ({ ...p, tm_hora_inicio_dia: v }))} />
          <Field label="Fin turno dia" type="time" value={configTurno.tm_hora_fin_dia} onChange={(v) => setConfigTurno((p) => ({ ...p, tm_hora_fin_dia: v }))} />
          <Field label="Inicio turno noche" type="time" value={configTurno.tm_hora_inicio_noche} onChange={(v) => setConfigTurno((p) => ({ ...p, tm_hora_inicio_noche: v }))} />
          <Field label="Fin turno noche" type="time" value={configTurno.tm_hora_fin_noche} onChange={(v) => setConfigTurno((p) => ({ ...p, tm_hora_fin_noche: v }))} />
        </div>

        <div style={styles.actionsRow}>
          <button style={styles.btnPrimary} type="button" onClick={handleSaveConfig} disabled={savingConfig}>
            {savingConfig ? 'Guardando...' : 'Guardar horarios'}
          </button>
        </div>
      </section>

      <section style={styles.tableCard}>
        <div style={styles.cardHeader}>
          <div>
            <h2 style={styles.sectionTitle}>Detalle de tarifas</h2>
            <p style={styles.sectionSubtitle}>La tabla vuelve a enfocarse en comprobante, tipo de vehiculo, importes, fraccion y tolerancia.</p>
          </div>
        </div>

        <EditableTable
          title=""
          columns={columns}
          data={tarifas}
          loading={loading}
          pkField="ch_codi_tarifario"
          onSave={handleSaveTarifa}
          onDelete={handleDeleteTarifa}
        />
      </section>
    </div>
  );
}

function Field({ label, value, onChange, type = 'text' }) {
  return (
    <div style={styles.field}>
      <label style={styles.label}>{label}</label>
      <input style={styles.input} type={type} value={value || ''} onChange={(e) => onChange(e.target.value)} />
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

const card = {
  background: theme.colors.panel,
  borderRadius: theme.radius.lg,
  border: `1px solid ${theme.colors.border}`,
  boxShadow: theme.shadow.card,
};

const styles = {
  page: { display: 'flex', flexDirection: 'column', gap: 18 },
  heroCard: { ...card, padding: 22 },
  eyebrow: { margin: 0, color: theme.colors.textSoft, fontSize: theme.typography.small, textTransform: 'uppercase', letterSpacing: 1, fontWeight: 800 },
  title: { margin: '6px 0 0', fontSize: 26, fontWeight: 900, color: theme.colors.text },
  subtitle: { margin: '8px 0 0', fontSize: theme.typography.body, color: theme.colors.textMuted, maxWidth: 780 },
  metricsGrid: { display: 'grid', gridTemplateColumns: 'repeat(3, minmax(0, 1fr))', gap: 12 },
  metricCard: { ...card, padding: '16px 18px', display: 'flex', flexDirection: 'column', gap: 6 },
  metricCardHighlight: { background: theme.colors.brandTint, borderColor: '#bfdbfe' },
  metricLabel: { color: theme.colors.textMuted, fontSize: theme.typography.small, textTransform: 'uppercase', letterSpacing: 0.8, fontWeight: 700 },
  metricLabelHighlight: { color: theme.colors.brandDark },
  metricValue: { color: theme.colors.text, fontSize: 24, fontWeight: 800 },
  metricValueHighlight: { color: theme.colors.brandDark },
  configCard: { ...card, padding: 20 },
  tableCard: { ...card, padding: 20 },
  cardHeader: { display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 12, marginBottom: 16 },
  sectionTitle: { margin: 0, fontSize: 20, color: theme.colors.text, fontWeight: 800 },
  sectionSubtitle: { margin: '6px 0 0', color: theme.colors.textMuted, fontSize: theme.typography.body },
  configGrid: { display: 'grid', gridTemplateColumns: 'repeat(4, minmax(0, 1fr))', gap: 14 },
  field: { display: 'flex', flexDirection: 'column', gap: 6 },
  label: { fontSize: theme.typography.label, fontWeight: 700, color: theme.colors.textMuted },
  input: { width: '100%', boxSizing: 'border-box', padding: '11px 12px', border: `1px solid ${theme.colors.borderStrong}`, borderRadius: theme.radius.sm, fontSize: theme.typography.body, color: theme.colors.text, background: theme.colors.panel, outline: 'none' },
  actionsRow: { display: 'flex', justifyContent: 'flex-end', marginTop: 16 },
  btnPrimary: { background: theme.colors.brand, color: '#fff', border: 'none', padding: '10px 18px', borderRadius: theme.radius.sm, cursor: 'pointer', fontWeight: 700, boxShadow: theme.shadow.soft },
};

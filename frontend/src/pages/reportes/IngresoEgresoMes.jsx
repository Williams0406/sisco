import { useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';

const COLUMNS_INGRESO = [
  { key: 'nu_codi_recibo',    label: '# Recibo' },
  { key: 'dt_fech_ingr',      label: 'Fecha',
    render: (v) => v ? new Date(v).toLocaleDateString('es-PE') : '—' },
  { key: 'tipo_ingreso_desc', label: 'Tipo' },
  { key: 'cliente_desc',      label: 'Cliente' },
  { key: 'nu_impo_ingr',      label: 'Importe',
    render: (v) => v ? `S/ ${parseFloat(v).toFixed(2)}` : '—' },
];

const COLUMNS_EGRESO = [
  { key: 'nu_codi_recibo',   label: '# Recibo' },
  { key: 'dt_fech_egre',     label: 'Fecha',
    render: (v) => v ? new Date(v).toLocaleDateString('es-PE') : '—' },
  { key: 'tipo_egreso_desc', label: 'Tipo' },
  { key: 'proveedor_desc',   label: 'Proveedor' },
  { key: 'nu_impo_egre',     label: 'Importe',
    render: (v) => v ? `S/ ${parseFloat(v).toFixed(2)}` : '—' },
];

const MESES = [
  { value: '1', label: 'Enero' },   { value: '2',  label: 'Febrero' },
  { value: '3', label: 'Marzo' },   { value: '4',  label: 'Abril' },
  { value: '5', label: 'Mayo' },    { value: '6',  label: 'Junio' },
  { value: '7', label: 'Julio' },   { value: '8',  label: 'Agosto' },
  { value: '9', label: 'Septiembre' }, { value: '10', label: 'Octubre' },
  { value: '11', label: 'Noviembre' }, { value: '12', label: 'Diciembre' },
];

export default function IngresoEgresoMes() {
  const anioActual = new Date().getFullYear();
  const mesActual  = String(new Date().getMonth() + 1);

  const [ingresos, setIngresos]   = useState([]);
  const [egresos, setEgresos]     = useState([]);
  const [loading, setLoading]     = useState(false);
  const [resumen, setResumen]     = useState(null);
  const [tab, setTab]             = useState('ingresos');
  const [filtros, setFiltros]     = useState({
    anio: String(anioActual), mes: mesActual, garita: '',
  });

  const handleBuscar = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (filtros.anio)   params.append('anio',   filtros.anio);
      if (filtros.mes)    params.append('mes',    filtros.mes);
      if (filtros.garita) params.append('garita', filtros.garita);
      const res = await api.get(`/reportes/ingreso-egreso-mes/?${params}`);
      setIngresos(res.data.ingresos  || []);
      setEgresos(res.data.egresos    || []);
      setResumen({
        total_ingresos: res.data.total_ingresos,
        total_egresos:  res.data.total_egresos,
        utilidad:       res.data.utilidad,
      });
    } finally { setLoading(false); }
  };

  const set = (k, v) => setFiltros(p => ({ ...p, [k]: v }));

  const anios = Array.from({ length: 5 }, (_, i) => String(anioActual - i));

  return (
    <div>
      {/* Filtros */}
      <div style={styles.card}>
        <h3 style={styles.cardTitle}>🔍 Filtros — Ingresos y Egresos por Mes</h3>
        <div style={styles.row}>
          <div style={styles.col}>
            <label style={styles.label}>Año</label>
            <select style={styles.input} value={filtros.anio}
              onChange={e => set('anio', e.target.value)}>
              {anios.map(a => <option key={a} value={a}>{a}</option>)}
            </select>
          </div>
          <div style={styles.col}>
            <label style={styles.label}>Mes</label>
            <select style={styles.input} value={filtros.mes}
              onChange={e => set('mes', e.target.value)}>
              <option value="">— Todos —</option>
              {MESES.map(m => <option key={m.value} value={m.value}>{m.label}</option>)}
            </select>
          </div>
          <div style={styles.col}>
            <label style={styles.label}>&nbsp;</label>
            <button style={styles.btnBuscar} onClick={handleBuscar}>
              🔍 Generar Reporte
            </button>
          </div>
        </div>

        {/* Tarjetas de resumen */}
        {resumen && (
          <div style={styles.totalesRow}>
            <div style={{ ...styles.totalBox, background: '#059669' }}>
              <span style={{ ...styles.totalLabel, color: '#a7f3d0' }}>Total Ingresos</span>
              <span style={{ ...styles.totalValor, color: '#fff' }}>
                S/ {parseFloat(resumen.total_ingresos || 0).toFixed(2)}
              </span>
            </div>
            <div style={{ ...styles.totalBox, background: '#dc2626' }}>
              <span style={{ ...styles.totalLabel, color: '#fecaca' }}>Total Egresos</span>
              <span style={{ ...styles.totalValor, color: '#fff' }}>
                S/ {parseFloat(resumen.total_egresos || 0).toFixed(2)}
              </span>
            </div>
            <div style={{
              ...styles.totalBox,
              background: resumen.utilidad >= 0 ? '#2563eb' : '#7c3aed',
            }}>
              <span style={{ ...styles.totalLabel, color: '#bfdbfe' }}>Utilidad Neta</span>
              <span style={{ ...styles.totalValor, color: '#fff' }}>
                S/ {parseFloat(resumen.utilidad || 0).toFixed(2)}
              </span>
            </div>
          </div>
        )}
      </div>

      {/* Tabs Ingresos / Egresos */}
      {(ingresos.length > 0 || egresos.length > 0) && (
        <>
          <div style={styles.tabs}>
            <button
              style={{ ...styles.tab, ...(tab === 'ingresos' ? styles.tabActive : {}) }}
              onClick={() => setTab('ingresos')}>
              💰 Ingresos ({ingresos.length})
            </button>
            <button
              style={{ ...styles.tab, ...(tab === 'egresos' ? styles.tabActive : {}) }}
              onClick={() => setTab('egresos')}>
              💸 Egresos ({egresos.length})
            </button>
          </div>

          {tab === 'ingresos' && (
            <DataTable
              title="Detalle de Ingresos"
              columns={COLUMNS_INGRESO}
              data={ingresos}
              loading={loading}
            />
          )}
          {tab === 'egresos' && (
            <DataTable
              title="Detalle de Egresos"
              columns={COLUMNS_EGRESO}
              data={egresos}
              loading={loading}
            />
          )}
        </>
      )}
    </div>
  );
}

const styles = {
  card: { background: '#fff', borderRadius: 10, padding: '18px 24px',
    marginBottom: 16, boxShadow: '0 1px 4px rgba(0,0,0,0.08)' },
  cardTitle: { margin: '0 0 16px', fontSize: 15, color: '#1f2937' },
  row: { display: 'flex', gap: 16, flexWrap: 'wrap', alignItems: 'flex-end' },
  col: { display: 'flex', flexDirection: 'column', gap: 4 },
  label: { fontSize: 12, fontWeight: 600, color: '#374151' },
  input: { padding: '8px 10px', border: '1px solid #d1d5db', borderRadius: 6, fontSize: 13 },
  btnBuscar: { padding: '8px 20px', background: '#2563eb', color: '#fff',
    border: 'none', borderRadius: 6, cursor: 'pointer', fontWeight: 600 },
  totalesRow: { display: 'flex', gap: 12, marginTop: 16, flexWrap: 'wrap' },
  totalBox: { background: '#f3f4f6', borderRadius: 8, padding: '12px 24px',
    display: 'flex', flexDirection: 'column', minWidth: 160 },
  totalLabel: { fontSize: 11, color: '#6b7280', fontWeight: 600, textTransform: 'uppercase' },
  totalValor: { fontSize: 22, fontWeight: 700, color: '#1f2937', marginTop: 2 },
  tabs: { display: 'flex', gap: 8, marginBottom: 12 },
  tab: { padding: '8px 20px', border: '1px solid #d1d5db', borderRadius: 6,
    cursor: 'pointer', background: '#fff', fontSize: 13, fontWeight: 600, color: '#6b7280' },
  tabActive: { background: '#2563eb', color: '#fff', border: '1px solid #2563eb' },
};
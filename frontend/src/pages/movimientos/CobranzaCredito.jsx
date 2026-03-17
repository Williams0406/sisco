import { useEffect, useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';

const COLUMNS = [
  { key: 'nu_codi_cobr_cred', label: '# Cobranza' },
  { key: 'dt_fech_cobr_cred', label: 'Fecha',
    render: (v) => v ? new Date(v).toLocaleDateString('es-PE') : '—' },
  { key: 'ch_seri_cobr_cred', label: 'Serie' },
  { key: 'ch_nume_cobr_cred', label: 'Número' },
  { key: 'cliente_desc',      label: 'Cliente' },
  { key: 'nu_impo_total',     label: 'Total',
    render: (v) => v ? `S/ ${parseFloat(v).toFixed(2)}` : '—' },
  { key: 'ch_esta_activo',    label: 'Estado',
    render: (v) => v === '1' ? '✅ Activo' : '❌ Anulado' },
];

export default function CobranzaCredito() {
  const [data, setData]       = useState([]);
  const [loading, setLoading] = useState(true);
  const [fechaDesde, setFechaDesde] = useState('');
  const [fechaHasta, setFechaHasta] = useState('');

  const fetchData = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams({ page_size: 200 });
      if (fechaDesde) params.append('fecha_desde', fechaDesde);
      if (fechaHasta) params.append('fecha_hasta', fechaHasta);
      const res = await api.get(`/movimientos/cobranza-credito/?${params}`);
      setData(res.data.results || res.data);
    } finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  return (
    <div>
      <div style={styles.filtros}>
        <label style={styles.label}>Desde:</label>
        <input type="date" style={styles.input}
          value={fechaDesde} onChange={(e) => setFechaDesde(e.target.value)} />
        <label style={styles.label}>Hasta:</label>
        <input type="date" style={styles.input}
          value={fechaHasta} onChange={(e) => setFechaHasta(e.target.value)} />
        <button style={styles.btnBuscar} onClick={fetchData}>🔍 Buscar</button>
      </div>
      <DataTable title="Consulta Ticket Crédito" columns={COLUMNS}
        data={data} loading={loading} />
    </div>
  );
}

const styles = {
  filtros: { display: 'flex', gap: 10, marginBottom: 16, alignItems: 'center',
    background: '#fff', padding: '14px 18px', borderRadius: 8, boxShadow: '0 1px 4px rgba(0,0,0,0.08)' },
  label: { fontSize: 13, fontWeight: 600, color: '#374151' },
  input: { padding: '7px 10px', border: '1px solid #d1d5db', borderRadius: 6, fontSize: 13 },
  btnBuscar: { padding: '8px 18px', background: '#2563eb', color: '#fff',
    border: 'none', borderRadius: 6, cursor: 'pointer', fontWeight: 600 },
};
import { useEffect, useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';
import EditableTable from '../../components/EditableTable';

const COLUMNS_VIP = [
  { key: 'ch_codi_cliente',      label: 'Código' },
  { key: 'ch_ruc_cliente',       label: 'RUC' },
  { key: 'vc_razo_soci_cliente', label: 'Razón Social' },
  { key: 'vc_dire_cliente',      label: 'Dirección' },
  { key: 'nu_impo_tarifa',       label: 'Tarifa Única (S/)',
    render: (v) => v ? `S/ ${parseFloat(v).toFixed(3)}` : '—' },
  { key: 'ch_esta_tarifa_unica', label: 'Tarifa Única',
    render: (v) => v === '1' ? '✅ Sí' : '—' },
  { key: 'ch_esta_activo',       label: 'Estado',
    render: (v) => v === '1' || v === true ? '✅ Activo' : '❌ Inactivo' },
];

export default function Tarifario() {
  const [tarifas, setTarifas]         = useState([]);
  const [clientesVip, setClientesVip] = useState([]);
  const [tiposVeh, setTiposVeh]       = useState([]);
  const [loading, setLoading]         = useState(true);
  const [loadingVip, setLoadingVip]   = useState(true);
  const [tab, setTab]                 = useState('tarifas');

  const fetchAll = async () => {
    setLoading(true);
    setLoadingVip(true);
    try {
      const [tRes, tvRes, cRes] = await Promise.all([
        api.get('/movimientos/tarifario/?page_size=200'),
        api.get('/maestros/tipo-vehiculos/?page_size=100'),
        api.get('/maestros/clientes/?page_size=200'),
      ]);
      setTarifas(tRes.data.results   || tRes.data);
      setTiposVeh(tvRes.data.results || tvRes.data);
      const todos = cRes.data.results || cRes.data;
      setClientesVip(todos.filter(
        c => c.ch_esta_cliente_vip === '1' || c.ch_esta_cliente_vip === true
      ));
    } finally {
      setLoading(false);
      setLoadingVip(false);
    }
  };

  useEffect(() => { fetchAll(); }, []);

  // ── Columnas en el orden solicitado ────────────────────────────────────
  // Código | Tipo Comprobante | Tipo Vehículo | Tolerancia h |
  // [TURNO COMPLETO] Día | Noche | Límite Fracción |
  // [FRACCIÓN] Día | Noche | Estado | Acciones
  const getColumnsTarifario = () => [
    // 1. Código
    {
      key: 'ch_codi_tarifario',
      label: 'Código',
      placeholder: 'Ej: TAR001',
      width: 85,
    },

    // 2. Tipo de Comprobante
    {
      key: 'ch_tipo_cmprbnt',
      label: 'Tipo Comprobante',
      type: 'select',
      width: 130,
      options: [
        { value: '',   label: '— Ninguno —' },
        { value: 'BO', label: 'Boleta' },
        { value: 'FA', label: 'Factura' },
      ],
      render: (v) => v === 'BO' ? '📄 Boleta' : v === 'FA' ? '🧾 Factura' : '—',
    },

    // 3. Tipo de Vehículo
    {
      key: 'ch_tipo_vehiculo',
      label: 'Tipo Vehículo',
      type: 'select',
      width: 120,
      options: tiposVeh.map(t => ({
        value: t.ch_tipo_vehiculo,
        label: t.vc_desc_tipo_vehiculo,
      })),
      render: (_, row) => row.tipo_vehiculo_desc || row.ch_tipo_vehiculo || '—',
    },

    // 4. Tolerancia (horas)
    {
      key: 'nu_nume_hora_tlrnc',
      label: 'Tolerancia (h)',
      type: 'number',
      width: 100,
      placeholder: '0',
      render: (v) => v != null && v !== '' ? `${v} h` : '—',
    },

    // ── TURNO COMPLETO ──────────────────────────────────────────────────
    // 5. Turno Completo Día
    {
      key: 'nu_impo_dia',
      label: 'T.Completo Día S/.',
      type: 'number',
      width: 130,
      placeholder: '0.000',
      render: (v) => v ? `S/ ${parseFloat(v).toFixed(3)}` : '—',
    },

    // 6. Turno Completo Noche
    {
      key: 'nu_impo_noche',
      label: 'T.Completo Noche S/.',
      type: 'number',
      width: 140,
      placeholder: '0.000',
      render: (v) => v ? `S/ ${parseFloat(v).toFixed(3)}` : '—',
    },

    // 7. Límite Fracción (horas)
    {
      key: 'nu_nume_hora_frccn',
      label: 'Límite Fracción (h)',
      type: 'number',
      width: 130,
      placeholder: '0',
      render: (v) => v != null && v !== '' ? `${v} h` : '—',
    },

    // ── FRACCIÓN ────────────────────────────────────────────────────────
    // 8. Fracción Día
    {
      key: 'nu_impo_frccn_dia',
      label: 'Fracción Día S/.',
      type: 'number',
      width: 115,
      placeholder: '0.000',
      render: (v) => v ? `S/ ${parseFloat(v).toFixed(3)}` : '—',
    },

    // 9. Fracción Noche
    {
      key: 'nu_impo_frccn_noche',
      label: 'Fracción Noche S/.',
      type: 'number',
      width: 125,
      placeholder: '0.000',
      render: (v) => v ? `S/ ${parseFloat(v).toFixed(3)}` : '—',
    },

    // 10. Estado
    {
      key: 'ch_esta_activo',
      label: 'Estado',
      type: 'select',
      width: 80,
      options: [
        { value: '1', label: 'Activo' },
        { value: '0', label: 'Inactivo' },
      ],
      render: (v) => v === '1' ? '✅' : '❌',
    },
    // 11. Acciones → lo añade EditableTable automáticamente
  ];

  const handleSaveTarifa = async (row) => {
    const payload = { ...row };
    delete payload.tipo_vehiculo_desc;
    delete payload.cliente_desc;

    const existe = tarifas.find(t => t.ch_codi_tarifario === row.ch_codi_tarifario);
    if (row.ch_codi_tarifario && existe) {
      await api.put(`/movimientos/tarifario/${row.ch_codi_tarifario}/`, payload);
    } else {
      await api.post('/movimientos/tarifario/', payload);
    }
    fetchAll();
  };

  const handleDeleteTarifa = async (row) => {
    if (!confirm(`¿Eliminar tarifa "${row.ch_codi_tarifario}"?`)) return;
    await api.delete(`/movimientos/tarifario/${row.ch_codi_tarifario}/`);
    fetchAll();
  };

  const tarifasActivas   = tarifas.filter(t => t.ch_esta_activo === '1').length;
  const tarifasVip       = tarifas.filter(t => t.ch_codi_cliente).length;
  const tarifasGenerales = tarifas.filter(t => !t.ch_codi_cliente).length;

  return (
    <div>
      {/* ── Resumen ── */}
      <div style={styles.resumenRow}>
        <div style={{ ...styles.resumenCard, borderTop: '4px solid #2563eb' }}>
          <span style={styles.resumenValor}>{tarifas.length}</span>
          <span style={styles.resumenLabel}>Total Tarifas</span>
        </div>
        <div style={{ ...styles.resumenCard, borderTop: '4px solid #059669' }}>
          <span style={styles.resumenValor}>{tarifasActivas}</span>
          <span style={styles.resumenLabel}>Activas</span>
        </div>
        <div style={{ ...styles.resumenCard, borderTop: '4px solid #d97706' }}>
          <span style={styles.resumenValor}>{tarifasVip}</span>
          <span style={styles.resumenLabel}>Tarifas VIP</span>
        </div>
        <div style={{ ...styles.resumenCard, borderTop: '4px solid #6b7280' }}>
          <span style={styles.resumenValor}>{tarifasGenerales}</span>
          <span style={styles.resumenLabel}>Tarifas Generales</span>
        </div>
        <div style={{ ...styles.resumenCard, borderTop: '4px solid #7c3aed' }}>
          <span style={styles.resumenValor}>{clientesVip.length}</span>
          <span style={styles.resumenLabel}>Clientes VIP</span>
        </div>
      </div>

      {/* ── Tabs ── */}
      <div style={styles.tabs}>
        <button
          style={{ ...styles.tab, ...(tab === 'vip' ? styles.tabActive : {}) }}
          onClick={() => setTab('vip')}
        >
          ⭐ Clientes VIP ({clientesVip.length})
        </button>
        <button
          style={{ ...styles.tab, ...(tab === 'tarifas' ? styles.tabActive : {}) }}
          onClick={() => setTab('tarifas')}
        >
          💰 Detalle de Tarifas ({tarifas.length})
        </button>
      </div>

      {/* ── Tabla Clientes VIP ── */}
      {tab === 'vip' && (
        <div>
          <div style={styles.infoBox}>
            ℹ️ Esta tabla muestra los clientes marcados como VIP. Para modificar
            un cliente ve al módulo <strong>Maestros → Clientes</strong>.
          </div>
          <DataTable
            title="Clientes VIP"
            columns={COLUMNS_VIP}
            data={clientesVip}
            loading={loadingVip}
          />
        </div>
      )}

      {/* ── Tabla Tarifario editable con cabeceras agrupadas ── */}
      {tab === 'tarifas' && (
        <div style={styles.tableCard}>
          <div style={styles.tableHeader}>
            <h2 style={styles.tableTitle}>Detalle de Tarifas</h2>
            <span style={styles.hint}>
              Haz clic en ✏️ para editar una fila o en "+ Nueva fila" para agregar
            </span>
          </div>

          {/* Cabeceras agrupadas visuales */}
          <div style={styles.groupHeaders}>
            <div style={{ ...styles.groupEmpty, width: 85  }}>Código</div>
            <div style={{ ...styles.groupEmpty, width: 130 }}>Tipo Comp.</div>
            <div style={{ ...styles.groupEmpty, width: 120 }}>Tipo Veh.</div>
            <div style={{ ...styles.groupEmpty, width: 100 }}>Tolerancia</div>
            <div style={{ ...styles.groupBadge, width: 400, background: '#2563eb' }}>
              ☀️ TURNO COMPLETO
            </div>
            <div style={{ ...styles.groupBadge, width: 265, background: '#7c3aed' }}>
              ⚡ FRACCIÓN
            </div>
            <div style={{ ...styles.groupEmpty, width: 80  }}>Estado</div>
            <div style={{ ...styles.groupEmpty, width: 110 }}>Acciones</div>
          </div>

          <EditableTable
            title=""
            columns={getColumnsTarifario()}
            data={tarifas}
            loading={loading}
            pkField="ch_codi_tarifario"
            onSave={handleSaveTarifa}
            onDelete={handleDeleteTarifa}
          />
        </div>
      )}
    </div>
  );
}

const styles = {
  resumenRow: {
    display: 'flex', gap: 14, marginBottom: 16, flexWrap: 'wrap',
  },
  resumenCard: {
    background: '#fff', borderRadius: 10, padding: '14px 22px',
    display: 'flex', flexDirection: 'column', alignItems: 'center',
    minWidth: 120, boxShadow: '0 1px 4px rgba(0,0,0,0.08)', flex: 1,
  },
  resumenValor: { fontSize: 28, fontWeight: 700, color: '#1f2937' },
  resumenLabel: {
    fontSize: 11, color: '#6b7280', fontWeight: 600,
    textTransform: 'uppercase', marginTop: 2, textAlign: 'center',
  },
  tabs: { display: 'flex', gap: 8, marginBottom: 12 },
  tab: {
    padding: '9px 22px', border: '1px solid #d1d5db', borderRadius: 6,
    cursor: 'pointer', background: '#fff', fontSize: 13,
    fontWeight: 600, color: '#6b7280',
  },
  tabActive: {
    background: '#2563eb', color: '#fff', border: '1px solid #2563eb',
  },
  infoBox: {
    background: '#eff6ff', border: '1px solid #bfdbfe', borderRadius: 8,
    padding: '10px 16px', marginBottom: 12, fontSize: 13, color: '#1d4ed8',
  },
  tableCard: {
    background: '#fff', borderRadius: 10,
    boxShadow: '0 1px 4px rgba(0,0,0,0.08)', overflow: 'hidden',
  },
  tableHeader: {
    display: 'flex', justifyContent: 'space-between', alignItems: 'center',
    padding: '16px 20px 0',
  },
  tableTitle: { margin: 0, fontSize: 17, color: '#1f2937' },
  hint: { fontSize: 12, color: '#9ca3af' },

  // Cabeceras agrupadas
  groupHeaders: {
    display: 'flex', alignItems: 'center',
    padding: '8px 20px 0', gap: 0, overflowX: 'auto',
  },
  groupEmpty: {
    fontSize: 11, color: 'transparent', fontWeight: 700,
    textAlign: 'center', padding: '4px 0', flexShrink: 0,
  },
  groupBadge: {
    fontSize: 11, color: '#fff', fontWeight: 700,
    textAlign: 'center', padding: '4px 8px',
    borderRadius: '4px 4px 0 0', flexShrink: 0,
    letterSpacing: 0.5,
  },
};
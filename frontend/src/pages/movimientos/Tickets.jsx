import { useEffect, useState } from 'react';
import api from '../../api/axios';

export default function Tickets() {
  // ── Datos maestros ──────────────────────────────────────────────────────
  const [vehiculos,  setVehiculos]  = useState([]);
  const [clientes,   setClientes]   = useState([]);
  const [choferes,   setChoferes]   = useState([]);
  const [tiposVeh,   setTiposVeh]   = useState([]);
  const [garitas,    setGaritas]    = useState([]);
  const [tarifarios, setTarifarios] = useState([]);
  const [loading,    setLoading]    = useState(true);

  // ── Ticket activo en el formulario ──────────────────────────────────────
  const [selected,   setSelected]   = useState(null);
  const [isIngreso,  setIsIngreso]  = useState(true); // true=ingreso, false=salida
  const [saving,     setSaving]     = useState(false);

  // ── Filtros tabla ───────────────────────────────────────────────────────
  const [filtroPlaca,  setFiltroPlaca]  = useState('');
  const [filtroEstado, setFiltroEstado] = useState('parqueado'); // 'parqueado'|'todos'

  // ── Tickets (lista de parqueo) ──────────────────────────────────────────
  const [tickets, setTickets] = useState([]);

  // ── Carga inicial ───────────────────────────────────────────────────────
  const fetchAll = async () => {
    setLoading(true);
    try {
      const [vRes, cRes, chRes, tvRes, gRes, tRes, tkRes] = await Promise.all([
        api.get('/maestros/vehiculos/?page_size=500'),
        api.get('/maestros/clientes/?page_size=500'),
        api.get('/maestros/choferes/?page_size=500'),
        api.get('/maestros/tipo-vehiculos/?page_size=100'),
        api.get('/maestros/garitas/?page_size=50'),
        api.get('/movimientos/tarifario/?page_size=200'),
        api.get('/movimientos/tickets/?page_size=500&ch_esta_activo=1'),
      ]);
      setVehiculos(vRes.data.results   || vRes.data);
      setClientes(cRes.data.results    || cRes.data);
      setChoferes(chRes.data.results   || chRes.data);
      setTiposVeh(tvRes.data.results   || tvRes.data);
      setGaritas(gRes.data.results     || gRes.data);
      setTarifarios(tRes.data.results  || tRes.data);
      setTickets(tkRes.data.results    || tkRes.data);
    } finally { setLoading(false); }
  };

  useEffect(() => { fetchAll(); }, []);

  // ── Helpers de búsqueda ─────────────────────────────────────────────────
  const getVehiculo  = (cod) => vehiculos.find(v => v.ch_codi_vehiculo === cod);
  const getTipoDesc  = (cod) => tiposVeh.find(t => t.ch_tipo_vehiculo  === cod)?.vc_desc_tipo_vehiculo || cod || '—';
  const getClienteDesc = (cod) => clientes.find(c => c.ch_codi_cliente === cod)?.vc_razo_soci_cliente  || '—';
  const getChoferDesc  = (cod) => choferes.find(c => c.ch_codi_chofer  === cod)?.vc_desc_chofer        || '—';

  // ── Tabla: vehiculos parqueados (desde MAE_VEHICULO) ───────────────────
  const vehiculosParqueados = vehiculos.filter(v => {
    const parqueado = v.ch_esta_parqueado === true || v.ch_esta_parqueado === '1';
    const activo    = v.ch_esta_activo    === true || v.ch_esta_activo    === '1';
    if (!activo) return false;
    if (filtroEstado === 'parqueado' && !parqueado) return false;
    if (filtroPlaca && !v.ch_plac_vehiculo?.toLowerCase().includes(filtroPlaca.toLowerCase()))
      return false;
    return true;
  });

  // ── Abrir formulario INGRESO para un vehículo ───────────────────────────
  const handleIngreso = (vehiculo) => {
    const now = new Date().toISOString().slice(0, 16);
    setSelected({
      // Datos del vehículo pre-cargados
      ch_codi_vehiculo:  vehiculo.ch_codi_vehiculo,
      ch_plac_vehiculo:  vehiculo.ch_plac_vehiculo,
      ch_tipo_vehiculo:  vehiculo.ch_tipo_vehiculo,
      ch_codi_cliente:   vehiculo.ch_codi_cliente  || '',
      ch_codi_chofer:    vehiculo.ch_codi_chofer   || '',
      // Campos del ticket
      dt_fech_ingreso:   now,
      dt_fech_emision:   now,
      ch_esta_ticket:    '0',
      ch_esta_activo:    '1',
      ch_esta_cancelado: '0',
      ch_esta_llave:     '0',
      ch_esta_duermen:   '0',
      ch_codi_garita:    garitas[0]?.ch_codi_garita || '',
      ch_codi_tarifario: '',
      ch_tipo_comprobante: '',
      nu_impo_total:     '',
      vc_obse_tckt_ingreso: '',
    });
    setIsIngreso(true);
  };

  // ── Abrir formulario SALIDA para un ticket abierto ──────────────────────
  const handleSalida = (vehiculo) => {
    // Buscar ticket abierto para este vehículo
    const ticketAbierto = tickets.find(
      t => t.ch_codi_vehiculo === vehiculo.ch_codi_vehiculo &&
           (t.ch_esta_ticket === '0' || !t.dt_fech_salida)
    );
    const now = new Date().toISOString().slice(0, 16);
    setSelected({
      ...(ticketAbierto || {}),
      ch_codi_vehiculo:  vehiculo.ch_codi_vehiculo,
      ch_plac_vehiculo:  vehiculo.ch_plac_vehiculo,
      ch_tipo_vehiculo:  vehiculo.ch_tipo_vehiculo,
      ch_codi_cliente:   vehiculo.ch_codi_cliente || '',
      ch_codi_chofer:    vehiculo.ch_codi_chofer  || '',
      dt_fech_salida:    now,
      ch_esta_ticket:    '1',
      ch_obse_tckt_salida: '',
      nu_impo_total:     ticketAbierto?.nu_impo_total || '',
    });
    setIsIngreso(false);
  };

  // ── Nuevo ingreso manual (sin seleccionar vehículo) ─────────────────────
  const handleNuevoManual = () => {
    const now = new Date().toISOString().slice(0, 16);
    setSelected({
      ch_codi_vehiculo: '', ch_plac_vehiculo: '',
      ch_tipo_vehiculo: '', ch_codi_cliente:  '',
      ch_codi_chofer:   '', dt_fech_ingreso:  now,
      dt_fech_emision:  now, ch_esta_ticket:  '0',
      ch_esta_activo:   '1', ch_esta_cancelado: '0',
      ch_esta_llave:    '0', ch_esta_duermen:   '0',
      ch_codi_garita:   garitas[0]?.ch_codi_garita || '',
      ch_codi_tarifario: '', ch_tipo_comprobante: '',
      nu_impo_total: '', vc_obse_tckt_ingreso: '',
    });
    setIsIngreso(true);
  };

  const set = (k, v) => setSelected(p => ({ ...p, [k]: v }));

  // Cuando cambia el vehículo en el selector, pre-cargar sus datos
  const handleVehiculoChange = (codVeh) => {
    const veh = getVehiculo(codVeh);
    if (veh) {
      set('ch_codi_vehiculo',  veh.ch_codi_vehiculo);
      set('ch_plac_vehiculo',  veh.ch_plac_vehiculo || '');
      set('ch_tipo_vehiculo',  veh.ch_tipo_vehiculo || '');
      set('ch_codi_cliente',   veh.ch_codi_cliente  || '');
      set('ch_codi_chofer',    veh.ch_codi_chofer   || '');
    } else {
      set('ch_codi_vehiculo', codVeh);
    }
  };

  // ── Guardar ticket ──────────────────────────────────────────────────────
  const handleGuardar = async () => {
    setSaving(true);
    try {
      const payload = { ...selected };
      // Limpiar campos descriptivos que no van al backend
      delete payload.garita_desc;
      delete payload.cliente_desc;
      delete payload.chofer_desc;
      delete payload.vehiculo_placa;
      delete payload.tarifario_desc;

      if (isIngreso) {
        // Crear nuevo ticket
        await api.post('/movimientos/tickets/', payload);
        // Marcar vehículo como parqueado
        if (payload.ch_codi_vehiculo) {
          await api.patch(
            `/maestros/vehiculos/${payload.ch_codi_vehiculo}/`,
            { ch_esta_parqueado: true }
          );
        }
      } else {
        // Actualizar ticket existente con salida
        if (selected.nu_codi_ticket) {
          await api.put(
            `/movimientos/tickets/${selected.nu_codi_ticket}/`,
            payload
          );
        }
        // Marcar vehículo como NO parqueado
        if (payload.ch_codi_vehiculo) {
          await api.patch(
            `/maestros/vehiculos/${payload.ch_codi_vehiculo}/`,
            { ch_esta_parqueado: false }
          );
        }
      }
      await fetchAll();
      setSelected(null);
    } catch (err) {
      alert('Error: ' + JSON.stringify(err.response?.data || err.message));
    } finally { setSaving(false); }
  };

  // ── Renderizado ─────────────────────────────────────────────────────────
  return (
    <div style={styles.page}>

      {/* ══ Panel izquierdo — Tabla de vehículos ══════════════════════════ */}
      <div style={styles.leftPanel}>
        {/* Encabezado + filtros */}
        <div style={styles.leftHeader}>
          <h2 style={styles.leftTitle}>🚗 Cochera</h2>
          <button style={styles.btnNuevo} onClick={handleNuevoManual}>
            + Ingreso
          </button>
        </div>

        <div style={styles.filtros}>
          <input
            style={styles.inputFiltro}
            placeholder="🔍 Buscar placa..."
            value={filtroPlaca}
            onChange={e => setFiltroPlaca(e.target.value)}
          />
          <select
            style={styles.inputFiltro}
            value={filtroEstado}
            onChange={e => setFiltroEstado(e.target.value)}
          >
            <option value="parqueado">🟢 Parqueados</option>
            <option value="todos">📋 Todos</option>
          </select>
        </div>

        {/* Contadores */}
        <div style={styles.contadores}>
          <div style={styles.counter}>
            <span style={styles.counterNum}>
              {vehiculos.filter(v =>
                v.ch_esta_parqueado === true || v.ch_esta_parqueado === '1'
              ).length}
            </span>
            <span style={styles.counterLabel}>Parqueados</span>
          </div>
          <div style={styles.counter}>
            <span style={styles.counterNum}>{vehiculos.length}</span>
            <span style={styles.counterLabel}>Total Vehículos</span>
          </div>
        </div>

        {/* Tabla */}
        <div style={styles.tableWrapper}>
          <table style={styles.table}>
            <thead>
              <tr>
                <th style={styles.th}>Código</th>
                <th style={styles.th}>Placa</th>
                <th style={styles.th}>Tipo</th>
                <th style={styles.th}>Cliente</th>
                <th style={styles.th}>Chofer</th>
                <th style={styles.th}>Estado</th>
                <th style={styles.th}>Acción</th>
              </tr>
            </thead>
            <tbody>
              {loading && (
                <tr><td colSpan={7} style={styles.empty}>Cargando...</td></tr>
              )}
              {!loading && vehiculosParqueados.length === 0 && (
                <tr>
                  <td colSpan={7} style={styles.empty}>
                    No hay vehículos {filtroEstado === 'parqueado' ? 'parqueados' : 'registrados'}
                  </td>
                </tr>
              )}
              {!loading && vehiculosParqueados.map((veh, i) => {
                const parqueado = veh.ch_esta_parqueado === true || veh.ch_esta_parqueado === '1';
                const isSelected = selected?.ch_codi_vehiculo === veh.ch_codi_vehiculo;
                return (
                  <tr key={veh.ch_codi_vehiculo} style={{
                    ...styles.tr,
                    ...(isSelected ? styles.trSelected : {}),
                    ...(i % 2 !== 0 && !isSelected ? styles.trOdd : {}),
                  }}>
                    <td style={styles.td}>{veh.ch_codi_vehiculo}</td>
                    <td style={{ ...styles.td, fontWeight: 600 }}>{veh.ch_plac_vehiculo}</td>
                    <td style={styles.td}>
                      {getTipoDesc(veh.ch_tipo_vehiculo)}
                    </td>
                    <td style={styles.td}>
                      {getClienteDesc(veh.ch_codi_cliente) !== '—'
                        ? getClienteDesc(veh.ch_codi_cliente)
                        : <span style={styles.muted}>—</span>}
                    </td>
                    <td style={styles.td}>
                      {getChoferDesc(veh.ch_codi_chofer) !== '—'
                        ? getChoferDesc(veh.ch_codi_chofer)
                        : <span style={styles.muted}>—</span>}
                    </td>
                    <td style={styles.td}>
                      <span style={{
                        ...styles.badge,
                        background: parqueado ? '#dcfce7' : '#f3f4f6',
                        color:      parqueado ? '#166534' : '#6b7280',
                      }}>
                        {parqueado ? '🟢 Parqueado' : '⚪ Libre'}
                      </span>
                    </td>
                    <td style={styles.td}>
                      {parqueado ? (
                        <button
                          style={styles.btnSalida}
                          onClick={() => handleSalida(veh)}
                        >
                          🚪 Salida
                        </button>
                      ) : (
                        <button
                          style={styles.btnIngreso}
                          onClick={() => handleIngreso(veh)}
                        >
                          🚗 Ingreso
                        </button>
                      )}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>

      {/* ══ Panel derecho — Formulario ════════════════════════════════════ */}
      <div style={styles.rightPanel}>
        {!selected ? (
          <div style={styles.placeholder}>
            <span style={styles.placeholderIcon}>🏁</span>
            <p style={styles.placeholderText}>
              Selecciona un vehículo y haz clic<br />
              en <strong>🚗 Ingreso</strong> o <strong>🚪 Salida</strong>,<br />
              o usa <strong>+ Ingreso</strong> para registrar manualmente.
            </p>
          </div>
        ) : (
          <>
            {/* Encabezado formulario */}
            <div style={styles.formHeader}>
              <div>
                <h3 style={styles.formTitle}>
                  {isIngreso ? '🚗 Registrar Ingreso' : '🚪 Registrar Salida'}
                </h3>
                <span style={{
                  ...styles.formBadge,
                  background: isIngreso ? '#dbeafe' : '#fef3c7',
                  color:      isIngreso ? '#1e40af' : '#92400e',
                }}>
                  {isIngreso ? 'ENTRADA A COCHERA' : 'SALIDA DE COCHERA'}
                </span>
              </div>
              <button style={styles.btnClose}
                onClick={() => setSelected(null)}>✕</button>
            </div>

            {/* ── Sección: Vehículo ── */}
            <div style={styles.section}>
              <p style={styles.sectionTitle}>Datos del Vehículo</p>
              <div style={styles.grid3}>

                <div style={styles.fieldWrap}>
                  <label style={styles.fieldLabel}>Código Vehículo</label>
                  <select
                    style={styles.fieldInput}
                    value={selected.ch_codi_vehiculo || ''}
                    onChange={e => handleVehiculoChange(e.target.value)}
                  >
                    <option value="">— Seleccionar —</option>
                    {vehiculos.map(v => (
                      <option key={v.ch_codi_vehiculo} value={v.ch_codi_vehiculo}>
                        {v.ch_codi_vehiculo} — {v.ch_plac_vehiculo}
                      </option>
                    ))}
                  </select>
                </div>

                <div style={styles.fieldWrap}>
                  <label style={styles.fieldLabel}>Placa</label>
                  <input style={styles.fieldInput}
                    type="text"
                    value={selected.ch_plac_vehiculo || ''}
                    onChange={e => set('ch_plac_vehiculo', e.target.value)}
                    placeholder="Ej: ABC-123" />
                </div>

                <div style={styles.fieldWrap}>
                  <label style={styles.fieldLabel}>Tipo de Vehículo</label>
                  <select style={styles.fieldInput}
                    value={selected.ch_tipo_vehiculo || ''}
                    onChange={e => set('ch_tipo_vehiculo', e.target.value)}>
                    <option value="">— Seleccionar —</option>
                    {tiposVeh.map(t => (
                      <option key={t.ch_tipo_vehiculo} value={t.ch_tipo_vehiculo}>
                        {t.vc_desc_tipo_vehiculo}
                      </option>
                    ))}
                  </select>
                </div>

                <div style={styles.fieldWrap}>
                  <label style={styles.fieldLabel}>Cliente</label>
                  <select style={styles.fieldInput}
                    value={selected.ch_codi_cliente || ''}
                    onChange={e => set('ch_codi_cliente', e.target.value)}>
                    <option value="">— Sin cliente —</option>
                    {clientes.map(c => (
                      <option key={c.ch_codi_cliente} value={c.ch_codi_cliente}>
                        {c.vc_razo_soci_cliente}
                      </option>
                    ))}
                  </select>
                </div>

                <div style={styles.fieldWrap}>
                  <label style={styles.fieldLabel}>Chofer</label>
                  <select style={styles.fieldInput}
                    value={selected.ch_codi_chofer || ''}
                    onChange={e => set('ch_codi_chofer', e.target.value)}>
                    <option value="">— Sin chofer —</option>
                    {choferes.map(c => (
                      <option key={c.ch_codi_chofer} value={c.ch_codi_chofer}>
                        {c.vc_desc_chofer}
                      </option>
                    ))}
                  </select>
                </div>

                <div style={styles.fieldWrap}>
                  <label style={styles.fieldLabel}>Estado Parqueo</label>
                  <select style={styles.fieldInput}
                    value={
                      isIngreso ? '1'
                      : (selected.ch_esta_ticket === '1' ? '0' : '1')
                    }
                    readOnly>
                    <option value="1">🟢 Parqueado</option>
                    <option value="0">⚪ Libre</option>
                  </select>
                </div>

              </div>
            </div>

            {/* ── Sección: Operación ── */}
            <div style={styles.section}>
              <p style={styles.sectionTitle}>
                {isIngreso ? 'Datos de Ingreso' : 'Datos de Salida'}
              </p>
              <div style={styles.grid3}>

                <div style={styles.fieldWrap}>
                  <label style={styles.fieldLabel}>
                    {isIngreso ? 'Fecha Ingreso' : 'Fecha Salida'}
                  </label>
                  <input style={styles.fieldInput}
                    type="datetime-local"
                    value={isIngreso
                      ? (selected.dt_fech_ingreso || '')
                      : (selected.dt_fech_salida  || '')}
                    onChange={e => set(
                      isIngreso ? 'dt_fech_ingreso' : 'dt_fech_salida',
                      e.target.value
                    )} />
                </div>

                <div style={styles.fieldWrap}>
                  <label style={styles.fieldLabel}>Garita</label>
                  <select style={styles.fieldInput}
                    value={selected.ch_codi_garita || ''}
                    onChange={e => set('ch_codi_garita', e.target.value)}>
                    <option value="">— Seleccionar —</option>
                    {garitas.map(g => (
                      <option key={g.ch_codi_garita} value={g.ch_codi_garita}>
                        {g.vc_desc_garita}
                      </option>
                    ))}
                  </select>
                </div>

                <div style={styles.fieldWrap}>
                  <label style={styles.fieldLabel}>Tarifario</label>
                  <select style={styles.fieldInput}
                    value={selected.ch_codi_tarifario || ''}
                    onChange={e => set('ch_codi_tarifario', e.target.value)}>
                    <option value="">— Sin tarifa —</option>
                    {tarifarios.map(t => (
                      <option key={t.ch_codi_tarifario} value={t.ch_codi_tarifario}>
                        {t.vc_desc_tarifario || t.ch_codi_tarifario}
                      </option>
                    ))}
                  </select>
                </div>

                <div style={styles.fieldWrap}>
                  <label style={styles.fieldLabel}>Tipo Comprobante</label>
                  <select style={styles.fieldInput}
                    value={selected.ch_tipo_comprobante || ''}
                    onChange={e => set('ch_tipo_comprobante', e.target.value)}>
                    <option value="">— Ninguno —</option>
                    <option value="BO">Boleta</option>
                    <option value="FA">Factura</option>
                  </select>
                </div>

                <div style={styles.fieldWrap}>
                  <label style={styles.fieldLabel}>Importe Total (S/)</label>
                  <input style={styles.fieldInput}
                    type="number" step="0.001"
                    value={selected.nu_impo_total || ''}
                    onChange={e => set('nu_impo_total', e.target.value)}
                    placeholder="0.000" />
                </div>

                {isIngreso && (
                  <>
                    <div style={styles.fieldWrap}>
                      <label style={styles.fieldLabel}>Llave</label>
                      <select style={styles.fieldInput}
                        value={selected.ch_esta_llave || '0'}
                        onChange={e => set('ch_esta_llave', e.target.value)}>
                        <option value="0">No</option>
                        <option value="1">Sí</option>
                      </select>
                    </div>

                    <div style={styles.fieldWrap}>
                      <label style={styles.fieldLabel}>Duermen</label>
                      <select style={styles.fieldInput}
                        value={selected.ch_esta_duermen || '0'}
                        onChange={e => set('ch_esta_duermen', e.target.value)}>
                        <option value="0">No</option>
                        <option value="1">Sí</option>
                      </select>
                    </div>

                    <div style={styles.fieldWrap}>
                      <label style={styles.fieldLabel}>Teléfono</label>
                      <input style={styles.fieldInput}
                        type="text"
                        value={selected.ch_nume_telefono || ''}
                        onChange={e => set('ch_nume_telefono', e.target.value)}
                        placeholder="Número de contacto" />
                    </div>
                  </>
                )}

              </div>
            </div>

            {/* ── Observación ── */}
            <div style={styles.section}>
              <p style={styles.sectionTitle}>Observación</p>
              <textarea
                style={styles.textarea}
                rows={2}
                value={isIngreso
                  ? (selected.vc_obse_tckt_ingreso || '')
                  : (selected.ch_obse_tckt_salida  || '')}
                onChange={e => set(
                  isIngreso ? 'vc_obse_tckt_ingreso' : 'ch_obse_tckt_salida',
                  e.target.value
                )}
                placeholder={isIngreso
                  ? 'Observaciones del ingreso...'
                  : 'Observaciones de la salida...'}
              />
            </div>

            {/* ── Botón guardar ── */}
            <div style={styles.formFooter}>
              <button style={styles.btnCancelar}
                onClick={() => setSelected(null)}>
                Cancelar
              </button>
              <button
                style={{
                  ...styles.btnGuardar,
                  background: isIngreso ? '#2563eb' : '#dc2626',
                }}
                onClick={handleGuardar}
                disabled={saving}
              >
                {saving
                  ? 'Guardando...'
                  : isIngreso ? '🚗 Confirmar Ingreso' : '🚪 Confirmar Salida'}
              </button>
            </div>
          </>
        )}
      </div>
    </div>
  );
}

// ── Estilos ─────────────────────────────────────────────────────────────────
const styles = {
  page: {
    display: 'flex', gap: 16, alignItems: 'flex-start',
  },

  // Panel izquierdo
  leftPanel: {
    width: 560, flexShrink: 0, background: '#fff',
    borderRadius: 10, boxShadow: '0 1px 4px rgba(0,0,0,0.08)',
    display: 'flex', flexDirection: 'column',
  },
  leftHeader: {
    display: 'flex', justifyContent: 'space-between',
    alignItems: 'center', padding: '16px 16px 8px',
  },
  leftTitle: { margin: 0, fontSize: 16, color: '#1f2937' },
  btnNuevo: {
    background: '#2563eb', color: '#fff', border: 'none',
    padding: '7px 16px', borderRadius: 6, cursor: 'pointer',
    fontWeight: 600, fontSize: 13,
  },
  filtros: {
    display: 'flex', gap: 8, padding: '0 16px 10px',
  },
  inputFiltro: {
    padding: '7px 10px', border: '1px solid #d1d5db',
    borderRadius: 6, fontSize: 12, flex: 1,
  },
  contadores: {
    display: 'flex', gap: 12, padding: '0 16px 10px',
  },
  counter: {
    background: '#f9fafb', borderRadius: 8, padding: '6px 14px',
    display: 'flex', flexDirection: 'column', alignItems: 'center',
    flex: 1,
  },
  counterNum:   { fontSize: 20, fontWeight: 700, color: '#1f2937' },
  counterLabel: { fontSize: 10, color: '#6b7280', textTransform: 'uppercase' },
  tableWrapper: { overflowY: 'auto', maxHeight: 'calc(100vh - 260px)' },
  table: { width: '100%', borderCollapse: 'collapse', fontSize: 12 },
  th: {
    background: '#f9fafb', padding: '8px 8px', textAlign: 'left',
    fontWeight: 600, color: '#374151', borderBottom: '2px solid #e5e7eb',
    position: 'sticky', top: 0, whiteSpace: 'nowrap',
  },
  td: { padding: '7px 8px', borderBottom: '1px solid #f3f4f6', color: '#4b5563' },
  tr: { cursor: 'pointer' },
  trOdd:     { background: '#fafafa' },
  trSelected:{ background: '#eff6ff' },
  empty: { textAlign: 'center', padding: 24, color: '#9ca3af', fontStyle: 'italic' },
  muted: { color: '#d1d5db' },
  badge: {
    display: 'inline-block', fontSize: 11, fontWeight: 600,
    padding: '2px 8px', borderRadius: 10,
  },
  btnIngreso: {
    background: '#2563eb', color: '#fff', border: 'none',
    padding: '4px 10px', borderRadius: 4, cursor: 'pointer', fontSize: 11,
  },
  btnSalida: {
    background: '#dc2626', color: '#fff', border: 'none',
    padding: '4px 10px', borderRadius: 4, cursor: 'pointer', fontSize: 11,
  },

  // Panel derecho
  rightPanel: {
    flex: 1, background: '#fff', borderRadius: 10,
    boxShadow: '0 1px 4px rgba(0,0,0,0.08)',
    padding: 20, minHeight: 400,
  },
  placeholder: {
    display: 'flex', flexDirection: 'column', alignItems: 'center',
    justifyContent: 'center', height: 320, color: '#9ca3af',
  },
  placeholderIcon: { fontSize: 52, marginBottom: 12 },
  placeholderText: { textAlign: 'center', fontSize: 14, lineHeight: 1.8 },

  // Formulario
  formHeader: {
    display: 'flex', justifyContent: 'space-between',
    alignItems: 'flex-start', marginBottom: 18,
    paddingBottom: 14, borderBottom: '1px solid #e5e7eb',
  },
  formTitle: { margin: '0 0 6px', fontSize: 17, color: '#1f2937' },
  formBadge: {
    display: 'inline-block', fontSize: 10, fontWeight: 700,
    padding: '3px 10px', borderRadius: 12, letterSpacing: 0.5,
  },
  btnClose: {
    background: '#f3f4f6', color: '#374151', border: '1px solid #d1d5db',
    padding: '6px 12px', borderRadius: 6, cursor: 'pointer', fontSize: 14,
  },
  section: { marginBottom: 18 },
  sectionTitle: {
    fontSize: 10, fontWeight: 700, color: '#6b7280',
    textTransform: 'uppercase', letterSpacing: 0.8,
    margin: '0 0 10px', paddingBottom: 5,
    borderBottom: '1px solid #f3f4f6',
  },
  grid3: {
    display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 10,
  },
  fieldWrap: { display: 'flex', flexDirection: 'column', gap: 3 },
  fieldLabel: {
    fontSize: 10, fontWeight: 600, color: '#6b7280',
    textTransform: 'uppercase', letterSpacing: 0.5,
  },
  fieldInput: {
    padding: '7px 10px', border: '1px solid #d1d5db',
    borderRadius: 6, fontSize: 13, outline: 'none',
    boxSizing: 'border-box', width: '100%',
  },
  textarea: {
    width: '100%', border: '1px solid #d1d5db', borderRadius: 6,
    padding: '9px 12px', fontSize: 13, resize: 'vertical',
    fontFamily: 'inherit', boxSizing: 'border-box', outline: 'none',
  },
  formFooter: {
    display: 'flex', gap: 10, justifyContent: 'flex-end',
    marginTop: 4, paddingTop: 16, borderTop: '1px solid #f3f4f6',
  },
  btnCancelar: {
    padding: '9px 20px', background: '#f3f4f6', border: '1px solid #d1d5db',
    borderRadius: 6, cursor: 'pointer', fontSize: 13,
  },
  btnGuardar: {
    padding: '9px 24px', color: '#fff', border: 'none',
    borderRadius: 6, cursor: 'pointer', fontWeight: 600, fontSize: 13,
  },
};
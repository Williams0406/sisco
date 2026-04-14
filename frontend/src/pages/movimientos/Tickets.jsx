import { useEffect, useMemo, useState } from 'react';
import api from '../../api/axios';
import DataTable from '../../components/DataTable';
import { theme } from '../../styles/tokens';

const DEFAULT_GARITA_CODE = 'GAR';
const DEFAULT_GARITA_LABEL = 'Garita';

const padDatePart = (value) => String(value).padStart(2, '0');

const parseDateValue = (value) => {
  if (!value) return null;
  if (value instanceof Date) return new Date(value);
  const normalized = typeof value === 'string' ? value.replace(' ', 'T') : value;
  const date = new Date(normalized);
  return Number.isNaN(date.getTime()) ? null : date;
};

const toDateTimeInputValue = (value = new Date()) => {
  const date = parseDateValue(value);
  if (!date) return '';
  return `${date.getFullYear()}-${padDatePart(date.getMonth() + 1)}-${padDatePart(date.getDate())}T${padDatePart(date.getHours())}:${padDatePart(date.getMinutes())}`;
};

const toDateTimeApiValue = (value) => {
  const date = parseDateValue(value);
  if (!date) return '';
  return `${toDateTimeInputValue(date)}:${padDatePart(date.getSeconds())}`;
};

const formatDateTimeDisplay = (value) => {
  const date = parseDateValue(value);
  if (!date) return '';
  return `${padDatePart(date.getDate())}/${padDatePart(date.getMonth() + 1)}/${date.getFullYear()} ${padDatePart(date.getHours())}:${padDatePart(date.getMinutes())}`;
};

const nowInputValue = () => toDateTimeInputValue(new Date());

const normalizeTicketDateFields = (ticket) => ({
  ...ticket,
  dt_fech_emision: toDateTimeInputValue(ticket?.dt_fech_emision),
  dt_fech_ingreso: toDateTimeInputValue(ticket?.dt_fech_ingreso),
  dt_fech_salida: toDateTimeInputValue(ticket?.dt_fech_salida),
});

const isTrueValue = (value) => value === true || value === '1' || value === 1 || value === 'true';

const decimalValue = (value) => {
  const parsed = Number(value ?? 0);
  return Number.isFinite(parsed) ? parsed : 0;
};

const IGV_FACTOR = 1.18;

const buildShiftInterval = (baseDate, startTime, endTime) => {
  const [startHour, startMinute] = String(startTime || '00:00').split(':').map(Number);
  const [endHour, endMinute] = String(endTime || '00:00').split(':').map(Number);

  const start = new Date(baseDate);
  start.setHours(startHour || 0, startMinute || 0, 0, 0);

  const end = new Date(baseDate);
  end.setHours(endHour || 0, endMinute || 0, 0, 0);
  if (end <= start) {
    end.setDate(end.getDate() + 1);
  }

  return [start, end];
};

const getShiftIntervals = (configTurno, ingreso, salida) => {
  if (!configTurno || !ingreso || !salida) return [];

  const current = new Date(ingreso);
  current.setDate(current.getDate() - 1);
  current.setHours(0, 0, 0, 0);

  const last = new Date(salida);
  last.setDate(last.getDate() + 1);
  last.setHours(0, 0, 0, 0);

  const intervals = [];
  while (current <= last) {
    const [diaStart, diaEnd] = buildShiftInterval(current, configTurno.tm_hora_inicio_dia, configTurno.tm_hora_fin_dia);
    const [nocheStart, nocheEnd] = buildShiftInterval(current, configTurno.tm_hora_inicio_noche, configTurno.tm_hora_fin_noche);

    intervals.push({ type: 'dia', start: diaStart, end: diaEnd });
    intervals.push({ type: 'noche', start: nocheStart, end: nocheEnd });

    current.setDate(current.getDate() + 1);
  }

  return intervals
    .filter((item) => item.end > ingreso && item.start < salida)
    .sort((a, b) => a.start - b.start);
};

const calculatePreviewTotal = (ticket, tarifarios, configTurno) => {
  if (!ticket?.ch_codi_tarifario || !ticket?.dt_fech_ingreso || !ticket?.dt_fech_salida) return '';

  const tarifario = tarifarios.find((item) => item.ch_codi_tarifario === ticket.ch_codi_tarifario);
  if (!tarifario) return '';

  const ingreso = new Date(ticket.dt_fech_ingreso);
  const salida = new Date(ticket.dt_fech_salida);
  if (Number.isNaN(ingreso.getTime()) || Number.isNaN(salida.getTime()) || salida <= ingreso) return '';

  const intervals = getShiftIntervals(configTurno, ingreso, salida);
  if (!intervals.length) return '';

  const totals = {
    totalDia: 0,
    totalNoche: 0,
    fraccionDia: 0,
    fraccionNoche: 0,
  };

  const toleranceHours = decimalValue(tarifario.nu_nume_hora_tlrnc);
  const fractionHours = decimalValue(tarifario.nu_nume_hora_frccn);
  const dayAmount = decimalValue(tarifario.nu_impo_dia);
  const nightAmount = decimalValue(tarifario.nu_impo_noche);
  const dayFractionAmount = decimalValue(tarifario.nu_impo_frccn_dia);
  const nightFractionAmount = decimalValue(tarifario.nu_impo_frccn_noche);
  const fractionLimit = toleranceHours + fractionHours;

  intervals.forEach((interval) => {
    const overlapStart = new Date(Math.max(ingreso.getTime(), interval.start.getTime()));
    const overlapEnd = new Date(Math.min(salida.getTime(), interval.end.getTime()));
    if (overlapEnd <= overlapStart) return;

    const elapsedHours = (overlapEnd.getTime() - overlapStart.getTime()) / 3600000;
    if (interval.type === 'dia') {
      if (elapsedHours > fractionLimit) totals.totalDia += 1;
      else if (elapsedHours > toleranceHours) totals.fraccionDia += dayFractionAmount;
      return;
    }

    if (elapsedHours > fractionLimit) totals.totalNoche += 1;
    else if (elapsedHours > toleranceHours) totals.fraccionNoche += nightFractionAmount;
  });

  const importeDia = totals.totalDia * dayAmount;
  const importeNoche = totals.totalNoche * nightAmount;
  const totalDia = importeDia + totals.fraccionDia;
  const totalNoche = importeNoche + totals.fraccionNoche;
  const subtotal = totalDia + totalNoche;
  return Math.max(subtotal * IGV_FACTOR, 0).toFixed(3);
};

export default function Tickets() {
  const [vehiculos, setVehiculos] = useState([]);
  const [clientes, setClientes] = useState([]);
  const [choferes, setChoferes] = useState([]);
  const [tiposVeh, setTiposVeh] = useState([]);
  const [tarifarios, setTarifarios] = useState([]);
  const [tickets, setTickets] = useState([]);
  const [configTurno, setConfigTurno] = useState(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  const [selected, setSelected] = useState(null);
  const [isIngreso, setIsIngreso] = useState(true);

  const [filtroPlaca, setFiltroPlaca] = useState('');
  const [filtroEstado, setFiltroEstado] = useState('todos');

  const fetchAll = async () => {
    setLoading(true);
    try {
      const [vehiculosRes, clientesRes, choferesRes, tiposRes, tarifariosRes, ticketsRes, configRes] = await Promise.all([
        api.get('/maestros/vehiculos/?page_size=500'),
        api.get('/maestros/clientes/?page_size=500'),
        api.get('/maestros/choferes/?page_size=500'),
        api.get('/maestros/tipo-vehiculos/?page_size=100'),
        api.get('/movimientos/tarifario/?page_size=200'),
        api.get('/movimientos/tickets/?page_size=500&ch_esta_activo=1'),
        api.get('/movimientos/config-turnos/?page_size=10'),
      ]);

      setVehiculos(vehiculosRes.data.results || vehiculosRes.data);
      setClientes(clientesRes.data.results || clientesRes.data);
      setChoferes(choferesRes.data.results || choferesRes.data);
      setTiposVeh(tiposRes.data.results || tiposRes.data);
      setTarifarios(tarifariosRes.data.results || tarifariosRes.data);
      setTickets((ticketsRes.data.results || ticketsRes.data || []).map(normalizeTicketDateFields));

      const configs = configRes.data.results || configRes.data || [];
      setConfigTurno(configs[0] || null);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchAll();
  }, []);

  const getVehiculo = (codigo) => vehiculos.find((item) => item.ch_codi_vehiculo === codigo);
  const getCliente = (codigo) => clientes.find((item) => item.ch_codi_cliente === codigo);
  const getChofer = (codigo) => choferes.find((item) => item.ch_codi_chofer === codigo);
  const getTipoVehiculo = (codigo) => tiposVeh.find((item) => item.ch_tipo_vehiculo === codigo);
  const getTarifario = (codigo) => tarifarios.find((item) => item.ch_codi_tarifario === codigo);
  const isVehiculoParqueado = (vehiculo) => isTrueValue(vehiculo?.ch_esta_parqueado);

  const getClienteDesc = (codigo) => getCliente(codigo)?.vc_razo_soci_cliente || '';
  const getChoferDesc = (codigo) => getChofer(codigo)?.vc_desc_chofer || '';
  const getTipoVehiculoDesc = (codigo) => getTipoVehiculo(codigo)?.vc_desc_tipo_vehiculo || '';
  const getTarifarioDesc = (codigo) => getTarifario(codigo)?.vc_desc_tarifario || codigo || '';

  const findOpenTicket = (codigoVehiculo) =>
    tickets.find((item) => item.ch_codi_vehiculo === codigoVehiculo && (!item.dt_fech_salida || item.ch_esta_ticket === '0'));

  const suggestTarifario = (vehiculo) => {
    if (!vehiculo) return '';

    const exact =
      tarifarios.find(
        (item) =>
          item.ch_esta_activo === '1' &&
          item.ch_tipo_vehiculo === vehiculo.ch_tipo_vehiculo &&
          item.ch_codi_cliente === vehiculo.ch_codi_cliente,
      ) ||
      tarifarios.find(
        (item) =>
          item.ch_tipo_vehiculo === vehiculo.ch_tipo_vehiculo &&
          item.ch_codi_cliente === vehiculo.ch_codi_cliente,
      );
    if (exact) return exact.ch_codi_tarifario;

    const byType =
      tarifarios.find(
        (item) =>
          item.ch_esta_activo === '1' &&
          item.ch_tipo_vehiculo === vehiculo.ch_tipo_vehiculo &&
          !item.ch_codi_cliente,
      ) ||
      tarifarios.find(
        (item) =>
          item.ch_tipo_vehiculo === vehiculo.ch_tipo_vehiculo &&
          !item.ch_codi_cliente,
      );
    return byType?.ch_codi_tarifario || '';
  };

  const createIngresoState = (vehiculo = null) => {
    const now = nowInputValue();
    const suggestedTariff = suggestTarifario(vehiculo);

    return {
      ch_codi_vehiculo: vehiculo?.ch_codi_vehiculo || '',
      ch_plac_vehiculo: vehiculo?.ch_plac_vehiculo || '',
      ch_tipo_vehiculo: vehiculo?.ch_tipo_vehiculo || '',
      ch_codi_cliente: vehiculo?.ch_codi_cliente || '',
      ch_codi_chofer: vehiculo?.ch_codi_chofer || '',
      dt_fech_ingreso: now,
      dt_fech_emision: now,
      dt_fech_salida: '',
      dt_fech_cancelado: '',
      ch_esta_ticket: '0',
      ch_esta_activo: '1',
      ch_esta_cancelado: '0',
      ch_esta_llave: '0',
      ch_esta_duermen: '0',
      ch_codi_garita: DEFAULT_GARITA_CODE,
      ch_codi_tarifario: suggestedTariff,
      ch_tipo_comprobante: '',
      ch_nume_telefono: '',
      vc_obse_tckt_ingreso: '',
      ch_obse_tckt_salida: '',
      nu_impo_total: '',
      nu_impo_dscto: '',
    };
  };

  const createSalidaState = (vehiculo, ticketAbierto) => {
    const now = nowInputValue();
    const suggestedTariff = ticketAbierto?.ch_codi_tarifario || suggestTarifario(vehiculo);

    return {
      ...normalizeTicketDateFields(ticketAbierto || {}),
      ch_codi_vehiculo: vehiculo?.ch_codi_vehiculo || '',
      ch_plac_vehiculo: vehiculo?.ch_plac_vehiculo || '',
      ch_tipo_vehiculo: vehiculo?.ch_tipo_vehiculo || '',
      ch_codi_cliente: vehiculo?.ch_codi_cliente || '',
      ch_codi_chofer: vehiculo?.ch_codi_chofer || '',
      ch_codi_tarifario: suggestedTariff,
      ch_codi_garita: ticketAbierto?.ch_codi_garita || DEFAULT_GARITA_CODE,
      dt_fech_salida: now,
      ch_esta_ticket: '1',
      ch_obse_tckt_salida: ticketAbierto?.ch_obse_tckt_salida || '',
    };
  };

  const handleRowClick = (vehiculo) => {
    if (isVehiculoParqueado(vehiculo)) {
      setSelected(createSalidaState(vehiculo, findOpenTicket(vehiculo.ch_codi_vehiculo)));
      setIsIngreso(false);
      return;
    }

    setSelected(createIngresoState(vehiculo));
    setIsIngreso(true);
  };

  const handleNuevoIngreso = () => {
    setSelected(createIngresoState());
    setIsIngreso(true);
  };

  const updateSelected = (key, value) => {
    setSelected((prev) => ({ ...prev, [key]: value }));
  };

  const handleCanceladoChange = (value) => {
    setSelected((prev) => ({
      ...prev,
      ch_esta_cancelado: value,
      dt_fech_cancelado: value === '1' ? nowInputValue() : '',
    }));
  };

  const handleVehiculoChange = (codigoVehiculo) => {
    const vehiculo = getVehiculo(codigoVehiculo);
    if (!vehiculo) {
      setSelected((prev) => ({
        ...prev,
        ch_codi_vehiculo: codigoVehiculo,
        ch_plac_vehiculo: '',
        ch_tipo_vehiculo: '',
        ch_codi_cliente: '',
        ch_codi_chofer: '',
        ch_codi_tarifario: '',
      }));
      return;
    }

    if (isVehiculoParqueado(vehiculo)) {
      setSelected(createSalidaState(vehiculo, findOpenTicket(vehiculo.ch_codi_vehiculo)));
      setIsIngreso(false);
      return;
    }

    setSelected((prev) => ({
      ...prev,
      ch_codi_vehiculo: vehiculo.ch_codi_vehiculo,
      ch_plac_vehiculo: vehiculo.ch_plac_vehiculo || '',
      ch_tipo_vehiculo: vehiculo.ch_tipo_vehiculo || '',
      ch_codi_cliente: vehiculo.ch_codi_cliente || '',
      ch_codi_chofer: vehiculo.ch_codi_chofer || '',
      ch_codi_tarifario: prev?.ch_codi_tarifario || suggestTarifario(vehiculo),
    }));
  };

  const previewTotal = useMemo(() => calculatePreviewTotal(selected, tarifarios, configTurno), [selected, tarifarios, configTurno]);

  const vehiculosFiltrados = useMemo(
    () =>
      vehiculos.filter((vehiculo) => {
        if (!isTrueValue(vehiculo.ch_esta_activo)) return false;
        if (filtroPlaca && !String(vehiculo.ch_plac_vehiculo || '').toLowerCase().includes(filtroPlaca.toLowerCase())) return false;

        const parqueado = isVehiculoParqueado(vehiculo);
        if (filtroEstado === 'parqueado' && !parqueado) return false;
        if (filtroEstado === 'libre' && parqueado) return false;

        return true;
      }),
    [vehiculos, filtroPlaca, filtroEstado],
  );

  const rows = useMemo(
    () =>
      vehiculosFiltrados.map((vehiculo) => ({
        ...vehiculo,
        tipo_desc: getTipoVehiculoDesc(vehiculo.ch_tipo_vehiculo),
        cliente_desc: getClienteDesc(vehiculo.ch_codi_cliente),
        chofer_desc: getChoferDesc(vehiculo.ch_codi_chofer),
      })),
    [vehiculosFiltrados, tiposVeh, clientes, choferes],
  );

  const columnas = [
    { key: 'ch_codi_vehiculo', label: 'Codigo vehiculo' },
    { key: 'ch_plac_vehiculo', label: 'Placa' },
    { key: 'tipo_desc', label: 'Tipo de vehiculo' },
    { key: 'cliente_desc', label: 'Cliente', render: (value) => value || '-' },
    { key: 'chofer_desc', label: 'Chofer', render: (value) => value || '-' },
    {
      key: 'ch_esta_parqueado',
      label: 'Estado parqueo',
      render: (_, row) => (isVehiculoParqueado(row) ? 'Parqueado' : 'Libre'),
    },
  ];

  const handleGuardar = async () => {
    if (!selected) return;

    setSaving(true);
    try {
      const payload = { ...selected };
      delete payload.ch_plac_vehiculo;
      payload.dt_fech_emision = toDateTimeApiValue(payload.dt_fech_emision);
      payload.dt_fech_ingreso = toDateTimeApiValue(payload.dt_fech_ingreso);
      payload.dt_fech_salida = toDateTimeApiValue(payload.dt_fech_salida);
      payload.dt_fech_cancelado = payload.dt_fech_cancelado ? toDateTimeApiValue(payload.dt_fech_cancelado) : null;

      if (isIngreso) {
        payload.dt_fech_emision = payload.dt_fech_ingreso || payload.dt_fech_emision;
        delete payload.dt_fech_salida;
        delete payload.nu_codi_ticket;
        delete payload.nu_impo_total;

        await api.post('/movimientos/tickets/', payload);

        if (payload.ch_codi_vehiculo) {
          await api.patch(`/maestros/vehiculos/${payload.ch_codi_vehiculo}/`, { ch_esta_parqueado: true });
        }
      } else {
        payload.dt_fech_salida = payload.dt_fech_salida || toDateTimeApiValue(new Date());
        delete payload.nu_impo_total;

        if (!payload.nu_codi_ticket) {
          throw new Error('No se encontro un ticket abierto para registrar la salida.');
        }

        await api.put(`/movimientos/tickets/${payload.nu_codi_ticket}/`, payload);

        if (payload.ch_codi_vehiculo) {
          await api.patch(`/maestros/vehiculos/${payload.ch_codi_vehiculo}/`, { ch_esta_parqueado: false });
        }
      }

      await fetchAll();
      setSelected(null);
    } catch (err) {
      alert(`Error: ${JSON.stringify(err.response?.data || err.message)}`);
    } finally {
      setSaving(false);
    }
  };

  const parqueados = useMemo(() => vehiculos.filter((item) => isVehiculoParqueado(item)).length, [vehiculos]);
  const libre = useMemo(() => vehiculos.filter((item) => !isVehiculoParqueado(item)).length, [vehiculos]);

  return (
    <div style={styles.page}>
      <div style={styles.contentGrid}>
        <section style={styles.listPanel}>
          <div style={styles.panelHeader}>
            <div>
              <p style={styles.eyebrow}>Movimientos</p>
              <h2 style={styles.title}>Alquiler de cochera</h2>
              <p style={styles.subtitle}>Haz clic en una fila para confirmar ingreso si el vehiculo esta libre o salida si ya esta parqueado.</p>
            </div>
            <button style={styles.btnPrimary} type="button" onClick={handleNuevoIngreso}>
              + Ingreso
            </button>
          </div>

          <div style={styles.filterRow}>
            <input
              style={styles.input}
              placeholder="Buscar por placa"
              value={filtroPlaca}
              onChange={(event) => setFiltroPlaca(event.target.value)}
            />
            <select style={styles.input} value={filtroEstado} onChange={(event) => setFiltroEstado(event.target.value)}>
              <option value="todos">Todos</option>
              <option value="parqueado">Parqueados</option>
              <option value="libre">Libres</option>
            </select>
          </div>

          <div style={styles.metricRow}>
            <MetricCard label="Parqueados" value={String(parqueados)} highlight />
            <MetricCard label="Libres" value={String(libre)} />
            <MetricCard label="Vehiculos" value={String(vehiculos.length)} />
          </div>

          <DataTable
            title="Vehiculos"
            subtitle="Selecciona un vehiculo para abrir el formulario lateral."
            columns={columnas}
            data={rows}
            loading={loading}
            onNew={null}
            onRowClick={(row) => handleRowClick(row)}
            getRowKey={(row) => row.ch_codi_vehiculo}
            selectedRowKey={selected?.ch_codi_vehiculo}
          />
        </section>

        <section style={styles.formPanel}>
          {!selected ? (
            <div style={styles.emptyForm}>
              <p style={styles.emptyTitle}>Selecciona un vehiculo</p>
              <p style={styles.emptyText}>La fila abre el formulario de ingreso o salida segun el estado de parqueo del vehiculo.</p>
            </div>
          ) : (
            <>
              <div style={styles.formHeader}>
                <div>
                  <p style={styles.eyebrow}>Operacion</p>
                  <h3 style={styles.formTitle}>{isIngreso ? 'Confirmar ingreso' : 'Confirmar salida'}</h3>
                  <p style={styles.formSubtitle}>
                    {isIngreso
                      ? 'Fecha ingreso se guarda en dt_fech_ingreso del ticket.'
                      : 'Fecha salida se guarda en dt_fech_salida del ticket.'}
                  </p>
                </div>
                <button style={styles.btnSecondary} type="button" onClick={() => setSelected(null)}>
                  Cerrar
                </button>
              </div>

              <div style={styles.section}>
                <p style={styles.sectionTitle}>Vehiculo</p>
                <div style={styles.formGrid}>
                  <FieldSelect
                    label="Codigo vehiculo"
                    value={selected.ch_codi_vehiculo || ''}
                    onChange={handleVehiculoChange}
                    options={vehiculos
                      .filter((item) => isTrueValue(item.ch_esta_activo))
                      .map((item) => ({
                        value: item.ch_codi_vehiculo,
                        label: `${item.ch_codi_vehiculo} - ${item.ch_plac_vehiculo}`,
                      }))}
                  />
                  <Field label="Placa" value={selected.ch_plac_vehiculo || ''} readOnly />
                  <Field label="Tipo de vehiculo" value={getTipoVehiculoDesc(selected.ch_tipo_vehiculo)} readOnly />
                  <Field label="Cliente" value={getClienteDesc(selected.ch_codi_cliente)} readOnly />
                  <Field label="Chofer" value={getChoferDesc(selected.ch_codi_chofer)} readOnly />
                  <Field label="Estado parqueo" value={isVehiculoParqueado(getVehiculo(selected.ch_codi_vehiculo)) ? 'Parqueado' : 'Libre'} readOnly />
                </div>
              </div>

              <div style={styles.section}>
                <p style={styles.sectionTitle}>{isIngreso ? 'Ingreso' : 'Salida'}</p>
                <div style={styles.formGrid}>
                  {isIngreso ? (
                    <Field
                      label="Fecha ingreso"
                      type="datetime-local"
                      value={selected.dt_fech_ingreso || ''}
                      onChange={(value) => updateSelected('dt_fech_ingreso', value)}
                    />
                  ) : (
                    <Field
                      label="Fecha salida"
                      type="datetime-local"
                      value={selected.dt_fech_salida || ''}
                      onChange={(value) => updateSelected('dt_fech_salida', value)}
                    />
                  )}

                  <Field label="Garita" value={DEFAULT_GARITA_LABEL} readOnly />

                  <FieldSelect
                    label="Tarifario"
                    value={selected.ch_codi_tarifario || ''}
                    onChange={(value) => updateSelected('ch_codi_tarifario', value)}
                    options={tarifarios
                      .filter((item) => item.ch_esta_activo === '1')
                      .map((item) => ({ value: item.ch_codi_tarifario, label: getTarifarioDesc(item.ch_codi_tarifario) }))}
                  />

                  <FieldSelect
                    label="Tipo comprobante"
                    value={selected.ch_tipo_comprobante || ''}
                    onChange={(value) => updateSelected('ch_tipo_comprobante', value)}
                    options={[
                      { value: 'BO', label: 'Boleta' },
                      { value: 'FA', label: 'Factura' },
                    ]}
                  />

                  <Field label="Importe total (S/)" value={isIngreso ? '' : previewTotal} readOnly />

                  {!isIngreso && <Field label="Fecha ingreso" value={formatDateTimeDisplay(selected.dt_fech_ingreso)} readOnly />}
                  {!isIngreso && (
                    <FieldSelect
                      label="Cancelado"
                      value={selected.ch_esta_cancelado || '0'}
                      onChange={handleCanceladoChange}
                      options={[
                        { value: '0', label: 'False' },
                        { value: '1', label: 'True' },
                      ]}
                    />
                  )}
                  {!isIngreso && <Field label="Fecha cancelado" value={formatDateTimeDisplay(selected.dt_fech_cancelado)} readOnly />}

                  {isIngreso && (
                    <>
                      <FieldSelect
                        label="Llave"
                        value={selected.ch_esta_llave || '0'}
                        onChange={(value) => updateSelected('ch_esta_llave', value)}
                        options={[
                          { value: '0', label: 'No' },
                          { value: '1', label: 'Si' },
                        ]}
                      />
                      <FieldSelect
                        label="Duermen"
                        value={selected.ch_esta_duermen || '0'}
                        onChange={(value) => updateSelected('ch_esta_duermen', value)}
                        options={[
                          { value: '0', label: 'No' },
                          { value: '1', label: 'Si' },
                        ]}
                      />
                      <Field
                        label="Telefono"
                        value={selected.ch_nume_telefono || ''}
                        onChange={(value) => updateSelected('ch_nume_telefono', value)}
                      />
                    </>
                  )}
                </div>
              </div>

              <div style={styles.section}>
                <p style={styles.sectionTitle}>Observacion</p>
                <textarea
                  style={styles.textarea}
                  rows={3}
                  value={isIngreso ? selected.vc_obse_tckt_ingreso || '' : selected.ch_obse_tckt_salida || ''}
                  onChange={(event) =>
                    updateSelected(isIngreso ? 'vc_obse_tckt_ingreso' : 'ch_obse_tckt_salida', event.target.value)
                  }
                  placeholder={isIngreso ? 'Observacion del ingreso' : 'Observacion de la salida'}
                />
              </div>

              <div style={styles.footer}>
                <button style={styles.btnSecondary} type="button" onClick={() => setSelected(null)}>
                  Cancelar
                </button>
                <button style={styles.btnPrimary} type="button" onClick={handleGuardar} disabled={saving}>
                  {saving ? 'Guardando...' : isIngreso ? 'Confirmar ingreso' : 'Confirmar salida'}
                </button>
              </div>
            </>
          )}
        </section>
      </div>
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

function Field({ label, value, onChange, type = 'text', readOnly = false }) {
  return (
    <div style={styles.field}>
      <label style={styles.label}>{label}</label>
      <input
        style={{ ...styles.input, ...(readOnly ? styles.inputReadOnly : {}) }}
        type={type}
        value={value || ''}
        onChange={(event) => onChange?.(event.target.value)}
        readOnly={readOnly}
      />
    </div>
  );
}

function FieldSelect({ label, value, onChange, options }) {
  return (
    <div style={styles.field}>
      <label style={styles.label}>{label}</label>
      <select style={styles.input} value={value || ''} onChange={(event) => onChange?.(event.target.value)}>
        <option value="">Seleccionar</option>
        {options.map((option) => (
          <option key={option.value} value={option.value}>
            {option.label}
          </option>
        ))}
      </select>
    </div>
  );
}

const cardBase = {
  background: theme.colors.panel,
  borderRadius: theme.radius.lg,
  border: `1px solid ${theme.colors.border}`,
  boxShadow: theme.shadow.card,
};

const styles = {
  page: {
    display: 'flex',
    flexDirection: 'column',
    gap: 16,
  },
  contentGrid: {
    display: 'grid',
    gridTemplateColumns: 'minmax(0, 1.15fr) minmax(360px, 0.95fr)',
    gap: 18,
    alignItems: 'start',
  },
  listPanel: {
    display: 'flex',
    flexDirection: 'column',
    gap: 16,
  },
  formPanel: {
    ...cardBase,
    padding: 20,
    position: 'sticky',
    top: 0,
  },
  panelHeader: {
    ...cardBase,
    padding: 20,
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    gap: 12,
  },
  eyebrow: {
    margin: 0,
    color: theme.colors.textSoft,
    fontSize: theme.typography.small,
    textTransform: 'uppercase',
    letterSpacing: 1,
    fontWeight: 800,
  },
  title: {
    margin: '6px 0 0',
    fontSize: 22,
    color: theme.colors.text,
    fontWeight: 800,
  },
  subtitle: {
    margin: '6px 0 0',
    fontSize: theme.typography.body,
    color: theme.colors.textMuted,
  },
  filterRow: {
    display: 'grid',
    gridTemplateColumns: 'minmax(0, 1fr) 220px',
    gap: 12,
  },
  metricRow: {
    display: 'grid',
    gridTemplateColumns: 'repeat(3, minmax(0, 1fr))',
    gap: 12,
  },
  metricCard: {
    ...cardBase,
    padding: '14px 16px',
    display: 'flex',
    flexDirection: 'column',
    gap: 6,
  },
  metricCardHighlight: {
    background: '#ecfdf5',
    borderColor: '#a7f3d0',
  },
  metricLabel: {
    color: theme.colors.textMuted,
    fontSize: theme.typography.small,
    textTransform: 'uppercase',
    letterSpacing: 0.8,
    fontWeight: 700,
  },
  metricLabelHighlight: {
    color: theme.colors.success,
  },
  metricValue: {
    color: theme.colors.text,
    fontSize: 24,
    fontWeight: 800,
  },
  metricValueHighlight: {
    color: theme.colors.success,
  },
  formHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    gap: 12,
    marginBottom: 18,
    paddingBottom: 16,
    borderBottom: `1px solid ${theme.colors.border}`,
  },
  formTitle: {
    margin: '6px 0 0',
    fontSize: 20,
    color: theme.colors.text,
    fontWeight: 800,
  },
  formSubtitle: {
    margin: '6px 0 0',
    fontSize: theme.typography.body,
    color: theme.colors.textMuted,
  },
  section: {
    marginBottom: 18,
    paddingBottom: 18,
    borderBottom: `1px solid ${theme.colors.border}`,
  },
  sectionTitle: {
    margin: '0 0 12px',
    fontSize: theme.typography.small,
    fontWeight: 800,
    color: theme.colors.textSoft,
    textTransform: 'uppercase',
    letterSpacing: 0.8,
  },
  formGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(2, minmax(0, 1fr))',
    gap: 14,
  },
  field: {
    display: 'flex',
    flexDirection: 'column',
    gap: 6,
  },
  label: {
    fontSize: theme.typography.label,
    fontWeight: 700,
    color: theme.colors.textMuted,
  },
  input: {
    width: '100%',
    boxSizing: 'border-box',
    padding: '11px 12px',
    border: `1px solid ${theme.colors.borderStrong}`,
    borderRadius: theme.radius.sm,
    fontSize: theme.typography.body,
    color: theme.colors.text,
    background: theme.colors.panel,
    outline: 'none',
  },
  inputReadOnly: {
    background: theme.colors.panelMuted,
    color: theme.colors.textMuted,
  },
  textarea: {
    width: '100%',
    boxSizing: 'border-box',
    padding: '11px 12px',
    border: `1px solid ${theme.colors.borderStrong}`,
    borderRadius: theme.radius.sm,
    fontSize: theme.typography.body,
    color: theme.colors.text,
    background: theme.colors.panel,
    outline: 'none',
    resize: 'vertical',
    fontFamily: 'inherit',
  },
  emptyForm: {
    minHeight: 340,
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    textAlign: 'center',
    gap: 10,
  },
  emptyTitle: {
    margin: 0,
    color: theme.colors.text,
    fontSize: 18,
    fontWeight: 800,
  },
  emptyText: {
    margin: 0,
    color: theme.colors.textMuted,
    fontSize: theme.typography.body,
    maxWidth: 320,
  },
  footer: {
    display: 'flex',
    justifyContent: 'flex-end',
    gap: 10,
    paddingTop: 4,
  },
  btnPrimary: {
    background: theme.colors.brand,
    color: '#fff',
    border: 'none',
    padding: '10px 18px',
    borderRadius: theme.radius.sm,
    cursor: 'pointer',
    fontWeight: 700,
    boxShadow: theme.shadow.soft,
  },
  btnSecondary: {
    background: theme.colors.panelMuted,
    color: theme.colors.textMuted,
    border: `1px solid ${theme.colors.border}`,
    padding: '10px 18px',
    borderRadius: theme.radius.sm,
    cursor: 'pointer',
    fontWeight: 700,
  },
};

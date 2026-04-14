import { Alert, FlatList, Modal, SafeAreaView, StyleSheet, Text, View } from 'react-native';
import { useEffect, useMemo, useState } from 'react';
import { apiRequest } from '../services/api';
import { theme } from '../theme/tokens';
import { boolValue, formatDateTime, normalizeList, nowInputValue, toApiDateTime } from '../utils/format';
import { EmptyState, FormField, InfoPanel, LoadingPanel, PrimaryButton, SearchBox, SecondaryButton, SecondaryPill } from '../components/ui';
import { DEFAULT_GARITA_CODE, DEFAULT_GARITA_LABEL } from '../config/appConfig';

export default function TicketsScreen({ session }) {
  const [vehicles, setVehicles] = useState([]);
  const [tickets, setTickets] = useState([]);
  const [tarifarios, setTarifarios] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [query, setQuery] = useState('');
  const [selectedVehicle, setSelectedVehicle] = useState(null);
  const [formState, setFormState] = useState(null);

  const fetchData = async () => {
    setLoading(true);
    try {
      const [vehiclesRes, ticketsRes, tarifariosRes] = await Promise.all([
        apiRequest('/maestros/vehiculos/?page_size=300', { token: session.accessToken }),
        apiRequest('/movimientos/tickets/?page_size=300&ch_esta_activo=1', { token: session.accessToken }),
        apiRequest('/movimientos/tarifario/?page_size=200', { token: session.accessToken }),
      ]);
      setVehicles(normalizeList(vehiclesRes));
      setTickets(normalizeList(ticketsRes));
      setTarifarios(normalizeList(tarifariosRes));
    } catch (error) {
      Alert.alert('Error', error.message || 'No se pudieron cargar los tickets.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const filteredVehicles = useMemo(() => {
    if (!query.trim()) return vehicles;
    const needle = query.trim().toLowerCase();
    return vehicles.filter((vehicle) =>
      [vehicle.ch_plac_vehiculo, vehicle.ch_codi_vehiculo].some((value) => String(value ?? '').toLowerCase().includes(needle)),
    );
  }, [vehicles, query]);

  const findOpenTicket = (vehicleCode) =>
    tickets.find((ticket) => ticket.ch_codi_vehiculo === vehicleCode && (!ticket.dt_fech_salida || ticket.ch_esta_ticket === '0'));

  const suggestTarifario = (vehicle) => {
    if (!vehicle) return '';
    const exact = tarifarios.find(
      (item) =>
        String(item.ch_esta_activo ?? '1') === '1' &&
        item.ch_tipo_vehiculo === vehicle.ch_tipo_vehiculo &&
        item.ch_codi_cliente === vehicle.ch_codi_cliente,
    );
    if (exact) return exact.ch_codi_tarifario;
    const byType = tarifarios.find(
      (item) => String(item.ch_esta_activo ?? '1') === '1' && item.ch_tipo_vehiculo === vehicle.ch_tipo_vehiculo,
    );
    return byType?.ch_codi_tarifario || '';
  };

  const openVehicleFlow = (vehicle) => {
    const openTicket = findOpenTicket(vehicle.ch_codi_vehiculo);
    const parked = boolValue(vehicle.ch_esta_parqueado);
    setSelectedVehicle(vehicle);
    if (parked && openTicket) {
      setFormState({
        mode: 'salida',
        nu_codi_ticket: openTicket.nu_codi_ticket,
        ch_codi_vehiculo: vehicle.ch_codi_vehiculo,
        dt_fech_ingreso: openTicket.dt_fech_ingreso,
        dt_fech_salida: nowInputValue(),
        ch_esta_cancelado: String(openTicket.ch_esta_cancelado ?? '0'),
        dt_fech_cancelado: openTicket.dt_fech_cancelado ? nowInputValue() : '',
        ch_obse_tckt_salida: openTicket.ch_obse_tckt_salida || '',
        ch_codi_tarifario: openTicket.ch_codi_tarifario || suggestTarifario(vehicle),
        ch_tipo_comprobante: openTicket.ch_tipo_comprobante || '',
      });
      return;
    }

    setFormState({
      mode: 'ingreso',
      ch_codi_vehiculo: vehicle.ch_codi_vehiculo,
      dt_fech_ingreso: nowInputValue(),
      ch_codi_tarifario: suggestTarifario(vehicle),
      ch_tipo_comprobante: '',
      ch_nume_telefono: '',
      vc_obse_tckt_ingreso: '',
      ch_esta_llave: '0',
      ch_esta_duermen: '0',
    });
  };

  const handleSave = async () => {
    if (!selectedVehicle || !formState) return;
    setSaving(true);
    try {
      if (formState.mode === 'ingreso') {
        await apiRequest('/movimientos/tickets/', {
          method: 'POST',
          token: session.accessToken,
          body: {
            ch_codi_vehiculo: selectedVehicle.ch_codi_vehiculo,
            dt_fech_ingreso: toApiDateTime(formState.dt_fech_ingreso),
            dt_fech_emision: toApiDateTime(formState.dt_fech_ingreso),
            ch_codi_tarifario: formState.ch_codi_tarifario || null,
            ch_tipo_comprobante: formState.ch_tipo_comprobante || '',
            ch_nume_telefono: formState.ch_nume_telefono || '',
            vc_obse_tckt_ingreso: formState.vc_obse_tckt_ingreso || '',
            ch_esta_llave: formState.ch_esta_llave,
            ch_esta_duermen: formState.ch_esta_duermen,
            ch_esta_ticket: '0',
            ch_esta_activo: '1',
            ch_esta_cancelado: '0',
            ch_codi_cajero: session.user.username,
            ch_codi_garita: DEFAULT_GARITA_CODE,
          },
        });
        await apiRequest(`/maestros/vehiculos/${selectedVehicle.ch_codi_vehiculo}/`, {
          method: 'PATCH',
          token: session.accessToken,
          body: { ch_esta_parqueado: true },
        });
      } else {
        await apiRequest(`/movimientos/tickets/${formState.nu_codi_ticket}/`, {
          method: 'PUT',
          token: session.accessToken,
          body: {
            ch_codi_vehiculo: selectedVehicle.ch_codi_vehiculo,
            dt_fech_ingreso: toApiDateTime(formState.dt_fech_ingreso),
            dt_fech_salida: toApiDateTime(formState.dt_fech_salida),
            dt_fech_cancelado: formState.ch_esta_cancelado === '1' ? toApiDateTime(formState.dt_fech_cancelado || formState.dt_fech_salida) : null,
            ch_codi_tarifario: formState.ch_codi_tarifario || null,
            ch_tipo_comprobante: formState.ch_tipo_comprobante || '',
            ch_esta_ticket: '1',
            ch_esta_cancelado: formState.ch_esta_cancelado,
            ch_obse_tckt_salida: formState.ch_obse_tckt_salida || '',
            ch_codi_cajero: session.user.username,
            ch_codi_garita: DEFAULT_GARITA_CODE,
          },
        });
        await apiRequest(`/maestros/vehiculos/${selectedVehicle.ch_codi_vehiculo}/`, {
          method: 'PATCH',
          token: session.accessToken,
          body: { ch_esta_parqueado: false },
        });
      }
      setSelectedVehicle(null);
      setFormState(null);
      await fetchData();
    } catch (error) {
      Alert.alert('Error', error.message || 'No se pudo guardar el ticket.');
    } finally {
      setSaving(false);
    }
  };

  return (
    <View style={styles.screenFill}>
      <View style={styles.screenHeaderCard}>
        <Text style={styles.screenEyebrow}>Tickets</Text>
        <Text style={styles.screenTitle}>Registro de ingreso y salida desde operación</Text>
        <SearchBox value={query} onChangeText={setQuery} placeholder="Buscar por placa o código" />
      </View>

      {loading ? (
        <LoadingPanel label="Cargando vehículos..." />
      ) : (
        <FlatList
          data={filteredVehicles}
          keyExtractor={(item) => String(item.ch_codi_vehiculo)}
          contentContainerStyle={styles.listContent}
          ListEmptyComponent={<EmptyState title="Sin vehículos" text="No se encontraron vehículos para registrar." />}
          renderItem={({ item }) => {
            const parked = boolValue(item.ch_esta_parqueado);
            return (
              <Text onPress={() => openVehicleFlow(item)} style={styles.cardTextWrap}>
                <Text style={styles.recordTitle}>{item.ch_plac_vehiculo || item.ch_codi_vehiculo}{'\n'}</Text>
                <Text style={styles.recordMeta}>{item.ch_codi_cliente || 'Sin cliente'} · {parked ? 'Parqueado' : 'Libre'}</Text>
              </Text>
            );
          }}
        />
      )}

      <Modal animationType="slide" visible={Boolean(selectedVehicle && formState)} onRequestClose={() => setSelectedVehicle(null)}>
        <SafeAreaView style={styles.modalShell}>
          <View style={styles.modalHeader}>
            <View>
              <Text style={styles.modalEyebrow}>{formState?.mode === 'salida' ? 'Salida' : 'Ingreso'}</Text>
              <Text style={styles.modalTitle}>{selectedVehicle?.ch_plac_vehiculo || selectedVehicle?.ch_codi_vehiculo}</Text>
            </View>
            <SecondaryPill label="Cerrar" onPress={() => { setSelectedVehicle(null); setFormState(null); }} />
          </View>

          <FlatList
            data={
              formState?.mode === 'ingreso'
                ? [
                    { key: 'dt_fech_ingreso', label: 'Fecha ingreso', type: 'datetime' },
                    { key: 'ch_codi_tarifario', label: 'Tarifario', type: 'text' },
                    { key: 'ch_tipo_comprobante', label: 'Comprobante', type: 'select', options: [{ label: 'Seleccionar', value: '' }, { label: 'Boleta', value: 'BO' }, { label: 'Factura', value: 'FA' }] },
                    { key: 'ch_nume_telefono', label: 'Teléfono', type: 'text' },
                    { key: 'ch_esta_llave', label: 'Llave', type: 'flag' },
                    { key: 'ch_esta_duermen', label: 'Duermen', type: 'flag' },
                    { key: 'vc_obse_tckt_ingreso', label: 'Observación', type: 'multiline' },
                  ]
                : [
                    { key: 'dt_fech_ingreso', label: 'Fecha ingreso', type: 'readonlyLabel', displayValue: formatDateTime(formState?.dt_fech_ingreso) },
                    { key: 'dt_fech_salida', label: 'Fecha salida', type: 'datetime' },
                    { key: 'ch_esta_cancelado', label: 'Cancelado', type: 'flag' },
                    ...(formState?.ch_esta_cancelado === '1' ? [{ key: 'dt_fech_cancelado', label: 'Fecha cancelado', type: 'datetime' }] : []),
                    { key: 'ch_obse_tckt_salida', label: 'Observación salida', type: 'multiline' },
                  ]
            }
            keyExtractor={(item) => item.key}
            contentContainerStyle={styles.modalContent}
            ListFooterComponent={
              <InfoPanel rows={[{ label: 'Garita', value: DEFAULT_GARITA_LABEL }, { label: 'Cajero', value: session.user.username }]} />
            }
            renderItem={({ item }) => (
              <FormField field={item} value={formState?.[item.key]} options={item.options || []} onChange={(value) => setFormState((prev) => ({ ...prev, [item.key]: value, ...(item.key === 'ch_esta_cancelado' ? { dt_fech_cancelado: value === '1' ? nowInputValue() : '' } : {}) }))} />
            )}
          />

          <View style={styles.modalFooter}>
            <SecondaryButton label="Cancelar" onPress={() => { setSelectedVehicle(null); setFormState(null); }} />
            <PrimaryButton label="Guardar ticket" onPress={handleSave} disabled={saving} loading={saving} compact />
          </View>
        </SafeAreaView>
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  screenFill: { flex: 1 },
  screenHeaderCard: { marginHorizontal: 20, marginBottom: 12, backgroundColor: theme.colors.panel, borderRadius: theme.radius.md, borderWidth: 1, borderColor: theme.colors.border, padding: 18, gap: 10 },
  screenEyebrow: { color: theme.colors.brand, fontSize: 12, fontWeight: '800', textTransform: 'uppercase' },
  screenTitle: { color: theme.colors.text, fontSize: 18, fontWeight: '800', lineHeight: 24 },
  listContent: { paddingHorizontal: 20, paddingBottom: 24, gap: 10 },
  cardTextWrap: { backgroundColor: theme.colors.panel, borderRadius: theme.radius.md, borderWidth: 1, borderColor: theme.colors.border, padding: 16, color: theme.colors.text },
  recordTitle: { color: theme.colors.text, fontSize: 16, fontWeight: '800' },
  recordMeta: { color: theme.colors.textMuted, fontSize: 13, lineHeight: 18 },
  modalShell: { flex: 1, backgroundColor: theme.colors.appBg },
  modalHeader: { paddingHorizontal: 20, paddingVertical: 16, flexDirection: 'row', justifyContent: 'space-between', gap: 12, alignItems: 'center' },
  modalEyebrow: { color: theme.colors.textSoft, fontSize: 12, fontWeight: '800', textTransform: 'uppercase' },
  modalTitle: { color: theme.colors.text, fontSize: 22, fontWeight: '900', marginTop: 4 },
  modalContent: { padding: 20, gap: 14 },
  modalFooter: { padding: 20, flexDirection: 'row', gap: 10 },
});

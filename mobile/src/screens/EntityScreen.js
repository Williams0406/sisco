import { Alert, FlatList, Modal, SafeAreaView, StyleSheet, Text, View } from 'react-native';
import { useEffect, useMemo, useState } from 'react';
import { apiRequest } from '../services/api';
import { theme } from '../theme/tokens';
import { normalizeList, normalizeRecordForForm, toApiDateTime } from '../utils/format';
import { EmptyState, FormField, LoadingPanel, PrimaryButton, SearchBox, SecondaryButton, SecondaryPill } from '../components/ui';

function toOptions(items, lookup) {
  return [
    { label: 'Seleccionar', value: '' },
    ...items.map((item) => ({
      value: item[lookup.valueKey],
      label: lookup.labelKeys.map((key) => item[key]).filter(Boolean).join(' · ') || item[lookup.valueKey],
    })),
  ];
}

export default function EntityScreen({ session, config }) {
  const [records, setRecords] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [refreshing, setRefreshing] = useState(false);
  const [query, setQuery] = useState('');
  const [formVisible, setFormVisible] = useState(false);
  const [formMode, setFormMode] = useState('create');
  const [selectedRecord, setSelectedRecord] = useState(null);
  const [formState, setFormState] = useState(config.emptyRecord({ user: session.user }));
  const [lookups, setLookups] = useState({});

  const fetchData = async (background = false) => {
    if (background) setRefreshing(true);
    else setLoading(true);
    try {
      const [recordsRes, lookupEntries] = await Promise.all([
        apiRequest(`${config.endpoint}?page_size=200`, { token: session.accessToken }),
        Promise.all(
          (config.lookups || []).map(async (lookup) => {
            const response = await apiRequest(lookup.endpoint, { token: session.accessToken });
            return [lookup.key, toOptions(normalizeList(response), lookup)];
          }),
        ),
      ]);
      setRecords(normalizeList(recordsRes));
      setLookups(Object.fromEntries(lookupEntries));
    } catch (error) {
      Alert.alert('Error', error.message || 'No se pudo cargar la información.');
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, [config.endpoint]);

  const filteredRecords = useMemo(() => {
    if (!query.trim()) return records;
    const needle = query.trim().toLowerCase();
    return records.filter((record) =>
      (config.searchKeys || []).some((key) => String(record[key] ?? '').toLowerCase().includes(needle)),
    );
  }, [records, query, config.searchKeys]);

  const openCreate = () => {
    setFormMode('create');
    setSelectedRecord(null);
    setFormState(config.emptyRecord({ user: session.user }));
    setFormVisible(true);
  };

  const openEdit = (record) => {
    setFormMode('edit');
    setSelectedRecord(record);
    setFormState({
      ...config.emptyRecord({ user: session.user }),
      ...normalizeRecordForForm(record),
      ch_codi_cajero: record.ch_codi_cajero || session.user.username,
      ch_codi_garita: record.ch_codi_garita || 'GAR',
    });
    setFormVisible(true);
  };

  const handleSave = async () => {
    if (config.fields.some((field) => field.required && !String(formState[field.key] ?? '').trim())) {
      Alert.alert('Faltan datos', 'Completa los campos obligatorios antes de guardar.');
      return;
    }

    setSaving(true);
    try {
      let payload = {
        ...formState,
        ch_codi_cajero: formState.ch_codi_cajero || session.user.username,
        ch_codi_garita: formState.ch_codi_garita || 'GAR',
      };

      Object.keys(payload).forEach((key) => {
        if (key.startsWith('dt_') && payload[key]) payload[key] = toApiDateTime(payload[key]);
      });

      if (config.sanitize) payload = config.sanitize(payload, { user: session.user });
      delete payload[config.idKey];

      if (formMode === 'create') {
        await apiRequest(config.endpoint, {
          method: 'POST',
          token: session.accessToken,
          body: payload,
        });
      } else if (selectedRecord) {
        await apiRequest(`${config.endpoint}${selectedRecord[config.idKey]}/`, {
          method: 'PUT',
          token: session.accessToken,
          body: payload,
        });
      }

      setFormVisible(false);
      await fetchData(true);
    } catch (error) {
      Alert.alert('Error al guardar', error.message || 'No se pudo guardar el registro.');
    } finally {
      setSaving(false);
    }
  };

  return (
    <View style={styles.screenFill}>
      <View style={styles.screenHeaderCard}>
        <Text style={styles.screenEyebrow}>{config.title}</Text>
        <Text style={styles.screenTitle}>{config.subtitle}</Text>
        <SearchBox value={query} onChangeText={setQuery} placeholder="Buscar registro" />
        {config.allowCreate !== false ? <PrimaryButton label={config.createLabel} onPress={openCreate} compact /> : null}
      </View>

      {loading ? (
        <LoadingPanel label={`Cargando ${config.title.toLowerCase()}...`} />
      ) : (
        <FlatList
          data={filteredRecords}
          keyExtractor={(item, index) => String(item[config.idKey] ?? index)}
          contentContainerStyle={styles.listContent}
          refreshing={refreshing}
          onRefresh={() => fetchData(true)}
          ListEmptyComponent={<EmptyState title="Sin registros" text="Aún no hay información para este módulo." />}
          renderItem={({ item }) => (
            <TextButtonCard title={config.getTitle(item)} subtitle={config.getMeta(item)} onPress={() => openEdit(item)} />
          )}
        />
      )}

      <Modal animationType="slide" visible={formVisible} onRequestClose={() => setFormVisible(false)}>
        <SafeAreaView style={styles.modalShell}>
          <View style={styles.modalHeader}>
            <View>
              <Text style={styles.modalEyebrow}>{formMode === 'create' ? 'Nuevo registro' : 'Editar registro'}</Text>
              <Text style={styles.modalTitle}>{config.title}</Text>
            </View>
            <SecondaryPill label="Cerrar" onPress={() => setFormVisible(false)} />
          </View>

          <FlatList
            data={config.fields}
            keyExtractor={(item) => item.key}
            contentContainerStyle={styles.modalContent}
            renderItem={({ item }) => (
              <FormField
                field={item}
                value={formState[item.key]}
                options={lookups[item.optionsKey] || []}
                onChange={(value) => setFormState((prev) => ({ ...prev, [item.key]: value }))}
              />
            )}
          />

          <View style={styles.modalFooter}>
            <SecondaryButton label="Cancelar" onPress={() => setFormVisible(false)} />
            <PrimaryButton label="Guardar" onPress={handleSave} disabled={saving} loading={saving} compact />
          </View>
        </SafeAreaView>
      </Modal>
    </View>
  );
}

function TextButtonCard({ title, subtitle, onPress }) {
  return (
    <Text onPress={onPress} style={styles.cardTextWrap}>
      <Text style={styles.recordTitle}>{title}{'\n'}</Text>
      <Text style={styles.recordMeta}>{subtitle}</Text>
    </Text>
  );
}

const styles = StyleSheet.create({
  screenFill: { flex: 1 },
  screenHeaderCard: {
    marginHorizontal: 20,
    marginBottom: 12,
    backgroundColor: theme.colors.panel,
    borderRadius: theme.radius.md,
    borderWidth: 1,
    borderColor: theme.colors.border,
    padding: 18,
    gap: 10,
  },
  screenEyebrow: { color: theme.colors.brand, fontSize: 12, fontWeight: '800', textTransform: 'uppercase' },
  screenTitle: { color: theme.colors.text, fontSize: 18, fontWeight: '800', lineHeight: 24 },
  listContent: { paddingHorizontal: 20, paddingBottom: 24, gap: 10 },
  cardTextWrap: {
    backgroundColor: theme.colors.panel,
    borderRadius: theme.radius.md,
    borderWidth: 1,
    borderColor: theme.colors.border,
    padding: 16,
    color: theme.colors.text,
  },
  recordTitle: { color: theme.colors.text, fontSize: 16, fontWeight: '800' },
  recordMeta: { color: theme.colors.textMuted, fontSize: 13, lineHeight: 18 },
  modalShell: { flex: 1, backgroundColor: theme.colors.appBg },
  modalHeader: {
    paddingHorizontal: 20,
    paddingVertical: 16,
    flexDirection: 'row',
    justifyContent: 'space-between',
    gap: 12,
    alignItems: 'center',
  },
  modalEyebrow: { color: theme.colors.textSoft, fontSize: 12, fontWeight: '800', textTransform: 'uppercase' },
  modalTitle: { color: theme.colors.text, fontSize: 22, fontWeight: '900', marginTop: 4 },
  modalContent: { padding: 20, gap: 14 },
  modalFooter: { padding: 20, flexDirection: 'row', gap: 10 },
});

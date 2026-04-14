import { useEffect, useRef, useState } from 'react';
import { ActivityIndicator, Pressable, ScrollView, StyleSheet, Switch, Text, TextInput, View } from 'react-native';
import { theme } from '../theme/tokens';
import { boolValue, formatMoney, nowInputValue, pad } from '../utils/format';

export function FeaturePill({ label }) {
  return (
    <View style={styles.featurePill}>
      <Text style={styles.featurePillText}>{label}</Text>
    </View>
  );
}

export function StatCard({ label, value, highlight = false }) {
  return (
    <View style={[styles.statCard, highlight && styles.statCardHighlight]}>
      <Text style={[styles.statLabel, highlight && styles.statLabelHighlight]}>{label}</Text>
      <Text style={[styles.statValue, highlight && styles.statValueHighlight]}>{value}</Text>
    </View>
  );
}

export function SectionHeader({ title, subtitle }) {
  return (
    <View style={styles.sectionHeader}>
      <Text style={styles.sectionTitle}>{title}</Text>
      <Text style={styles.sectionSubtitle}>{subtitle}</Text>
    </View>
  );
}

export function InfoPanel({ rows }) {
    return (
      <View style={styles.infoPanel}>
        {rows.map((row) => (
          <View key={row.label} style={styles.infoRow}>
            <Text style={styles.infoLabel}>{row.label}</Text>
            <Text style={styles.infoValue}>{row.value}</Text>
          </View>
        ))}
      </View>
    );
}

export function EmptyState({ title, text }) {
  return (
    <View style={styles.emptyState}>
      <Text style={styles.emptyTitle}>{title}</Text>
      <Text style={styles.emptyText}>{text}</Text>
    </View>
  );
}

export function LoadingPanel({ label }) {
  return (
    <View style={styles.loadingPanel}>
      <ActivityIndicator color={theme.colors.brand} />
      <Text style={styles.loadingText}>{label}</Text>
    </View>
  );
}

export function LabeledInput({ label, ...props }) {
  return (
    <View style={styles.fieldBlock}>
      <Text style={styles.fieldLabel}>{label}</Text>
      <TextInput {...props} placeholderTextColor={theme.colors.textSoft} style={styles.textInput} />
    </View>
  );
}

export function SearchBox({ value, onChangeText, placeholder }) {
  return (
    <View style={styles.searchBox}>
      <TextInput
        value={value}
        onChangeText={onChangeText}
        placeholder={placeholder}
        placeholderTextColor={theme.colors.textSoft}
        style={styles.searchInput}
      />
    </View>
  );
}

export function PrimaryButton({ label, onPress, disabled = false, loading = false, compact = false }) {
  return (
    <Pressable style={[compact ? styles.primaryButtonCompact : styles.primaryButton, disabled && styles.buttonDisabled]} onPress={onPress} disabled={disabled}>
      {loading ? <ActivityIndicator color="#fff" /> : <Text style={styles.primaryButtonText}>{label}</Text>}
    </Pressable>
  );
}

export function SecondaryButton({ label, onPress }) {
  return (
    <Pressable style={styles.secondaryButton} onPress={onPress}>
      <Text style={styles.secondaryButtonText}>{label}</Text>
    </Pressable>
  );
}

export function SecondaryPill({ label, onPress }) {
  return (
    <Pressable style={styles.secondaryPill} onPress={onPress}>
      <Text style={styles.secondaryPillText}>{label}</Text>
    </Pressable>
  );
}

export function FormField({ field, value, onChange, options = [] }) {
  const currentValue = value ?? '';

  if (field.type === 'readonly' || field.type === 'readonlyLabel' || field.type === 'readonlyMoney') {
    const displayValue =
      field.type === 'readonlyMoney'
        ? formatMoney(currentValue)
        : field.displayValue || String(currentValue || 'Auto');

    return (
      <View style={styles.fieldBlock}>
        <Text style={styles.fieldLabel}>{field.label}</Text>
        <View style={styles.readonlyBox}>
          <Text style={styles.readonlyText}>{displayValue}</Text>
        </View>
      </View>
    );
  }

  if (field.type === 'boolean') {
    return (
      <View style={styles.fieldBlock}>
        <Text style={styles.fieldLabel}>{field.label}</Text>
        <View style={styles.switchRow}>
          <Text style={styles.switchText}>{boolValue(currentValue) ? 'Sí' : 'No'}</Text>
          <Switch value={boolValue(currentValue)} onValueChange={(next) => onChange(next)} trackColor={{ true: theme.colors.brandTint }} />
        </View>
      </View>
    );
  }

  if (field.type === 'flag') {
    const flagValue = String(currentValue || '0') === '1';
    return (
      <View style={styles.fieldBlock}>
        <Text style={styles.fieldLabel}>{field.label}</Text>
        <View style={styles.flagRow}>
          <Pressable style={[styles.flagButton, !flagValue && styles.flagButtonActive]} onPress={() => onChange('0')}>
            <Text style={[styles.flagButtonText, !flagValue && styles.flagButtonTextActive]}>No</Text>
          </Pressable>
          <Pressable style={[styles.flagButton, flagValue && styles.flagButtonActive]} onPress={() => onChange('1')}>
            <Text style={[styles.flagButtonText, flagValue && styles.flagButtonTextActive]}>Sí</Text>
          </Pressable>
        </View>
      </View>
    );
  }

  if (field.type === 'select') {
    const mergedOptions = options.length ? options : field.options || [];
    return (
      <View style={styles.fieldBlock}>
        <Text style={styles.fieldLabel}>{field.label}</Text>
        <ScrollView horizontal showsHorizontalScrollIndicator={false}>
          <View style={styles.selectWrap}>
            {mergedOptions.map((option) => {
              const selected = String(option.value) === String(currentValue);
              return (
                <Pressable key={`${field.key}-${option.value}`} style={[styles.optionChip, selected && styles.optionChipActive]} onPress={() => onChange(option.value)}>
                  <Text style={[styles.optionChipText, selected && styles.optionChipTextActive]}>{option.label}</Text>
                </Pressable>
              );
            })}
          </View>
        </ScrollView>
      </View>
    );
  }

  if (field.type === 'datetime') {
    return (
      <DateTimeField label={field.label} value={currentValue} onChange={onChange} />
    );
  }

  if (field.type === 'multiline') {
    return (
      <View style={styles.fieldBlock}>
        <Text style={styles.fieldLabel}>{field.label}</Text>
        <TextInput
          value={String(currentValue)}
          onChangeText={onChange}
          placeholder={field.placeholder || 'Escribe aquí'}
          placeholderTextColor={theme.colors.textSoft}
          style={[styles.textInput, styles.textArea]}
          multiline
          textAlignVertical="top"
        />
      </View>
    );
  }

  return (
    <View style={styles.fieldBlock}>
      <Text style={styles.fieldLabel}>{field.label}</Text>
      <TextInput
        value={String(currentValue)}
        onChangeText={onChange}
        placeholder={field.placeholder || ''}
        placeholderTextColor={theme.colors.textSoft}
        keyboardType={field.type === 'number' ? 'numeric' : 'default'}
        style={styles.textInput}
      />
    </View>
  );
}

function DateTimeField({ label, value, onChange }) {
  const initialValue = value || nowInputValue();
  const [parts, setParts] = useState(parseDateTimeParts(initialValue));
  const lastEmittedRef = useRef(buildDateTimeDraft(parseDateTimeParts(initialValue)));

  useEffect(() => {
    const externalValue = value || nowInputValue();
    if (externalValue === lastEmittedRef.current) return;
    setParts(parseDateTimeParts(externalValue));
    lastEmittedRef.current = buildDateTimeDraft(parseDateTimeParts(externalValue));
  }, [value]);

  const updatePart = (key, nextValue, maxLength) => {
    const cleanValue = String(nextValue).replace(/\D/g, '').slice(0, maxLength);
    const nextParts = { ...parts, [key]: cleanValue };
    const nextDraft = buildDateTimeDraft(nextParts);
    setParts(nextParts);
    lastEmittedRef.current = nextDraft;
    onChange(nextDraft);
  };

  const setNow = () => {
    const current = parseDateTimeParts(nowInputValue());
    const nextDraft = buildDateTimeDraft(current);
    setParts(current);
    lastEmittedRef.current = nextDraft;
    onChange(nextDraft);
  };

  return (
    <View style={styles.fieldBlock}>
      <View style={styles.fieldHeaderRow}>
        <Text style={styles.fieldLabel}>{label}</Text>
        <Pressable onPress={setNow}>
          <Text style={styles.nowLink}>Ahora</Text>
        </Pressable>
      </View>

      <View style={styles.dateTimeCard}>
        <Text style={styles.dateTimeSectionLabel}>Fecha</Text>
        <View style={styles.dateTimeRow}>
          <DatePartInput value={parts.day} placeholder="DD" onChangeText={(text) => updatePart('day', text, 2)} />
          <Text style={styles.dateTimeSeparator}>/</Text>
          <DatePartInput value={parts.month} placeholder="MM" onChangeText={(text) => updatePart('month', text, 2)} />
          <Text style={styles.dateTimeSeparator}>/</Text>
          <DatePartInput value={parts.year} placeholder="AAAA" onChangeText={(text) => updatePart('year', text, 4)} wide />
        </View>

        <Text style={styles.dateTimeSectionLabel}>Hora</Text>
        <View style={styles.dateTimeRow}>
          <DatePartInput value={parts.hour} placeholder="HH" onChangeText={(text) => updatePart('hour', text, 2)} />
          <Text style={styles.dateTimeSeparator}>:</Text>
          <DatePartInput value={parts.minute} placeholder="MM" onChangeText={(text) => updatePart('minute', text, 2)} />
        </View>
      </View>
    </View>
  );
}

function DatePartInput({ wide = false, ...props }) {
  return (
    <TextInput
      {...props}
      keyboardType="numeric"
      maxLength={wide ? 4 : 2}
      placeholderTextColor={theme.colors.textSoft}
      style={[styles.datePartInput, wide && styles.datePartInputWide]}
    />
  );
}

function parseDateTimeParts(value) {
  const source = String(value || nowInputValue());
  const [datePart = '', timePart = ''] = source.replace('T', ' ').split(' ');
  const [year = '', month = '', day = ''] = datePart.split('-');
  const [hour = '', minute = ''] = timePart.split(':');
  return { day, month, year, hour, minute };
}

function buildDateTimeDraft(parts) {
  const year = parts.year || '';
  const month = parts.month || '';
  const day = parts.day || '';
  const hour = parts.hour || '';
  const minute = parts.minute || '';
  return `${year}-${month}-${day} ${hour}:${minute}`;
}

const styles = StyleSheet.create({
  featurePill: {
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: theme.radius.pill,
    backgroundColor: 'rgba(255,255,255,0.12)',
  },
  featurePillText: {
    color: '#eaf4ff',
    fontSize: 12,
    fontWeight: '700',
  },
  statCard: {
    flex: 1,
    backgroundColor: theme.colors.panel,
    borderRadius: theme.radius.md,
    borderWidth: 1,
    borderColor: theme.colors.border,
    padding: 16,
    gap: 6,
  },
  statCardHighlight: {
    backgroundColor: theme.colors.brandTint,
    borderColor: '#b8d9ff',
  },
  statLabel: {
    color: theme.colors.textMuted,
    fontSize: 11,
    textTransform: 'uppercase',
    fontWeight: '800',
  },
  statLabelHighlight: {
    color: theme.colors.brandStrong,
  },
  statValue: {
    color: theme.colors.text,
    fontSize: 24,
    fontWeight: '900',
  },
  statValueHighlight: {
    color: theme.colors.brandStrong,
  },
  sectionHeader: {
    gap: 4,
  },
  sectionTitle: {
    color: theme.colors.text,
    fontSize: 18,
    fontWeight: '800',
  },
  sectionSubtitle: {
    color: theme.colors.textMuted,
    fontSize: 13,
  },
  infoPanel: {
    backgroundColor: theme.colors.panel,
    borderRadius: theme.radius.md,
    borderWidth: 1,
    borderColor: theme.colors.border,
    overflow: 'hidden',
  },
  infoRow: {
    paddingHorizontal: 18,
    paddingVertical: 14,
    borderBottomWidth: 1,
    borderBottomColor: '#ebf0f6',
  },
  infoLabel: {
    color: theme.colors.textSoft,
    fontSize: 11,
    fontWeight: '800',
    textTransform: 'uppercase',
    marginBottom: 4,
  },
  infoValue: {
    color: theme.colors.text,
    fontSize: 15,
    fontWeight: '700',
  },
  emptyState: {
    marginTop: 40,
    alignItems: 'center',
    gap: 8,
    paddingHorizontal: 24,
  },
  emptyTitle: {
    color: theme.colors.text,
    fontSize: 18,
    fontWeight: '800',
  },
  emptyText: {
    color: theme.colors.textMuted,
    fontSize: 13,
    textAlign: 'center',
    lineHeight: 20,
  },
  loadingPanel: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    gap: 10,
  },
  loadingText: {
    color: theme.colors.textMuted,
    fontSize: 13,
  },
  fieldBlock: {
    gap: 8,
  },
  fieldLabel: {
    color: theme.colors.textMuted,
    fontSize: 12,
    fontWeight: '800',
    textTransform: 'uppercase',
  },
  textInput: {
    backgroundColor: theme.colors.panel,
    borderRadius: theme.radius.sm,
    borderWidth: 1,
    borderColor: theme.colors.border,
    paddingHorizontal: 14,
    paddingVertical: 13,
    color: theme.colors.text,
    fontSize: 15,
  },
  dateTimeCard: {
    backgroundColor: theme.colors.panel,
    borderRadius: theme.radius.sm,
    borderWidth: 1,
    borderColor: theme.colors.border,
    padding: 14,
    gap: 10,
  },
  dateTimeSectionLabel: {
    color: theme.colors.textSoft,
    fontSize: 11,
    fontWeight: '800',
    textTransform: 'uppercase',
  },
  dateTimeRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  dateTimeSeparator: {
    color: theme.colors.textMuted,
    fontSize: 18,
    fontWeight: '800',
  },
  datePartInput: {
    minWidth: 58,
    backgroundColor: theme.colors.panelMuted,
    borderRadius: theme.radius.sm,
    borderWidth: 1,
    borderColor: theme.colors.border,
    paddingHorizontal: 12,
    paddingVertical: 12,
    color: theme.colors.text,
    fontSize: 16,
    fontWeight: '800',
    textAlign: 'center',
  },
  datePartInputWide: {
    minWidth: 94,
  },
  textArea: {
    minHeight: 110,
  },
  searchBox: {
    backgroundColor: theme.colors.panelMuted,
    borderRadius: theme.radius.sm,
    borderWidth: 1,
    borderColor: theme.colors.border,
  },
  searchInput: {
    paddingHorizontal: 14,
    paddingVertical: 12,
    color: theme.colors.text,
    fontSize: 14,
  },
  primaryButton: {
    backgroundColor: theme.colors.brand,
    borderRadius: theme.radius.sm,
    paddingVertical: 15,
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: 52,
  },
  primaryButtonCompact: {
    backgroundColor: theme.colors.brand,
    borderRadius: theme.radius.sm,
    paddingHorizontal: 16,
    paddingVertical: 14,
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: 50,
  },
  primaryButtonText: {
    color: '#ffffff',
    fontSize: 15,
    fontWeight: '800',
  },
  secondaryButton: {
    flex: 1,
    backgroundColor: theme.colors.panel,
    borderRadius: theme.radius.sm,
    borderWidth: 1,
    borderColor: theme.colors.border,
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: 50,
  },
  secondaryButtonText: {
    color: theme.colors.textMuted,
    fontSize: 15,
    fontWeight: '800',
  },
  secondaryPill: {
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: theme.radius.pill,
    backgroundColor: theme.colors.panel,
    borderWidth: 1,
    borderColor: theme.colors.border,
  },
  secondaryPillText: {
    color: theme.colors.textMuted,
    fontSize: 12,
    fontWeight: '800',
  },
  buttonDisabled: {
    opacity: 0.7,
  },
  readonlyBox: {
    backgroundColor: theme.colors.panelMuted,
    borderRadius: theme.radius.sm,
    borderWidth: 1,
    borderColor: theme.colors.border,
    paddingHorizontal: 14,
    paddingVertical: 13,
  },
  readonlyText: {
    color: theme.colors.text,
    fontSize: 15,
    fontWeight: '700',
  },
  switchRow: {
    backgroundColor: theme.colors.panel,
    borderRadius: theme.radius.sm,
    borderWidth: 1,
    borderColor: theme.colors.border,
    paddingHorizontal: 14,
    paddingVertical: 12,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  switchText: {
    color: theme.colors.text,
    fontSize: 15,
    fontWeight: '700',
  },
  flagRow: {
    flexDirection: 'row',
    gap: 10,
  },
  flagButton: {
    flex: 1,
    backgroundColor: theme.colors.panel,
    borderRadius: theme.radius.sm,
    borderWidth: 1,
    borderColor: theme.colors.border,
    paddingVertical: 13,
    alignItems: 'center',
  },
  flagButtonActive: {
    backgroundColor: theme.colors.brandTint,
    borderColor: '#b8d9ff',
  },
  flagButtonText: {
    color: theme.colors.textMuted,
    fontWeight: '800',
  },
  flagButtonTextActive: {
    color: theme.colors.brandStrong,
  },
  fieldHeaderRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  nowLink: {
    color: theme.colors.brand,
    fontSize: 12,
    fontWeight: '800',
  },
  selectWrap: {
    flexDirection: 'row',
    gap: 8,
  },
  optionChip: {
    paddingHorizontal: 12,
    paddingVertical: 10,
    borderRadius: theme.radius.pill,
    backgroundColor: theme.colors.panel,
    borderWidth: 1,
    borderColor: theme.colors.border,
  },
  optionChipActive: {
    backgroundColor: theme.colors.brandTint,
    borderColor: '#b8d9ff',
  },
  optionChipText: {
    color: theme.colors.textMuted,
    fontSize: 12,
    fontWeight: '700',
  },
  optionChipTextActive: {
    color: theme.colors.brandStrong,
  },
});

import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { theme } from '../theme/tokens';
import { InfoPanel, SectionHeader, StatCard } from '../components/ui';

export function DashboardScreen({ stats, loading, onOpenModule }) {
  const quickActions = [
    { key: 'tickets', label: 'Registrar ticket', helper: 'Ingreso y salida de vehículos' },
    { key: 'recibosIngreso', label: 'Nuevo ingreso', helper: 'Captura otros ingresos de caja' },
    { key: 'recibosEgreso', label: 'Nuevo egreso', helper: 'Registra egresos autorizados' },
    { key: 'vehiculos', label: 'Vehículos', helper: 'Consulta y actualiza datos base' },
  ];

  return (
    <ScrollView contentContainerStyle={styles.scrollContent}>
      <View style={styles.kpiRow}>
        <StatCard label="Clientes" value={loading ? '...' : String(stats?.clientes || 0)} />
        <StatCard label="Vehículos" value={loading ? '...' : String(stats?.vehiculos || 0)} />
        <StatCard label="Tickets activos" value={loading ? '...' : String(stats?.tickets || 0)} highlight />
      </View>

      <SectionHeader title="Acciones rápidas" subtitle="Los flujos más usados quedan a un toque." />
      <View style={styles.quickActionGrid}>
        {quickActions.map((action) => (
          <Pressable key={action.key} style={styles.quickActionCard} onPress={() => onOpenModule(action.key)}>
            <Text style={styles.quickActionTitle}>{action.label}</Text>
            <Text style={styles.quickActionHelper}>{action.helper}</Text>
          </Pressable>
        ))}
      </View>

      <SectionHeader title="Cobertura" subtitle="La app móvil se enfoca en MAESTROS y MOVIMIENTOS." />
      <InfoPanel
        rows={[
          { label: 'Módulos visibles', value: 'MAESTROS · MOVIMIENTOS' },
          { label: 'Garita por defecto', value: 'Garita' },
          { label: 'Perfiles con acceso', value: 'Administrador · Personal' },
        ]}
      />
    </ScrollView>
  );
}

export function ModuleGridScreen({ eyebrow, title, subtitle, modules, onOpen }) {
  return (
    <ScrollView contentContainerStyle={styles.scrollContent}>
      <View style={styles.heroPanel}>
        <Text style={styles.heroEyebrow}>{eyebrow}</Text>
        <Text style={styles.heroTitle}>{title}</Text>
        <Text style={styles.heroText}>{subtitle}</Text>
      </View>

      <View style={styles.moduleGrid}>
        {modules.map((module) => (
          <Pressable key={module.key} style={[styles.moduleCard, { borderColor: `${module.accent}33` }]} onPress={() => onOpen(module.key)}>
            <View style={[styles.moduleAccent, { backgroundColor: module.accent }]} />
            <Text style={styles.moduleTitle}>{module.title}</Text>
            <Text style={styles.moduleSubtitle}>{module.subtitle}</Text>
          </Pressable>
        ))}
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  scrollContent: { padding: 20, gap: 16 },
  kpiRow: { flexDirection: 'row', gap: 10 },
  quickActionGrid: { gap: 10 },
  quickActionCard: { backgroundColor: theme.colors.panel, borderRadius: theme.radius.md, padding: 18, borderWidth: 1, borderColor: theme.colors.border },
  quickActionTitle: { color: theme.colors.text, fontSize: 16, fontWeight: '800' },
  quickActionHelper: { color: theme.colors.textMuted, fontSize: 13, marginTop: 4, lineHeight: 19 },
  heroPanel: {
    backgroundColor: theme.colors.panel,
    borderRadius: theme.radius.lg,
    borderWidth: 1,
    borderColor: theme.colors.border,
    padding: 20,
    gap: 8,
  },
  heroEyebrow: {
    color: theme.colors.brand,
    fontSize: 12,
    fontWeight: '800',
    textTransform: 'uppercase',
    letterSpacing: 0.8,
  },
  heroTitle: {
    color: theme.colors.text,
    fontSize: 22,
    fontWeight: '900',
  },
  heroText: {
    color: theme.colors.textMuted,
    fontSize: 14,
    lineHeight: 20,
  },
  moduleGrid: { gap: 12 },
  moduleCard: { backgroundColor: theme.colors.panel, borderRadius: theme.radius.md, borderWidth: 1, padding: 18, gap: 8 },
  moduleAccent: { width: 52, height: 6, borderRadius: theme.radius.pill },
  moduleTitle: { color: theme.colors.text, fontSize: 18, fontWeight: '900' },
  moduleSubtitle: { color: theme.colors.textMuted, fontSize: 13, lineHeight: 20 },
});

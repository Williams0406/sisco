import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { theme } from '../theme/tokens';
import { InfoPanel } from '../components/ui';

export default function AccountScreen({ session, onLogout }) {
  return (
    <ScrollView contentContainerStyle={styles.scrollContent}>
      <View style={styles.heroPanel}>
        <Text style={styles.heroEyebrow}>Cuenta</Text>
        <Text style={styles.heroTitle}>Perfil operativo</Text>
        <Text style={styles.heroText}>Información del usuario autenticado para esta app móvil.</Text>
      </View>

      <InfoPanel
        rows={[
          { label: 'Usuario', value: session.user.username },
          { label: 'Nombre', value: session.user.nombre || '-' },
          { label: 'Apellido paterno', value: session.user.apellido_paterno || '-' },
          { label: 'Rol', value: session.user.role || '-' },
          { label: 'Módulos', value: (session.user.allowed_modules || []).join(' · ') || '-' },
        ]}
      />

      <Pressable style={styles.logoutButton} onPress={onLogout}>
        <Text style={styles.logoutButtonText}>Cerrar sesión</Text>
      </Pressable>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  scrollContent: { padding: 20, gap: 16 },
  heroPanel: { backgroundColor: theme.colors.panel, borderRadius: theme.radius.lg, borderWidth: 1, borderColor: theme.colors.border, padding: 22, gap: 8 },
  heroEyebrow: { color: theme.colors.brand, fontSize: 12, fontWeight: '800', textTransform: 'uppercase', letterSpacing: 1 },
  heroTitle: { color: theme.colors.text, fontSize: 26, fontWeight: '900' },
  heroText: { color: theme.colors.textMuted, fontSize: 14, lineHeight: 22 },
  logoutButton: { backgroundColor: theme.colors.dangerTint, borderRadius: theme.radius.md, paddingVertical: 15, alignItems: 'center' },
  logoutButtonText: { color: theme.colors.danger, fontWeight: '800', fontSize: 15 },
});

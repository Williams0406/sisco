import { SafeAreaView, ScrollView, StyleSheet, Text, View } from 'react-native';
import { theme } from '../theme/tokens';
import { LabeledInput, PrimaryButton } from '../components/ui';

export default function LoginScreen({ form, error, loggingIn, onChange, onSubmit }) {
  return (
    <SafeAreaView style={styles.appShell}>
      <ScrollView contentContainerStyle={styles.loginScroll}>
        <View style={styles.loginCard}>
          <Text style={styles.cardEyebrow}>Acceso</Text>
          <Text style={styles.cardTitle}>Iniciar sesión</Text>
          <Text style={styles.cardSubtitle}>Usa tu código de usuario y contraseña de SISCO.</Text>

          <LabeledInput label="Usuario" value={form.username} onChangeText={(value) => onChange('username', value)} placeholder="Ingresa tu usuario" />
          <LabeledInput label="Contraseña" value={form.password} onChangeText={(value) => onChange('password', value)} placeholder="Ingresa tu contraseña" secureTextEntry />

          {error ? <Text style={styles.errorBanner}>{error}</Text> : null}

          <PrimaryButton label="Ingresar" onPress={onSubmit} disabled={loggingIn} loading={loggingIn} />
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  appShell: { flex: 1, backgroundColor: theme.colors.appBg },
  loginScroll: { flexGrow: 1, padding: 20, justifyContent: 'center' },
  loginCard: { backgroundColor: theme.colors.panel, borderRadius: theme.radius.lg, borderWidth: 1, borderColor: theme.colors.border, padding: 22, gap: 14 },
  cardEyebrow: { color: theme.colors.brand, fontSize: 12, fontWeight: '800', textTransform: 'uppercase', letterSpacing: 1 },
  cardTitle: { color: theme.colors.text, fontSize: 24, fontWeight: '900' },
  cardSubtitle: { color: theme.colors.textMuted, fontSize: 14, lineHeight: 20 },
  errorBanner: { backgroundColor: theme.colors.dangerTint, color: theme.colors.danger, borderRadius: theme.radius.sm, padding: 12, fontSize: 13, fontWeight: '700' },
});

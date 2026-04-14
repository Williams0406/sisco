import { StatusBar } from 'expo-status-bar';
import { useEffect, useState } from 'react';
import { Alert, BackHandler, Pressable, SafeAreaView, StyleSheet, Text, View } from 'react-native';
import { apiRequest } from './services/api';
import { theme } from './theme/tokens';
import LoginScreen from './screens/LoginScreen';
import { DashboardScreen, ModuleGridScreen } from './screens/HomeScreen';
import AccountScreen from './screens/AccountScreen';
import EntityScreen from './screens/EntityScreen';
import TicketsScreen from './screens/TicketsScreen';
import { MAESTROS_MODULES, MOVIMIENTOS_MODULES, ROOT_TABS, ENTITY_CONFIGS } from './data/moduleCatalog';
import { normalizeList } from './utils/format';
import { SecondaryPill } from './components/ui';

async function fetchDashboardStats(token) {
  const [clientes, vehiculos, tickets] = await Promise.all([
    apiRequest('/maestros/clientes/?page_size=1', { token }),
    apiRequest('/maestros/vehiculos/?page_size=1', { token }),
    apiRequest('/movimientos/tickets/?page_size=1&ch_esta_activo=1', { token }),
  ]);
  return {
    clientes: clientes.count || normalizeList(clientes).length,
    vehiculos: vehiculos.count || normalizeList(vehiculos).length,
    tickets: tickets.count || normalizeList(tickets).length,
  };
}

export default function MainApp() {
  const [session, setSession] = useState(null);
  const [loginForm, setLoginForm] = useState({ username: '', password: '' });
  const [loginError, setLoginError] = useState('');
  const [loggingIn, setLoggingIn] = useState(false);
  const [activeTab, setActiveTab] = useState('dashboard');
  const [detailScreen, setDetailScreen] = useState(null);
  const [dashboardStats, setDashboardStats] = useState(null);
  const [dashboardLoading, setDashboardLoading] = useState(false);

  useEffect(() => {
    if (!session?.accessToken || activeTab !== 'dashboard' || detailScreen) return;
    let cancelled = false;
    setDashboardLoading(true);
    fetchDashboardStats(session.accessToken)
      .then((stats) => {
        if (!cancelled) setDashboardStats(stats);
      })
      .catch(() => {
        if (!cancelled) setDashboardStats(null);
      })
      .finally(() => {
        if (!cancelled) setDashboardLoading(false);
      });
    return () => {
      cancelled = true;
    };
  }, [session, activeTab, detailScreen]);

  useEffect(() => {
    const subscription = BackHandler.addEventListener('hardwareBackPress', () => {
      if (detailScreen) {
        setDetailScreen(null);
        return true;
      }
      if (activeTab !== 'dashboard') {
        setActiveTab('dashboard');
        return true;
      }
      return false;
    });
    return () => subscription.remove();
  }, [activeTab, detailScreen]);

  const handleLogin = async () => {
    setLoggingIn(true);
    setLoginError('');
    try {
      const auth = await apiRequest('/auth/login/', {
        method: 'POST',
        body: {
          username: loginForm.username.trim(),
          password: loginForm.password,
        },
      });
      const me = await apiRequest('/seguridad/me/', { token: auth.access });
      const normalizedRole = String(me.role || '').trim().toLowerCase();
      if (!['personal', 'administrador'].includes(normalizedRole)) {
        throw new Error('Solo pueden ingresar usuarios con perfil Administrador o Personal.');
      }
      setSession({
        accessToken: auth.access,
        refreshToken: auth.refresh,
        user: me,
      });
      setActiveTab('dashboard');
      setDetailScreen(null);
    } catch (error) {
      setLoginError(error.message || 'No se pudo iniciar sesión.');
    } finally {
      setLoggingIn(false);
    }
  };

  const handleLogout = () => {
    setSession(null);
    setDetailScreen(null);
    setDashboardStats(null);
    setLoginForm({ username: '', password: '' });
  };

  if (!session) {
    return (
      <>
        <StatusBar style="dark" />
        <LoginScreen
          form={loginForm}
          error={loginError}
          loggingIn={loggingIn}
          onChange={(key, value) => setLoginForm((prev) => ({ ...prev, [key]: value }))}
          onSubmit={handleLogin}
        />
      </>
    );
  }

  const rootTitle = detailScreen
    ? detailScreen.type === 'tickets'
      ? 'Tickets'
      : ENTITY_CONFIGS[detailScreen.key]?.title || 'Módulo'
    : ROOT_TABS.find((tab) => tab.key === activeTab)?.label || 'Inicio';

  return (
    <SafeAreaView style={styles.appShell}>
      <StatusBar style="dark" />
      <View style={styles.topBar}>
        <View>
          <Text style={styles.topBarLabel}>SISCO Movil</Text>
          <Text style={styles.topBarTitle}>{rootTitle}</Text>
        </View>
        {detailScreen ? (
          <SecondaryPill label="Volver" onPress={() => setDetailScreen(null)} />
        ) : (
          <View style={styles.userChip}>
            <Text style={styles.userChipText}>{session.user.username}</Text>
          </View>
        )}
      </View>

      <View style={styles.mainContent}>
        {detailScreen ? (
          detailScreen.type === 'tickets' ? (
            <TicketsScreen session={session} />
          ) : (
            <EntityScreen session={session} config={ENTITY_CONFIGS[detailScreen.key]} />
          )
        ) : activeTab === 'dashboard' ? (
          <DashboardScreen stats={dashboardStats} loading={dashboardLoading} onOpenModule={(moduleKey) => setDetailScreen(moduleKey === 'tickets' ? { type: 'tickets' } : { type: 'entity', key: moduleKey })} />
        ) : activeTab === 'maestros' ? (
          <ModuleGridScreen eyebrow="Maestros" title="Catalogos para operacion" subtitle="Manten al dia los datos que el equipo usa con mas frecuencia." modules={MAESTROS_MODULES} onOpen={(key) => setDetailScreen({ type: 'entity', key })} />
        ) : activeTab === 'movimientos' ? (
          <ModuleGridScreen eyebrow="Movimientos" title="Registro operativo" subtitle="Captura tickets, recibos y cierres con menos pasos y mejor enfoque." modules={MOVIMIENTOS_MODULES} onOpen={(key) => setDetailScreen(key === 'tickets' ? { type: 'tickets' } : { type: 'entity', key })} />
        ) : (
          <AccountScreen session={session} onLogout={handleLogout} />
        )}
      </View>

      {!detailScreen && (
        <View style={styles.bottomTabs}>
          {ROOT_TABS.map((tab) => {
            const active = tab.key === activeTab;
            return (
              <Pressable key={tab.key} onPress={() => setActiveTab(tab.key)} style={[styles.bottomTab, active && styles.bottomTabActive]}>
                <Text style={[styles.bottomTabText, active && styles.bottomTabTextActive]}>{tab.label}</Text>
              </Pressable>
            );
          })}
        </View>
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  appShell: { flex: 1, backgroundColor: theme.colors.appBg },
  topBar: {
    paddingHorizontal: 20,
    paddingTop: 12,
    paddingBottom: 10,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  topBarLabel: {
    color: theme.colors.textSoft,
    fontSize: 12,
    fontWeight: '800',
    textTransform: 'uppercase',
    letterSpacing: 0.8,
  },
  topBarTitle: {
    color: theme.colors.text,
    fontSize: 24,
    fontWeight: '900',
    marginTop: 4,
  },
  userChip: {
    borderRadius: theme.radius.pill,
    paddingHorizontal: 12,
    paddingVertical: 8,
    backgroundColor: theme.colors.panel,
    borderWidth: 1,
    borderColor: theme.colors.border,
  },
  userChipText: {
    color: theme.colors.brand,
    fontWeight: '800',
    fontSize: 12,
  },
  mainContent: {
    flex: 1,
  },
  bottomTabs: {
    flexDirection: 'row',
    paddingHorizontal: 14,
    paddingTop: 10,
    paddingBottom: 18,
    gap: 8,
    backgroundColor: theme.colors.appBg,
  },
  bottomTab: {
    flex: 1,
    backgroundColor: theme.colors.panel,
    borderRadius: theme.radius.pill,
    borderWidth: 1,
    borderColor: theme.colors.border,
    paddingVertical: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  bottomTabActive: {
    backgroundColor: theme.colors.brand,
    borderColor: theme.colors.brand,
  },
  bottomTabText: {
    color: theme.colors.textMuted,
    fontSize: 12,
    fontWeight: '800',
    textAlign: 'center',
  },
  bottomTabTextActive: {
    color: '#ffffff',
  },
});

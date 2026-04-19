import axios from 'axios';
import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { theme } from '../styles/tokens';

function getLoginErrorMessage(error) {
  if (axios.isAxiosError(error)) {
    if (error.response?.status === 401) {
      return 'Usuario o contrasena incorrectos';
    }

    if (error.response?.status && error.response.status >= 500) {
      return 'El servidor de Railway respondio con un error. Intenta nuevamente en unos minutos.';
    }

    if (error.request && !error.response) {
      return 'No se pudo conectar con Railway. Revisa CORS_ALLOWED_ORIGINS y que el backend este activo.';
    }
  }

  return 'No se pudo iniciar sesion. Verifica la conexion con Railway e intenta otra vez.';
}

export default function Login() {
  const { login } = useAuth();
  const navigate = useNavigate();
  const [form, setForm] = useState({ username: '', password: '' });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      await login(form.username, form.password);
      navigate('/');
    } catch (error) {
      setError(getLoginErrorMessage(error));
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={styles.page}>
      <div style={styles.backdropA} />
      <div style={styles.backdropB} />

      <div style={styles.layout}>
        <section style={styles.hero}>
          <p style={styles.eyebrow}>Plataforma operativa</p>
          <h1 style={styles.heroTitle}>SISCO</h1>
          <p style={styles.heroText}>
            Controla tickets, cobranzas, caja y reportes diarios desde una experiencia
            mas clara, rapida y consistente.
          </p>

          <div style={styles.featureGrid}>
            <div style={styles.featureCard}>
              <strong style={styles.featureTitle}>Operacion centralizada</strong>
              <span style={styles.featureText}>Movimientos, reportes y seguridad en un mismo flujo.</span>
            </div>
            <div style={styles.featureCard}>
              <strong style={styles.featureTitle}>Seguimiento diario</strong>
              <span style={styles.featureText}>Consulta cierres, ingresos y cobranzas con menos pasos.</span>
            </div>
          </div>
        </section>

        <section style={styles.card}>
          <div style={styles.cardHeader}>
            <p style={styles.cardEyebrow}>Acceso seguro</p>
            <h2 style={styles.cardTitle}>Iniciar sesion</h2>
            <p style={styles.cardSubtitle}>Ingresa con tu usuario para continuar trabajando.</p>
          </div>

          <form onSubmit={handleSubmit} style={styles.form}>
            <div style={styles.field}>
              <label style={styles.label}>Usuario</label>
              <input
                style={styles.input}
                type="text"
                value={form.username}
                onChange={(e) => setForm({ ...form, username: e.target.value })}
                placeholder="Ingrese su usuario"
                required
              />
            </div>

            <div style={styles.field}>
              <label style={styles.label}>Contrasena</label>
              <input
                style={styles.input}
                type="password"
                value={form.password}
                onChange={(e) => setForm({ ...form, password: e.target.value })}
                placeholder="Ingrese su contrasena"
                required
              />
            </div>

            {error && <p style={styles.error}>{error}</p>}

            <button style={styles.button} type="submit" disabled={loading}>
              {loading ? 'Ingresando...' : 'Ingresar al sistema'}
            </button>

            <div style={styles.helperBox}>
              <span style={styles.helperLabel}>Ayuda</span>
              <span style={styles.helperText}>Si no puedes ingresar, valida tus credenciales con administracion.</span>
            </div>
          </form>
        </section>
      </div>
    </div>
  );
}

const styles = {
  page: {
    minHeight: '100vh',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    padding: '32px 20px',
    background: 'linear-gradient(135deg, #dbeafe 0%, #eef2f7 45%, #f8fafc 100%)',
    position: 'relative',
    overflow: 'hidden',
  },
  backdropA: {
    position: 'absolute',
    width: 380,
    height: 380,
    borderRadius: '50%',
    background: 'rgba(37, 99, 235, 0.16)',
    top: -100,
    left: -90,
    filter: 'blur(8px)',
  },
  backdropB: {
    position: 'absolute',
    width: 320,
    height: 320,
    borderRadius: '50%',
    background: 'rgba(15, 23, 42, 0.08)',
    right: -100,
    bottom: -90,
    filter: 'blur(8px)',
  },
  layout: {
    position: 'relative',
    zIndex: 1,
    width: '100%',
    maxWidth: 1120,
    display: 'grid',
    gridTemplateColumns: 'minmax(320px, 1.2fr) minmax(320px, 460px)',
    gap: 26,
    alignItems: 'stretch',
  },
  hero: {
    background: 'linear-gradient(160deg, #0f172a 0%, #1e3a8a 100%)',
    borderRadius: 28,
    padding: '44px 42px',
    color: '#fff',
    boxShadow: '0 30px 90px rgba(15, 23, 42, 0.22)',
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'space-between',
    minHeight: 560,
  },
  eyebrow: {
    margin: 0,
    textTransform: 'uppercase',
    letterSpacing: 1.4,
    fontSize: 12,
    fontWeight: 700,
    color: 'rgba(255,255,255,0.72)',
  },
  heroTitle: {
    margin: '16px 0 12px',
    fontSize: 54,
    lineHeight: 1,
    fontWeight: 900,
    letterSpacing: -1.4,
  },
  heroText: {
    margin: 0,
    maxWidth: 470,
    fontSize: 17,
    lineHeight: 1.7,
    color: 'rgba(255,255,255,0.82)',
  },
  featureGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(180px, 1fr))',
    gap: 14,
    marginTop: 28,
  },
  featureCard: {
    background: 'rgba(255,255,255,0.1)',
    border: '1px solid rgba(255,255,255,0.14)',
    borderRadius: 20,
    padding: 18,
    backdropFilter: 'blur(6px)',
    display: 'flex',
    flexDirection: 'column',
    gap: 6,
  },
  featureTitle: {
    fontSize: 15,
    fontWeight: 800,
  },
  featureText: {
    fontSize: 13,
    lineHeight: 1.5,
    color: 'rgba(255,255,255,0.75)',
  },
  card: {
    background: 'rgba(255,255,255,0.94)',
    borderRadius: 28,
    padding: '34px 32px',
    border: `1px solid ${theme.colors.border}`,
    boxShadow: '0 24px 70px rgba(15, 23, 42, 0.12)',
    backdropFilter: 'blur(12px)',
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'center',
  },
  cardHeader: {
    marginBottom: 28,
  },
  cardEyebrow: {
    margin: 0,
    textTransform: 'uppercase',
    letterSpacing: 1.3,
    fontSize: 12,
    fontWeight: 800,
    color: theme.colors.brand,
  },
  cardTitle: {
    margin: '10px 0 8px',
    fontSize: 30,
    lineHeight: 1.1,
    color: theme.colors.text,
    fontWeight: 900,
  },
  cardSubtitle: {
    margin: 0,
    color: theme.colors.textMuted,
    fontSize: 14,
    lineHeight: 1.6,
  },
  form: {
    display: 'flex',
    flexDirection: 'column',
    gap: 16,
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
    padding: '13px 14px',
    border: `1px solid ${theme.colors.borderStrong}`,
    borderRadius: 12,
    fontSize: 14,
    boxSizing: 'border-box',
    outline: 'none',
    color: theme.colors.text,
    background: '#fff',
  },
  button: {
    width: '100%',
    padding: '13px 16px',
    background: 'linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%)',
    color: '#fff',
    border: 'none',
    borderRadius: 12,
    fontSize: 15,
    fontWeight: 800,
    cursor: 'pointer',
    boxShadow: theme.shadow.soft,
    marginTop: 6,
  },
  error: {
    color: theme.colors.danger,
    margin: 0,
    fontSize: 13,
    background: theme.colors.dangerTint,
    border: '1px solid #fecaca',
    borderRadius: 10,
    padding: '10px 12px',
  },
  helperBox: {
    marginTop: 10,
    padding: '14px 16px',
    borderRadius: 14,
    background: theme.colors.panelMuted,
    border: `1px solid ${theme.colors.border}`,
    display: 'flex',
    flexDirection: 'column',
    gap: 4,
  },
  helperLabel: {
    fontSize: 12,
    fontWeight: 800,
    textTransform: 'uppercase',
    color: theme.colors.textSoft,
  },
  helperText: {
    fontSize: 13,
    lineHeight: 1.5,
    color: theme.colors.textMuted,
  },
};

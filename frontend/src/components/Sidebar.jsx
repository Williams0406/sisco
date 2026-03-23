import { NavLink, useLocation } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

const iconPaths = {
  maestros: 'M3 7.5A2.5 2.5 0 0 1 5.5 5h13A2.5 2.5 0 0 1 21 7.5v9A2.5 2.5 0 0 1 18.5 19h-13A2.5 2.5 0 0 1 3 16.5zm2.5-.5a.5.5 0 0 0-.5.5v9c0 .276.224.5.5.5h13a.5.5 0 0 0 .5-.5v-9a.5.5 0 0 0-.5-.5zM7 3h10a1 1 0 1 1 0 2H7a1 1 0 1 1 0-2',
  movimientos: 'M4 5.5A2.5 2.5 0 0 1 6.5 3h11A2.5 2.5 0 0 1 20 5.5v13A2.5 2.5 0 0 1 17.5 21h-11A2.5 2.5 0 0 1 4 18.5zm2.5-.5a.5.5 0 0 0-.5.5v13c0 .276.224.5.5.5h11a.5.5 0 0 0 .5-.5v-13a.5.5 0 0 0-.5-.5zM8 9a1 1 0 0 1 1-1h6a1 1 0 1 1 0 2H9a1 1 0 0 1-1-1m0 4a1 1 0 0 1 1-1h6a1 1 0 1 1 0 2H9a1 1 0 0 1-1-1',
  reportes: 'M5 4.5A2.5 2.5 0 0 1 7.5 2h8A2.5 2.5 0 0 1 18 4.5V7h1.5A2.5 2.5 0 0 1 22 9.5v10a2.5 2.5 0 0 1-2.5 2.5h-15A2.5 2.5 0 0 1 2 19.5v-10A2.5 2.5 0 0 1 4.5 7H6V4.5zM8 7h8V4.5a.5.5 0 0 0-.5-.5h-8a.5.5 0 0 0-.5.5zM4.5 9a.5.5 0 0 0-.5.5v10c0 .276.224.5.5.5h15a.5.5 0 0 0 .5-.5v-10a.5.5 0 0 0-.5-.5z',
  seguridad: 'M12 2.5 4.5 5.3v5.2c0 5.17 3.3 9.98 7.5 11.5 4.2-1.52 7.5-6.33 7.5-11.5V5.3zm0 2.14 5.5 2.06v3.8c0 4.1-2.52 8.05-5.5 9.45-2.98-1.4-5.5-5.35-5.5-9.45V6.7z',
  chevron: 'm8 10 4 4 4-4',
  dot: 'M12 8.5a3.5 3.5 0 1 0 0 7 3.5 3.5 0 0 0 0-7',
};

const menu = [
  {
    grupo: 'Maestros',
    icon: 'maestros',
    modulos: [
      {
        nombre: 'Maestros',
        items: [
          { label: 'Cliente', path: '/maestros/clientes', vistas: ['Tabla', 'Formulario'] },
          { label: 'Chofer', path: '/maestros/choferes', vistas: ['Tabla', 'Formulario'] },
          { label: 'Vehículo', path: '/maestros/vehiculos', vistas: ['Tabla', 'Formulario'] },
          { label: 'Tipo Vehículo', path: '/maestros/tipo-vehiculo', vistas: ['Tabla', 'Formulario'] },
          { label: 'Proveedor', path: '/maestros/proveedores', vistas: ['Tabla', 'Formulario'] },
          { label: 'Tipo Egreso', path: '/maestros/tipo-egreso', vistas: ['Tabla', 'Formulario'] },
          { label: 'Tipo Incidente', path: '/maestros/tipo-incidente', vistas: ['Tabla', 'Formulario'] },
          { label: 'Tipo Ingreso', path: '/maestros/tipo-ingreso', vistas: ['Tabla', 'Formulario'] },
        ],
      },
    ],
  },
  {
    grupo: 'Movimientos',
    icon: 'movimientos',
    modulos: [
      {
        nombre: 'Alquiler cochera',
        items: [
          { label: 'Tarifario', path: '/movimientos/tarifario', vistas: ['Tabla clientes VIP', 'Tabla editable de tarifa'] },
          { label: 'Alquiler de cochera', path: '/movimientos/tickets', vistas: ['Registro', 'Tabla'] },
          { label: 'Cierre de turno', path: '/movimientos/cierre-turno', vistas: ['Tabla', 'Formulario'] },
        ],
      },
      {
        nombre: 'Cobranza a crédito',
        items: [
          { label: 'Cobranza crédito', path: '/movimientos/cobranza-credito', vistas: ['Registro', 'Tabla'] },
          { label: 'Consulta ticket crédito', path: '/movimientos/consulta-ticket-credito', vistas: ['Filtros', 'Tabla'] },
        ],
      },
      {
        nombre: 'Registro egresos',
        items: [
          { label: 'Recibo egreso', path: '/movimientos/recibos-egreso', vistas: ['Registro', 'Tabla'] },
        ],
      },
      {
        nombre: 'Registro ingresos',
        items: [
          { label: 'Recibo ingresos', path: '/movimientos/recibos-ingreso', vistas: ['Registro', 'Tabla'] },
        ],
      },
      {
        nombre: 'Cierre general',
        items: [
          { label: 'Consulta de ingreso diario', path: '/movimientos/consulta-ingreso-diario', vistas: ['Filtros', 'Tabla'] },
        ],
      },
    ],
  },
  {
    grupo: 'Reportes',
    icon: 'reportes',
    modulos: [
      {
        nombre: 'Reportes principales',
        items: [
          { label: 'Lista de ticket de salida', path: '/reportes/ticket-salida', vistas: ['Filtros', 'Tabla'] },
          { label: 'Relación comprobante de venta', path: '/reportes/comprobantes', vistas: ['Filtros', 'Tabla'] },
          { label: 'Lista de cobranza diaria', path: '/reportes/cobranza-diaria', vistas: ['Filtros', 'Tabla'] },
          { label: 'Ingresos y egresos por mes', path: '/reportes/ingreso-egreso', vistas: ['Filtros', 'Tabla'] },
        ],
      },
    ],
  },
  {
    grupo: 'Seguridad',
    icon: 'seguridad',
    modulos: [
      {
        nombre: 'Administración',
        items: [
          { label: 'Usuarios', path: '/seguridad/usuarios', vistas: ['Tabla', 'Formulario'] },
          { label: 'Perfil de usuario', path: '/seguridad/perfiles', vistas: ['Tabla', 'Formulario'] },
        ],
      },
    ],
  },
];

function Icon({ name, size = 16, stroke = 1.8, color = 'currentColor' }) {
  return (
    <svg viewBox="0 0 24 24" fill="none" width={size} height={size} style={{ flexShrink: 0 }}>
      <path d={iconPaths[name]} stroke={color} strokeWidth={stroke} strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}

export default function Sidebar() {
  const { user, logout } = useAuth();
  const location = useLocation();

  return (
    <aside style={styles.sidebar}>
      <div style={styles.logo}>
        <span style={styles.logoText}>SISCO</span>
        <span style={styles.logoSub}>Panel de Operaciones</span>
      </div>
      <nav style={styles.nav}>
        {menu.map((grupo) => (
          <section key={grupo.grupo} style={styles.grupo}>
            <div style={styles.grupoLabelWrap}>
              <Icon name={grupo.icon} size={15} color="#93c5fd" />
              <p style={styles.grupoLabel}>{grupo.grupo}</p>
            </div>
            {grupo.modulos.map((modulo) => {
              const hasActive = modulo.items.some((item) => location.pathname === item.path);
              return (
                <details key={modulo.nombre} open={hasActive} style={styles.modulo}>
                  <summary style={styles.moduloSummary}>
                    <span>{modulo.nombre}</span>
                    <span style={styles.chevron}><Icon name="chevron" size={14} stroke={2} color="#6b7280" /></span>
                  </summary>
                  <div style={styles.moduloBody}>
                    {modulo.items.map((item) => (
                      <NavLink
                        key={item.path}
                        to={item.path}
                        style={({ isActive }) => ({
                          ...styles.link,
                          ...(isActive ? styles.linkActive : {}),
                        })}
                      >
                        <div style={styles.linkHeader}>
                          <Icon name="dot" size={8} stroke={2.4} color="currentColor" />
                          <span>{item.label}</span>
                        </div>
                        <div style={styles.vistasWrap}>
                          {item.vistas.map((vista) => (
                            <span key={`${item.path}-${vista}`} style={styles.vistaTag}>{vista}</span>
                          ))}
                        </div>
                      </NavLink>
                    ))}
                  </div>
                </details>
              );
            })}
          </section>
        ))}
      </nav>
      <div style={styles.footer}>
        <span style={styles.username}>{user?.username}</span>
        <button style={styles.logoutBtn} onClick={logout}>Salir</button>
      </div>
    </aside>
  );
}

const styles = {
  sidebar: {
    width: 320,
    minHeight: '100vh',
    background: 'linear-gradient(180deg, #0f172a 0%, #131c31 100%)',
    display: 'flex',
    flexDirection: 'column',
    position: 'fixed',
    top: 0,
    left: 0,
    zIndex: 100,
    borderRight: '1px solid #1f2b46',
  },
  logo: {
    padding: '20px 22px 14px',
    borderBottom: '1px solid #1f2b46',
    display: 'flex',
    flexDirection: 'column',
    gap: 4,
  },
  logoText: { color: '#fff', fontSize: 22, fontWeight: 800, letterSpacing: 1.2 },
  logoSub: { color: '#94a3b8', fontSize: 11, fontWeight: 600, letterSpacing: 0.4 },
  nav: { flex: 1, overflowY: 'auto', padding: '12px 8px 8px' },
  grupo: { marginBottom: 8 },
  grupoLabelWrap: { display: 'flex', alignItems: 'center', gap: 6, padding: '8px 10px 6px' },
  grupoLabel: {
    color: '#d1d5db',
    fontSize: 11,
    fontWeight: 800,
    letterSpacing: 0.9,
    margin: 0,
    textTransform: 'uppercase',
  },
  modulo: {
    border: '1px solid #1f2937',
    borderRadius: 10,
    margin: '0 6px 8px',
    background: '#0b1220',
    overflow: 'hidden',
  },
  moduloSummary: {
    color: '#cbd5e1',
    fontSize: 12,
    fontWeight: 700,
    cursor: 'pointer',
    listStyle: 'none',
    padding: '10px 12px',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    borderBottom: '1px solid #172236',
  },
  chevron: { display: 'inline-flex' },
  moduloBody: { padding: 8, display: 'grid', gap: 6 },
  link: {
    display: 'flex',
    flexDirection: 'column',
    gap: 7,
    padding: '9px 10px',
    color: '#94a3b8',
    textDecoration: 'none',
    fontSize: 12,
    borderRadius: 8,
    border: '1px solid transparent',
    transition: 'all 0.15s',
  },
  linkHeader: { display: 'flex', alignItems: 'center', gap: 8, fontWeight: 700 },
  linkActive: {
    color: '#eff6ff',
    background: 'linear-gradient(135deg, rgba(37,99,235,0.28), rgba(59,130,246,0.38))',
    border: '1px solid rgba(147,197,253,0.38)',
  },
  vistasWrap: { display: 'flex', flexWrap: 'wrap', gap: 6, paddingLeft: 16 },
  vistaTag: {
    fontSize: 10,
    padding: '2px 6px',
    borderRadius: 999,
    background: 'rgba(148,163,184,0.14)',
    color: '#cbd5e1',
    letterSpacing: 0.2,
  },
  footer: {
    padding: '14px 16px',
    borderTop: '1px solid #1f2b46',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: 8,
  },
  username: { color: '#cbd5e1', fontSize: 12, maxWidth: 170, overflow: 'hidden', textOverflow: 'ellipsis' },
  logoutBtn: {
    background: 'transparent',
    border: '1px solid #334155',
    color: '#cbd5e1',
    padding: '6px 11px',
    borderRadius: 7,
    cursor: 'pointer',
    fontSize: 12,
    fontWeight: 600,
  },
};
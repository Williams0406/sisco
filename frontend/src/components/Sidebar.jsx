import { NavLink } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

const menu = [
  {
    grupo: 'Maestros',
    items: [
      { label: 'Clientes',       path: '/maestros/clientes' },
      { label: 'Choferes',       path: '/maestros/choferes' },
      { label: 'Vehículos',      path: '/maestros/vehiculos' },
      { label: 'Tipo Vehículo',  path: '/maestros/tipo-vehiculo' },
      { label: 'Proveedores',    path: '/maestros/proveedores' },
    ],
  },
  {
    grupo: 'Movimientos',
    items: [
      { label: 'Alquiler Cochera',    path: '/movimientos/tickets' },
      { label: 'Tarifario',           path: '/movimientos/tarifario' },
      { label: 'Cierre de Turno',     path: '/movimientos/cierre-turno' },
      { label: 'Cobranza Crédito',    path: '/movimientos/cobranza-credito' },
      { label: 'Recibo de Egreso',    path: '/movimientos/recibos-egreso' },
      { label: 'Recibo de Ingreso',   path: '/movimientos/recibos-ingreso' },
    ],
  },
  {
    grupo: 'Reportes',
    items: [
      { label: 'Ticket de Salida',    path: '/reportes/ticket-salida' },
      { label: 'Comprobantes Venta',  path: '/reportes/comprobantes' },
      { label: 'Cobranza Diaria',     path: '/reportes/cobranza-diaria' },
      { label: 'Ingresos y Egresos',  path: '/reportes/ingreso-egreso' },
      { label: 'Ingreso Diario',      path: '/reportes/ingreso-diario' },
    ],
  },
  {
    grupo: 'Seguridad',
    items: [
      { label: 'Usuarios', path: '/seguridad/usuarios' },
      { label: 'Perfiles', path: '/seguridad/perfiles' },
    ],
  },
];

export default function Sidebar() {
  const { user, logout } = useAuth();

  return (
    <aside style={styles.sidebar}>
      <div style={styles.logo}>
        <span style={styles.logoText}>SISCO</span>
      </div>
      <nav style={styles.nav}>
        {menu.map((grupo) => (
          <div key={grupo.grupo} style={styles.grupo}>
            <p style={styles.grupoLabel}>{grupo.grupo.toUpperCase()}</p>
            {grupo.items.map((item) => (
              <NavLink
                key={item.path}
                to={item.path}
                style={({ isActive }) => ({
                  ...styles.link,
                  ...(isActive ? styles.linkActive : {}),
                })}
              >
                {item.label}
              </NavLink>
            ))}
          </div>
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
    width: 240, minHeight: '100vh', background: '#1a1f2e',
    display: 'flex', flexDirection: 'column', position: 'fixed',
    top: 0, left: 0, zIndex: 100,
  },
  logo: {
    padding: '24px 20px 16px', borderBottom: '1px solid #2d3748',
  },
  logoText: { color: '#fff', fontSize: 22, fontWeight: 700, letterSpacing: 2 },
  nav: { flex: 1, overflowY: 'auto', padding: '12px 0' },
  grupo: { marginBottom: 8 },
  grupoLabel: {
    color: '#6b7280', fontSize: 10, fontWeight: 700,
    padding: '8px 20px 4px', letterSpacing: 1, margin: 0,
  },
  link: {
    display: 'block', padding: '8px 20px', color: '#9ca3af',
    textDecoration: 'none', fontSize: 13, borderRadius: 4,
    transition: 'all 0.15s',
  },
  linkActive: { color: '#fff', background: '#2563eb' },
  footer: {
    padding: '16px 20px', borderTop: '1px solid #2d3748',
    display: 'flex', alignItems: 'center', justifyContent: 'space-between',
  },
  username: { color: '#9ca3af', fontSize: 12 },
  logoutBtn: {
    background: 'transparent', border: '1px solid #4b5563',
    color: '#9ca3af', padding: '4px 10px', borderRadius: 4,
    cursor: 'pointer', fontSize: 12,
  },
};
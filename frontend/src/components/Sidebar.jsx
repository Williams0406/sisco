import { useEffect, useMemo, useState } from 'react';
import { NavLink, useLocation } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

const iconPaths = {
  maestros: 'M3 7.5A2.5 2.5 0 0 1 5.5 5h13A2.5 2.5 0 0 1 21 7.5v9A2.5 2.5 0 0 1 18.5 19h-13A2.5 2.5 0 0 1 3 16.5zm2.5-.5a.5.5 0 0 0-.5.5v9c0 .276.224.5.5.5h13a.5.5 0 0 0 .5-.5v-9a.5.5 0 0 0-.5-.5zM7 3h10a1 1 0 1 1 0 2H7a1 1 0 1 1 0-2',
  movimientos: 'M4 5.5A2.5 2.5 0 0 1 6.5 3h11A2.5 2.5 0 0 1 20 5.5v13A2.5 2.5 0 0 1 17.5 21h-11A2.5 2.5 0 0 1 4 18.5zm2.5-.5a.5.5 0 0 0-.5.5v13c0 .276.224.5.5.5h11a.5.5 0 0 0 .5-.5v-13a.5.5 0 0 0-.5-.5zM8 9a1 1 0 0 1 1-1h6a1 1 0 1 1 0 2H9a1 1 0 0 1-1-1m0 4a1 1 0 0 1 1-1h6a1 1 0 1 1 0 2H9a1 1 0 0 1-1-1',
  reportes: 'M5 4.5A2.5 2.5 0 0 1 7.5 2h8A2.5 2.5 0 0 1 18 4.5V7h1.5A2.5 2.5 0 0 1 22 9.5v10a2.5 2.5 0 0 1-2.5 2.5h-15A2.5 2.5 0 0 1 2 19.5v-10A2.5 2.5 0 0 1 4.5 7H6V4.5zM8 7h8V4.5a.5.5 0 0 0-.5-.5h-8a.5.5 0 0 0-.5.5zM4.5 9a.5.5 0 0 0-.5.5v10c0 .276.224.5.5.5h15a.5.5 0 0 0 .5-.5v-10a.5.5 0 0 0-.5-.5z',
  seguridad: 'M12 2.5 4.5 5.3v5.2c0 5.17 3.3 9.98 7.5 11.5 4.2-1.52 7.5-6.33 7.5-11.5V5.3zm0 2.14 5.5 2.06v3.8c0 4.1-2.52 8.05-5.5 9.45-2.98-1.4-5.5-5.35-5.5-9.45V6.7z',
  chevron: 'm8 10 4 4 4-4',
  dot: 'M12 8.5a3.5 3.5 0 1 0 0 7 3.5 3.5 0 0 0 0-7',
  panel: 'M4 5.5A1.5 1.5 0 0 1 5.5 4h13A1.5 1.5 0 0 1 20 5.5v13a1.5 1.5 0 0 1-1.5 1.5h-13A1.5 1.5 0 0 1 4 18.5zm5 0v13m-4-13h4',
};

const menu = [
  {
    grupo: 'Maestros',
    icon: 'maestros',
    modulos: [
      {
        nombre: 'Maestros',
        items: [
          { label: 'Cliente', path: '/maestros/clientes' },
          { label: 'Chofer', path: '/maestros/choferes' },
          { label: 'Vehiculo', path: '/maestros/vehiculos' },
          { label: 'Tipo Vehiculo', path: '/maestros/tipo-vehiculo' },
          { label: 'Proveedor', path: '/maestros/proveedores' },
          { label: 'Tipo Egreso', path: '/maestros/tipo-egreso' },
          { label: 'Tipo Incidente', path: '/maestros/tipo-incidente' },
          { label: 'Tipo Ingreso', path: '/maestros/tipo-ingreso' },
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
          { label: 'Tarifario', path: '/movimientos/tarifario' },
          { label: 'Alquiler de cochera', path: '/movimientos/tickets' },
          { label: 'Cierre de turno', path: '/movimientos/cierre-turno' },
        ],
      },
      {
        nombre: 'Cobranza a credito',
        items: [
          { label: 'Cobranza credito', path: '/movimientos/cobranza-credito' },
          { label: 'Consulta ticket credito', path: '/movimientos/consulta-ticket-credito' },
        ],
      },
      {
        nombre: 'Registro egresos',
        items: [{ label: 'Recibo egreso', path: '/movimientos/recibos-egreso' }],
      },
      {
        nombre: 'Registro ingresos',
        items: [{ label: 'Recibo ingresos', path: '/movimientos/recibos-ingreso' }],
      },
      {
        nombre: 'Cierre general',
        items: [{ label: 'Consulta de ingreso diario', path: '/movimientos/consulta-ingreso-diario' }],
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
          { label: 'Lista de ticket de salida', path: '/reportes/ticket-salida' },
          { label: 'Relacion comprobante de venta', path: '/reportes/comprobantes' },
          { label: 'Lista de cobranza diaria', path: '/reportes/cobranza-diaria' },
          { label: 'Ingresos y egresos por mes', path: '/reportes/ingreso-egreso' },
        ],
      },
    ],
  },
  {
    grupo: 'Seguridad',
    icon: 'seguridad',
    modulos: [
      {
        nombre: 'Administracion',
        items: [
          { label: 'Usuarios', path: '/seguridad/usuarios' },
          { label: 'Perfil de usuario', path: '/seguridad/perfiles' },
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

export default function Sidebar({ collapsed = false, onToggle }) {
  const { user, logout } = useAuth();
  const location = useLocation();
  const [query, setQuery] = useState('');
  const allowedModules = user?.allowed_modules || ['MAESTROS', 'MOVIMIENTOS', 'REPORTES', 'SEGURIDAD'];
  const [expandedGroups, setExpandedGroups] = useState(() =>
    Object.fromEntries(menu.map((grupo) => [grupo.grupo, true])),
  );
  const [expandedModules, setExpandedModules] = useState(() =>
    Object.fromEntries(
      menu.flatMap((grupo) =>
        grupo.modulos.map((modulo) => [`${grupo.grupo}:${modulo.nombre}`, modulo.items.some((item) => item.path === location.pathname)]),
      ),
    ),
  );

  const filteredMenu = useMemo(() => {
    const term = query.trim().toLowerCase();
    const visibleMenu = menu.filter((grupo) => allowedModules.includes(grupo.grupo.toUpperCase()));
    if (!term) return visibleMenu;

    return visibleMenu
      .map((grupo) => ({
        ...grupo,
        modulos: grupo.modulos
          .map((modulo) => ({
            ...modulo,
            items: modulo.items.filter((item) => item.label.toLowerCase().includes(term)),
          }))
          .filter((modulo) => modulo.items.length > 0),
      }))
      .filter((grupo) => grupo.modulos.length > 0);
  }, [allowedModules, query]);

  useEffect(() => {
    if (collapsed) return;

    setExpandedGroups((prev) => {
      const next = { ...prev };
      let changed = false;

      filteredMenu.forEach((grupo) => {
        const shouldExpand = query.trim() !== '' || grupo.modulos.some((modulo) => modulo.items.some((item) => item.path === location.pathname));
        if (shouldExpand && !next[grupo.grupo]) {
          next[grupo.grupo] = true;
          changed = true;
        }
      });

      return changed ? next : prev;
    });

    setExpandedModules((prev) => {
      const next = { ...prev };
      let changed = false;

      filteredMenu.forEach((grupo) => {
        grupo.modulos.forEach((modulo) => {
          const key = `${grupo.grupo}:${modulo.nombre}`;
          const shouldExpand = query.trim() !== '' || modulo.items.some((item) => item.path === location.pathname);
          if (shouldExpand && !next[key]) {
            next[key] = true;
            changed = true;
          }
        });
      });

      return changed ? next : prev;
    });
  }, [collapsed, filteredMenu, location.pathname, query]);

  const toggleGroup = (groupName) => {
    setExpandedGroups((prev) => ({
      ...prev,
      [groupName]: !prev[groupName],
    }));
  };

  const toggleModule = (groupName, moduleName) => {
    const key = `${groupName}:${moduleName}`;
    setExpandedModules((prev) => ({
      ...prev,
      [key]: !prev[key],
    }));
  };

  return (
    <aside style={{ ...styles.sidebar, ...(collapsed ? styles.sidebarCollapsed : {}) }}>
      <style>{`
        .sidebar-scroll::-webkit-scrollbar {
          width: 10px;
        }
        .sidebar-scroll::-webkit-scrollbar-track {
          background: transparent;
        }
        .sidebar-scroll::-webkit-scrollbar-thumb {
          background: linear-gradient(180deg, rgba(71, 85, 105, 0.92), rgba(51, 65, 85, 0.92));
          border-radius: 999px;
          border: 2px solid transparent;
          background-clip: padding-box;
        }
        .sidebar-scroll::-webkit-scrollbar-thumb:hover {
          background: linear-gradient(180deg, rgba(96, 165, 250, 0.95), rgba(59, 130, 246, 0.95));
          border: 2px solid transparent;
          background-clip: padding-box;
        }
      `}</style>
      <div style={styles.logo}>
        <div style={styles.logoRow}>
          <div style={styles.logoMark}>
            <Icon name="panel" size={16} color="#e2e8f0" />
          </div>
          {!collapsed && (
            <div style={styles.logoTextWrap}>
              <span style={styles.logoText}>SISCO</span>
              <span style={styles.logoSub}>Control operativo y reportes</span>
            </div>
          )}
          <button style={styles.toggleBtn} type="button" onClick={onToggle} title={collapsed ? 'Expandir menu' : 'Plegar menu'}>
            <span style={{ ...styles.toggleIcon, ...(collapsed ? styles.toggleIconCollapsed : {}) }}>
              <Icon name="chevron" size={14} stroke={2} color="#cbd5e1" />
            </span>
          </button>
        </div>
      </div>

      {!collapsed && (
        <div style={styles.searchWrap}>
          <input
            style={styles.searchInput}
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Buscar modulo..."
          />
        </div>
      )}

      <nav className="sidebar-scroll" style={styles.nav}>
        {filteredMenu.map((grupo) => (
          <section key={grupo.grupo} style={styles.grupo}>
            <button
              type="button"
              onClick={() => !collapsed && toggleGroup(grupo.grupo)}
              title={collapsed ? grupo.grupo : `Plegar o desplegar ${grupo.grupo}`}
              style={{
                ...styles.groupButton,
                ...(collapsed ? styles.groupButtonCollapsed : {}),
              }}
            >
              <div style={styles.groupButtonMain}>
                <div style={styles.groupIconWrap}>
                  <Icon name={grupo.icon} size={16} color="#93c5fd" />
                </div>
                {!collapsed && (
                  <div style={styles.groupTextWrap}>
                    <p style={styles.grupoLabel}>{grupo.grupo}</p>
                    <span style={styles.groupMeta}>{grupo.modulos.reduce((acc, modulo) => acc + modulo.items.length, 0)} accesos</span>
                  </div>
                )}
              </div>
              {!collapsed && (
                <span
                  style={{
                    ...styles.groupChevron,
                    ...(expandedGroups[grupo.grupo] ? styles.groupChevronExpanded : {}),
                  }}
                >
                  <Icon name="chevron" size={14} stroke={2} color="#cbd5e1" />
                </span>
              )}
            </button>
            {!collapsed && expandedGroups[grupo.grupo] && (
              <div style={styles.groupBody}>
                {grupo.modulos.map((modulo) => {
                  const moduleKey = `${grupo.grupo}:${modulo.nombre}`;
                  const isExpanded = expandedModules[moduleKey];
                  return (
                    <div key={modulo.nombre} style={styles.modulo}>
                      <button
                        type="button"
                        onClick={() => toggleModule(grupo.grupo, modulo.nombre)}
                        style={styles.moduloSummary}
                      >
                        <div style={styles.moduleTitleWrap}>
                          <span style={styles.moduleAccent} />
                          <span>{modulo.nombre}</span>
                        </div>
                        <span
                          style={{
                            ...styles.chevron,
                            ...(isExpanded ? styles.chevronExpanded : {}),
                          }}
                        >
                          <Icon name="chevron" size={14} stroke={2} color="#94a3b8" />
                        </span>
                      </button>
                      {isExpanded && (
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
                            </NavLink>
                          ))}
                        </div>
                      )}
                    </div>
                  );
                })}
              </div>
            )}
          </section>
        ))}
      </nav>

      <div style={{ ...styles.footer, ...(collapsed ? styles.footerCollapsed : {}) }}>
        {!collapsed && <span style={styles.username}>{user?.username}</span>}
        <button style={styles.logoutBtn} type="button" onClick={logout} title="Salir">
          {collapsed ? '->' : 'Salir'}
        </button>
      </div>
    </aside>
  );
}

const styles = {
  sidebar: {
    width: 320,
    height: '100vh',
    background: 'linear-gradient(180deg, #081120 0%, #0b1630 38%, #111c37 100%)',
    display: 'flex',
    flexDirection: 'column',
    position: 'fixed',
    top: 0,
    left: 0,
    zIndex: 100,
    borderRight: '1px solid rgba(59, 130, 246, 0.16)',
    boxShadow: '18px 0 48px rgba(2, 6, 23, 0.28)',
    transition: 'width 0.2s ease',
    overflow: 'hidden',
  },
  sidebarCollapsed: {
    width: 88,
  },
  logo: {
    padding: '18px 14px 14px',
    borderBottom: '1px solid rgba(51, 65, 85, 0.7)',
    background: 'linear-gradient(180deg, rgba(15, 23, 42, 0.96), rgba(15, 23, 42, 0.74))',
    backdropFilter: 'blur(16px)',
  },
  logoRow: {
    display: 'flex',
    alignItems: 'center',
    gap: 10,
  },
  logoMark: {
    width: 42,
    height: 42,
    borderRadius: 14,
    display: 'grid',
    placeItems: 'center',
    background: 'linear-gradient(135deg, rgba(37, 99, 235, 0.34), rgba(14, 165, 233, 0.24))',
    border: '1px solid rgba(147, 197, 253, 0.24)',
    boxShadow: '0 16px 28px rgba(2, 132, 199, 0.16)',
    flexShrink: 0,
  },
  logoTextWrap: {
    display: 'flex',
    flexDirection: 'column',
    gap: 3,
    minWidth: 0,
    flex: 1,
  },
  logoText: { color: '#fff', fontSize: 22, fontWeight: 900, letterSpacing: 1.1 },
  logoSub: { color: '#8fb3d9', fontSize: 11, fontWeight: 600, letterSpacing: 0.2 },
  toggleBtn: {
    width: 32,
    height: 32,
    borderRadius: 10,
    border: '1px solid rgba(71, 85, 105, 0.7)',
    background: 'rgba(15, 23, 42, 0.74)',
    display: 'grid',
    placeItems: 'center',
    cursor: 'pointer',
    flexShrink: 0,
  },
  toggleIcon: {
    display: 'inline-flex',
    transition: 'transform 0.2s ease',
    transform: 'rotate(90deg)',
  },
  toggleIconCollapsed: {
    transform: 'rotate(-90deg)',
  },
  searchWrap: {
    padding: '14px 14px 10px',
  },
  searchInput: {
    width: '100%',
    boxSizing: 'border-box',
    background: 'rgba(8, 15, 29, 0.88)',
    color: '#e2e8f0',
    border: '1px solid rgba(51, 65, 85, 0.9)',
    borderRadius: 14,
    padding: '12px 13px',
    fontSize: 12,
    outline: 'none',
    boxShadow: 'inset 0 1px 0 rgba(148, 163, 184, 0.08)',
  },
  nav: {
    flex: 1,
    overflowY: 'auto',
    overflowX: 'hidden',
    padding: '8px 10px 12px',
    scrollbarWidth: 'thin',
    scrollbarColor: '#334155 transparent',
  },
  grupo: { marginBottom: 10 },
  groupButton: {
    width: '100%',
    border: '1px solid rgba(51, 65, 85, 0.78)',
    borderRadius: 18,
    background: 'linear-gradient(180deg, rgba(15, 23, 42, 0.98), rgba(15, 23, 42, 0.82))',
    padding: '12px 14px',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: 10,
    cursor: 'pointer',
    boxShadow: '0 18px 32px rgba(2, 6, 23, 0.16)',
  },
  groupButtonCollapsed: {
    justifyContent: 'center',
    padding: '12px 10px',
  },
  groupButtonMain: {
    display: 'flex',
    alignItems: 'center',
    gap: 12,
    minWidth: 0,
  },
  groupIconWrap: {
    width: 34,
    height: 34,
    borderRadius: 12,
    display: 'grid',
    placeItems: 'center',
    background: 'linear-gradient(135deg, rgba(30, 41, 59, 0.96), rgba(15, 23, 42, 0.72))',
    border: '1px solid rgba(96, 165, 250, 0.16)',
    flexShrink: 0,
  },
  groupTextWrap: {
    display: 'flex',
    flexDirection: 'column',
    gap: 3,
    minWidth: 0,
    textAlign: 'left',
  },
  grupoLabel: {
    color: '#e2e8f0',
    fontSize: 12,
    fontWeight: 800,
    letterSpacing: 0.4,
    margin: 0,
    textTransform: 'uppercase',
  },
  groupMeta: {
    color: '#7dd3fc',
    fontSize: 11,
    fontWeight: 600,
    letterSpacing: 0.2,
  },
  groupChevron: {
    display: 'inline-flex',
    transition: 'transform 0.2s ease',
    transform: 'rotate(-90deg)',
  },
  groupChevronExpanded: {
    transform: 'rotate(0deg)',
  },
  groupBody: {
    marginTop: 10,
    display: 'grid',
    gap: 8,
  },
  modulo: {
    border: '1px solid rgba(30, 41, 59, 0.9)',
    borderRadius: 16,
    background: 'linear-gradient(180deg, rgba(7, 12, 24, 0.9), rgba(11, 18, 32, 0.78))',
    overflow: 'hidden',
  },
  moduloSummary: {
    width: '100%',
    background: 'transparent',
    border: 'none',
    color: '#dbeafe',
    fontSize: 12,
    fontWeight: 700,
    cursor: 'pointer',
    padding: '12px 13px',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    borderBottom: '1px solid rgba(30, 41, 59, 0.75)',
  },
  moduleTitleWrap: {
    display: 'flex',
    alignItems: 'center',
    gap: 10,
    textAlign: 'left',
  },
  moduleAccent: {
    width: 8,
    height: 8,
    borderRadius: 999,
    background: 'linear-gradient(135deg, #38bdf8, #60a5fa)',
    boxShadow: '0 0 0 4px rgba(56, 189, 248, 0.12)',
    flexShrink: 0,
  },
  chevron: {
    display: 'inline-flex',
    transition: 'transform 0.2s ease',
    transform: 'rotate(-90deg)',
  },
  chevronExpanded: {
    transform: 'rotate(0deg)',
  },
  moduloBody: { padding: 8, display: 'grid', gap: 6 },
  link: {
    display: 'flex',
    flexDirection: 'column',
    gap: 7,
    padding: '10px 11px',
    color: '#a5b4fc',
    textDecoration: 'none',
    fontSize: 12,
    borderRadius: 12,
    border: '1px solid transparent',
    background: 'rgba(15, 23, 42, 0.34)',
    transition: 'all 0.15s',
  },
  linkHeader: { display: 'flex', alignItems: 'center', gap: 8, fontWeight: 700 },
  linkActive: {
    color: '#eff6ff',
    background: 'linear-gradient(135deg, rgba(37, 99, 235, 0.38), rgba(14, 165, 233, 0.36))',
    border: '1px solid rgba(147, 197, 253, 0.42)',
    boxShadow: '0 14px 24px rgba(37, 99, 235, 0.16)',
  },
  footer: {
    padding: '14px 16px',
    borderTop: '1px solid rgba(51, 65, 85, 0.72)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: 8,
    background: 'rgba(8, 15, 29, 0.78)',
    backdropFilter: 'blur(10px)',
  },
  footerCollapsed: {
    justifyContent: 'center',
    padding: '14px 10px',
  },
  username: { color: '#cbd5e1', fontSize: 12, maxWidth: 170, overflow: 'hidden', textOverflow: 'ellipsis' },
  logoutBtn: {
    background: 'linear-gradient(180deg, rgba(15, 23, 42, 0.82), rgba(30, 41, 59, 0.82))',
    border: '1px solid rgba(71, 85, 105, 0.72)',
    color: '#e2e8f0',
    padding: '6px 11px',
    borderRadius: 10,
    cursor: 'pointer',
    fontSize: 12,
    fontWeight: 600,
  },
};

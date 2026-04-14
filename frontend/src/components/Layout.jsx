import { useState } from 'react';
import { useLocation } from 'react-router-dom';
import Sidebar from './Sidebar';
import { theme } from '../styles/tokens';

const PAGE_META = [
  { match: '/maestros/', group: 'Maestros' },
  { match: '/movimientos/', group: 'Movimientos' },
  { match: '/reportes/', group: 'Reportes' },
  { match: '/seguridad/', group: 'Seguridad' },
];

const PAGE_TITLES = {
  '/maestros/clientes': 'Clientes',
  '/maestros/choferes': 'Choferes',
  '/maestros/vehiculos': 'Vehiculos',
  '/maestros/tipo-vehiculo': 'Tipo de Vehiculo',
  '/maestros/proveedores': 'Proveedores',
  '/maestros/tipo-egreso': 'Tipo de Egreso',
  '/maestros/tipo-ingreso': 'Tipo de Ingreso',
  '/maestros/tipo-incidente': 'Tipo de Incidente',
  '/movimientos/tickets': 'Alquiler de cochera',
  '/movimientos/cobranza-credito': 'Cobranza credito',
  '/movimientos/consulta-ticket-credito': 'Cuentas por cobrar',
  '/movimientos/recibos-egreso': 'Recibo egreso',
  '/movimientos/recibos-ingreso': 'Recibo ingreso',
  '/movimientos/cierre-turno': 'Cierre de turno',
  '/movimientos/consulta-ingreso-diario': 'Cierre diario',
  '/reportes/ticket-salida': 'Lista de ticket de salida',
  '/reportes/comprobantes': 'Relacion de comprobante de venta',
  '/reportes/cobranza-diaria': 'Cobranza diaria',
  '/reportes/ingreso-egreso': 'Ingresos y egresos mensuales',
  '/seguridad/usuarios': 'Usuarios',
  '/seguridad/perfiles': 'Definir perfiles',
};

export default function Layout({ children }) {
  const location = useLocation();
  const [sidebarCollapsed, setSidebarCollapsed] = useState(false);
  const meta = PAGE_META.find((item) => location.pathname.startsWith(item.match));
  const pageTitle = PAGE_TITLES[location.pathname] || 'Panel';

  return (
    <div style={styles.shell}>
      <Sidebar collapsed={sidebarCollapsed} onToggle={() => setSidebarCollapsed((prev) => !prev)} />
      <main
        style={{
          ...styles.main,
          marginLeft: sidebarCollapsed ? 88 : 320,
        }}
      >
        <div style={styles.topbar}>
          <div>
            <div style={styles.breadcrumb}>
              <span>{meta?.group || 'SISCO'}</span>
              <span style={styles.separator}>/</span>
              <span style={styles.breadcrumbCurrent}>{pageTitle}</span>
            </div>
            <h1 style={styles.pageTitle}>{pageTitle}</h1>
          </div>
          <div style={styles.topbarBadge}>Operacion en curso</div>
        </div>
        {children}
      </main>
    </div>
  );
}

const styles = {
  shell: {
    display: 'flex',
    background: `linear-gradient(180deg, ${theme.colors.appBg} 0%, #f8fafc 100%)`,
  },
  main: {
    flex: 1,
    minHeight: '100vh',
    padding: 24,
    transition: 'margin-left 0.2s ease',
  },
  topbar: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    gap: 16,
    marginBottom: 18,
  },
  breadcrumb: {
    display: 'flex',
    alignItems: 'center',
    gap: 8,
    color: theme.colors.textMuted,
    fontSize: theme.typography.small,
    fontWeight: 700,
    textTransform: 'uppercase',
    letterSpacing: 0.6,
  },
  separator: {
    color: theme.colors.textSoft,
  },
  breadcrumbCurrent: {
    color: theme.colors.brandDark,
  },
  pageTitle: {
    margin: '8px 0 0',
    color: theme.colors.text,
    fontSize: theme.typography.title,
    fontWeight: 800,
    letterSpacing: -0.4,
  },
  topbarBadge: {
    background: theme.colors.panel,
    color: theme.colors.textMuted,
    border: `1px solid ${theme.colors.border}`,
    borderRadius: theme.radius.pill,
    padding: '8px 12px',
    boxShadow: theme.shadow.soft,
    fontSize: theme.typography.small,
    fontWeight: 700,
    whiteSpace: 'nowrap',
  },
};

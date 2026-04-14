import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import Layout from './components/Layout';
import Login from './pages/Login';

// Maestros
import Clientes    from './pages/maestros/Clientes';
import Choferes    from './pages/maestros/Choferes';
import Vehiculos   from './pages/maestros/Vehiculos';
import TipoVehiculo from './pages/maestros/TipoVehiculo';
import Proveedores from './pages/maestros/Proveedores';
import TipoEgreso from './pages/maestros/TipoEgreso';
import TipoIngreso from './pages/maestros/TipoIngreso';
import TipoIncidente from './pages/maestros/TipoIncidente';

// Movimientos
import Tickets        from './pages/movimientos/Tickets';
import CobranzaCredito from './pages/movimientos/CobranzaCredito';
import ConsultaTicketCredito from './pages/movimientos/ConsultaTicketCredito';
import RecibosEgreso  from './pages/movimientos/RecibosEgreso';
import RecibosIngreso from './pages/movimientos/RecibosIngreso';
import Tarifario   from './pages/movimientos/Tarifario';
import CierreTurno from './pages/movimientos/CierreTurno';

// Reportes
import TicketSalida from './pages/reportes/TicketSalida';
import ComprobantesVenta from './pages/reportes/ComprobantesVenta';
import CobranzaDiaria    from './pages/reportes/CobranzaDiaria';
import IngresoEgresoMes  from './pages/reportes/IngresoEgresoMes';
import IngresoDiario     from './pages/reportes/IngresoDiario';

// Seguridad
import Usuarios    from './pages/seguridad/Usuarios';
import Perfiles    from './pages/seguridad/Perfiles';

function hasModuleAccess(user, allowedModules) {
  if (!allowedModules || allowedModules.length === 0) return true;
  return allowedModules.some((moduleName) => user?.allowed_modules?.includes(moduleName));
}

function hasRoleAccess(user, allowedRoles) {
  if (!allowedRoles || allowedRoles.length === 0) return true;
  return allowedRoles.includes(user?.role);
}

function PrivateRoute({ children, allowedModules = [], allowedRoles = [] }) {
  const { user, loading } = useAuth();
  if (loading) return <div style={{ padding: 40, textAlign: 'center' }}>Cargando...</div>;
  if (!user) return <Navigate to="/login" />;
  if (!hasModuleAccess(user, allowedModules) || !hasRoleAccess(user, allowedRoles)) {
    return <Navigate to="/" replace />;
  }
  return <Layout>{children}</Layout>;
}

function PR({ children, allowedModules = [], allowedRoles = [] }) {
  return <PrivateRoute allowedModules={allowedModules} allowedRoles={allowedRoles}>{children}</PrivateRoute>;
}

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<Login />} />

          {/* Maestros */}
          <Route path="/maestros/clientes"      element={<PR allowedModules={['MAESTROS']}><Clientes /></PR>} />
          <Route path="/maestros/choferes"      element={<PR allowedModules={['MAESTROS']}><Choferes /></PR>} />
          <Route path="/maestros/vehiculos"     element={<PR allowedModules={['MAESTROS']}><Vehiculos /></PR>} />
          <Route path="/maestros/tipo-vehiculo" element={<PR allowedModules={['MAESTROS']}><TipoVehiculo /></PR>} />
          <Route path="/maestros/proveedores"   element={<PR allowedModules={['MAESTROS']}><Proveedores /></PR>} />
          <Route path="/maestros/tipo-egreso"   element={<PR allowedModules={['MAESTROS']}><TipoEgreso /></PR>} />
          <Route path="/maestros/tipo-ingreso"  element={<PR allowedModules={['MAESTROS']}><TipoIngreso /></PR>} />
          <Route path="/maestros/tipo-incidente" element={<PR allowedModules={['MAESTROS']}><TipoIncidente /></PR>} />

          {/* Movimientos */}
          <Route path="/movimientos/tickets"                  element={<PR allowedModules={['MOVIMIENTOS']}><Tickets /></PR>} />
          <Route path="/movimientos/cobranza-credito"         element={<PR allowedModules={['MOVIMIENTOS']}><CobranzaCredito /></PR>} />
          <Route path="/movimientos/consulta-ticket-credito"   element={<PR allowedModules={['MOVIMIENTOS']}><ConsultaTicketCredito /></PR>} />
          <Route path="/movimientos/recibos-egreso"           element={<PR allowedModules={['MOVIMIENTOS']}><RecibosEgreso /></PR>} />
          <Route path="/movimientos/recibos-ingreso"  element={<PR allowedModules={['MOVIMIENTOS']}><RecibosIngreso /></PR>} />
          <Route path="/movimientos/tarifario"    element={<PR allowedModules={['MOVIMIENTOS']}><Tarifario /></PR>} />
          <Route path="/movimientos/cierre-turno"             element={<PR allowedModules={['MOVIMIENTOS']}><CierreTurno /></PR>} />
          <Route path="/movimientos/consulta-ingreso-diario"  element={<PR allowedModules={['MOVIMIENTOS']}><IngresoDiario /></PR>} />

          {/* Reportes */}
          <Route path="/reportes/ticket-salida" element={<PR allowedModules={['REPORTES']}><TicketSalida /></PR>} />
          <Route path="/reportes/comprobantes"    element={<PR allowedModules={['REPORTES']}><ComprobantesVenta /></PR>} />
          <Route path="/reportes/cobranza-diaria" element={<PR allowedModules={['REPORTES']}><CobranzaDiaria /></PR>} />
          <Route path="/reportes/ingreso-egreso"  element={<PR allowedModules={['REPORTES']}><IngresoEgresoMes /></PR>} />

          {/* Redirecciones */}
          <Route path="/" element={<Navigate to="/maestros/clientes" />} />
          <Route path="*" element={<Navigate to="/" />} />

          {/* Seguridad */}
          <Route path="/seguridad/usuarios"       element={<PR allowedModules={['SEGURIDAD']} allowedRoles={['Administrador']}><Usuarios /></PR>} />
          <Route path="/seguridad/perfiles"       element={<PR allowedModules={['SEGURIDAD']} allowedRoles={['Administrador']}><Perfiles /></PR>} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}

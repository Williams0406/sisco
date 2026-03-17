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

// Movimientos
import Tickets        from './pages/movimientos/Tickets';
import CobranzaCredito from './pages/movimientos/CobranzaCredito';
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

function PrivateRoute({ children }) {
  const { user, loading } = useAuth();
  if (loading) return <div style={{ padding: 40, textAlign: 'center' }}>Cargando...</div>;
  return user ? <Layout>{children}</Layout> : <Navigate to="/login" />;
}

function PR({ children }) {
  return <PrivateRoute>{children}</PrivateRoute>;
}

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<Login />} />

          {/* Maestros */}
          <Route path="/maestros/clientes"      element={<PR><Clientes /></PR>} />
          <Route path="/maestros/choferes"      element={<PR><Choferes /></PR>} />
          <Route path="/maestros/vehiculos"     element={<PR><Vehiculos /></PR>} />
          <Route path="/maestros/tipo-vehiculo" element={<PR><TipoVehiculo /></PR>} />
          <Route path="/maestros/proveedores"   element={<PR><Proveedores /></PR>} />

          {/* Movimientos */}
          <Route path="/movimientos/tickets"          element={<PR><Tickets /></PR>} />
          <Route path="/movimientos/cobranza-credito" element={<PR><CobranzaCredito /></PR>} />
          <Route path="/movimientos/recibos-egreso"   element={<PR><RecibosEgreso /></PR>} />
          <Route path="/movimientos/recibos-ingreso"  element={<PR><RecibosIngreso /></PR>} />
          <Route path="/movimientos/tarifario"    element={<PR><Tarifario /></PR>} />
          <Route path="/movimientos/cierre-turno" element={<PR><CierreTurno /></PR>} />

          {/* Reportes */}
          <Route path="/reportes/ticket-salida" element={<PR><TicketSalida /></PR>} />
          <Route path="/reportes/comprobantes"    element={<PR><ComprobantesVenta /></PR>} />
          <Route path="/reportes/cobranza-diaria" element={<PR><CobranzaDiaria /></PR>} />
          <Route path="/reportes/ingreso-egreso"  element={<PR><IngresoEgresoMes /></PR>} />
          <Route path="/reportes/ingreso-diario"  element={<PR><IngresoDiario /></PR>} />

          {/* Redirecciones */}
          <Route path="/" element={<Navigate to="/maestros/clientes" />} />
          <Route path="*" element={<Navigate to="/" />} />

          {/* Seguridad */}
          <Route path="/seguridad/usuarios"       element={<PR><Usuarios /></PR>} />
          <Route path="/seguridad/perfiles"       element={<PR><Perfiles /></PR>} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}
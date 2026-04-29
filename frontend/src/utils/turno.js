export const TURNO_DIA = '1';
export const TURNO_NOCHE = '2';

export function normalizeTurno(value) {
  if (value == null) return '';

  const token = String(value).trim().toLowerCase();
  if (!token) return '';

  if (['1', '01', '1.0', 'dia', 'day'].includes(token)) return TURNO_DIA;
  if (['2', '02', '2.0', 'noche', 'night'].includes(token)) return TURNO_NOCHE;
  return String(value).trim();
}

export function formatTurno(value, { withCode = false, fallback = '-' } = {}) {
  const normalized = normalizeTurno(value);
  if (normalized === TURNO_DIA) return withCode ? '1 - Dia' : 'Dia';
  if (normalized === TURNO_NOCHE) return withCode ? '2 - Noche' : 'Noche';
  return normalized || fallback;
}


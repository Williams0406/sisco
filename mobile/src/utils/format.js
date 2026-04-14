export function normalizeList(payload) {
  return payload?.results || payload || [];
}

export function boolValue(value) {
  return value === true || value === '1' || value === 1 || value === 'true';
}

export function boolLabel(value, trueLabel, falseLabel) {
  return boolValue(value) ? trueLabel : falseLabel;
}

export function pad(value) {
  return String(value).padStart(2, '0');
}

function isValidDate(date) {
  return date instanceof Date && !Number.isNaN(date.getTime());
}

function formatLocalDateTime(date) {
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ${pad(date.getHours())}:${pad(date.getMinutes())}`;
}

export function toInputDateTime(value) {
  if (!value) return '';
  if (value instanceof Date) {
    return isValidDate(value) ? formatLocalDateTime(value) : '';
  }
  const normalized = String(value).replace(' ', 'T');
  const date = new Date(normalized);
  if (Number.isNaN(date.getTime())) {
    const match = String(value).match(/^(\d{4})-(\d{2})-(\d{2})[ T](\d{2}):(\d{2})/);
    if (match) {
      return `${match[1]}-${match[2]}-${match[3]} ${match[4]}:${match[5]}`;
    }
    return '';
  }
  return formatLocalDateTime(date);
}

export function nowInputValue() {
  return toInputDateTime(new Date());
}

export function toApiDateTime(value) {
  if (!value) return null;
  if (value instanceof Date) {
    if (!isValidDate(value)) return null;
    return `${value.getFullYear()}-${pad(value.getMonth() + 1)}-${pad(value.getDate())}T${pad(value.getHours())}:${pad(value.getMinutes())}:${pad(value.getSeconds())}`;
  }
  const normalized = String(value).trim().replace(' ', 'T');
  const date = new Date(normalized);
  if (Number.isNaN(date.getTime())) return normalized;
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}T${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}`;
}

export function formatDateTime(value) {
  if (!value) return 'Sin fecha';
  const date = new Date(String(value).replace(' ', 'T'));
  if (Number.isNaN(date.getTime())) return String(value);
  return `${pad(date.getDate())}/${pad(date.getMonth() + 1)}/${date.getFullYear()} ${pad(date.getHours())}:${pad(date.getMinutes())}`;
}

export function formatDate(value) {
  if (!value) return 'Sin fecha';
  const date = new Date(String(value).replace(' ', 'T'));
  if (Number.isNaN(date.getTime())) return String(value);
  return `${pad(date.getDate())}/${pad(date.getMonth() + 1)}/${date.getFullYear()}`;
}

export function formatMoney(value) {
  const amount = Number(value);
  return Number.isFinite(amount) ? `S/ ${amount.toFixed(2)}` : 'S/ 0.00';
}

export function normalizeRecordForForm(record) {
  const next = { ...record };
  Object.keys(next).forEach((key) => {
    if (next[key] === null || next[key] === undefined) next[key] = '';
    if (key.startsWith('dt_')) next[key] = toInputDateTime(next[key]);
  });
  return next;
}

export function extractErrorMessage(payload) {
  if (!payload) return '';
  if (typeof payload === 'string') return payload;
  if (payload.detail) return payload.detail;
  const firstKey = Object.keys(payload)[0];
  if (!firstKey) return '';
  const firstValue = payload[firstKey];
  if (Array.isArray(firstValue)) return firstValue[0];
  if (typeof firstValue === 'string') return firstValue;
  return JSON.stringify(payload);
}

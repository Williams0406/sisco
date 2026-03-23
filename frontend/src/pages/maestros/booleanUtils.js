export const isTrueValue = (value) => value === true || value === 'true' || value === 1 || value === '1';

export const toBooleanOrNull = (value) => {
  if (value === '' || value === null || value === undefined) return null;
  return isTrueValue(value);
};
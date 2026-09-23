// All period boundaries are UTC so results don't depend on the server's timezone
const DAY_MS = 24 * 60 * 60 * 1000;

function startOfDay(date) {
  return new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()));
}

function startOfMonth(date, monthOffset = 0) {
  return new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth() + monthOffset, 1));
}

function startOfYear(date, yearOffset = 0) {
  return new Date(Date.UTC(date.getUTCFullYear() + yearOffset, 0, 1));
}

function addDays(date, days) {
  return new Date(date.getTime() + days * DAY_MS);
}

module.exports = { DAY_MS, startOfDay, startOfMonth, startOfYear, addDays };

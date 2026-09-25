const prisma = require('../lib/prisma');
const { startOfDay, startOfMonth, startOfYear, addDays } = require('../lib/dates');

function periodRanges(period, now) {
  switch (period) {
    case 'last_month':
      return {
        current: { gte: startOfMonth(now, -1), lt: startOfMonth(now) },
        previous: { gte: startOfMonth(now, -2), lt: startOfMonth(now, -1) },
      };
    case 'this_year':
      return {
        current: { gte: startOfYear(now), lt: startOfYear(now, 1) },
        previous: { gte: startOfYear(now, -1), lt: startOfYear(now) },
      };
    default:
      return {
        current: { gte: startOfMonth(now), lt: startOfMonth(now, 1) },
        previous: { gte: startOfMonth(now, -1), lt: startOfMonth(now) },
      };
  }
}

async function countByDirection(userId, createdAt) {
  const groups = await prisma.shipment.groupBy({
    by: ['direction'],
    where: { userId, createdAt },
    _count: { _all: true },
  });
  const counts = { EXPORT: 0, IMPORT: 0 };
  for (const group of groups) counts[group.direction] = group._count._all;
  return { total: counts.EXPORT + counts.IMPORT, exports: counts.EXPORT, imports: counts.IMPORT };
}

function compare(count, previousCount) {
  const changePercent =
    previousCount === 0 ? null : Math.round(((count - previousCount) / previousCount) * 100);
  return { count, previousCount, changePercent };
}

async function getOverview(userId, period, now = new Date()) {
  const ranges = periodRanges(period, now);
  const [user, current, previous] = await Promise.all([
    prisma.user.findUniqueOrThrow({ where: { id: userId }, select: { walletBalance: true } }),
    countByDirection(userId, ranges.current),
    countByDirection(userId, ranges.previous),
  ]);

  return {
    period,
    walletBalance: user.walletBalance,
    totalShipments: compare(current.total, previous.total),
    exports: compare(current.exports, previous.exports),
    imports: compare(current.imports, previous.imports),
  };
}

const monthLabel = new Intl.DateTimeFormat('en-US', { month: 'short', timeZone: 'UTC' });
const weekdayLabel = new Intl.DateTimeFormat('en-US', { weekday: 'short', timeZone: 'UTC' });

function growthBuckets(range, now) {
  const today = startOfDay(now);

  if (range === 'year') {
    return Array.from({ length: 12 }, (_, i) => {
      const start = startOfMonth(now, i - 11);
      return { start, end: startOfMonth(now, i - 10), label: monthLabel.format(start) };
    });
  }

  const days = range === 'month' ? 30 : 7;
  return Array.from({ length: days }, (_, i) => {
    const start = addDays(today, i - days + 1);
    const label = range === 'week' ? weekdayLabel.format(start) : String(start.getUTCDate());
    return { start, end: addDays(start, 1), label };
  });
}

async function getGrowth(range, now = new Date()) {
  const buckets = growthBuckets(range, now);
  const stats = await prisma.shipmentStat.findMany({
    where: { date: { gte: buckets[0].start, lt: buckets.at(-1).end } },
  });

  const points = buckets.map(({ start, end, label }) => ({
    date: start.toISOString().slice(0, 10),
    label,
    value: stats
      .filter((stat) => stat.date >= start && stat.date < end)
      .reduce((sum, stat) => sum + stat.count, 0),
  }));

  return { range, points };
}

module.exports = { getOverview, getGrowth };

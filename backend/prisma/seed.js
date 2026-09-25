require('dotenv').config({ quiet: true });
const bcrypt = require('bcryptjs');
const { PrismaClient } = require('@prisma/client');
const { buildShipment, randomDateBetween } = require('../src/lib/sampleShipments');
const { startOfDay, startOfMonth, addDays } = require('../src/lib/dates');

const prisma = new PrismaClient();

const DEMO_EMAIL = 'demo@securebypay.test';
const DEMO_PASSWORD = 'Demo@1234';
const DEMO_BALANCE = 300_000_028;

const MONTHLY_TOTALS = [270, 320, 300, 360, 330, 440, 320, 490, 370, 620, 120, 980];

const DEMO_VOLUME = [
  [0, 19, 15],
  [1, 10, 8],
  [2, 9, 7],
  [3, 12, 6],
  [4, 8, 9],
  [5, 11, 7],
  [6, 7, 5],
  [7, 9, 6],
  [8, 10, 8],
  [9, 6, 7],
  [10, 8, 4],
  [11, 7, 6],
  [12, 5, 5],
];

function createRandom(seed) {
  let state = seed;
  return () => {
    state = (state + 0x6d2b79f5) | 0;
    let t = Math.imul(state ^ (state >>> 15), 1 | state);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

function buildDailyStats(now, random) {
  const today = startOfDay(now);
  const stats = [];

  MONTHLY_TOTALS.forEach((total, i) => {
    const monthStart = startOfMonth(now, i - 11);
    const monthEnd = i === 11 ? addDays(today, 1) : startOfMonth(now, i - 10);
    const days = [];
    for (let day = monthStart; day < monthEnd; day = addDays(day, 1)) days.push(day);

    const weights = days.map(() => 0.6 + random() * 0.8);
    const weightSum = weights.reduce((sum, w) => sum + w, 0);
    days.forEach((date, d) => {
      stats.push({ date, count: Math.round((total * weights[d]) / weightSum) });
    });
  });

  return stats;
}

function buildDemoShipments(now, random) {
  const shipments = [];

  for (const [monthsAgo, exports, imports] of DEMO_VOLUME) {
    const start = startOfMonth(now, -monthsAgo);
    const end = monthsAgo === 0 ? now : startOfMonth(now, 1 - monthsAgo);
    const directions = [...Array(exports).fill('EXPORT'), ...Array(imports).fill('IMPORT')];
    for (const direction of directions) {
      shipments.push(
        buildShipment({ direction, random, createdAt: randomDateBetween(start, end, random) }),
      );
    }
  }

  shipments.sort((a, b) => b.createdAt - a.createdAt);
  const designShipment = {
    senderName: 'Bunmi Tanny',
    receiverName: 'Mercy',
    pickupCity: 'Lagos',
    pickupCountry: 'Nigeria',
    deliveryCity: 'Oyo',
    deliveryCountry: 'Nigeria',
    amount: 300_000,
    processingHours: 10,
  };
  const designOverrides = [
    { trackingId: 'MAF-100-234-291', status: 'IN_TRANSIT', isPaid: true },
    { status: 'DELAYED', isPaid: false },
    { status: 'IN_TRANSIT', isPaid: false },
  ];
  designOverrides.forEach((override, i) => {
    Object.assign(shipments[i], designShipment, override);
    shipments[i].createdAt = new Date(now.getTime() - i * 60 * 60 * 1000);
  });

  return shipments;
}

async function main() {
  const now = new Date();
  const random = createRandom(20260926);

  const passwordHash = await bcrypt.hash(DEMO_PASSWORD, 10);
  const demoProfile = {
    firstName: 'Firstname',
    lastName: 'Lastname',
    phoneCode: '+234',
    phoneNumber: '8012345678',
    passwordHash,
    walletBalance: DEMO_BALANCE,
  };

  const shipments = buildDemoShipments(now, random);
  const stats = buildDailyStats(now, random);

  await prisma.$transaction(async (tx) => {
    const user = await tx.user.upsert({
      where: { email: DEMO_EMAIL },
      update: demoProfile,
      create: { email: DEMO_EMAIL, ...demoProfile },
    });

    await tx.shipment.deleteMany({ where: { userId: user.id } });
    await tx.walletTransaction.deleteMany({ where: { userId: user.id } });
    await tx.shipment.createMany({ data: shipments.map((s) => ({ ...s, userId: user.id })) });
    await tx.walletTransaction.create({
      data: { userId: user.id, type: 'FUND', amount: DEMO_BALANCE, reference: 'FND-SEED-DEMO' },
    });

    await tx.shipmentStat.deleteMany();
    await tx.shipmentStat.createMany({ data: stats });
  }, { maxWait: 10_000, timeout: 30_000 });

  console.log(`Seeded ${DEMO_EMAIL} with ${shipments.length} shipments and ${stats.length} days of stats`);
}

main()
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(() => prisma.$disconnect());

const request = require('supertest');
const app = require('../src/app');
const prisma = require('../src/lib/prisma');

const email = 'wallet.test@example.com';
let auth;
let userId;

beforeAll(async () => {
  await prisma.user.deleteMany({ where: { email } });
  const res = await request(app).post('/api/auth/register').send({
    firstName: 'Wallet',
    lastName: 'Tester',
    email,
    phoneCode: '+234',
    phoneNumber: '8012345678',
    password: 'Secret@123',
  });
  auth = { Authorization: `Bearer ${res.body.token}` };
  userId = res.body.user.id;

  await prisma.shipment.create({
    data: {
      userId,
      trackingId: 'MAF-999-000-001',
      senderName: 'Bunmi Tanny',
      receiverName: 'Mercy',
      pickupCity: 'Lagos',
      pickupCountry: 'Nigeria',
      deliveryCity: 'Oyo',
      deliveryCountry: 'Nigeria',
      amount: 300_000,
      status: 'DELAYED',
      direction: 'EXPORT',
      processingHours: 10,
    },
  });
});

afterAll(async () => {
  await prisma.user.deleteMany({ where: { email } });
  await prisma.$disconnect();
});

it('gives new accounts sample shipments and a zero balance', async () => {
  const res = await request(app).get('/api/shipments?limit=50').set(auth);

  expect(res.status).toBe(200);
  expect(res.body.total).toBe(7);
  expect(res.body.data[0]).not.toHaveProperty('userId');

  const overview = await request(app).get('/api/dashboard/overview').set(auth);
  expect(overview.body.walletBalance).toBe(0);
  expect(overview.body.totalShipments.count).toBe(5);
  expect(overview.body.totalShipments.previousCount).toBe(2);
});

it('rejects payment when the balance is too low', async () => {
  const res = await request(app).post('/api/shipments/MAF-999-000-001/pay').set(auth);

  expect(res.status).toBe(400);
  expect(res.body.message).toMatch(/insufficient/i);
  const shipment = await prisma.shipment.findUnique({ where: { trackingId: 'MAF-999-000-001' } });
  expect(shipment.isPaid).toBe(false);
});

it('funds the wallet and records a transaction', async () => {
  const res = await request(app).post('/api/wallet/fund').set(auth).send({ amount: 500_000 });

  expect(res.status).toBe(200);
  expect(res.body.walletBalance).toBe(500_000);
  expect(res.body.transaction).toMatchObject({ type: 'FUND', amount: 500_000 });
});

it('validates the fund amount', async () => {
  const res = await request(app).post('/api/wallet/fund').set(auth).send({ amount: 12.5 });

  expect(res.status).toBe(400);
  expect(res.body.errors).toHaveProperty('amount');
});

it('pays for a shipment once', async () => {
  const res = await request(app).post('/api/shipments/MAF-999-000-001/pay').set(auth);

  expect(res.status).toBe(200);
  expect(res.body.shipment.isPaid).toBe(true);
  expect(res.body.walletBalance).toBe(200_000);

  const again = await request(app).post('/api/shipments/MAF-999-000-001/pay').set(auth);
  expect(again.status).toBe(400);
  expect(again.body.message).toMatch(/already been paid/);

  const payments = await prisma.walletTransaction.count({ where: { userId, type: 'PAYMENT' } });
  expect(payments).toBe(1);
});

it('returns 404 for a shipment the user does not own', async () => {
  const res = await request(app).get('/api/shipments/MAF-000-000-000').set(auth);
  expect(res.status).toBe(404);
});

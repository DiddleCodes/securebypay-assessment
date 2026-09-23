const request = require('supertest');
const app = require('../src/app');
const prisma = require('../src/lib/prisma');

const validUser = {
  firstName: 'Ada',
  lastName: 'Obi',
  email: 'Ada.Obi@Example.com',
  phoneCode: '+234',
  phoneNumber: '8012345678',
  password: 'Secret@123',
};

beforeAll(async () => {
  await prisma.user.deleteMany();
});

afterAll(async () => {
  await prisma.user.deleteMany();
  await prisma.$disconnect();
});

describe('POST /api/auth/register', () => {
  it('creates a user and returns a token', async () => {
    const res = await request(app).post('/api/auth/register').send(validUser);

    expect(res.status).toBe(201);
    expect(res.body.token).toEqual(expect.any(String));
    expect(res.body.user).toMatchObject({
      firstName: 'Ada',
      email: 'ada.obi@example.com',
      walletBalance: 0,
    });
    expect(res.body.user).not.toHaveProperty('passwordHash');
  });

  it('rejects a duplicate email regardless of case', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send({ ...validUser, email: 'ADA.OBI@example.com' });

    expect(res.status).toBe(409);
    expect(res.body.errors).toHaveProperty('email');
  });

  it('returns field errors for invalid input', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send({ ...validUser, email: 'new@example.com', password: 'short', phoneNumber: '801-234' });

    expect(res.status).toBe(400);
    expect(res.body.errors).toEqual({
      password: 'Password must be at least 8 characters',
      phoneNumber: 'Phone number must contain digits only',
    });
  });

  it('reports missing fields', async () => {
    const res = await request(app).post('/api/auth/register').send({});

    expect(res.status).toBe(400);
    expect(res.body.errors.firstName).toBe('First name is required');
    expect(res.body.errors.email).toBe('Email is required');
  });
});

describe('POST /api/auth/login', () => {
  it('logs in with valid credentials', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({ email: 'ada.obi@example.com', password: validUser.password });

    expect(res.status).toBe(200);
    expect(res.body.token).toEqual(expect.any(String));
    expect(res.body.user.email).toBe('ada.obi@example.com');
    expect(res.body.user).not.toHaveProperty('passwordHash');
  });

  it.each([
    ['wrong password', { email: validUser.email, password: 'Wrong@1234' }],
    ['unknown email', { email: 'nobody@example.com', password: validUser.password }],
  ])('returns a generic 401 for %s', async (_, credentials) => {
    const res = await request(app).post('/api/auth/login').send(credentials);

    expect(res.status).toBe(401);
    expect(res.body.message).toBe('Invalid email or password');
  });
});

describe('GET /api/auth/me', () => {
  it('returns the current user for a valid token', async () => {
    const login = await request(app)
      .post('/api/auth/login')
      .send({ email: validUser.email, password: validUser.password });

    const res = await request(app)
      .get('/api/auth/me')
      .set('Authorization', `Bearer ${login.body.token}`);

    expect(res.status).toBe(200);
    expect(res.body.user.email).toBe('ada.obi@example.com');
  });

  it('rejects requests without a token', async () => {
    const res = await request(app).get('/api/auth/me');
    expect(res.status).toBe(401);
  });

  it('rejects an invalid token', async () => {
    const res = await request(app).get('/api/auth/me').set('Authorization', 'Bearer not-a-jwt');
    expect(res.status).toBe(401);
  });
});

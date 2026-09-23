const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const prisma = require('../lib/prisma');
const HttpError = require('../lib/httpError');
const { buildShipment, randomDateBetween } = require('../lib/sampleShipments');
const { startOfMonth } = require('../lib/dates');
const { jwtSecret, jwtExpiresIn } = require('../config');

const SALT_ROUNDS = 10;

// Compared against when the email doesn't exist so both failure paths take the same time
const DUMMY_HASH = bcrypt.hashSync('not-a-real-password', SALT_ROUNDS);

const publicUserFields = {
  id: true,
  firstName: true,
  lastName: true,
  email: true,
  phoneCode: true,
  phoneNumber: true,
  avatarUrl: true,
  walletBalance: true,
  createdAt: true,
};

// Gives a new account a few shipments this month and last so the dashboard has something to show
function sampleShipments(now = new Date()) {
  const thisMonth = [startOfMonth(now), now];
  const lastMonth = [startOfMonth(now, -1), startOfMonth(now)];
  return [thisMonth, thisMonth, thisMonth, thisMonth, lastMonth, lastMonth].map(([start, end]) =>
    buildShipment({ createdAt: randomDateBetween(start, end) }),
  );
}

function signToken(userId) {
  return jwt.sign({ sub: userId }, jwtSecret, { expiresIn: jwtExpiresIn });
}

async function register({ password, ...data }) {
  const existing = await prisma.user.findUnique({ where: { email: data.email } });
  if (existing) {
    throw new HttpError(409, 'An account with this email already exists', {
      email: 'An account with this email already exists',
    });
  }

  const user = await prisma.user.create({
    data: {
      ...data,
      passwordHash: await bcrypt.hash(password, SALT_ROUNDS),
      shipments: { create: sampleShipments() },
    },
    select: publicUserFields,
  });

  return { token: signToken(user.id), user };
}

async function login({ email, password }) {
  const user = await prisma.user.findUnique({ where: { email } });
  const valid = await bcrypt.compare(password, user?.passwordHash ?? DUMMY_HASH);
  if (!user || !valid) {
    throw new HttpError(401, 'Invalid email or password');
  }

  const { passwordHash, ...publicUser } = user;
  return { token: signToken(user.id), user: publicUser };
}

async function getUser(userId) {
  const user = await prisma.user.findUnique({ where: { id: userId }, select: publicUserFields });
  if (!user) {
    throw new HttpError(401, 'Account no longer exists');
  }
  return user;
}

module.exports = { register, login, getUser, publicUserFields };

const { rateLimit } = require('express-rate-limit');
const { env } = require('../config');

const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 20,
  standardHeaders: 'draft-8',
  legacyHeaders: false,
  skip: () => env === 'test',
  message: { message: 'Too many attempts, please try again in a few minutes' },
});

module.exports = { authLimiter };

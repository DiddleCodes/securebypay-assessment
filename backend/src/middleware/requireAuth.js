const jwt = require('jsonwebtoken');
const HttpError = require('../lib/httpError');
const { jwtSecret } = require('../config');

function requireAuth(req, res, next) {
  const [scheme, token] = (req.headers.authorization || '').split(' ');
  if (scheme !== 'Bearer' || !token) {
    throw new HttpError(401, 'Authentication required');
  }

  try {
    req.userId = jwt.verify(token, jwtSecret).sub;
  } catch {
    throw new HttpError(401, 'Session expired, please log in again');
  }
  next();
}

module.exports = requireAuth;

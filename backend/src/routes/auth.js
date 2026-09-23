const { Router } = require('express');
const authController = require('../controllers/authController');
const validate = require('../middleware/validate');
const requireAuth = require('../middleware/requireAuth');
const { authLimiter } = require('../middleware/rateLimit');
const { registerSchema, loginSchema } = require('../validators/auth');

const router = Router();

router.post('/register', authLimiter, validate(registerSchema), authController.register);
router.post('/login', authLimiter, validate(loginSchema), authController.login);
router.get('/me', requireAuth, authController.me);

module.exports = router;

const { Router } = require('express');
const dashboardController = require('../controllers/dashboardController');
const validate = require('../middleware/validate');
const requireAuth = require('../middleware/requireAuth');
const { overviewQuerySchema, growthQuerySchema } = require('../validators/dashboard');

const router = Router();

router.use(requireAuth);
router.get('/overview', validate(overviewQuerySchema, 'query'), dashboardController.overview);
router.get('/growth', validate(growthQuerySchema, 'query'), dashboardController.growth);

module.exports = router;

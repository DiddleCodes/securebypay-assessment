const { Router } = require('express');
const walletController = require('../controllers/walletController');
const validate = require('../middleware/validate');
const requireAuth = require('../middleware/requireAuth');
const { fundWalletSchema } = require('../validators/wallet');

const router = Router();

router.use(requireAuth);
router.post('/fund', validate(fundWalletSchema), walletController.fund);

module.exports = router;

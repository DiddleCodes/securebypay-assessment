const { Router } = require('express');
const shipmentController = require('../controllers/shipmentController');
const validate = require('../middleware/validate');
const requireAuth = require('../middleware/requireAuth');
const { listShipmentsQuerySchema } = require('../validators/shipments');

const router = Router();

router.use(requireAuth);
router.get('/', validate(listShipmentsQuerySchema, 'query'), shipmentController.list);
router.get('/:trackingId', shipmentController.show);
router.post('/:trackingId/pay', shipmentController.pay);

module.exports = router;

const { Router } = require('express');
const authRoutes = require('./auth');
const dashboardRoutes = require('./dashboard');
const shipmentRoutes = require('./shipments');
const walletRoutes = require('./wallet');

const router = Router();

router.get('/health', (req, res) => res.json({ status: 'ok' }));
router.use('/auth', authRoutes);
router.use('/dashboard', dashboardRoutes);
router.use('/shipments', shipmentRoutes);
router.use('/wallet', walletRoutes);

module.exports = router;

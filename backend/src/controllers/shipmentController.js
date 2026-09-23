const shipmentService = require('../services/shipmentService');
const walletService = require('../services/walletService');

async function list(req, res) {
  res.json(await shipmentService.listShipments(req.userId, req.validated));
}

async function show(req, res) {
  res.json({ shipment: await shipmentService.getShipment(req.userId, req.params.trackingId) });
}

async function pay(req, res) {
  res.json(await walletService.payForShipment(req.userId, req.params.trackingId));
}

module.exports = { list, show, pay };

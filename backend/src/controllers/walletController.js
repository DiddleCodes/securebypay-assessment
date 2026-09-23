const walletService = require('../services/walletService');

async function fund(req, res) {
  res.json(await walletService.fundWallet(req.userId, req.validated.amount));
}

module.exports = { fund };

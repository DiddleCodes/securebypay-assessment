const dashboardService = require('../services/dashboardService');

async function overview(req, res) {
  res.json(await dashboardService.getOverview(req.userId, req.validated.period));
}

async function growth(req, res) {
  res.json(await dashboardService.getGrowth(req.validated.range));
}

module.exports = { overview, growth };

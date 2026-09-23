const authService = require('../services/authService');

async function register(req, res) {
  res.status(201).json(await authService.register(req.validated));
}

async function login(req, res) {
  res.json(await authService.login(req.validated));
}

async function me(req, res) {
  res.json({ user: await authService.getUser(req.userId) });
}

module.exports = { register, login, me };

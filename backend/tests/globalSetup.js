const { execSync } = require('node:child_process');

module.exports = () => {
  require('./setupEnv');
  execSync('npx prisma migrate deploy', { stdio: 'ignore', env: process.env });
};

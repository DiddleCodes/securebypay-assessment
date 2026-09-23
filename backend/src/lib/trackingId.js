const { randomInt } = require('node:crypto');

const group = () => String(randomInt(100, 1000));

function generateTrackingId() {
  return `MAF-${group()}-${group()}-${group()}`;
}

module.exports = generateTrackingId;

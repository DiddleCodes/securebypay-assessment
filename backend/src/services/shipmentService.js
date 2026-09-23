const prisma = require('../lib/prisma');
const HttpError = require('../lib/httpError');

async function listShipments(userId, { page, limit }) {
  const where = { userId };
  const [shipments, total] = await Promise.all([
    prisma.shipment.findMany({
      where,
      orderBy: { createdAt: 'desc' },
      skip: (page - 1) * limit,
      take: limit,
      omit: { userId: true },
    }),
    prisma.shipment.count({ where }),
  ]);

  return { data: shipments, page, limit, total, totalPages: Math.ceil(total / limit) };
}

async function getShipment(userId, trackingId) {
  const shipment = await prisma.shipment.findFirst({
    where: { userId, trackingId },
    omit: { userId: true },
  });
  if (!shipment) {
    throw new HttpError(404, 'Shipment not found');
  }
  return shipment;
}

module.exports = { listShipments, getShipment };

const { randomBytes } = require('node:crypto');
const prisma = require('../lib/prisma');
const HttpError = require('../lib/httpError');

// walletBalance is a 32-bit Int column
const MAX_BALANCE = 2_147_483_647;

const reference = (prefix) => `${prefix}-${randomBytes(6).toString('hex').toUpperCase()}`;

async function fundWallet(userId, amount) {
  return prisma.$transaction(async (tx) => {
    // Conditional update keeps the balance check and the write atomic
    const { count } = await tx.user.updateMany({
      where: { id: userId, walletBalance: { lte: MAX_BALANCE - amount } },
      data: { walletBalance: { increment: amount } },
    });
    if (count === 0) {
      throw new HttpError(400, 'This top-up would exceed the maximum wallet balance');
    }

    const transaction = await tx.walletTransaction.create({
      data: { userId, type: 'FUND', amount, reference: reference('FND') },
      omit: { userId: true },
    });
    const { walletBalance } = await tx.user.findUniqueOrThrow({
      where: { id: userId },
      select: { walletBalance: true },
    });

    return { walletBalance, transaction };
  });
}

async function payForShipment(userId, trackingId) {
  return prisma.$transaction(async (tx) => {
    const shipment = await tx.shipment.findFirst({ where: { userId, trackingId } });
    if (!shipment) {
      throw new HttpError(404, 'Shipment not found');
    }

    // Guarded on isPaid so two concurrent requests can't both pay
    const marked = await tx.shipment.updateMany({
      where: { id: shipment.id, isPaid: false },
      data: { isPaid: true },
    });
    if (marked.count === 0) {
      throw new HttpError(400, 'This shipment has already been paid for');
    }

    const debited = await tx.user.updateMany({
      where: { id: userId, walletBalance: { gte: shipment.amount } },
      data: { walletBalance: { decrement: shipment.amount } },
    });
    if (debited.count === 0) {
      throw new HttpError(400, 'Insufficient wallet balance. Fund your wallet and try again.');
    }

    await tx.walletTransaction.create({
      data: { userId, type: 'PAYMENT', amount: shipment.amount, reference: reference('PAY') },
    });

    const [updatedShipment, { walletBalance }] = await Promise.all([
      tx.shipment.findUniqueOrThrow({ where: { id: shipment.id }, omit: { userId: true } }),
      tx.user.findUniqueOrThrow({ where: { id: userId }, select: { walletBalance: true } }),
    ]);

    return { shipment: updatedShipment, walletBalance };
  });
}

module.exports = { fundWallet, payForShipment };

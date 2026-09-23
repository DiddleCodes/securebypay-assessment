const generateTrackingId = require('./trackingId');

const NAMES = [
  'Bunmi Tanny', 'Mercy Okafor', 'Tunde Bakare', 'Chioma Eze', 'Ibrahim Musa',
  'Funke Adeyemi', 'Emeka Nwosu', 'Aisha Bello', 'Segun Ojo', 'Ngozi Obi',
];

const CITIES = ['Lagos', 'Oyo', 'Abuja', 'Kano', 'Port Harcourt', 'Enugu', 'Ibadan', 'Kaduna'];

// Paid state follows status: delivered and in-transit shipments were paid before dispatch
const STATUS_PAID = [
  ['DELIVERED', true],
  ['IN_TRANSIT', true],
  ['DELAYED', false],
  ['PENDING', false],
];

const pick = (items, random) => items[Math.floor(random() * items.length)];

function buildShipment({ createdAt, direction, random = Math.random }) {
  const [status, isPaid] = pick(STATUS_PAID, random);
  const pickupCity = pick(CITIES, random);
  const deliveryCity = pick(CITIES.filter((city) => city !== pickupCity), random);

  return {
    trackingId: generateTrackingId(),
    senderName: pick(NAMES, random),
    receiverName: pick(NAMES, random).split(' ')[0],
    pickupCity,
    pickupCountry: 'Nigeria',
    deliveryCity,
    deliveryCountry: 'Nigeria',
    amount: (1500 + Math.floor(random() * 48) * 500) * 100,
    status,
    direction: direction ?? (random() < 0.55 ? 'EXPORT' : 'IMPORT'),
    isPaid,
    processingHours: 6 + Math.floor(random() * 67),
    createdAt,
  };
}

function randomDateBetween(start, end, random = Math.random) {
  return new Date(start.getTime() + random() * (end.getTime() - start.getTime()));
}

module.exports = { buildShipment, randomDateBetween };

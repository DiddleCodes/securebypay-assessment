const { z } = require('zod');

const listShipmentsQuerySchema = z.object({
  limit: z.coerce
    .number({ error: 'Limit must be a number' })
    .int('Limit must be a whole number')
    .min(1, 'Limit must be at least 1')
    .max(50, 'Limit must be at most 50')
    .default(10),
  page: z.coerce
    .number({ error: 'Page must be a number' })
    .int('Page must be a whole number')
    .min(1, 'Page must be at least 1')
    .default(1),
});

module.exports = { listShipmentsQuerySchema };

const { z } = require('zod');

const fundWalletSchema = z.object({
  amount: z
    .number({
      error: (issue) => (issue.input === undefined ? 'Amount is required' : 'Amount must be a number'),
    })
    .int('Amount must be a whole number of kobo')
    .min(100, 'Amount must be at least N1')
    .max(100_000_000, 'Amount must be at most N1,000,000'),
});

module.exports = { fundWalletSchema };

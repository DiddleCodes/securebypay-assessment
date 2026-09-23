const { z } = require('zod');

const overviewQuerySchema = z.object({
  period: z
    .enum(['this_month', 'last_month', 'this_year'], {
      error: 'Period must be this_month, last_month or this_year',
    })
    .default('this_month'),
});

const growthQuerySchema = z.object({
  range: z.enum(['year', 'month', 'week'], { error: 'Range must be year, month or week' }).default('year'),
});

module.exports = { overviewQuerySchema, growthQuerySchema };

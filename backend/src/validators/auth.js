const { z } = require('zod');

const requiredString = (label) =>
  z.string({ error: `${label} is required` }).trim().min(1, `${label} is required`);

const email = requiredString('Email')
  .toLowerCase()
  .pipe(z.email('Enter a valid email address'));

const registerSchema = z.object({
  firstName: requiredString('First name').max(50, 'First name is too long'),
  lastName: requiredString('Last name').max(50, 'Last name is too long'),
  email,
  phoneCode: requiredString('Country code').regex(/^\+\d{1,4}$/, 'Enter a valid country code'),
  phoneNumber: requiredString('Phone number')
    .regex(/^\d+$/, 'Phone number must contain digits only')
    .min(7, 'Phone number is too short')
    .max(15, 'Phone number is too long'),
  password: z
    .string({ error: 'Password is required' })
    .min(8, 'Password must be at least 8 characters')
    .max(72, 'Password must be at most 72 characters'),
});

const loginSchema = z.object({
  email,
  password: z.string({ error: 'Password is required' }).min(1, 'Password is required'),
});

module.exports = { registerSchema, loginSchema };

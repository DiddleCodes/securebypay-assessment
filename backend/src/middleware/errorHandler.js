const { ZodError } = require('zod');
const { Prisma } = require('@prisma/client');
const HttpError = require('../lib/httpError');
const { env } = require('../config');

function formatZodErrors(error) {
  const errors = {};
  for (const issue of error.issues) {
    const field = issue.path.join('.') || 'body';
    errors[field] ??= issue.message;
  }
  return errors;
}

function notFound(req, res) {
  res.status(404).json({ message: `Route ${req.method} ${req.originalUrl} not found` });
}

function errorHandler(err, req, res, next) {
  if (err instanceof HttpError) {
    return res.status(err.status).json({ message: err.message, errors: err.errors });
  }

  if (err instanceof ZodError) {
    return res.status(400).json({ message: 'Validation failed', errors: formatZodErrors(err) });
  }

  if (err.type === 'entity.parse.failed') {
    return res.status(400).json({ message: 'Malformed JSON body' });
  }

  if (err instanceof Prisma.PrismaClientKnownRequestError && err.code === 'P2002') {
    return res.status(409).json({ message: 'Resource already exists' });
  }

  console.error(err);
  const body = { message: 'Something went wrong' };
  if (env !== 'production') body.stack = err.stack;
  res.status(500).json(body);
}

module.exports = { notFound, errorHandler };

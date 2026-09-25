const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const routes = require('./routes');
const { notFound, errorHandler } = require('./middleware/errorHandler');
const { env, corsOrigins } = require('./config');

const app = express();

app.set('trust proxy', 1);

app.use(helmet());
app.use(cors({ origin: corsOrigins }));
if (env !== 'test') {
  app.use(morgan(env === 'production' ? 'combined' : 'dev'));
}
app.use(express.json({ limit: '10kb' }));

app.use('/api', routes);
app.use(notFound);
app.use(errorHandler);

module.exports = app;

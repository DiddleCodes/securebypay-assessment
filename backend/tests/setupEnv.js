require('dotenv').config({ quiet: true });

if (!process.env.TEST_DATABASE_URL) {
  throw new Error('TEST_DATABASE_URL must be set to run tests (the suite wipes that database)');
}
process.env.DATABASE_URL = process.env.TEST_DATABASE_URL;

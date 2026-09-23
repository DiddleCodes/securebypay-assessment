# Backend

Express + Prisma + PostgreSQL API.

## Setup

Requires Node 20+ and a PostgreSQL database.

```bash
npm install
cp .env.example .env        # then fill in DATABASE_URL and JWT_SECRET
npx prisma migrate dev      # creates tables and generates the client
npm run seed                # demo account and chart data
npm run dev                 # http://localhost:4000/api
```

The seed is idempotent: rerunning it resets the demo account (`demo@securebypay.test` / `Demo@1234`) and the growth chart data. Dates are relative to the day it runs.

## Tests

Tests run against the database in `TEST_DATABASE_URL`, which is migrated automatically and wiped by the suite. Never point it at real data.

```bash
npm test
```

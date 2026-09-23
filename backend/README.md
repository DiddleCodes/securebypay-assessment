# Backend

Express + Prisma + PostgreSQL API.

## Setup

Requires Node 20+ and a PostgreSQL database.

```bash
npm install
cp .env.example .env        # then fill in DATABASE_URL and JWT_SECRET
npx prisma migrate dev      # creates tables and generates the client
npm run dev                 # http://localhost:4000/api
```

## Tests

Tests run against the database in `TEST_DATABASE_URL`, which is migrated automatically and wiped by the suite. Never point it at real data.

```bash
npm test
```

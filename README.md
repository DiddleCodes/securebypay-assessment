# Myafrimall Dashboard

My submission for the SecureByPay Full Stack Developer assessment: the Myafrimall sign in, sign up and dashboard screens built from the Figma design in Flutter Web, backed by a Node.js/Express API with PostgreSQL.

- **Live demo:** _link added once deployed_
- **API:** _link added once deployed_ (health check at `/api/health`)
- **Demo account:** `demo@securebypay.test` / `Demo@1234`

The API runs on Render's free tier, so if it has been idle the first request can take up to a minute while it wakes up. After that it's quick.

You can also register a new account. New accounts start with a zero balance and a few sample shipments, so the dashboard has something to show; use Fund Wallet to top up and try paying for a shipment.

## What works

- Register, log in and stay logged in across reloads. Protected routes redirect to the login page, and a 401 from any request signs you out.
- Dashboard with live data: wallet balance, shipment totals for this month, last month or this year (with change against the previous period), the company growth chart by year, month or week, and recent shipments.
- Fund the wallet, pay for a shipment from the wallet balance, view shipment details, and load the full shipment history page by page.
- Loading, error and retry states for each section.
- Layouts for desktop, tablet and mobile.

## Tech stack

**Backend:** Node.js, Express 5, Prisma 6, PostgreSQL (Neon in production), zod, jsonwebtoken, bcryptjs, helmet, cors, express-rate-limit, morgan. Jest and supertest for tests.

Express 5 forwards errors from async route handlers to the error handler without any wrapper, which keeps the controllers small. Prisma gives typed queries and proper migrations, and zod handles validation with readable error messages that map straight onto form fields. I pinned Prisma 6 because Prisma 7 and later need driver adapters and a TypeScript config file, which doesn't fit a plain CommonJS project.

**Frontend:** Flutter Web, go_router, flutter_riverpod, dio, shared_preferences, fl_chart, intl, and the Lucide icon font.

go_router handles URL-based routing with auth redirects, so deep links like `/dashboard` work after a reload. Riverpod keeps the data for each section (overview, chart, shipments) in its own provider, so each one loads, fails and retries independently. DM Sans and Montserrat are bundled with the app rather than fetched at runtime.

## Project structure

```
backend/
  prisma/          schema, migrations, seed script
  src/             routes -> controllers -> services, plus middleware and validators
  tests/           auth and wallet tests
frontend/
  lib/core/        theme tokens, network client, shared widgets, utilities
  lib/features/    auth and dashboard (data, providers, screens, widgets)
render.yaml        Render service definition for the API
```

## Running locally

You'll need Node 20+, PostgreSQL and Flutter 3.47+ (stable).

**Backend**

```bash
cd backend
npm install
cp .env.example .env         # set DATABASE_URL and JWT_SECRET
npx prisma migrate dev       # creates the tables
npm run seed                 # demo account and chart data
npm run dev                  # http://localhost:4000/api
```

To run the tests, set `TEST_DATABASE_URL` to a separate database (the test suite wipes it) and run `npm test`.

**Frontend**

```bash
cd frontend
flutter pub get
flutter run -d chrome --web-port 5050
```

The app calls `http://localhost:4000/api` by default. If your API runs somewhere else, pass `--dart-define=API_URL=http://localhost:<port>/api`. Keep the web port in line with `CORS_ORIGIN` in the backend `.env`.

## Environment variables

| Variable | Used for | Example |
|---|---|---|
| `DATABASE_URL` | PostgreSQL connection string | `postgresql://user:pass@host:5432/db?sslmode=require` |
| `JWT_SECRET` | Signing access tokens. Use a long random string. | `openssl rand -hex 32` |
| `JWT_EXPIRES_IN` | Token lifetime | `7d` |
| `CORS_ORIGIN` | Allowed frontend origin(s), comma-separated | `https://myafrimall.netlify.app` |
| `PORT` | API port (Render sets this itself) | `4000` |
| `TEST_DATABASE_URL` | Database for the test suite only | `postgresql://.../securebypay_test` |
| `NODE_ENV` | `production` on Render, hides error details | `production` |

The frontend has one build-time setting, `API_URL`, passed with `--dart-define`.

## API

All routes are under `/api` and return JSON. Authenticated routes expect `Authorization: Bearer <token>`. Errors come back as `{ message, errors? }`, where `errors` maps field names to messages.

All amounts are in kobo, so N3,000 is `300000`.

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/health` | | Health check |
| POST | `/auth/register` | | Create an account. Returns `201` with `{ token, user }` |
| POST | `/auth/login` | | Log in. Returns `{ token, user }` |
| GET | `/auth/me` | Yes | Current user |
| GET | `/dashboard/overview?period=this_month\|last_month\|this_year` | Yes | Wallet balance, total shipments, exports and imports, each with the previous period's count and % change |
| GET | `/dashboard/growth?range=year\|month\|week` | Yes | Chart points: 12 months, the last 30 days, or the last 7 days |
| GET | `/shipments?page=1&limit=10` | Yes | Your shipments, newest first, paginated |
| GET | `/shipments/:trackingId` | Yes | One shipment |
| POST | `/shipments/:trackingId/pay` | Yes | Pay from the wallet. `400` if the balance is too low or it's already paid |
| POST | `/wallet/fund` | Yes | `{ amount }` in kobo. Credits the wallet and records a transaction |

Status codes: `400` validation, `401` bad credentials or missing token, `404` not found, `409` email already registered. Register and login are rate limited to 20 attempts per 15 minutes.

## Deployment

**Database (Neon):** create a project and copy the connection string. Use the direct connection, not the pooled one; Prisma migrations need a direct connection.

**API (Render):** create a Blueprint from this repo (it picks up `render.yaml`), or a Web Service with these settings:

- Root directory: `backend`
- Build command: `npm install && npx prisma generate && npx prisma migrate deploy`
- Start command: `node src/server.js`
- Health check path: `/api/health`
- Environment: `NODE_ENV=production`, `DATABASE_URL`, `JWT_SECRET`, `JWT_EXPIRES_IN=7d`, `CORS_ORIGIN` (the Netlify URL)

Then seed the production database once from your machine:

```bash
cd backend
DATABASE_URL="<neon connection string>" npm run seed
```

**Frontend (Netlify):**

```bash
cd frontend
flutter build web --release --dart-define=API_URL=https://<render-service>.onrender.com/api
```

Deploy the `build/web` folder, either by dragging it onto [app.netlify.com/drop](https://app.netlify.com/drop) or with `npx netlify-cli deploy --prod --dir build/web`. `web/_redirects` is copied into the build, so deep links fall back to `index.html`.

## Decisions and trade-offs

- **Only the desktop layout was designed.** At 1440px the screens follow the Figma frames closely; I checked them against the exported frames at the same size. For tablet and mobile I adapted the layout: the auth panel is hidden, the sidebar becomes a drawer, cards stack, and shipment fields wrap into two columns. Everything works from 360px up.
- **Money is stored as integers in kobo** and only formatted on the frontend, to avoid floating point errors. The wallet balance column is a 32-bit integer, which caps a balance at about N21 million; top-ups are capped at N1 million and can't push a balance past that limit.
- **Paying for a shipment is atomic.** The balance check and the debit happen in one conditional update inside a transaction, so two quick clicks can't pay twice or overdraw the wallet.
- **Forgot password is out of scope.** The link shows a message saying so, as do the privacy policy and terms links.
- **Only the dashboard was designed**, so the other sidebar items (Shipments, Wallet and so on) open a simple "coming soon" page inside the same layout.
- **Chart axis labels.** The design numbers the months 1 to 12. The chart shows the last 12 months ending with the current one, so I label them with month names instead.
- **The dashboard header** reads "Invite & Earn" with the saved-addresses subtitle, exactly as in the design.
- **Period boundaries** (this month, last month and so on) are calculated in UTC.
- **Delivered and Pending statuses** don't appear in the design, so I picked badge colours from the existing palette.
- **Icons.** I reference the Lucide icon font directly for the icons the app uses, instead of importing the package's icon class. That class is large enough to crash Flutter's debug web compiler.
- **Tests** cover the backend auth, wallet and payment flows. I tested the frontend by hand and with browser screenshots at several screen sizes, and didn't write Flutter widget tests in the time available.

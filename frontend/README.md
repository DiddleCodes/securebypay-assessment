# Frontend

Flutter Web app for the Myafrimall dashboard.

## Setup

Requires Flutter 3.47+ (stable). Start the backend first (see `../backend/README.md`).

```bash
flutter pub get
flutter run -d chrome --web-port 5050
```

The app calls `http://localhost:4000/api` by default. If the API runs elsewhere, add `--dart-define=API_URL=http://localhost:<port>/api`. The web port must match `CORS_ORIGIN` in the backend `.env`.

## Release build

```bash
flutter build web --release --dart-define=API_URL=https://<your-api-host>/api
```

The output in `build/web` is a static site. Serve it with a fallback to `index.html` so deep links like `/dashboard` work.

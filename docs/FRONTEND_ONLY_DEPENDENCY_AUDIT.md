# Frontend-only dependency audit

AstroSaathi runs with `AppConfig.frontendOnly == true`. No application route
requires a backend server, Firebase, Google Sign-In, Razorpay, AdMob, remote
geocoding, or an HTTP astrology provider.

## Runtime dependency map

- **Home / Calendar / Panchang / Muhurat / Kundli / Horoscope** → Riverpod
  astrology providers → `DemoAstrologyEngine` → local deterministic/sample
  data.
- **Ask AstroSaathi** → `AstroBabaNotifier` → `DemoAstrologyEngine` → clearly
  labelled local demo response; history remains in `SharedPreferences`.
- **Synastry / Numerology** → local saved profiles → local enrichment and
  numerology calculations.
- **Onboarding / Profile / Language / selected profile** → local Riverpod
  notifiers → `SharedPreferences`.
- **Authentication screen** → `AuthRepository` → local demo session in
  `SharedPreferences`.
- **Reports** → existing local catalog and report generation.
- **Subscription / paywall** → local subscription notifier and demo payment
  compatibility facade. No transaction or external checkout occurs.
- **Former ad slot** → static local demo/premium preview card.

## Removed runtime packages

- `http`
- `firebase_core`
- `firebase_auth`
- `google_sign_in`
- `razorpay_flutter`
- `google_mobile_ads`
- `geocoding`

## Retained optional external actions

`url_launcher` remains for user-initiated support, policy, store, email and
sharing links. These actions are optional and are not required to launch,
navigate, render, or use the demo application offline.

The NestJS `api/` source tree is retained as separate reference/source history,
but Flutter has no import, URL, client, or runtime dependency on it.

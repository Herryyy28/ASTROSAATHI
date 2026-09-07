# AstroSaathi 🌌

AstroSaathi is a premium, AI-powered astrology application that blends deterministic Vedic/Western astrological math with generative AI to provide deeply personalized daily insights, birth charts, and game plans for users.

This project is built using a modern full-stack architecture:
- **Frontend**: Flutter (Cross-platform Mobile & Web)
- **Backend**: NestJS (TypeScript, Node.js)
- **Database**: PostgreSQL (Production) / SQLite (Development) using TypeORM
- **AI Integration**: OpenAI & Gemini for personalized interpretations
- **Astrology Engine**: Astronomy Engine (Swiss Ephemeris equivalent) & AstrologyAPI.com integration
- **Message Queue**: Redis (BullMQ for background data pre-calculation)

## 📁 Project Structure

The repository is structured as a monorepo containing both the NestJS API and the Flutter application. 

```text
ASTROSAATHI/
├── api/                    # NestJS Backend Application
│   ├── src/
│   │   ├── ai/             # Generative AI (OpenAI) & RAG logic
│   │   ├── astrology/      # Astrology domain module
│   │   │   ├── dto/        # Canonical request/response models
│   │   │   ├── engines/    # Deterministic math (muhurat, game plan, rules)
│   │   │   ├── interfaces/ # Provider and kundli contracts
│   │   │   ├── processors/ # BullMQ job processors
│   │   │   ├── providers/  # AstrologyAPI / local / mock data providers
│   │   │   ├── services/   # Supporting services + their specs
│   │   │   └── validators/ # Kundli data validation
│   │   ├── auth/           # JWT and Firebase Authentication
│   │   ├── core/           # Cross-module services (time, location, monitoring)
│   │   ├── database/       # TypeORM entities, seeds, blockchain audit
│   │   ├── notifications/  # BullMQ workers and FCM Push Notifications
│   │   ├── payments/       # Razorpay subscription flow
│   │   └── users/          # User and Profile management
│   ├── db/                 # SQL exports and local database fixtures
│   ├── .env.example        # Template for api/.env (never commit the real one)
│   └── package.json
│
├── lib/                    # Flutter Frontend Application
│   ├── core/               # Shared across two or more features
│   │   ├── config/         # App-wide configuration
│   │   ├── engine/         # Astrology API client, local engine + models
│   │   ├── providers/      # Riverpod state management
│   │   ├── routing/        # go_router configuration
│   │   ├── services/       # Firebase, notifications, payments, storage
│   │   ├── theme/          # Cosmic Glassmorphism design system
│   │   ├── utils/          # Pure helpers (responsive, zodiac)
│   │   └── widgets/        # Shared UI components (GlassCard, etc.)
│   ├── features/           # One folder per feature (ai, horoscope, kundli, ...)
│   │   └── <feature>/
│   │       ├── data/       # Repositories, models, caching
│   │       ├── providers/  # Feature-scoped Riverpod providers
│   │       └── presentation/
│   │           ├── screens/
│   │           └── widgets/
│   ├── l10n/               # Languages and translation tables
│   └── main.dart           # App entrypoint
│
├── test/                   # Flutter tests, mirroring lib/ (core/, features/)
├── tool/                   # Developer scripts run with `dart run tool/...`
├── docs/                   # PRD, TRD, architecture and structure guides
├── assets/                 # Images and icons bundled by pubspec.yaml
├── android/ ios/ web/ linux/ macos/ windows/   # Platform runners
├── pubspec.yaml            # Flutter dependencies
└── README.md               # This file
```

For the rules on where a new file belongs, see [docs/PROJECT_STRUCTURE.md](docs/PROJECT_STRUCTURE.md)
and [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## 🛠️ Architecture Overview

### Frontend (Flutter)
- **State Management**: `flutter_riverpod` for reactive data flow.
- **Routing**: `go_router` for deep linking support.
- **Animations**: `flutter_animate` for high-quality cosmic micro-interactions.
- **Rendering**: Custom Canvas painters for complex Astrological charts.

### Backend (NestJS)
- **Modularity**: Isolated domain modules follow Feature-First architecture.
- **Engines**: Deterministic math via `astronomy-engine` and third-party API integration for high-accuracy ephemeris data.
- **Optimization**: Nightly background jobs via `BullMQ` pre-calculate daily horoscopes and "Game Plans" to minimize morning API latency.
- **Storage**: Hybrid TypeORM setup supporting both local SQLite for rapid development and PostgreSQL for production.

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.13+)
- [Node.js](https://nodejs.org/) (v18+)
- [Docker](https://www.docker.com/) (For running Postgres/Redis locally)

### Running the Backend
```bash
cd api
npm install
# Ensure Postgres and Redis are running (e.g. via docker-compose)
npm run start:dev
```

### Running the Frontend
```bash
flutter pub get
flutter run -d chrome  # Or select an iOS/Android emulator
```

### Running the Tests
```bash
flutter test          # Flutter widget and unit tests in test/
cd api && npm test    # NestJS specs (*.spec.ts) next to the code they cover
```

## 🧑‍💻 Contributing
When creating a new feature, please adhere to the domain-driven folder structure. UI components specific to a feature belong in `lib/features/{feature_name}/presentation/`, while globally shared UI components belong in `lib/core/widgets/`. See [CONTRIBUTING.md](CONTRIBUTING.md) for the full checklist.

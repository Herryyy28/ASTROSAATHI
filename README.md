# AstroSaathi 🌌

AstroSaathi is a premium, AI-powered astrology application that blends deterministic Vedic/Western astrological math with generative AI to provide deeply personalized daily insights, birth charts, and game plans for users.

This project is built using a modern full-stack architecture:
- **Frontend**: Flutter (Cross-platform Mobile & Web)
- **Backend**: NestJS (TypeScript, Node.js)
- **Database**: PostgreSQL (Prisma ORM)
- **Message Queue**: Redis (BullMQ for background jobs)

## 📁 Project Structure

The repository is structured as a monorepo containing both the backend API and the Flutter application. 

```text
ASTROSAATHI/
├── api/                  # NestJS Backend Application
│   ├── src/
│   │   ├── ai/           # Generative AI integration (Gemini/OpenAI)
│   │   ├── astrology/    # Core deterministic math engine (Swiss Ephemeris/Rules)
│   │   ├── auth/         # JWT and Firebase Authentication guards
│   │   ├── core/         # Shared utilities (Time, Location, etc.)
│   │   ├── database/     # Prisma client and Postgres connections
│   │   ├── notifications/# Background CRON jobs and FCM Push Notifications
│   │   └── users/        # User profile and preferences management
│   └── package.json
│
├── lib/                  # Flutter Frontend Application
│   ├── core/
│   │   ├── engine/       # Local representations of backend data models
│   │   ├── providers/    # Riverpod state management providers
│   │   ├── theme/        # Cosmic Glassmorphism design system (Colors, Animations)
│   │   └── widgets/      # Reusable UI components (GlassCard, ZodiacIcon, etc.)
│   └── features/
│       ├── ai/           # "Ask Astro Baba" conversational interface
│       ├── astrology/    # Visual Birth Chart (Kundli) canvas painters
│       ├── auth/         # Onboarding and login screens
│       ├── home/         # Daily Dashboard and Energy Scores
│       ├── horoscope/    # Daily/Weekly/Monthly Zodiac forecasts
│       └── panchang/     # Daily Hindu calendar and planetary times
│
├── pubspec.yaml          # Flutter dependencies
└── README.md             # This file
```

## 🛠️ Architecture Overview

### Frontend (Flutter)
- **State Management**: We use `flutter_riverpod` for robust, reactive state management and dependency injection.
- **Routing**: Handled by `go_router` for deep linking and declarative navigation.
- **Design System**: A custom "Cosmic Glassmorphism" UI system. It utilizes `flutter_animate` for rich micro-interactions and custom `BackdropFilter` implementations for frosted glass effects.

### Backend (NestJS)
- **Domain-Driven Design**: The backend is split into isolated modules (`ai`, `astrology`, `users`).
- **Astrology Engine**: Uses a rule-based engine (`astrology-rule.engine.ts`, `muhurat.engine.ts`) to calculate deterministic scores for Career, Love, and Health based on current planetary transits against the user's natal chart.
- **Background Jobs**: A nightly CRON job utilizes `BullMQ` (Redis) to pre-calculate the "Daily Game Plan" for all users at midnight, preventing database strain during peak morning hours.

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

## 🧑‍💻 Contributing
When creating a new feature, please adhere to the domain-driven folder structure. UI components specific to a feature belong in `lib/features/{feature_name}/presentation/`, while globally shared UI components belong in `lib/core/widgets/`.

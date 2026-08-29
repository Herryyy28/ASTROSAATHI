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
├── api/                  # NestJS Backend Application
│   ├── src/
│   │   ├── ai/           # Generative AI (OpenAI) & RAG logic
│   │   ├── astrology/    # Core engines, Muhurat, and Panchang logic
│   │   ├── auth/         # JWT and Firebase Authentication
│   │   ├── database/     # TypeORM entities and migrations (Postgres/SQLite)
│   │   ├── notifications/# BullMQ workers and FCM Push Notifications
│   │   └── users/        # User and Profile management
│   └── package.json
│
├── lib/                  # Flutter Frontend Application
│   ├── core/
│   │   ├── engine/       # API client and local data processing
│   │   ├── providers/    # Riverpod state management
│   │   ├── theme/        # Cosmic Glassmorphism design system
│   │   └── widgets/      # Shared UI components (GlassCard, etc.)
│   └── features/
│       ├── ai/           # "Ask Astro Baba" AI Chat
│       ├── astrology/    # Birth Chart (Kundli) rendering
│       ├── horoscope/    # Daily/Weekly forecasts
│       ├── matching/     # Kundli Matching (Gun Milan)
│       ├── panchang/     # Vedic Calendar & planetary transits
│       ├── remedies/     # Personalized astrological suggestions
│       └── onboarding/   # User registration and birth detail entry
│
├── pubspec.yaml          # Flutter dependencies
└── README.md             # This file
```

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

## 🧑‍💻 Contributing
When creating a new feature, please adhere to the domain-driven folder structure. UI components specific to a feature belong in `lib/features/{feature_name}/presentation/`, while globally shared UI components belong in `lib/core/widgets/`.

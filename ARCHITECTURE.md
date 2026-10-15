# AstroSaathi Architecture Guidelines

This document serves as a deep dive into the architecture of AstroSaathi for developers joining the project. 

## 1. Current Runtime Mode
AstroSaathi currently runs as a frontend-only offline demo. The Flutter client in `lib/` uses local deterministic engines and SharedPreferences. The standalone `api/` source remains in the repository for reference but is not connected to the Flutter runtime.

## 2. Flutter Architecture (Frontend)

We follow a **Feature-First Domain-Driven Design** pattern for the Flutter application. 

### Folder Structure Rule
Every distinct feature of the app gets its own folder inside `lib/features/`. A feature folder should be entirely self-contained. 

Example: `lib/features/horoscope/`
- `/data/`: API repositories, DTOs, and local caching logic.
- `/domain/`: Business logic, entities, and Riverpod StateNotifiers.
- `/presentation/`: UI components, Screens, and Widgets specific only to this feature.

### Global vs Feature Widgets
- If a UI component (like the glowing `GlassCard` or the `ZodiacIcon`) is used across *multiple* features (e.g. Onboarding, Home, and Horoscope), it MUST be placed in `lib/core/widgets/`. 
- If a UI component (like `VedicChartPainter`) is only used for the Birth Chart feature, it stays in `lib/features/astrology/presentation/widgets/`.

### State Management
We strictly use **Riverpod** (`flutter_riverpod`).
- Avoid `StatefulWidget` for complex data fetching. Use `FutureProvider` instead.
- Use `ConsumerWidget` to listen to state changes. 

---

## 3. Standalone NestJS Source (Inactive)

The retained NestJS source follows the standard Nest modular architecture, but it is not a production dependency of the current frontend-only build.

### Data Flow
1. **Controller**: Handles incoming HTTP requests and JWT validation. No business logic allowed here.
2. **Service**: Contains the core business logic.
3. **Engine/Processor**: For highly complex, deterministic math (like the Astrology rules), we separate logic from Services into "Engines" (`muhurat.engine.ts`).

### Background Processing (BullMQ)
Astrology math is expensive. Calculating the personalized "Game Plan" for 100,000 users at exactly 6:00 AM would crash the database. 
- We use **BullMQ** (Redis) to queue jobs.
- The `CronService` triggers at midnight, pushing 100,000 jobs to the queue.
- Background worker threads process these queues slowly over the night, saving the pre-calculated JSON to Postgres so the frontend can fetch it instantly via a simple `GET` request in the morning.

## 4. UI / UX Standards
- **Lovable light system**: The primary experience uses the fixed light lavender palette in `AppColors`, white rounded cards, restrained shadows, serif display headings, and 150–300 ms transitions.
- **Primary shell**: Home, Calendar, Ask, Reports, and Profile are hosted in an `IndexedStack` and share `AstroBottomNav`.
- **Shared components**: New primary UI work should use the `Astro*` widgets in `lib/core/widgets/astro_components.dart`.
- **Behavior separation**: Presentation code may be replaced without changing Riverpod providers, engines, repositories, API contracts, authentication, persistence, or payment services.

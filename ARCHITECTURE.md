# AstroSaathi Architecture Guidelines

This document serves as a deep dive into the architecture of AstroSaathi for developers joining the project. 

## 1. Monorepo Philosophy
AstroSaathi is built as a logical monorepo. Both the client (`lib/`) and the server (`api/`) live in the same repository. This ensures that frontend data models and backend DTOs (Data Transfer Objects) stay in sync during active development.

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

## 3. NestJS Architecture (Backend)

The NestJS backend strictly follows the standard Nest modular architecture.

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
- **Cosmic Glassmorphism**: The app relies heavily on dark backgrounds (`AppColors.cosmicGradient`) with frosted, semi-transparent glass cards (`BackdropFilter`).
- **Animations**: DO NOT use basic state changes. If a user clicks a button, or a list loads, use `flutter_animate` to fade, slide, or shimmer the elements. The app must feel like magic.

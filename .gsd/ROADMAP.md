# ASTROSAATHI GSD Roadmap

## Wave 0 — Baseline & Cleanup
*   **Objective:** Establish the foundation for the GSD workflow and ensure the project builds without errors.
*   **Tasks:**
    *   Create missing `.gsd/SPEC.md`.
    *   Run `flutter analyze` and resolve all current warnings.
    *   Run `flutter test` and ensure existing 5 tests pass.
*   **Affected Areas:** `.gsd/`, `lib/`, `test/`
*   **Dependencies:** None
*   **Priority:** P0 — Blocking
*   **Validation Requirements:** `flutter analyze` must return 0 issues. `flutter test` must pass all existing tests.
*   **Acceptance Criteria:** A clean working tree with a fully functioning build and test pipeline.

## Wave 1 — Foundation & Architecture
*   **Objective:** Solidify the Riverpod state management and NestJS backend integration.
*   **Tasks:**
    *   Setup Mock API Repositories in `lib/core/services/` to decouple Flutter from NestJS during development.
    *   Define core data models/DTOs for API communication.
*   **Affected Areas:** `lib/core/`, `api/src/`
*   **Dependencies:** Wave 0
*   **Priority:** P1 — Critical
*   **Validation Requirements:** API connection tests (or mock tests).
*   **Acceptance Criteria:** Flutter app can reliably mock or hit the backend for basic connectivity.

## Wave 2 — Authentication & User Foundation
*   **Objective:** Secure user access and profile management.
*   **Tasks:**
    *   Implement and validate `auth` (Firebase Auth / Google Sign In).
    *   Implement `onboarding` and `splash` flows.
    *   Implement `profile` and `security` features.
*   **Affected Areas:** `lib/features/auth/`, `lib/features/onboarding/`, `lib/features/splash/`, `lib/features/profile/`, `lib/features/security/`
*   **Dependencies:** Wave 1
*   **Priority:** P1 — Critical
*   **Validation Requirements:** Successful login, logout, and profile creation workflows.
*   **Acceptance Criteria:** A user can create an account, log in, and view their profile.

## Wave 3 — Astrology Core
*   **Objective:** Core astrological calculations and chart generation.
*   **Tasks:**
    *   Implement `astrology` engine integration.
    *   Implement `kundli` generation and visualization (VedicChartPainter).
    *   Implement `horoscope` logic.
*   **Affected Areas:** `lib/features/astrology/`, `lib/features/kundli/`, `lib/features/horoscope/`, `api/src/` (BullMQ jobs)
*   **Dependencies:** Wave 2
*   **Priority:** P1 — Critical
*   **Validation Requirements:** Verify astrological math against known test cases (e.g., `astrology_accuracy_test.dart`).
*   **Acceptance Criteria:** Accurate generation of a user's Kundli and daily horoscope.

## Wave 4 — Panchang / Muhurat / Predictions
*   **Objective:** Daily utility features for Hindu calendar.
*   **Tasks:**
    *   Implement `panchang` and `muhurat`.
    *   Implement `reports`.
*   **Affected Areas:** `lib/features/panchang/`, `lib/features/muhurat/`, `lib/features/reports/`
*   **Dependencies:** Wave 3
*   **Priority:** P2 — Important
*   **Validation Requirements:** UI rendering of daily timings correctly matching backend outputs.
*   **Acceptance Criteria:** Accurate display of daily Panchang and Muhurat timings.

## Wave 5 — Compatibility & Advanced Astrology
*   **Objective:** Advanced astrological insights and matchmaking.
*   **Tasks:**
    *   Implement `matching` (Ashtakoota Guna Milap).
    *   Implement `divination` and `remedies`.
*   **Affected Areas:** `lib/features/matching/`, `lib/features/divination/`, `lib/features/remedies/`
*   **Dependencies:** Wave 3
*   **Priority:** P2 — Important
*   **Validation Requirements:** 36-points match calculation accuracy tests.
*   **Acceptance Criteria:** Two profiles can be matched with a detailed Guna score.

## Wave 6 — Premium & Monetization
*   **Objective:** Monetization and expert access.
*   **Tasks:**
    *   Implement `consult` (Call/Chat with Astrologers).
    *   Implement `ai` (Talk to Kundli AI / AI Astrologers).
    *   Implement `subscription` and `workspace` features.
*   **Affected Areas:** `lib/features/consult/`, `lib/features/ai/`, `lib/features/subscription/`, `lib/features/workspace/`
*   **Dependencies:** Wave 2, Wave 3
*   **Priority:** P1 — Critical (Business goal)
*   **Validation Requirements:** Payment gateway tests (Razorpay/In-App Purchases).
*   **Acceptance Criteria:** Users can subscribe and initiate a consultation (AI or Human).

## Wave 7 — Notifications & Supporting Features
*   **Objective:** Engagement and retention loops.
*   **Tasks:**
    *   Implement `reminders`, `search`, `explore`, and `family` (managing multiple profiles).
*   **Affected Areas:** `lib/features/reminders/`, `lib/features/search/`, `lib/features/explore/`, `lib/features/family/`
*   **Dependencies:** Wave 2
*   **Priority:** P3 — Improvement
*   **Validation Requirements:** Local/Push notification delivery.
*   **Acceptance Criteria:** Users can set and receive astrological reminders.

## Wave 8 — UI/UX Premium Polish
*   **Objective:** Elevate the app to "Cosmic Glassmorphism" standards.
*   **Tasks:**
    *   Audit all screens to ensure use of `flutter_animate`.
    *   Standardize `lib/core/widgets/`.
*   **Affected Areas:** All `lib/features/*/presentation/` folders, `lib/core/widgets/`
*   **Dependencies:** Waves 2-7
*   **Priority:** P2 — Important
*   **Validation Requirements:** Visual inspection via screenshots.
*   **Acceptance Criteria:** The app strictly follows the ARCHITECTURE.md UI guidelines.

## Wave 9 — Testing & Reliability
*   **Objective:** Increase test coverage significantly.
*   **Tasks:**
    *   Write Widget and Unit tests for all major features (aiming for coverage > 80%).
*   **Affected Areas:** `test/`
*   **Dependencies:** All previous Waves
*   **Priority:** P1 — Critical
*   **Validation Requirements:** `flutter test --coverage`
*   **Acceptance Criteria:** High test coverage and robust error handling.

## Wave 10 — Production Readiness
*   **Objective:** Prepare for App Store / Play Store release.
*   **Tasks:**
    *   Finalize PDF exports, geocoding edge cases, and perform full release builds.
*   **Affected Areas:** Entire App
*   **Dependencies:** All previous Waves
*   **Priority:** P0 — Blocking (for release)
*   **Validation Requirements:** Successful `flutter build apk --release` and `flutter build ios --release`.
*   **Acceptance Criteria:** Release artifacts generated without errors.

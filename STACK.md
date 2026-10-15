# Technology Stack

## Runtime

- Flutter / Dart 3.12+
- Material 3 with a fixed light theme
- Riverpod 2 for state management
- GoRouter for the four root routes
- Deterministic local demo engines

## Local runtime integrations

- SharedPreferences local persistence
- DemoAstrologyEngine and DemoCalendarEngine
- Offline demo authentication and payment previews
- Bundled location coordinates
- PDF generation and printing

## Frontend structure

- Entry point: `lib/main.dart`
- Root routing: `lib/core/routing/app_router.dart`
- Design tokens: `lib/core/theme/`
- Shared Lovable components: `lib/core/widgets/astro_components.dart`
- Feature screens: `lib/features/*/presentation/screens/`

## Configuration

- Frontend-only mode: `lib/core/config/app_config.dart`
- Profile persistence: `lib/core/providers/profile_provider.dart`
- Calendar derivation: `lib/core/engine/demo_calendar_engine.dart`
- Package and asset declarations: `pubspec.yaml`

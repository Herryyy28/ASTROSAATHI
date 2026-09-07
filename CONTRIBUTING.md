# Contributing to AstroSaathi

## Local setup

```bash
# Backend
cd api
cp .env.example .env        # fill in your own keys; .env is git-ignored
npm ci
docker compose up -d        # Postgres + Redis
npm run start:dev

# Frontend
flutter pub get
flutter run                 # or: flutter run -d chrome
```

## Where do I put my file?

Read [docs/PROJECT_STRUCTURE.md](docs/PROJECT_STRUCTURE.md). The short version:

| I am adding... | It goes in |
| --- | --- |
| A screen for an existing feature | `lib/features/<feature>/presentation/screens/` |
| A widget used by one feature | `lib/features/<feature>/presentation/widgets/` |
| A widget used by several features | `lib/core/widgets/` |
| Riverpod state for one feature | `lib/features/<feature>/providers/` |
| Global Riverpod state | `lib/core/providers/` |
| A pure helper function | `lib/core/utils/` |
| Translations | `lib/l10n/translations/` |
| A Flutter test | `test/` mirroring the `lib/` path |
| A one-off developer script | `tool/` |
| A new backend endpoint | `api/src/<module>/<module>.controller.ts` |
| Backend business logic | `api/src/<module>/<module>.service.ts` or `services/` |
| Framework-free astrology math | `api/src/astrology/engines/` |
| A TypeORM entity | `api/src/database/entities/` |
| A backend test | next to the code as `*.spec.ts` |
| Product/architecture documentation | `docs/` |

## Before you open a PR

```bash
flutter analyze && flutter test
cd api && npm run lint && npm test && npm run build
```

- Keep commits scoped to one concern and use conventional prefixes (`feat:`, `fix:`, `docs:`,
  `refactor:`, `test:`, `chore:`).
- Never commit secrets, `node_modules/`, build output, or local databases — see the ignored-files
  table in [docs/PROJECT_STRUCTURE.md](docs/PROJECT_STRUCTURE.md). If a new secret is required,
  add a placeholder to `api/.env.example`.
- Update [docs/PROJECT_STRUCTURE.md](docs/PROJECT_STRUCTURE.md) whenever you introduce a new
  top-level folder or change a layout convention.

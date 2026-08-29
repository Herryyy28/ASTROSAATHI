# Phase 1 — Truth Layer Implementation Plan

**Goal:** Real calculated astrology data flows from backend → Flutter UI, with unified profiles and no silent mock fallbacks.

## Architecture

```
Onboarding / My Kundlis
        ↓
  Unified Profile Store (SharedPreferences)
        ↓
  activeProfileProvider
        ↓
  ApiAstrologyEngine → NestJS (LocalAstrologyProvider)
        ↓
  Canonical Kundli + Game Plan + Panchang
        ↓
  UI (with timestamps + error/retry states)
```

## Tasks

| # | Task | Files |
|---|------|-------|
| 1 | Persist profiles; remove hardcoded Delhi/Mumbai | `lib/core/providers/profile_provider.dart` |
| 2 | Onboarding writes to unified profile store | `lib/features/onboarding/.../onboarding_screen.dart` |
| 3 | Switch Flutter to `ApiAstrologyEngine` | `lib/core/providers/astrology_provider.dart` |
| 4 | Restore auth sync (best-effort, non-blocking) | `lib/features/auth/data/auth_repository.dart` |
| 5 | Fix horoscope weekly/monthly on backend (mock mode) | `api/src/astrology/astrology.service.ts` |
| 6 | Astro Baba uses active profile | `lib/features/ai/.../astro_baba_provider.dart` |
| 7 | Show Rashi/Nakshatra + calculated-at on Kundli card | `lib/features/astrology/.../birth_chart_card.dart` |
| 8 | Profile change invalidates all astrology providers | `lib/core/providers/astrology_provider.dart` |

## Success Criteria

- [ ] Onboarding birth details appear in Game Plan, Kundli, Panchang
- [ ] Switching primary profile recalculates all data
- [ ] Kundli shows real Lagna, Rashi, 9 Grahas from backend
- [ ] API failure shows error + Retry (no mock fallback)
- [ ] `calculatedAt` visible on birth chart

## Out of Scope (Phase 2+)

- Responsive mobile layouts
- Horoscope depth sections
- Astro Baba OpenAI grounding
- Notifications, History, Trust Center

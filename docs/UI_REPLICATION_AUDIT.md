# AstroSaathi UI Replication Audit

## Root routes

- `/` — primary five-tab shell
- `/splash` — splash
- `/onboarding` — eight-step profile onboarding
- `/auth` — Google/guest login

Feature detail screens continue to use their existing `Navigator` flows.

## Screen inventory found

- Auth/onboarding: Splash, Auth, Onboarding
- Primary: Home, Astro Calendar, Ask AstroSaathi, Predictions/Reports, Profile
- Astrology: Decision Engine, Research, Scenario Simulator, Chart Patterns, Future Event Radar, Numerology, Returns Center, Saturn Return, Transit Center
- Kundli: Kundli, New Kundli Input, Chart Comparison
- Compatibility: Matching
- Horoscope/panchang: Horoscope, Panchang, Monthly Panchang, Muhurat
- Consult: AI Astrologer Call, Chat with Astrologers, Personal Astrologer Chat, Talk to AI Astrologers
- Explore: Explore, Astro Academy, Astrocartography, Future Radar, Personal Timing Engine, Sky Now, Synastry Composite, Year Ahead
- Family/divination: Family Astrology Dashboard, Human Design
- Reports: Predictions Reports, Custom PDF Report Builder
- Remedies/reminders: Remedy Hub, Astro Reminders
- Profile/settings: About, Data Privacy, Saved Insights
- Security/support: Privacy Dashboard, Security Center, Trust Center
- Subscription: Premium Upgrade, Payment Success, Payment Failed
- Search/workspace: Astrology Search, Astro Workspace

## Lovable reference screens inspected

- Welcome/login
- Onboarding steps 1–8
- Home
- Calendar: Today, Month, Moon, Transits
- Ask
- Reports
- Profile

## Visually replicated in this pass

- Fixed light palette and typography hierarchy
- Welcome/login presentation
- Eight-step onboarding presentation and existing profile-save flow
- Home dashboard and real daily game-plan binding
- Calendar Today/Month/Moon/Transits structure
- Ask chat, suggestions, loading state, input, and existing AI provider flow
- Reports cards, lock states, upgrade path, and report discussion flow
- Profile header, grouped rows, existing actions, logout, and account reset
- Bottom navigation: Home, Calendar, Ask, Reports, Profile (Match removed only from primary navigation)

## Functional boundaries preserved

No API URLs, request/response models, Firebase configuration, Google Sign-In implementation, Riverpod providers, repositories, astrology engines, Razorpay/payment logic, application identifiers, signing configuration, or database logic were rewritten.

## Secondary-screen replication pass

### Dedicated reconstructions

- Astrology Research Mode
- Chart Patterns and elemental balance
- Saturn Return Center
- 90-Day Future Radar
- Synastry/Composite result palette and hierarchy
- Custom PDF Report Builder
- Payment Success, Payment Failed, and Payment Processing states
- About AstroSaathi
- Saved Insights empty state
- Language selection sheets
- Location permission dialog
- Search filters and selected states
- Data Privacy actions
- Premium upgrade/paywall light-surface and CTA treatment

### Existing rich screens aligned through shared presentation components

- Horoscope details and daily/weekly/monthly prediction states
- Kundli, birth chart, planet/house detail sheets, and Dasha timeline
- New Kundli/Birth Details input
- Panchang, Monthly Panchang, and Muhurat
- Numerology and result cards
- Matching and Chart Comparison
- Decision Engine, Scenario Simulator, Returns Center, Future Event Radar, and Transit Center
- Family Dashboard and Astro Workspace
- Privacy Dashboard
- Reusable dialogs, bottom sheets, loading, error, and empty states

These routes retain their existing data binding and interaction structure while using the centralized `GlassCard`, `GradientButton`, design tokens, exact palette, and global control themes.

### Inventory items not found as standalone routes/screens

- Credit wallet
- Notification inbox
- Generic history screen
- Standalone edit-profile screen
- Standalone language page (language exists as bottom sheets)
- Standalone Terms or Help screens (Terms is an external link; support is provided from About)
- Standalone planet, house, nakshatra, moon, calendar-event, or report-detail routes (details are embedded in existing feature screens, cards, dialogs, or sheets)

### Responsive verification

Automated widget coverage exercises the shared secondary detail shell and payment result layouts at 360, 390, 412, and 430 logical pixels. The shell constrains readable width, scrolls vertically, respects safe areas, dismisses the keyboard on drag, and avoids fixed phone-width assumptions.

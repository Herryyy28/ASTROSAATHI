# 📄 PRODUCT REQUIREMENTS DOCUMENT (PRD)

**App Name**: ASTROSAATHI  
**Tagline**: Next-Generation Vedic Astrology & Quantitative Cosmic Intelligence Platform  
**Version**: 2.5.0  
**Document Owner**: Product & Engineering Team  
**Date**: September 3, 2026  

---

## 1. 📊 Project Overview
ASTROSAATHI is a flagship cross-platform mobile application built with Flutter that blends ancient **Vedic Astrological Wisdom (Jyotish)** with modern computational precision and AI decision support. The platform provides real-time ephemeris calculations, birth chart analysis (Kundli), Ashtakoota matchmaking, Muhurat timing engines, Dasha lifecycle tracking, and AI-driven personalized insights for users worldwide.

---

## 2. 🎯 Product Vision
To become the world's most trusted, visually stunning, and mathematically precise Vedic astrology platform. ASTROSAATHI empowers users to navigate life decisions—ranging from career transitions and relationships to timing investments—using transparent quantitative algorithms and personalized AI consultations.

---

## 3. 👤 Target User Personas

### Persona A: The Modern Seeker (Age 22–38)
- **Goal**: Daily guidance, Panchang timings, transit alerts, and relationship matchmaking.
- **Pain Point**: Overwhelmed by cluttered, outdated astrology apps with confusing jargon.
- **Needs**: Sleek dark glassmorphism UI, intuitive charts, short actionable advice, and instant AI chat.

### Persona B: Executive & Business Leader (Age 30–55)
- **Goal**: Timing high-stakes decisions (contracts, hiring, property buying, job switches).
- **Pain Point**: Needs quantitative evidence and clear score breakdowns before taking major action.
- **Needs**: Astro Decision Engine, Location Scenario Simulator, and calculation transparency ledgers ("Show Me The Math").

### Persona C: Experienced Vedic Practitioner (Age 35+)
- **Goal**: In-depth research, exact arc-second ephemeris positions, divisional charts (D1–D60), and transit centers.
- **Pain Point**: Standard consumer apps lack precise degrees, ayanamsa controls, and raw coordinate outputs.
- **Needs**: Practitioner Research Mode, Sky Now live ephemeris clock, and custom PDF report builder.

---

## 4. ✨ Core Features

| Feature Module | Description & Capability |
| :--- | :--- |
| **Vedic Birth Chart (Kundli)** | Static D1 Natal & D9 Navamsha charts, planetary degrees, house alignments, and Lagna Explorer. |
| **Astro Decision Engine** | AI + Mathematical score calculator (0.0 to 10.0) evaluating timing windows for career, finance, and contracts. |
| **Ashtakoota Matchmaking** | 36-Guna compatibility scoring with 8-dimension radar chart visualization and Dosh analysis. |
| **Future Event Radar** | 90-Day timeline tracker for major planetary transits, dasha shifts, and benefic aspect windows. |
| **Sky Now & Ephemeris** | Real-time live clock streaming current planetary coordinates down to exact arc-seconds. |
| **Panchang & Muhurat** | Daily Tithi, Nakshatra, Yoga, Karana, Rahu Kaal, and Abhijit Muhurat golden timing windows. |
| **Explore Hub** | Multi-layout Hub featuring Grid View, List View, and Folder View modes with VIP/Free filtering. |
| **VIP Pass Subscription** | Premium feature access, unlimited family Kundlis, custom PDF generation, and priority AI chat. |

---

## 5. 🧮 Screen Inventory

1. `SplashScreen` — Cosmic onboarding entry & theme bootstrap.
2. `AuthScreen` — Phone OTP & OAuth sign-in / registration.
3. `OnboardingScreen` — User profile creation (DOB, TOB, POB search).
4. `HomeScreen` — Daily energy score, Panchang summary, and quick action grid.
5. `KundliScreen` — Interactive birth chart viewer, house details & Lagna analysis.
6. `AstroDecisionEngineScreen` — Real-life decision evaluation with calculation ledger.
7. `FutureEventRadarScreen` — 90-day milestone radar & transit scheduler.
8. `MatchingScreen` — Partner compatibility & 8-dimension Ashtakoota radar.
9. `ChartComparisonScreen` — Dual Kundli synastry overlay.
10. `AstroScenarioSimulatorScreen` — Astrocartography relocation & time shift simulator.
11. `ReturnsCenterScreen` — Solar (Varshphal) & Lunar return forecasting.
12. `SaturnReturnScreen` — 29.5-year maturity cycle calculator.
13. `SkyNowEphemerisScreen` — Live ephemeris coordinates clock.
14. `ExploreScreen` — Categorized tool discovery with Grid/List/Folder layout modes.
15. `RemedyHubScreen` — Gemstone, mantra counter, and ritual guidance.
16. `FamilyAstrologyDashboardScreen` — Family synergy score & group transit overview.
17. `ProfileScreen` — User settings, saved Kundlis, and subscription manager.
18. `SecurityCenterScreen` — Device session manager & biometric lock toggle.
19. `PrivacyDashboardScreen` — Data export, privacy controls & deletion manager.
20. `AstroBabaScreen` — AI Conversational Astrologer Chat Interface.

---

## 6. 🔄 Key User Flows

### Flow 1: Daily Guidance Flow
```
App Launch ➔ HomeScreen ➔ Daily Energy Score ➔ View Shubh Muhurat ➔ Save Event to Calendar
```

### Flow 2: Decision Assistant Flow
```
Explore Hub ➔ Astro Decision Engine ➔ Input Question & Category ➔ View 8.6/10 Score ➔ Inspect "Show Me Math" ➔ Ask AI
```

### Flow 3: Matchmaking Flow
```
Matching Tab ➔ Input Partner Details ➔ Calculate Ashtakoota ➔ View 30.5/36 Score ➔ Inspect 8-Guna Radar ➔ Share Summary
```

---

## 7. 📊 Success Metrics (KPIs)

- **Daily Active Users (DAU) / MAU**: Target DAU/MAU ratio > 45%.
- **30-Day User Retention**: Target > 40% retention rate.
- **Conversion to VIP Pass**: Target 5.5% conversion from free to paid VIP subscribers.
- **Crash-Free Sessions**: Maintain > 99.9% crash-free session rate across Android & iOS.
- **Average Session Duration**: > 6.5 minutes per active user daily.

---

## 8. 🚫 Out of Scope (Phase 1 & 2)

- Live 1-on-1 video call consultations with human astrologers (deferred to Phase 4).
- Offline Bluetooth peer-to-peer chart sharing without internet connection.
- Physical gemstone marketplace & e-commerce delivery logistics.

---

## 9. 🎯 Development Phases & Roadmap

```
Phase 1 (Q1 2026): Core Engine & Ephemeris (Completed)
├── Swiss Ephemeris Integration, D1/D9 Chart Painters, Basic Panchang

Phase 2 (Q2 2026): AI Integration & Decision Tools (Completed)
├── Astro Baba AI Engine, Decision Simulator, Matchmaking Radar, Glassmorphism UI

Phase 3 (Q3 2026): UI Sharpness, Layout Switcher & Redundancy (Current)
├── Zero RenderFlex Overflows, Explore View Switcher, High-Availability HA Infra Setup

Phase 4 (Q4 2026): Live Marketplace & Wearables (Upcoming)
├── Apple Watch / WearOS Complications, Live Astrologer Consultation Portal
```

---

## 10. 🔒 Privacy, Safety & Security

- **Data Encryption**: All birth details, notes, and profile data encrypted at rest (AES-256) and in transit (TLS 1.3).
- **Biometric App Lock**: Fingerprint / FaceID security layer for saved private Kundlis.
- **Data Ownership**: Full data export (JSON/PDF) and 1-click permanent account deletion under GDPR & DPDP compliance.

---

## 11. ✅ Definition of Done (DoD)

- All UI components pass 100% responsiveness without any RenderFlex overflow on viewports down to 320px width.
- Code base compiles cleanly with zero static analyzer warnings.
- Dark mode glassmorphic styling maintains WCAG AA contrast standards.
- All core calculations match planetary ephemeris datasets with < 0.01 arc-second variance.

---

## 12. 🎨 Design System Principles

- **Visual Style**: Sleek Dark Glassmorphism, radial cosmic gradients, ambient glows.
- **Typography**: `GoogleFonts.outfit` for headlines & titles; `GoogleFonts.inter` for body copy.
- **Palette**: Deep Space Black (`#0B0E17`), Cosmic Purple (`#6C5CE7`), Celestial Amber (`#FFD700`), Emerald Success (`#50E3C2`).
- **Card Styling**: Blur backdrop filters (`BackdropFilter(sigmaX: 10, sigmaY: 10)`), subtle 0.8px borders.

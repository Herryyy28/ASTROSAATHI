# Astrology Data Provider Audit

## Classification

- **A — Already available but not exposed:** Ascendant sign, current planetary retrograde flags.
- **B — Calculable locally from existing data:** Elements, modalities, natal aspects, supported chart patterns, synastry cross-aspects/orbs/bi-wheel inputs, Soul Urge, Birthday Number, numerology section interpretations.
- **C — Existing backend data not mapped:** Exact planet degrees, current/weekly planet positions, current Moon sign/degree.
- **D — Backend/API extension required:** Exact AC degree, MC/DC/IC, retrograde station timeline, lifestyle date events, lunar illumination/age and lunation dates.
- **E — Not currently supported:** Lifestyle category event-generation rules and provider-backed section-specific numerology prose beyond deterministic local interpretations.

## Implemented

The Flutter provider layer now normalizes wrapped and canonical birth-chart responses, preserves real degrees and retrograde flags, derives element/modality percentages, detects supported aspects and chart patterns only when exact positions exist, exposes current sky positions through the existing `/astrology/biwheel` endpoint, calculates synastry cross-aspects from two provider-backed charts, and calculates all four core numerology values from saved profile fields.

## Required backend contracts

### Exact chart angles

Extend `GET /astrology/birth-chart` with:

```json
{
  "angles": {
    "ascendant": { "longitude": 123.45, "sign": "Leo", "degree": 3.45 },
    "midheaven": { "longitude": 210.12, "sign": "Scorpio", "degree": 0.12 },
    "descendant": { "longitude": 303.45, "sign": "Aquarius", "degree": 3.45 },
    "imumCoeli": { "longitude": 30.12, "sign": "Taurus", "degree": 0.12 }
  }
}
```

Values must be calculated from the submitted date, exact time, latitude, longitude and timezone. The existing hard-coded `lagna.degree: 0` is not sufficient.

### Retrograde calendar

Add `GET /astrology/retrogrades?from=YYYY-MM-DD&to=YYYY-MM-DD` returning:

```json
{
  "data": [
    {
      "planet": "Mercury",
      "sign": "Scorpio",
      "retrogradeStart": "2026-10-24T00:00:00Z",
      "stationRetrograde": "2026-10-24T00:00:00Z",
      "stationDirect": "2026-11-13T00:00:00Z",
      "directDate": "2026-11-13T00:00:00Z",
      "durationDays": 20
    }
  ]
}
```

### Lifestyle calendar

Add `GET /astrology/lifestyle-calendar?month=YYYY-MM&lat=&lon=&tz=&profileId=` returning date-level events with stable category IDs, labels, semantic indicator keys, start/end times and source/provenance. Legends must be returned or versioned as category metadata; the client must not infer events from colors.

### Lunar details

Extend Panchang or add `GET /astrology/moon?date=&lat=&lon=&tz=` returning phase name, elongation, illumination percentage, lunar age in days, sidereal/tropical sign and degree, next full moon, next new moon, and typed lunar events. Include ISO timestamps and calculation provenance.

### Provider-authored numerology prose

If editorial interpretations are required, add a versioned numerology response containing `corePattern`, `strengths`, `challenges`, `relationships`, `career`, and `growth`, keyed by the calculated numbers and language. The Flutter client currently provides deterministic local summaries only.

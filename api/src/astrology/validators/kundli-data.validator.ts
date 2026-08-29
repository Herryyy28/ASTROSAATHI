import { CanonicalKundli } from '../interfaces/canonical-kundli.interface';

export class KundliDataValidator {
  static validate(kundli: any): CanonicalKundli {
    if (!kundli) {
      throw new Error('Kundli data is empty.');
    }

    if (!kundli.birthDetails || !kundli.birthDetails.date) {
      throw new Error('Birth details (date) missing.');
    }

    if (!kundli.planets || !Array.isArray(kundli.planets)) {
      throw new Error('Planetary data missing or invalid.');
    }

    // Ensure all 9 planets exist
    const requiredPlanets = ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn', 'Rahu', 'Ketu'];
    const planetNames = kundli.planets.map((p: any) => p.name);

    for (const req of requiredPlanets) {
      if (!planetNames.includes(req)) {
        throw new Error(`Planet ${req} is missing from calculations.`);
      }
    }

    if (new Set(planetNames).size !== planetNames.length) {
      throw new Error('Duplicate planets found in chart data.');
    }

    for (const p of kundli.planets) {
      if (!p.rashi || p.degree === undefined || p.house === undefined) {
        throw new Error(`Incomplete data for planet ${p.name}`);
      }
      if (p.house < 1 || p.house > 12) {
        throw new Error(`Invalid house ${p.house} for planet ${p.name}`);
      }
    }

    if (!kundli.rashi || !kundli.rashi.name) {
      throw new Error('Moon sign (Rashi) could not be calculated.');
    }

    return kundli as CanonicalKundli;
  }
}

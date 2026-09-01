import { CanonicalKundli } from '../interfaces/canonical-kundli.interface';

export class KundliDataValidator {
  static validate(kundli: any): CanonicalKundli {
    if (!kundli) {
      throw new Error('Kundli data is empty.');
    }

    if (!kundli.birthDetails || !kundli.birthDetails.date) {
      throw new Error('Birth details (date) missing.');
    }

    // Strict validation for birthDate to prevent future dates
    const birthDate = new Date(kundli.birthDetails.date);
    if (isNaN(birthDate.getTime())) {
      throw new Error('Invalid birth date format.');
    }
    if (birthDate.getTime() > Date.now()) {
      throw new Error('Birth date cannot be in the future.');
    }

    // Strict validation for coordinates
    if (kundli.birthDetails.latitude !== undefined) {
      const lat = parseFloat(kundli.birthDetails.latitude);
      if (isNaN(lat) || lat < -90 || lat > 90) {
        throw new Error('Latitude must be between -90 and 90.');
      }
    }
    
    if (kundli.birthDetails.longitude !== undefined) {
      const lon = parseFloat(kundli.birthDetails.longitude);
      if (isNaN(lon) || lon < -180 || lon > 180) {
        throw new Error('Longitude must be between -180 and 180.');
      }
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

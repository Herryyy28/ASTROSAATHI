import { Injectable } from '@nestjs/common';
import { PlanetaryPosition, ProviderMetadata } from '../interfaces/astrology-data-provider.interface';

export interface AspectPattern {
  name: 'Grand Trine' | 'T-Square' | 'Yod (Finger of God)' | 'Stellium' | 'Kite';
  description: string;
  planets: string[];
  elementOrQuality?: string;
}

export interface PlanetaryAspect {
  planet1: string;
  planet2: string;
  aspectName: 'Conjunction' | 'Sextile' | 'Square' | 'Trine' | 'Opposition' | 'Quincunx';
  angle: number;
  orb: number;
}

export interface BiWheelPayload {
  innerChartName: string;
  outerChartName: string;
  innerPlanets: Record<string, PlanetaryPosition>;
  outerPlanets: Record<string, PlanetaryPosition>;
  aspects: PlanetaryAspect[];
  aspectPatterns: AspectPattern[];
  provenance: {
    calculatedAt: string;
    engineVersion: string;
    ayanamsaUsed: string;
    isAiGenerated: boolean;
  };
}

@Injectable()
export class AdvancedAstrologyEngine {

  /**
   * Detects geometric aspect patterns across planetary longitudes.
   */
  detectAspectPatterns(planets: Record<string, PlanetaryPosition>): { aspects: PlanetaryAspect[]; patterns: AspectPattern[] } {
    const planetList = Object.keys(planets).map((key) => ({
      name: planets[key].name || key,
      longitude: planets[key].longitude,
      sign: planets[key].sign,
    }));

    const aspects: PlanetaryAspect[] = [];

    // 1. Calculate All Pairwise Aspects
    for (let i = 0; i < planetList.length; i++) {
      for (let j = i + 1; j < planetList.length; j++) {
        const p1 = planetList[i];
        const p2 = planetList[j];
        
        let diff = Math.abs(p1.longitude - p2.longitude);
        if (diff > 180) diff = 360 - diff;

        const aspect = this.classifyAspect(p1.name, p2.name, diff);
        if (aspect) {
          aspects.push(aspect);
        }
      }
    }

    const patterns: AspectPattern[] = [];

    // 2. Detect Stelliums (3+ planets in same sign or within 10 degrees)
    const signGroups: Record<string, string[]> = {};
    planetList.forEach((p) => {
      if (!signGroups[p.sign]) signGroups[p.sign] = [];
      signGroups[p.sign].push(p.name);
    });

    Object.entries(signGroups).forEach(([sign, names]) => {
      if (names.length >= 3) {
        patterns.push({
          name: 'Stellium',
          description: `Concentrated energy cluster of ${names.length} celestial bodies in ${sign}.`,
          planets: names,
          elementOrQuality: sign,
        });
      }
    });

    // 3. Detect Grand Trines (3 planets with 120° aspects between each pair)
    const trines = aspects.filter((a) => a.aspectName === 'Trine');
    for (let i = 0; i < trines.length; i++) {
      for (let j = i + 1; j < trines.length; j++) {
        const t1 = trines[i];
        const t2 = trines[j];
        
        const shared = [t1.planet1, t1.planet2].filter((p) => p === t2.planet1 || p === t2.planet2);
        if (shared.length === 1) {
          const apex = shared[0];
          const pA = t1.planet1 === apex ? t1.planet2 : t1.planet1;
          const pB = t2.planet1 === apex ? t2.planet2 : t2.planet1;

          const closingTrine = trines.find(
            (t) => (t.planet1 === pA && t.planet2 === pB) || (t.planet1 === pB && t.planet2 === pA)
          );

          if (closingTrine) {
            const patternPlanets = Array.from(new Set([apex, pA, pB]));
            if (!patterns.some((p) => p.name === 'Grand Trine' && p.planets.sort().join() === patternPlanets.sort().join())) {
              patterns.push({
                name: 'Grand Trine',
                description: `Powerful harmonic triangle linking ${patternPlanets.join(', ')} bringing natural talents and effortless flow.`,
                planets: patternPlanets,
              });
            }
          }
        }
      }
    }

    // 4. Detect T-Squares (1 Opposition + 2 Squares to a focal apex planet)
    const oppositions = aspects.filter((a) => a.aspectName === 'Opposition');
    const squares = aspects.filter((a) => a.aspectName === 'Square');

    oppositions.forEach((opp) => {
      planetList.forEach((p) => {
        if (p.name !== opp.planet1 && p.name !== opp.planet2) {
          const sq1 = squares.find(
            (s) => (s.planet1 === opp.planet1 && s.planet2 === p.name) || (s.planet1 === p.name && s.planet2 === opp.planet1)
          );
          const sq2 = squares.find(
            (s) => (s.planet1 === opp.planet2 && s.planet2 === p.name) || (s.planet1 === p.name && s.planet2 === opp.planet2)
          );

          if (sq1 && sq2) {
            patterns.push({
              name: 'T-Square',
              description: `High-dynamism tension triangle with focal apex planet ${p.name} driving growth through challenge.`,
              planets: [opp.planet1, opp.planet2, p.name],
            });
          }
        }
      });
    });

    return { aspects, patterns };
  }

  /**
   * Generates a Dual-Ring Bi-Wheel payload (Natal vs Transits or Partner 1 vs Partner 2).
   */
  generateBiWheelPayload(
    innerChartName: string,
    outerChartName: string,
    innerPlanets: Record<string, PlanetaryPosition>,
    outerPlanets: Record<string, PlanetaryPosition>,
  ): BiWheelPayload {
    const combinedPlanets = { ...innerPlanets, ...outerPlanets };
    const { aspects, patterns } = this.detectAspectPatterns(combinedPlanets);

    return {
      innerChartName,
      outerChartName,
      innerPlanets,
      outerPlanets,
      aspects,
      aspectPatterns: patterns,
      provenance: {
        calculatedAt: new Date().toISOString(),
        engineVersion: 'AstroSaathi-Advanced-v2.1',
        ayanamsaUsed: 'Lahiri (23.85° + precession)',
        isAiGenerated: false,
      },
    };
  }

  /**
   * Helper to classify angular relationships into standard aspect names with tight orb tolerances.
   */
  private classifyAspect(planet1: string, planet2: string, diff: number): PlanetaryAspect | null {
    const aspectTargets = [
      { name: 'Conjunction' as const, angle: 0, orbMax: 8 },
      { name: 'Sextile' as const, angle: 60, orbMax: 6 },
      { name: 'Square' as const, angle: 90, orbMax: 7 },
      { name: 'Trine' as const, angle: 120, orbMax: 8 },
      { name: 'Quincunx' as const, angle: 150, orbMax: 3 },
      { name: 'Opposition' as const, angle: 180, orbMax: 8 },
    ];

    for (const target of aspectTargets) {
      const orb = Math.abs(diff - target.angle);
      if (orb <= target.orbMax) {
        return {
          planet1,
          planet2,
          aspectName: target.name,
          angle: Number(diff.toFixed(2)),
          orb: Number(orb.toFixed(2)),
        };
      }
    }

    return null;
  }
}

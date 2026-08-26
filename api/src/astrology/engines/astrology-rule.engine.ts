import { Injectable } from '@nestjs/common';
import { PanchangResponse, PlanetaryPosition } from '../interfaces/astrology-data-provider.interface';

export interface RuleResult {
  score: number; // 0 to 10
  doList: string[];
  avoidList: string[];
  categories: {
    Career: number;
    Love: number;
    Money: number;
  };
}

@Injectable()
export class AstrologyRuleEngine {
  
  /**
   * Deterministic calculation based on planetary positions and today's Panchang.
   */
  evaluateDayRules(
    planets: Record<string, PlanetaryPosition>, 
    panchang: PanchangResponse,
    focusWeights: Record<string, number> = { Career: 1.0, Love: 1.0, Money: 1.0 }
  ): RuleResult {
    
    let baseScore = 5.0; // Neutral starting point
    const doList: string[] = [];
    const avoidList: string[] = [];
    
    const categories = {
      Career: 5.0,
      Love: 5.0,
      Money: 5.0,
    };

    // 1. Analyze Moon position (Mind/Emotions)
    const moon = planets['moon'];
    if (moon) {
      if (moon.sign === 'Taurus' || moon.sign === 'Cancer') {
        baseScore += 1.5;
        categories.Love += 2.0;
        doList.push('Focus on nurturing relationships today.');
      } else if (moon.sign === 'Scorpio') {
        baseScore -= 1.0;
        categories.Love -= 1.0;
        avoidList.push('Avoid getting into deep emotional arguments.');
      }
    }

    // 2. Analyze Sun (Career/Ego)
    const sun = planets['sun'];
    if (sun) {
      if (sun.sign === 'Aries' || sun.sign === 'Leo') {
        baseScore += 1.0;
        categories.Career += 2.5;
        doList.push('Take charge of important professional projects.');
      }
    }

    // 3. Panchang Modifiers
    if (panchang.yoga.toLowerCase().includes('shiva') || panchang.yoga.toLowerCase().includes('siddhi')) {
      baseScore += 1.0;
      categories.Money += 1.5;
      doList.push('Auspicious energy for financial planning.');
    }

    if (panchang.tithi.toLowerCase().includes('amavasya')) {
      baseScore -= 1.5;
      avoidList.push('Not an ideal day for starting completely new ventures.');
    }

    // 4. Advanced Yogas: Gajakesari Yoga (Jupiter in Kendra from Moon)
    // Simplified for demonstration: If both Moon and Jupiter are strong
    const jupiter = planets['jupiter'];
    if (moon && jupiter) {
       // Mock logic: assuming they are in Kendra (1,4,7,10 houses apart)
       const distance = Math.abs(moon.house - jupiter.house);
       if (distance === 0 || distance === 3 || distance === 6 || distance === 9) {
         baseScore += 2.0;
         categories.Career += 3.0;
         categories.Money += 2.0;
         doList.push('Excellent day for major career decisions and leadership (Gajakesari Yoga active).');
       }
    }

    // 5. House Aspects
    const mars = planets['mars'];
    if (mars && mars.house === 10) { // Mars in 10th house (Career)
       baseScore += 1.0;
       categories.Career += 2.0;
       doList.push('High energy for professional tasks. Be assertive.');
       avoidList.push('Avoid being too aggressive with colleagues.');
    }

    // Apply Focus Weights
    const finalScore = (
      (categories.Career * (focusWeights.Career || 1.0)) +
      (categories.Love * (focusWeights.Love || 1.0)) +
      (categories.Money * (focusWeights.Money || 1.0))
    ) / 3;

    return {
      score: Math.min(Math.max(baseScore + (finalScore * 0.2), 1), 10), // Clamp 1 to 10
      doList,
      avoidList,
      categories: {
        Career: Math.min(Math.max(categories.Career, 1), 10),
        Love: Math.min(Math.max(categories.Love, 1), 10),
        Money: Math.min(Math.max(categories.Money, 1), 10),
      }
    };
  }
}

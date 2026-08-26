import { Injectable } from '@nestjs/common';
import { AstrologyRuleEngine } from './astrology-rule.engine';
import { PanchangResponse, PlanetaryPosition } from '../interfaces/astrology-data-provider.interface';

@Injectable()
export class GamePlanEngine {
  constructor(private readonly ruleEngine: AstrologyRuleEngine) {}

  generateDailyGamePlan(
    date: Date,
    planets: Record<string, PlanetaryPosition>,
    panchang: PanchangResponse,
    focusWeights?: Record<string, number>
  ) {
    const rulesResult = this.ruleEngine.evaluateDayRules(planets, panchang, focusWeights);

    // Calculate dynamic best window based on Panchang (e.g., avoiding Rahu Kaal)
    let bestStart = '10:00 AM';
    let bestEnd = '12:00 PM';

    // Simple fallback logic to avoid Rahu Kaal if overlapping
    if (panchang.rahuKaal.start && panchang.rahuKaal.start.includes('10:') || panchang.rahuKaal.start.includes('11:')) {
      bestStart = '02:00 PM';
      bestEnd = '04:00 PM';
    }

    return {
      success: true,
      data: {
        date: date.toISOString().split('T')[0],
        dayScore: Number(rulesResult.score.toFixed(1)),
        doList: rulesResult.doList.length > 0 ? rulesResult.doList : ['Trust your intuition today.'],
        beCarefulList: ['Double check details during communications.'],
        avoidList: rulesResult.avoidList.length > 0 ? rulesResult.avoidList : ['Avoid rushing into major financial decisions.'],
        bestWindow: { start: bestStart, end: bestEnd },
        categories: rulesResult.categories,
      }
    };
  }
}

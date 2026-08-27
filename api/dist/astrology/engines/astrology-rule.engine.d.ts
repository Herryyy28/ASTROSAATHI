import { PanchangResponse, PlanetaryPosition } from '../interfaces/astrology-data-provider.interface';
export interface RuleResult {
    score: number;
    doList: string[];
    avoidList: string[];
    categories: {
        Career: number;
        Love: number;
        Money: number;
    };
}
export declare class AstrologyRuleEngine {
    evaluateDayRules(planets: Record<string, PlanetaryPosition>, panchang: PanchangResponse, focusWeights?: Record<string, number>): RuleResult;
}

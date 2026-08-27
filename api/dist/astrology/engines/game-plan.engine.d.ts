import { AstrologyRuleEngine } from './astrology-rule.engine';
import { PanchangResponse, PlanetaryPosition } from '../interfaces/astrology-data-provider.interface';
export declare class GamePlanEngine {
    private readonly ruleEngine;
    constructor(ruleEngine: AstrologyRuleEngine);
    generateDailyGamePlan(date: Date, planets: Record<string, PlanetaryPosition>, panchang: PanchangResponse, focusWeights?: Record<string, number>): {
        success: boolean;
        data: {
            date: string;
            dayScore: number;
            doList: string[];
            beCarefulList: string[];
            avoidList: string[];
            bestWindow: {
                start: string;
                end: string;
            };
            categories: {
                Career: number;
                Love: number;
                Money: number;
            };
        };
    };
}

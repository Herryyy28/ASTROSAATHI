import { AstrologyService } from './astrology.service';
import { AstrologySyncService } from './astrology-sync.service';
import { GamePlanEngine } from './engines/game-plan.engine';
import { MuhuratEngine } from './engines/muhurat.engine';
import { UsersService } from '../users/users.service';
import { MatchingService } from './matching.service';
export declare class AstrologyController {
    private readonly astrologyService;
    private readonly syncService;
    private readonly gamePlanEngine;
    private readonly muhuratEngine;
    private readonly usersService;
    private readonly matchingService;
    constructor(astrologyService: AstrologyService, syncService: AstrologySyncService, gamePlanEngine: GamePlanEngine, muhuratEngine: MuhuratEngine, usersService: UsersService, matchingService: MatchingService);
    private parseLocation;
    getGamePlan(req: any, dateStr: string, lat: string, lon: string, tz: string): Promise<{
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
    }>;
    getPanchang(dateStr: string, lat: string, lon: string, tz: string): Promise<{
        data: import("./interfaces/astrology-data-provider.interface").PanchangResponse;
        meta: import("./interfaces/astrology-data-provider.interface").ProviderMetadata;
    }>;
    getMuhurat(category: string, dateStr: string, lat: string, lon: string, tz: string): Promise<{
        success: boolean;
        data: {
            category: string;
            quality: string;
            score: number;
            specificGuidance: string;
            bestWindow: {
                start: string;
                end: string;
            };
            strength: string;
            bestFor: string;
            avoidWindow: {
                start: string;
                end: string;
            } | null;
        };
    }>;
    getBirthChart(dateStr: string, timeStr: string, lat: string, lon: string, tz: string): Promise<{
        data: any;
        meta: import("./interfaces/astrology-data-provider.interface").ProviderMetadata;
    }>;
    getHoroscope(sign: string, timeframe: string): Promise<any>;
    getMatch(p1Sign: string, p2Sign: string): Promise<import("./matching.service").AshtakootaMilanResult>;
}

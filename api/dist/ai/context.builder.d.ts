import { AstrologySyncService } from '../astrology/astrology-sync.service';
import { GamePlanEngine } from '../astrology/engines/game-plan.engine';
import { MuhuratEngine } from '../astrology/engines/muhurat.engine';
import { LocationData } from '../core/location/location.service';
import { TimeService } from '../core/time/time.service';
export interface AiContext {
    timestamp: string;
    timeZone: string;
    location: {
        lat: number;
        lon: number;
    };
    gamePlan: any;
    panchang: any;
    planets: any;
    muhurat: any;
}
export declare class ContextBuilder {
    private readonly syncService;
    private readonly gamePlanEngine;
    private readonly muhuratEngine;
    private readonly timeService;
    constructor(syncService: AstrologySyncService, gamePlanEngine: GamePlanEngine, muhuratEngine: MuhuratEngine, timeService: TimeService);
    buildRealTimeContext(date: Date, location: LocationData): Promise<AiContext>;
}

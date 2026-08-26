import { Injectable } from '@nestjs/common';
import { AstrologySyncService } from '../astrology/astrology-sync.service';
import { GamePlanEngine } from '../astrology/engines/game-plan.engine';
import { MuhuratEngine } from '../astrology/engines/muhurat.engine';
import { LocationData } from '../core/location/location.service';
import { TimeService } from '../core/time/time.service';

export interface AiContext {
  timestamp: string;
  timeZone: string;
  location: { lat: number; lon: number };
  gamePlan: any;
  panchang: any;
  planets: any;
  muhurat: any;
}

@Injectable()
export class ContextBuilder {
  constructor(
    private readonly syncService: AstrologySyncService,
    private readonly gamePlanEngine: GamePlanEngine,
    private readonly muhuratEngine: MuhuratEngine,
    private readonly timeService: TimeService,
  ) {}

  async buildRealTimeContext(date: Date, location: LocationData): Promise<AiContext> {
    // 1. Fetch structured calculated data
    const { panchang, planets } = await this.syncService.getCombinedData(date, location);
    
    // 2. Generate personalized deterministic scores
    const focusWeights = { Career: 1.0, Love: 1.0, Money: 1.0 }; // Mocked profile
    const gamePlan = this.gamePlanEngine.generateDailyGamePlan(date, planets, panchang, focusWeights).data;
    
    // 3. Generate Muhurat
    const muhurat = this.muhuratEngine.calculateMuhurat('General', date, location, panchang).data;

    return {
      timestamp: this.timeService.getCurrentUtcTime().toISOString(),
      timeZone: location.timeZone,
      location: { lat: location.latitude, lon: location.longitude },
      gamePlan,
      panchang,
      planets,
      muhurat,
    };
  }
}

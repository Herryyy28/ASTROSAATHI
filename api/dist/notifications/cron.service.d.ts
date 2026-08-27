import { Repository } from 'typeorm';
import { UserProfile } from '../database/entities/profile.entity';
import { GamePlanEngine } from '../astrology/engines/game-plan.engine';
import { AstrologySyncService } from '../astrology/astrology-sync.service';
export declare class CronService {
    private readonly profileRepository;
    private readonly syncService;
    private readonly gamePlanEngine;
    private readonly logger;
    constructor(profileRepository: Repository<UserProfile>, syncService: AstrologySyncService, gamePlanEngine: GamePlanEngine);
    calculateDailyGamePlans(): Promise<void>;
}

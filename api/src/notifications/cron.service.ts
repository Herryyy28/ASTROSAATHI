import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UserProfile } from '../database/entities/profile.entity';
import { GamePlanEngine } from '../astrology/engines/game-plan.engine';
import { AstrologySyncService } from '../astrology/astrology-sync.service';

@Injectable()
export class CronService {
  private readonly logger = new Logger(CronService.name);

  constructor(
    @InjectRepository(UserProfile) private readonly profileRepository: Repository<UserProfile>,
    private readonly syncService: AstrologySyncService,
    private readonly gamePlanEngine: GamePlanEngine,
  ) {}

  // Run every night at midnight (UTC)
  @Cron(CronExpression.EVERY_DAY_AT_MIDNIGHT)
  async calculateDailyGamePlans() {
    this.logger.log('Starting nightly Game Plan calculations...');
    const profiles = await this.profileRepository.find();
    
    // In production, we'd use BullMQ to queue these tasks to avoid blocking.
    // For now, we simulate the batch job.
    for (const profile of profiles) {
      try {
        const date = new Date();
        const location = {
          latitude: profile.currentLatitude || profile.birthLatitude,
          longitude: profile.currentLongitude || profile.birthLongitude,
          timeZone: profile.currentTimeZone || profile.birthTimeZone,
        };

        const { panchang, planets } = await this.syncService.getCombinedData(date, location);
        const focusWeights = profile.focusWeights as any || { Career: 1.0, Love: 1.0, Money: 1.0 };

        const gamePlan = this.gamePlanEngine.generateDailyGamePlan(date, planets, panchang, focusWeights);

        this.logger.log(`Calculated Game Plan for user ${profile.id}: Score ${gamePlan.data.dayScore}`);
        
        // TODO: Push Notification Trigger (Phase 2 FCM integration)
        // e.g., await this.fcmService.sendPush(profile.user.firebaseUid, gamePlan.data);

      } catch (error) {
        const errorMessage = error instanceof Error ? error.message : String(error);
        this.logger.error(`Failed to calculate Game Plan for profile ${profile.id}: ${errorMessage}`);
      }
    }
    this.logger.log('Finished nightly Game Plan calculations.');
  }
}

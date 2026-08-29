import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { AiService } from '../ai/ai.service';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { KnowledgeRashi } from '../database/entities/knowledge_rashi.entity';

@Injectable()
export class RashiBhavishyaService {
  private readonly logger = new Logger(RashiBhavishyaService.name);
  
  // In-memory cache for MVP. Should use Redis for production.
  private dailyForecastCache: Record<string, any> = {};

  constructor(
    private readonly aiService: AiService,
    @InjectRepository(KnowledgeRashi)
    private readonly rashiRepo: Repository<KnowledgeRashi>,
  ) {}

  /**
   * Generates predictions for all 12 Rashis for today.
   * Runs at midnight daily.
   */
  @Cron(CronExpression.EVERY_DAY_AT_MIDNIGHT)
  async generateDailyForecasts() {
    this.logger.log('Starting daily Rashi Bhavishya generation...');
    
    try {
      const rashis = await this.rashiRepo.find();
      if (rashis.length === 0) {
        this.logger.warn('No Rashis found in Knowledge Database. Skip generation.');
        return;
      }

      const today = new Date();
      // In a full implementation, this loops through all rashis and asks AiService to generate a deterministic forecast based on transits.
      for (const rashi of rashis) {
        // Generate real forecast via AI
        const realForecast = await this.aiService.generateRashiForecast(rashi.name, today);
        this.dailyForecastCache[rashi.name] = {
          date: today.toISOString(),
          ...realForecast,
        };
      }

      this.logger.log('Daily Rashi Bhavishya generation completed.');
    } catch (e) {
      this.logger.error('Failed to generate daily forecasts', e);
    }
  }

  getTodayForecast(rashiName: string) {
    if (!this.dailyForecastCache[rashiName]) {
      // Trigger a generation if missing
      this.logger.log(`Cache miss for ${rashiName}, returning fallback`);
      return {
        rashi: rashiName,
        forecast: 'Today is a day of balance and karmic alignment.',
        score: 7
      };
    }
    return this.dailyForecastCache[rashiName];
  }
}

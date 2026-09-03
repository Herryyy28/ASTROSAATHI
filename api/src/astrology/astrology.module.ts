import { Module } from '@nestjs/common';
// import { BullModule } from '@nestjs/bullmq';
import { AstrologyService } from './astrology.service';
import { AstrologyController } from './astrology.controller';
import { AstrologySyncService } from './astrology-sync.service';
import { AstrologyApiProvider } from './providers/astrology-api.provider';
import { MockAstrologyProvider } from './providers/mock-astrology.provider';
import { LocalAstrologyProvider } from './providers/local-astrology.provider';
import { AstrologySyncProcessor } from './processors/astrology-sync.processor';
import { AstrologyRuleEngine } from './engines/astrology-rule.engine';
import { GamePlanEngine } from './engines/game-plan.engine';
import { MuhuratEngine } from './engines/muhurat.engine';
import { RashiBhavishyaService } from './rashi-bhavishya.service';
import { UsersModule } from '../users/users.module';
import { CoreModule } from '../core/core.module';
import { AstrologyDataIntegrityService } from './astrology-data-integrity.service';

import { MatchingService } from './matching.service';

import { KnowledgeRashi } from '../database/entities/knowledge_rashi.entity';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AiModule } from '../ai/ai.module';
import { forwardRef } from '@nestjs/common';

import { AdvancedAstrologyEngine } from './engines/astrology-advanced.engine';
import { VipIntelligenceEngine } from './engines/astrology-vip.engine';

@Module({
  imports: [
    /* BullModule.registerQueue({
      name: 'astrology-sync',
    }), */
    UsersModule,
    CoreModule,
    TypeOrmModule.forFeature([KnowledgeRashi]),
    forwardRef(() => AiModule)
  ],
  providers: [
    AstrologyService,
    AstrologySyncService,
    MatchingService,
    AstrologyApiProvider,
    MockAstrologyProvider,
    LocalAstrologyProvider,
    // AstrologySyncProcessor,
    AstrologyRuleEngine,
    GamePlanEngine,
    MuhuratEngine,
    AdvancedAstrologyEngine,
    VipIntelligenceEngine,
    RashiBhavishyaService,
    AstrologyDataIntegrityService,
    {
      provide: 'ASTROLOGY_PROVIDER',
      useClass: process.env.USE_MOCK_PROVIDER === 'true' ? LocalAstrologyProvider : AstrologyApiProvider,
    },
  ],
  controllers: [AstrologyController],
  exports: [AstrologyService, AstrologySyncService, MatchingService, GamePlanEngine, MuhuratEngine, AdvancedAstrologyEngine, VipIntelligenceEngine, RashiBhavishyaService],
})
export class AstrologyModule { }

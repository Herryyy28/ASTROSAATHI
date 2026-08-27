import { Module } from '@nestjs/common';
import { BullModule } from '@nestjs/bullmq';
import { AstrologyService } from './astrology.service';
import { AstrologyController } from './astrology.controller';
import { AstrologySyncService } from './astrology-sync.service';
import { AstrologyApiProvider } from './providers/astrology-api.provider';
import { MockAstrologyProvider } from './providers/mock-astrology.provider';
import { AstrologySyncProcessor } from './processors/astrology-sync.processor';
import { AstrologyRuleEngine } from './engines/astrology-rule.engine';
import { GamePlanEngine } from './engines/game-plan.engine';
import { MuhuratEngine } from './engines/muhurat.engine';
import { UsersModule } from '../users/users.module';
import { CoreModule } from '../core/core.module';

@Module({
  imports: [
    BullModule.registerQueue({
      name: 'astrology-sync',
    }),
    UsersModule,
    CoreModule,
  ],
  providers: [
    AstrologyService,
    AstrologySyncService,
    AstrologyApiProvider,
    MockAstrologyProvider,
    AstrologySyncProcessor,
    AstrologyRuleEngine,
    GamePlanEngine,
    MuhuratEngine,
    {
      provide: 'ASTROLOGY_PROVIDER',
      useClass: process.env.USE_MOCK_PROVIDER === 'true' ? MockAstrologyProvider : AstrologyApiProvider,
    },
  ],
  controllers: [AstrologyController],
  exports: [AstrologyService, AstrologySyncService, GamePlanEngine, MuhuratEngine],
})
export class AstrologyModule { }

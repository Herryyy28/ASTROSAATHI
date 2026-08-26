import { Module } from '@nestjs/common';
import { AiController } from './ai.controller';
import { AiService } from './ai.service';
import { ContextBuilder } from './context.builder';
import { AstrologyModule } from '../astrology/astrology.module';
import { CoreModule } from '../core/core.module';

@Module({
  imports: [AstrologyModule, CoreModule],
  controllers: [AiController],
  providers: [AiService, ContextBuilder],
  exports: [AiService],
})
export class AiModule {}

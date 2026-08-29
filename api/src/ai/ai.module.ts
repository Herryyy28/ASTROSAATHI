import { Module } from '@nestjs/common';
import { AiController } from './ai.controller';
import { AiService } from './ai.service';
import { ContextBuilder } from './context.builder';
import { AstrologyModule } from '../astrology/astrology.module';
import { CoreModule } from '../core/core.module';
import { KnowledgeRetrievalService } from './knowledge-retrieval.service';
import { forwardRef } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { KnowledgeRashi } from '../database/entities/knowledge_rashi.entity';
import { KnowledgeBhava } from '../database/entities/knowledge_bhava.entity';
import { KnowledgeGraha } from '../database/entities/knowledge_graha.entity';

@Module({
  imports: [
    forwardRef(() => AstrologyModule), 
    CoreModule,
    TypeOrmModule.forFeature([KnowledgeRashi, KnowledgeBhava, KnowledgeGraha])
  ],
  controllers: [AiController],
  providers: [AiService, ContextBuilder, KnowledgeRetrievalService],
  exports: [AiService, KnowledgeRetrievalService],
})
export class AiModule {}

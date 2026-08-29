import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { KnowledgeRashi } from '../database/entities/knowledge_rashi.entity';
import { KnowledgeBhava } from '../database/entities/knowledge_bhava.entity';
import { KnowledgeGraha } from '../database/entities/knowledge_graha.entity';

@Injectable()
export class KnowledgeRetrievalService {
  private readonly logger = new Logger(KnowledgeRetrievalService.name);

  constructor(
    @InjectRepository(KnowledgeRashi)
    private readonly rashiRepo: Repository<KnowledgeRashi>,
    @InjectRepository(KnowledgeBhava)
    private readonly bhavaRepo: Repository<KnowledgeBhava>,
    @InjectRepository(KnowledgeGraha)
    private readonly grahaRepo: Repository<KnowledgeGraha>,
  ) {}

  /**
   * Resolves basic deterministic knowledge from the DB based on a query text or context
   */
  async retrieveContextualKnowledge(query: string, currentTransitRashi?: string): Promise<any> {
    const knowledgeChunks = [];

    try {
      // Very basic relational retrieval for MVP. 
      // In production, this will use pgvector similarity search on a 'KnowledgeChunk' entity.

      // If we know the user is asking about their transit, we grab the specific Rashi facts.
      if (currentTransitRashi) {
        const rashiKnowledge = await this.rashiRepo.findOne({
          where: { name: currentTransitRashi },
        });
        if (rashiKnowledge) {
          knowledgeChunks.push({
            type: 'rashi_context',
            rashi: rashiKnowledge.name,
            lord: rashiKnowledge.lord,
            nature: rashiKnowledge.nature,
            careerThemes: rashiKnowledge.careerThemes,
          });
        }
      }

      // Quick keyword matching for Grahas
      const grahas = ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn', 'Rahu', 'Ketu'];
      for (const g of grahas) {
        if (query.toLowerCase().includes(g.toLowerCase())) {
          const grahaKnowledge = await this.grahaRepo.findOne({ where: { name: g } });
          if (grahaKnowledge) {
            knowledgeChunks.push({
              type: 'graha_context',
              graha: grahaKnowledge.name,
              nature: grahaKnowledge.nature,
              karakatwa: grahaKnowledge.karakatwa,
            });
          }
        }
      }

    } catch (e) {
      this.logger.error('Failed to retrieve knowledge chunks', e);
    }

    return knowledgeChunks;
  }
}

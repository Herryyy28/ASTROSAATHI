import { Repository } from 'typeorm';
import { KnowledgeRashi } from '../database/entities/knowledge_rashi.entity';
import { KnowledgeBhava } from '../database/entities/knowledge_bhava.entity';
import { KnowledgeGraha } from '../database/entities/knowledge_graha.entity';
export declare class KnowledgeRetrievalService {
    private readonly rashiRepo;
    private readonly bhavaRepo;
    private readonly grahaRepo;
    private readonly logger;
    constructor(rashiRepo: Repository<KnowledgeRashi>, bhavaRepo: Repository<KnowledgeBhava>, grahaRepo: Repository<KnowledgeGraha>);
    retrieveContextualKnowledge(query: string, currentTransitRashi?: string): Promise<any>;
}

import { AiService } from '../ai/ai.service';
import { Repository } from 'typeorm';
import { KnowledgeRashi } from '../database/entities/knowledge_rashi.entity';
export declare class RashiBhavishyaService {
    private readonly aiService;
    private readonly rashiRepo;
    private readonly logger;
    private dailyForecastCache;
    constructor(aiService: AiService, rashiRepo: Repository<KnowledgeRashi>);
    generateDailyForecasts(): Promise<void>;
    getTodayForecast(rashiName: string): any;
}

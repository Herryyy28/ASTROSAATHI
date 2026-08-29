import { ConfigService } from '@nestjs/config';
import { ContextBuilder } from './context.builder';
import { KnowledgeRetrievalService } from './knowledge-retrieval.service';
export declare class AiService {
    private readonly contextBuilder;
    private readonly knowledgeRetrieval;
    private configService;
    private openai;
    private readonly logger;
    constructor(contextBuilder: ContextBuilder, knowledgeRetrieval: KnowledgeRetrievalService, configService: ConfigService);
    askAstroBaba(question: string, date: Date, location: any): Promise<{
        success: boolean;
        data: {
            answer: any;
            confidence: any;
            actions: any;
            warnings: any;
            grounding: any;
        };
    }>;
    generateRashiForecast(rashiName: string, date: Date): Promise<{
        rashi: string;
        forecast: any;
        score: number;
        luckyColor: any;
    }>;
    private getFallbackResponse;
}

import { ConfigService } from '@nestjs/config';
import { ContextBuilder } from './context.builder';
export declare class AiService {
    private readonly contextBuilder;
    private configService;
    private openai;
    private readonly logger;
    constructor(contextBuilder: ContextBuilder, configService: ConfigService);
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
    private getFallbackResponse;
}

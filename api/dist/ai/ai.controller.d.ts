import { AiService } from './ai.service';
export declare class AiController {
    private readonly aiService;
    constructor(aiService: AiService);
    askAstroBaba(question: string, dateStr: string, lat: number, lon: number, tz: string): Promise<{
        success: boolean;
        data: {
            answer: any;
            confidence: any;
            actions: any;
            warnings: any;
            grounding: any;
        };
    }>;
}

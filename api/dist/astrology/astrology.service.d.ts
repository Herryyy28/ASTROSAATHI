import { ConfigService } from '@nestjs/config';
export declare class AstrologyService {
    private configService;
    private readonly logger;
    private cache;
    constructor(configService: ConfigService);
    private getCacheKey;
    private fetchFromApi;
    private getApiPayload;
    getDailyGamePlan(date: string, location: string): Promise<any>;
    getPanchang(date: string, location: string): Promise<any>;
    getMuhurat(category: string, date: string, location: string): Promise<any>;
    getHoroscope(sign: string, timeframe: string): Promise<any>;
}

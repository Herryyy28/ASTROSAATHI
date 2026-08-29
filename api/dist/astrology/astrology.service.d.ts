import { ConfigService } from '@nestjs/config';
import { AstrologyDataIntegrityService } from './astrology-data-integrity.service';
export declare class AstrologyService {
    private configService;
    private dataIntegrity;
    private readonly logger;
    private cache;
    constructor(configService: ConfigService, dataIntegrity: AstrologyDataIntegrityService);
    private getCacheKey;
    private fetchFromApi;
    private getApiPayload;
    getDailyGamePlan(date: string, location: string): Promise<any>;
    getPanchang(date: string, location: string): Promise<any>;
    getMuhurat(category: string, date: string, location: string): Promise<any>;
    private generatePlanetaryStateHash;
    getHoroscope(sign: string, timeframe: string): Promise<any>;
}

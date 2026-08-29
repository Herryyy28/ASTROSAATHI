import { ConfigService } from '@nestjs/config';
import { AstrologyDataProvider, PanchangResponse, PlanetaryPosition, ProviderMetadata } from './interfaces/astrology-data-provider.interface';
import { LocationData } from '../core/location/location.service';
export declare class AstrologySyncService {
    private readonly provider;
    private configService;
    private readonly logger;
    private cache;
    constructor(provider: AstrologyDataProvider, configService: ConfigService);
    private getCacheKey;
    syncPanchang(date: Date, location: LocationData): Promise<{
        data: PanchangResponse;
        meta: ProviderMetadata;
    }>;
    syncPlanetaryPositions(date: Date, location: LocationData): Promise<{
        data: Record<string, PlanetaryPosition>;
        meta: ProviderMetadata;
    }>;
    syncBirthChart(date: Date, time: string, location: LocationData): Promise<{
        data: any;
        meta: ProviderMetadata;
    }>;
    getCombinedData(date: Date, location: LocationData): Promise<{
        panchang: PanchangResponse;
        planets: Record<string, PlanetaryPosition>;
    }>;
}

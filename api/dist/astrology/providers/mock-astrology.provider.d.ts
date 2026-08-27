import { AstrologyDataProvider, PanchangResponse, PlanetaryPosition, ProviderMetadata } from '../interfaces/astrology-data-provider.interface';
import { LocationData } from '../../core/location/location.service';
export declare class MockAstrologyProvider implements AstrologyDataProvider {
    private createMetadata;
    getPlanetaryPositions(date: Date, location: LocationData): Promise<{
        data: Record<string, PlanetaryPosition>;
        meta: ProviderMetadata;
    }>;
    getBirthChart(dob: Date, time: string, location: LocationData): Promise<{
        data: any;
        meta: ProviderMetadata;
    }>;
    getPanchang(date: Date, location: LocationData): Promise<{
        data: PanchangResponse;
        meta: ProviderMetadata;
    }>;
}

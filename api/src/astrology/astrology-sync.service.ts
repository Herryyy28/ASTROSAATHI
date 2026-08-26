import { Injectable, Logger, Inject } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AstrologyDataProvider, PanchangResponse, PlanetaryPosition, ProviderMetadata } from './interfaces/astrology-data-provider.interface';
import { LocationData } from '../core/location/location.service';

@Injectable()
export class AstrologySyncService {
  private readonly logger = new Logger(AstrologySyncService.name);
  // Simple in-memory cache to represent Redis for now
  private cache = new Map<string, any>();

  constructor(
    @Inject('ASTROLOGY_PROVIDER') private readonly provider: AstrologyDataProvider,
    private configService: ConfigService,
  ) {}

  private getCacheKey(endpoint: string, location: LocationData, date: Date): string {
    const dStr = date.toISOString().split('T')[0];
    return `${endpoint}-${dStr}-${location.latitude}-${location.longitude}`;
  }

  async syncPanchang(date: Date, location: LocationData): Promise<{ data: PanchangResponse; meta: ProviderMetadata }> {
    const cacheKey = this.getCacheKey('panchang', location, date);
    
    // Check if we have valid cached data
    const cached = this.cache.get(cacheKey);
    if (cached) {
      const now = new Date();
      if (now >= cached.meta.validFrom && now <= cached.meta.validUntil) {
        this.logger.log(`Serving Panchang from valid cache for ${location.cityName || location.latitude}`);
        return cached;
      } else {
        this.logger.log(`Cache expired for Panchang. Refreshing.`);
      }
    }

    try {
      const result = await this.provider.getPanchang(date, location);
      this.cache.set(cacheKey, result);
      return result;
    } catch (error) {
      this.logger.error(`Provider failed to get Panchang: ${error.message}`);
      // Fallback to cache even if expired if we have no other choice
      if (cached) {
        this.logger.warn(`Serving stale Panchang from cache due to provider failure.`);
        return cached;
      }
      throw new Error('Panchang data unavailable.');
    }
  }

  async syncPlanetaryPositions(date: Date, location: LocationData): Promise<{ data: Record<string, PlanetaryPosition>; meta: ProviderMetadata }> {
    const cacheKey = this.getCacheKey('planets', location, date);
    
    const cached = this.cache.get(cacheKey);
    if (cached) {
      const now = new Date();
      if (now >= cached.meta.validFrom && now <= cached.meta.validUntil) {
        return cached;
      }
    }

    try {
      const result = await this.provider.getPlanetaryPositions(date, location);
      this.cache.set(cacheKey, result);
      return result;
    } catch (error) {
      this.logger.error(`Provider failed to get Planets: ${error.message}`);
      if (cached) return cached;
      throw new Error('Planetary data unavailable.');
    }
  }

  // To be used by Controller / GamePlanEngine
  async getCombinedData(date: Date, location: LocationData) {
    const [panchang, planets] = await Promise.all([
      this.syncPanchang(date, location),
      this.syncPlanetaryPositions(date, location)
    ]);
    
    return {
      panchang: panchang.data,
      planets: planets.data
    };
  }
}

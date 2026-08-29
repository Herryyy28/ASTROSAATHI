import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AstrologyDataIntegrityService } from './astrology-data-integrity.service';

@Injectable()
export class AstrologyService {
  private readonly logger = new Logger(AstrologyService.name);
  // Cache to store daily API responses to avoid duplicates
  private cache = new Map<string, any>();

  constructor(
    private configService: ConfigService,
    private dataIntegrity: AstrologyDataIntegrityService,
  ) {}

  private getCacheKey(endpoint: string, params: any): string {
    const today = new Date().toISOString().split('T')[0];
    return `${endpoint}-${today}-${JSON.stringify(params)}`;
  }

  private async fetchFromApi(endpoint: string, data: any): Promise<any> {
    const userId = this.configService.get<string>('ASTROLOGY_USER_ID') || '657466';
    const apiKey = this.configService.get<string>('ASTROLOGY_API_KEY') || 'ak-dbf59adeb917e54a4f3eb845c26e6181acf1e707';

    if (!userId || !apiKey) {
      this.logger.error('Astrology API credentials missing. Cannot fetch real data.');
      throw new Error('Astrology API credentials missing.');
    }

    const auth = Buffer.from(`${userId}:${apiKey}`).toString('base64');
    
    try {
      const response = await fetch(`https://json.astrologyapi.com/v1/${endpoint}`, {
        method: 'POST',
        headers: {
          'Authorization': `Basic ${auth}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
      });

      if (!response.ok) {
        const errorText = await response.text();
        this.logger.error(`API Error ${response.status}: ${errorText}`);
        require('fs').writeFileSync('astrology_api_error.txt', `Service Error ${response.status}: ${errorText}\n`);
        throw new Error(`AstrologyAPI Error: ${errorText}`);
      }

      return await response.json();
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : String(error);
      this.logger.error(`Failed to fetch from AstrologyAPI: ${errorMessage}`);
      return null;
    }
  }

  // Parse location and date into AstrologyAPI required format
  private getApiPayload(dateStr: string, locationStr: string) {
    const date = new Date(); // In a real app, parse dateStr properly
    return {
      day: date.getDate(),
      month: date.getMonth() + 1,
      year: date.getFullYear(),
      hour: date.getHours(),
      min: date.getMinutes(),
      lat: 28.6139, // Default to New Delhi if location string can't be geocoded easily
      lon: 77.2090,
      tzone: 5.5,
    };
  }

  async getDailyGamePlan(date: string, location: string) {
    const cacheKey = this.getCacheKey('game-plan', { date, location });
    if (this.cache.has(cacheKey)) {
      return this.cache.get(cacheKey);
    }

    const payload = this.getApiPayload(date, location);
    const apiData = await this.fetchFromApi('game_plan', payload);
    
    if (!apiData) {
       throw new Error('Failed to retrieve daily game plan data');
    }

    const result = {
      success: true,
      data: this.dataIntegrity.normalizeGamePlan(apiData, date)
    };
    
    this.cache.set(cacheKey, result);
    return result;
  }

  async getPanchang(date: string, location: string) {
    const cacheKey = this.getCacheKey('advanced_panchang', { date, location });
    if (this.cache.has(cacheKey)) {
      return this.cache.get(cacheKey);
    }

    const payload = this.getApiPayload(date, location);
    const apiData = await this.fetchFromApi('advanced_panchang', payload);

    if (!apiData) {
      throw new Error('Failed to fetch Panchang data');
    }

    const resultData = this.dataIntegrity.normalizePanchang(apiData);

    const result = { success: true, data: resultData };
    this.cache.set(cacheKey, result);
    return result;
  }

  async getMuhurat(category: string, date: string, location: string) {
    const cacheKey = this.getCacheKey('muhurat', { category, date, location });
    if (this.cache.has(cacheKey)) {
      return this.cache.get(cacheKey);
    }

    const payload = this.getApiPayload(date, location);
    const apiData = await this.fetchFromApi('muhurat', payload);

    if (!apiData) {
       throw new Error('Failed to retrieve Muhurat data');
    }

    const result = {
      success: true,
      data: this.dataIntegrity.normalizeMuhurat(apiData, category)
    };

    this.cache.set(cacheKey, result);
    return result;
  }

  private generatePlanetaryStateHash(sign: string, timeframe: string): string {
    // In a full implementation, we'd hash the canonical kundli object
    // For now, we hash the sign, timeframe and current day to guarantee uniqueness per day per sign
    const today = new Date().toISOString().split('T')[0];
    return require('crypto').createHash('md5').update(`${sign}-${timeframe}-${today}`).digest('hex');
  }

  async getHoroscope(sign: string, timeframe: string) {
    const planetaryStateHash = this.generatePlanetaryStateHash(sign, timeframe);
    const cacheKey = `horoscope-${sign}-${timeframe}-${planetaryStateHash}`;
    
    if (this.cache.has(cacheKey)) {
      return this.cache.get(cacheKey);
    }

    if (this.configService.get<string>('USE_MOCK_PROVIDER') === 'true') {
      const result = {
        success: true,
        data: {
          sign,
          timeframe,
          reading: `According to your calculated birth chart, your personalized reading for ${sign} today shows positive transits. The underlying astrological context emphasizes grounding and focus.`,
          luckyNumber: 7,
          luckyColor: 'Blue',
        },
      };
      this.cache.set(cacheKey, result);
      return result;
    }

    const apiEndpoint = timeframe === 'daily' ? `sun_sign_prediction/daily/${sign.toLowerCase()}` : null;
    let apiData: any = null;
    
    if (apiEndpoint) {
       apiData = await this.fetchFromApi(apiEndpoint, {});
    }

    if (!apiData) {
      throw new Error('Failed to retrieve Horoscope data');
    }

    const result = {
      success: true,
      data: {
        sign,
        timeframe,
        reading: apiData.prediction,
        luckyNumber: apiData.lucky_number || 7,
        luckyColor: apiData.lucky_color || 'White',
      },
    };

    this.cache.set(cacheKey, result);
    return result;
  }
}

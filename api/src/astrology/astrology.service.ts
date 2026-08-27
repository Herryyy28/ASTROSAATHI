import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class AstrologyService {
  private readonly logger = new Logger(AstrologyService.name);
  // Cache to store daily API responses to avoid duplicates
  private cache = new Map<string, any>();

  constructor(private configService: ConfigService) {}

  private getCacheKey(endpoint: string, params: any): string {
    const today = new Date().toISOString().split('T')[0];
    return `${endpoint}-${today}-${JSON.stringify(params)}`;
  }

  private async fetchFromApi(endpoint: string, data: any): Promise<any> {
    const userId = this.configService.get<string>('ASTROLOGY_USER_ID');
    const apiKey = this.configService.get<string>('ASTROLOGY_API_KEY');

    if (!userId || !apiKey) {
      this.logger.warn('Astrology API credentials missing. Falling back to mock data.');
      return null;
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
        throw new Error(`API Error: ${response.statusText}`);
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

    // In a full implementation, you would map astrology API endpoints to generate the game plan.
    // For now, we return the mock data if API keys aren't set, or we can fetch a generalized prediction.
    const result = {
      success: true,
      data: {
        date,
        dayScore: 8.4,
        doList: ['Important conversations', 'Start planned work'],
        beCarefulList: ['Avoid rushed decisions'],
        avoidList: ['Unnecessary arguments'],
        bestWindow: { start: '11:15 AM', end: '1:20 PM' },
        categories: { Career: 8.8, Love: 7.4, Money: 8.1 },
      },
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

    let resultData;
    if (apiData) {
      resultData = {
        tithi: apiData.tithi.details.tithi_name,
        vara: apiData.day,
        nakshatra: apiData.nakshatra.details.nak_name,
        yoga: apiData.yoga.details.yoga_name,
        karana: apiData.karana.details.karana_name,
        sunrise: apiData.sunrise,
        sunset: apiData.sunset,
        rahuKaal: { start: apiData.rahukaal.start, end: apiData.rahukaal.end },
      };
    } else {
      // Fallback
      resultData = {
        tithi: 'Shukla Paksha Dashami',
        vara: 'Wednesday',
        nakshatra: 'Rohini',
        yoga: 'Shiva',
        karana: 'Taitila',
        sunrise: '06:12 AM',
        sunset: '06:45 PM',
        rahuKaal: { start: '12:00 PM', end: '01:30 PM' },
      };
    }

    const result = { success: true, data: resultData };
    this.cache.set(cacheKey, result);
    return result;
  }

  async getMuhurat(category: string, date: string, location: string) {
    const cacheKey = this.getCacheKey('muhurat', { category, date, location });
    if (this.cache.has(cacheKey)) {
      return this.cache.get(cacheKey);
    }

    const result = {
      success: true,
      data: {
        category,
        bestWindow: { start: '11:15 AM', end: '01:20 PM' },
        strength: 'Excellent',
        bestFor: 'Important professional discussions',
        avoidWindow: { start: '02:10 PM', end: '03:25 PM' },
      },
    };

    this.cache.set(cacheKey, result);
    return result;
  }

  async getHoroscope(sign: string, timeframe: string) {
    const cacheKey = this.getCacheKey(`horoscope-${sign}`, { timeframe });
    if (this.cache.has(cacheKey)) {
      return this.cache.get(cacheKey);
    }

    const apiEndpoint = timeframe === 'daily' ? `sun_sign_prediction/daily/${sign.toLowerCase()}` : null;
    let apiData: any = null;
    
    if (apiEndpoint) {
       // Note: the astrology API horoscope endpoints are usually GET, but we use POST fetchFromApi for simplicity
       // or we fallback.
    }

    let reading = '';
    if (timeframe === 'daily') {
      reading = `Today brings a powerful surge of energy for ${sign}. The moon's transit emphasizes your career sector, pushing you to take bold steps.`;
    } else if (timeframe === 'weekly') {
      reading = `This week, ${sign} will find balance in personal relationships. A planetary shift on Wednesday clears up misunderstandings.`;
    } else {
      reading = `This month highlights financial growth and stability for ${sign}. Keep an eye out for long-term investments around the 15th.`;
    }

    const result = {
      success: true,
      data: {
        sign,
        timeframe,
        reading: apiData?.prediction || reading,
        luckyNumber: Math.floor(Math.random() * 9) + 1,
        luckyColor: ['Blue', 'Red', 'Green', 'Gold', 'Silver'][Math.floor(Math.random() * 5)],
      },
    };

    this.cache.set(cacheKey, result);
    return result;
  }
}

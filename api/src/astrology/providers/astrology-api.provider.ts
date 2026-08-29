import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AstrologyDataProvider, PanchangResponse, PlanetaryPosition, ProviderMetadata } from '../interfaces/astrology-data-provider.interface';
import { LocationData } from '../../core/location/location.service';
import { startOfDay, endOfDay } from 'date-fns';

@Injectable()
export class AstrologyApiProvider implements AstrologyDataProvider {
  private readonly logger = new Logger(AstrologyApiProvider.name);

  constructor(private configService: ConfigService) {}

  private createMetadata(date: Date, providerVersion: string = 'api-v1'): ProviderMetadata {
    return {
      provider: 'AstrologyAPI',
      providerVersion,
      calculationVersion: '1.0.0',
      calculatedAt: new Date(),
      validFrom: startOfDay(date),
      validUntil: endOfDay(date),
    };
  }

  private async fetchFromApi(endpoint: string, payload: any): Promise<any> {
    const userId = this.configService.get<string>('ASTROLOGY_USER_ID') || '657466';
    const apiKey = this.configService.get<string>('ASTROLOGY_API_KEY') || 'ak-dbf59adeb917e54a4f3eb845c26e6181acf1e707';

    if (!userId || !apiKey) {
      throw new Error('Astrology API credentials missing');
    }

    const auth = Buffer.from(`${userId}:${apiKey}`).toString('base64');
    
    const response = await fetch(`https://json.astrologyapi.com/v1/${endpoint}`, {
      method: 'POST',
      headers: {
        'Authorization': `Basic ${auth}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      const errorText = await response.text();
      this.logger.error(`API Error ${response.status}: ${errorText}`);
      require('fs').writeFileSync('astrology_api_error.txt', `Provider Error ${response.status}: ${errorText}\n`);
      throw new Error(`AstrologyAPI Error: ${errorText}`);
    }

    return await response.json();
  }

  private getApiPayload(date: Date, location: LocationData) {
    return {
      day: date.getDate(),
      month: date.getMonth() + 1,
      year: date.getFullYear(),
      hour: date.getHours(),
      min: date.getMinutes(),
      lat: location.latitude,
      lon: location.longitude,
      tzone: parseFloat(location.timeZone) || 5.5,
    };
  }

  async getPlanetaryPositions(date: Date, location: LocationData): Promise<{ data: Record<string, PlanetaryPosition>; meta: ProviderMetadata }> {
    const payload = this.getApiPayload(date, location);
    const apiData = await this.fetchFromApi('planets', payload);
    
    // Map apiData array to Record<string, PlanetaryPosition> (pseudo-implementation)
    const data: Record<string, PlanetaryPosition> = {};
    if (Array.isArray(apiData)) {
       apiData.forEach((p: any) => {
         data[p.name] = {
           name: p.name,
           longitude: p.normDegree,
           sign: p.sign,
           degree: p.normDegree,
           house: p.house,
           isRetrograde: p.isRetro === 'true',
           nakshatra: p.nakshatra,
           pada: p.nakshatra_pada,
           speed: p.speed,
         };
       });
    }

    return { data, meta: this.createMetadata(date) };
  }

  async getBirthChart(dob: Date, time: string, location: LocationData): Promise<{ data: any; meta: ProviderMetadata }> {
    const payload = this.getApiPayload(dob, location);
    const apiData = await this.fetchFromApi('astro_details', payload);
    return { data: apiData, meta: this.createMetadata(dob) };
  }

  async getPanchang(date: Date, location: LocationData): Promise<{ data: PanchangResponse; meta: ProviderMetadata }> {
    const payload = this.getApiPayload(date, location);
    const apiData = await this.fetchFromApi('advanced_panchang', payload);
    
    return {
      data: {
        tithi: apiData.tithi?.details?.tithi_name || '',
        vara: apiData.day || '',
        nakshatra: apiData.nakshatra?.details?.nak_name || '',
        yoga: apiData.yoga?.details?.yoga_name || '',
        karana: apiData.karana?.details?.karana_name || '',
        sunrise: apiData.sunrise || '',
        sunset: apiData.sunset || '',
        moonrise: apiData.moonrise || '',
        moonset: apiData.moonset || '',
        rahuKaal: { start: apiData.rahukaal?.start || '', end: apiData.rahukaal?.end || '' },
        yamaganda: { start: apiData.yamghant_kaal?.start || '', end: apiData.yamghant_kaal?.end || '' },
        gulika: { start: apiData.guliKaal?.start || '', end: apiData.guliKaal?.end || '' },
      },
      meta: this.createMetadata(date),
    };
  }
}

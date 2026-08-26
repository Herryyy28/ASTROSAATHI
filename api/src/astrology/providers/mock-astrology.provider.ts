import { Injectable } from '@nestjs/common';
import { AstrologyDataProvider, PanchangResponse, PlanetaryPosition, ProviderMetadata } from '../interfaces/astrology-data-provider.interface';
import { LocationData } from '../../core/location/location.service';
import { addHours, startOfDay, endOfDay } from 'date-fns';

@Injectable()
export class MockAstrologyProvider implements AstrologyDataProvider {
  private createMetadata(date: Date, providerVersion: string = '1.0.0'): ProviderMetadata {
    return {
      provider: 'MockAstrologyProvider',
      providerVersion,
      calculationVersion: '1.0.0',
      calculatedAt: new Date(),
      validFrom: startOfDay(date),
      validUntil: endOfDay(date),
    };
  }

  async getPlanetaryPositions(date: Date, location: LocationData): Promise<{ data: Record<string, PlanetaryPosition>; meta: ProviderMetadata }> {
    return {
      data: {
        sun: { name: 'Sun', longitude: 15.5, sign: 'Aries', degree: 15, house: 1, isRetrograde: false, nakshatra: 'Ashwini', pada: 1, speed: 1.0 },
        moon: { name: 'Moon', longitude: 45.2, sign: 'Taurus', degree: 15, house: 2, isRetrograde: false, nakshatra: 'Rohini', pada: 2, speed: 13.5 },
      },
      meta: this.createMetadata(date, 'mock-1.0'),
    };
  }

  async getBirthChart(dob: Date, time: string, location: LocationData): Promise<{ data: any; meta: ProviderMetadata }> {
    return {
      data: {
        ascendant: 'Leo',
        houses: [],
      },
      meta: this.createMetadata(dob, 'mock-1.0'),
    };
  }

  async getPanchang(date: Date, location: LocationData): Promise<{ data: PanchangResponse; meta: ProviderMetadata }> {
    return {
      data: {
        tithi: 'Shukla Paksha Dashami',
        vara: 'Wednesday',
        nakshatra: 'Rohini',
        yoga: 'Shiva',
        karana: 'Taitila',
        sunrise: '06:12 AM',
        sunset: '06:45 PM',
        moonrise: '08:00 PM',
        moonset: '07:30 AM',
        rahuKaal: { start: '12:00 PM', end: '01:30 PM' },
        yamaganda: { start: '07:30 AM', end: '09:00 AM' },
        gulika: { start: '10:30 AM', end: '12:00 PM' },
      },
      meta: this.createMetadata(date, 'mock-1.0'),
    };
  }
}

import { LocationData } from '../../core/location/location.service';

export interface PlanetaryPosition {
  name: string;
  longitude: number;
  sign: string;
  degree: number;
  house: number;
  isRetrograde: boolean;
  nakshatra: string;
  pada: number;
  speed: number;
}

export interface PanchangResponse {
  tithi: string;
  vara: string;
  nakshatra: string;
  yoga: string;
  karana: string;
  sunrise: string;
  sunset: string;
  moonrise: string;
  moonset: string;
  rahuKaal: { start: string; end: string };
  yamaganda: { start: string; end: string };
  gulika: { start: string; end: string };
}

export interface ProviderMetadata {
  provider: string;
  providerVersion: string;
  calculationVersion: string;
  calculatedAt: Date;
  validFrom: Date;
  validUntil: Date;
}

export interface AstrologyDataProvider {
  getPlanetaryPositions(date: Date, location: LocationData): Promise<{ data: Record<string, PlanetaryPosition>, meta: ProviderMetadata }>;
  getBirthChart(dob: Date, time: string, location: LocationData): Promise<{ data: any, meta: ProviderMetadata }>;
  getPanchang(date: Date, location: LocationData): Promise<{ data: PanchangResponse, meta: ProviderMetadata }>;
}

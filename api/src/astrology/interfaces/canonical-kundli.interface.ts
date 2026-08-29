export interface CanonicalKundli {
  profileId: string;
  birthDetails: {
    date: string;
    time: string;
    location: string;
    latitude: number;
    longitude: number;
    timezone: string;
  };
  lagna: {
    rashi: string;
    degree: number;
  };
  rashi: {
    id: string;
    name: string;
    englishName: string;
    degree: number;
  };
  planets: CanonicalPlanet[];
  houses: any[];
  nakshatra: Record<string, any>;
  dasha: Record<string, any>;
  yogas: any[];
  aspects: any[];
  calculatedAt: string;
  calculationVersion: string;
}

export interface CanonicalPlanet {
  id: string;
  name: string;
  rashi: string;
  rashiId: string;
  house: number;
  degree: number;
  nakshatra: string;
  pada: number;
  retrograde: boolean;
}

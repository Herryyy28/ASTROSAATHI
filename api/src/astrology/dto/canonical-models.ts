export interface CanonicalPanchang {
  tithi: string;
  vara: string;
  nakshatra: string;
  yoga: string;
  karana: string;
  sunrise: string;
  sunset: string;
  rahuKaal: { start: string; end: string } | null;
  calculatedAt: string; // ISO String
}

export interface CanonicalMuhurat {
  category: string;
  bestWindow: { start: string; end: string };
  avoidWindow: { start: string; end: string } | null;
  strength: string;
  bestFor: string;
  calculatedAt: string;
}

export interface CanonicalGamePlan {
  date: string;
  dayScore: number;
  doList: string[];
  beCarefulList: string[];
  avoidList: string[];
  bestWindow: { start: string; end: string };
  categories: Record<string, number>;
  calculatedAt: string;
}

export interface CanonicalPlanet {
  id: string;
  name: string;
  longitude: number;
  degree: number;
  sign: string;
  signId: number;
  house: number;
  nakshatra: string;
  pada: number;
  retrograde: boolean;
  speed: number;
}

export interface CanonicalBirthChart {
  ascendant: string;
  ascendantDegree: number;
  planets: CanonicalPlanet[];
  houses: { houseNumber: number; sign: string; signId: number; planets: string[] }[];
  calculatedAt: string;
}

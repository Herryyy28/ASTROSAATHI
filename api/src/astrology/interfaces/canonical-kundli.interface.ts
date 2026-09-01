export interface CanonicalKundli {
  readonly profileId: string;
  readonly birthDetails: {
    readonly date: string;
    readonly time: string;
    readonly location: string;
    readonly latitude: number;
    readonly longitude: number;
    readonly timezone: string;
  };
  readonly lagna: {
    readonly rashi: string;
    readonly degree: number;
  };
  readonly rashi: {
    readonly id: string;
    readonly name: string;
    readonly englishName: string;
    readonly degree: number;
  };
  readonly planets: readonly CanonicalPlanet[];
  readonly houses: readonly any[];
  readonly nakshatra: Readonly<Record<string, any>>;
  readonly dasha: Readonly<Record<string, any>>;
  readonly yogas: readonly any[];
  readonly aspects: readonly any[];
  readonly calculatedAt: string;
  readonly calculationVersion: string;
}

export interface CanonicalPlanet {
  readonly id: string;
  readonly name: string;
  readonly rashi: string;
  readonly rashiId: string;
  readonly house: number;
  readonly degree: number;
  readonly nakshatra: string;
  readonly pada: number;
  readonly retrograde: boolean;
}

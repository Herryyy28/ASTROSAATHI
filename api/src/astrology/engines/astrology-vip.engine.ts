import { Injectable } from '@nestjs/common';

export interface BirthDetailsInput {
  dob: string; // YYYY-MM-DD
  tob: string; // HH:mm
  lat: number;
  lng: number;
  tz?: number;
  name?: string;
}

export interface YearAheadMonth {
  month: string;
  focus: string;
  score: number; // 1 - 100
  career: string;
  relationship: string;
  finance: string;
  health: string;
  importantDates: string[];
}

export interface RadarEvent {
  dayOffset: number;
  date: string;
  title: string;
  category: 'Transit' | 'Dasha' | 'Eclipse' | 'Relationship' | 'Career';
  rating: 'Favorable' | 'Caution' | 'Neutral' | 'High Impact';
  description: string;
}

export interface DateComparisonResult {
  date: string;
  rating: 'Strong' | 'Moderate' | 'Caution';
  score: number;
  favorableWindow: string;
  planetarySupport: string;
  cautionNotice?: string;
}

export interface AspectMatrixItem {
  personAPlanet: String;
  personBPlanet: String;
  aspectType: 'Trine' | 'Square' | 'Conjunction' | 'Opposition' | 'Sextile';
  harmonyScore: number;
  interpretation: string;
}

export interface RelocationCityResult {
  city: String;
  country: String;
  dominantLine: String;
  careerImpact: String;
  relationshipImpact: String;
  overallVibe: 'Highly Favorable' | 'Growth & Challenge' | 'Harmonic & Peaceful';
}

@Injectable()
export class VipIntelligenceEngine {
  /**
   * 1. Personal Year Ahead Roadmap (Jan - Dec)
   */
  generateYearAheadRoadmap(input: BirthDetailsInput, targetYear: number = 2026) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    const focuses = [
      'Career Expansion & Leadership',
      'Relationships & Emotional Harmony',
      'Financial Growth & Investments',
      'Health & Spiritual Renewal',
      'Creative Endeavors & Education',
      'Partnerships & Public Standing',
      'Internal Growth & Meditation',
      'Travel & Global Opportunities',
      'Career Promotion & Authority',
      'Social Connections & Wealth',
      'Introspection & Planning',
      'Yearly Culmination & Rewards',
    ];

    const roadmap: YearAheadMonth[] = months.map((month, idx) => {
      const baseScore = 65 + ((idx * 7 + input.lat) % 30);
      return {
        month: `${month} ${targetYear}`,
        focus: focuses[idx],
        score: Math.min(98, Math.max(60, baseScore)),
        career: `Promising developments in ${month}. Key alignments favor decision-making around the ${(idx * 3 + 5) % 28 + 1}th.`,
        relationship: `Harmonic communication cycles active. Best period for meaningful conversations: ${(idx * 4 + 8) % 28 + 1}th.`,
        finance: `Positive liquidity flow expected. Favorable investment window: ${(idx * 2 + 10) % 28 + 1}th - ${(idx * 2 + 15) % 28 + 1}th.`,
        health: `High physical vitality. Maintain consistent sleep schedule around full moon cycles.`,
        importantDates: [
          `${targetYear}-${(idx + 1).toString().padStart(2, '0')}-05`,
          `${targetYear}-${(idx + 1).toString().padStart(2, '0')}-18`,
          `${targetYear}-${(idx + 1).toString().padStart(2, '0')}-27`,
        ],
      };
    });

    return {
      year: targetYear,
      overallEnergy: 'Year of Strategic Growth & Relationship Alignment',
      yearScore: 88,
      primaryMahadasha: 'Jupiter',
      activeAntardasha: 'Mercury',
      roadmap,
    };
  }

  /**
   * 2. 90-Day Future Radar
   */
  generate90DayFutureRadar(input: BirthDetailsInput) {
    const today = new Date();
    const radarEvents: RadarEvent[] = [
      {
        dayOffset: 4,
        date: new Date(today.getTime() + 4 * 86400000).toISOString().split('T')[0],
        title: 'Jupiter Trine Natal Sun',
        category: 'Transit',
        rating: 'Favorable',
        description: 'High confidence & expansion window for negotiations and leadership.',
      },
      {
        dayOffset: 14,
        date: new Date(today.getTime() + 14 * 86400000).toISOString().split('T')[0],
        title: 'Mercury Antardasha Shift',
        category: 'Dasha',
        rating: 'High Impact',
        description: 'New 4-month sub-period activating intellect, trade, and media opportunities.',
      },
      {
        dayOffset: 28,
        date: new Date(today.getTime() + 28 * 86400000).toISOString().split('T')[0],
        title: 'Solar Eclipse in 10th House',
        category: 'Eclipse',
        rating: 'Caution',
        description: 'Avoid impulsive career announcements; reflect on long-term authority.',
      },
      {
        dayOffset: 45,
        date: new Date(today.getTime() + 45 * 86400000).toISOString().split('T')[0],
        title: 'Venus Trine Natal Moon',
        category: 'Relationship',
        rating: 'Favorable',
        description: 'Peak emotional harmony & romantic alignment window.',
      },
      {
        dayOffset: 65,
        date: new Date(today.getTime() + 65 * 86400000).toISOString().split('T')[0],
        title: 'Mars Transit 10th House',
        category: 'Career',
        rating: 'High Impact',
        description: 'High drive & execution speed. Channel energy productively to avoid friction.',
      },
      {
        dayOffset: 82,
        date: new Date(today.getTime() + 82 * 86400000).toISOString().split('T')[0],
        title: 'Saturn Direct Gochar',
        category: 'Transit',
        rating: 'Favorable',
        description: 'Structural clarity returns; long-term delayed plans gain momentum.',
      },
    ];

    return {
      generatedAt: today.toISOString(),
      rangeDays: 90,
      totalEvents: radarEvents.length,
      favorableCount: 3,
      cautionCount: 1,
      events: radarEvents,
    };
  }

  /**
   * 3. Personal Timing Engine & Date Comparison
   */
  evaluatePersonalTiming(activity: string, dates: string[]) {
    const results: DateComparisonResult[] = dates.map((dateStr, idx) => {
      const dayNum = parseInt(dateStr.split('-')[2] || '15', 10);
      const isStrong = (dayNum % 3 === 0) || idx === 0;
      const isCaution = (dayNum % 5 === 0) && !isStrong;

      return {
        date: dateStr,
        rating: isStrong ? 'Strong' : isCaution ? 'Caution' : 'Moderate',
        score: isStrong ? 88 + (dayNum % 10) : isCaution ? 54 : 72 + (dayNum % 10),
        favorableWindow: isStrong ? '10:15 AM - 12:30 PM (Abhijit Muhurat)' : '02:00 PM - 04:15 PM',
        planetarySupport: `Supported by ${isStrong ? 'Jupiter & Moon' : 'Venus & Mercury'} in favorable Nakshatra alignment.`,
        cautionNotice: isCaution ? 'Avoid Rahu Kaal window between 03:00 PM - 04:30 PM.' : undefined,
      };
    });

    return {
      activity,
      recommendedBestDate: results.reduce((best, cur) => cur.score > best.score ? cur : best, results[0]),
      comparisonMatrix: results,
    };
  }

  /**
   * 4. Solar Return & Secondary Progressions Engine
   */
  generateSolarReturn(input: BirthDetailsInput, year: number = 2026) {
    return {
      targetYear: year,
      solarReturnAscendant: 'Leo 14° 22\'',
      solarReturnSunHouse: 1,
      keyTheme: 'Self-Expression, Leadership & Vitality Focus',
      progressedMoonSign: 'Scorpio (8th House Transits)',
      progressedSunSign: 'Taurus 02° 15\'',
      forecastSummary: `The ${year} Solar Return chart places Sun in the 1st House, signaling a major year of personal re-branding, independence, and career visibility.`,
      importantMilestones: [
        { month: 'Quarter 1', note: 'New personal initiatives & physical vitality renewal' },
        { month: 'Quarter 2', note: 'Financial investments & assets acquisition' },
        { month: 'Quarter 3', note: 'Deep emotional shifts via Progressed Moon in Scorpio' },
        { month: 'Quarter 4', note: 'Career recognition & long-term stability' },
      ],
    };
  }

  /**
   * 5. Advanced Synastry & Composite Relationship Engine
   */
  generateSynastryAndComposite(personA: BirthDetailsInput, personB: BirthDetailsInput) {
    const aspectMatrix: AspectMatrixItem[] = [
      {
        personAPlanet: 'Sun',
        personBPlanet: 'Moon',
        aspectType: 'Trine',
        harmonyScore: 95,
        interpretation: 'Deep soul harmony & natural mutual understanding. Person A provides purpose, Person B provides emotional nurturing.',
      },
      {
        personAPlanet: 'Venus',
        personBPlanet: 'Mars',
        aspectType: 'Conjunction',
        harmonyScore: 92,
        interpretation: 'Intense romantic magnetism & mutual attraction. Shared passion and artistic alignment.',
      },
      {
        personAPlanet: 'Saturn',
        personBPlanet: 'Venus',
        aspectType: 'Trine',
        harmonyScore: 86,
        interpretation: 'Long-term commitment & stability foundation. Fosters loyalty and security over time.',
      },
      {
        personAPlanet: 'Mercury',
        personBPlanet: 'Mercury',
        aspectType: 'Sextile',
        harmonyScore: 88,
        interpretation: 'Fluid communication & intellectual rapport. Solves disagreements easily through dialogue.',
      },
    ];

    return {
      personAName: personA.name || 'Person A',
      personBName: personB.name || 'Person B',
      compositeAscendant: 'Libra 18° 05\'',
      compositeSunSign: 'Gemini (9th House)',
      overallCompatibilityScore: 91,
      relationshipTier: 'Soulmate Connection (High Harmony)',
      aspectMatrix,
      growthAreas: 'Balance independence with shared social goals.',
    };
  }

  /**
   * 6. Astrocartography & Relocation Engine
   */
  generateAstrocartography(input: BirthDetailsInput) {
    const relocationCities: RelocationCityResult[] = [
      {
        city: 'Dubai',
        country: 'UAE',
        dominantLine: 'Jupiter Midheaven (MC) Line',
        careerImpact: 'Rapid financial growth & high executive authority.',
        relationshipImpact: 'Expansive social network.',
        overallVibe: 'Highly Favorable',
      },
      {
        city: 'London',
        country: 'UK',
        dominantLine: 'Mercury Ascendant Line',
        careerImpact: 'High intellectual output, media & strategic communication.',
        relationshipImpact: 'Stimulating conversations & analytical connections.',
        overallVibe: 'Highly Favorable',
      },
      {
        city: 'Toronto',
        country: 'Canada',
        dominantLine: 'Venus Descendant (DC) Line',
        careerImpact: 'Creative partnerships & diplomacy.',
        relationshipImpact: 'Harmonic romantic prospects & family peace.',
        overallVibe: 'Harmonic & Peaceful',
      },
      {
        city: 'Tokyo',
        country: 'Japan',
        dominantLine: 'Mars Imum Coeli (IC) Line',
        careerImpact: 'High inner drive & technical mastery.',
        relationshipImpact: 'Dynamic & active domestic environment.',
        overallVibe: 'Growth & Challenge',
      },
    ];

    return {
      birthPlace: `${input.lat}° N, ${input.lng}° E`,
      primaryPowerLine: 'Jupiter MC Line (Wealth & Career Pinnacle)',
      relocationCities,
    };
  }
}

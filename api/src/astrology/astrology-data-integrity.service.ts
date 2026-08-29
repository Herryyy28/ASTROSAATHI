import { Injectable, Logger, ServiceUnavailableException } from '@nestjs/common';
import { CanonicalPanchang, CanonicalMuhurat, CanonicalGamePlan, CanonicalBirthChart } from './dto/canonical-models';

@Injectable()
export class AstrologyDataIntegrityService {
  private readonly logger = new Logger(AstrologyDataIntegrityService.name);

  normalizePanchang(apiData: any): CanonicalPanchang {
    if (!apiData || !apiData.tithi || !apiData.nakshatra) {
      this.logger.error('Invalid Panchang API response payload.');
      throw new ServiceUnavailableException('Astrology data provider returned invalid Panchang structure.');
    }

    return {
      tithi: apiData.tithi.details.tithi_name,
      vara: apiData.day,
      nakshatra: apiData.nakshatra.details.nak_name,
      yoga: apiData.yoga.details.yoga_name,
      karana: apiData.karana.details.karana_name,
      sunrise: apiData.sunrise,
      sunset: apiData.sunset,
      rahuKaal: apiData.rahukaal ? { start: apiData.rahukaal.start, end: apiData.rahukaal.end } : null,
      calculatedAt: new Date().toISOString(),
    };
  }

  normalizeMuhurat(apiData: any, category: string): CanonicalMuhurat {
    if (!apiData) {
      throw new ServiceUnavailableException('Muhurat data missing from provider.');
    }
    
    // Fallback parsing (assuming we get varied API structures depending on the provider)
    return {
      category,
      bestWindow: apiData.bestWindow || { start: 'N/A', end: 'N/A' },
      avoidWindow: apiData.avoidWindow || null,
      strength: apiData.strength || 'Average',
      bestFor: apiData.bestFor || 'Routine activities',
      calculatedAt: new Date().toISOString(),
    };
  }

  normalizeGamePlan(apiData: any, date: string): CanonicalGamePlan {
    if (!apiData) {
      throw new ServiceUnavailableException('Game plan data missing from provider.');
    }

    return {
      date,
      dayScore: typeof apiData.dayScore === 'number' ? apiData.dayScore : 5.0,
      doList: Array.isArray(apiData.doList) ? apiData.doList : [],
      beCarefulList: Array.isArray(apiData.beCarefulList) ? apiData.beCarefulList : [],
      avoidList: Array.isArray(apiData.avoidList) ? apiData.avoidList : [],
      bestWindow: apiData.bestWindow || { start: 'N/A', end: 'N/A' },
      categories: apiData.categories || {},
      calculatedAt: new Date().toISOString(),
    };
  }

  normalizeBirthChart(apiData: any): CanonicalBirthChart {
    if (!apiData || !apiData.ascendant) {
      throw new ServiceUnavailableException('Birth chart data missing required ascendant fields.');
    }

    return {
      ascendant: apiData.ascendant,
      ascendantDegree: apiData.ascendantDegree || 0,
      planets: apiData.planets || [],
      houses: apiData.houses || [],
      calculatedAt: new Date().toISOString(),
    };
  }
}

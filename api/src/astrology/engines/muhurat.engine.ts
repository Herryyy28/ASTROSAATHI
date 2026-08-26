import { Injectable } from '@nestjs/common';
import { PanchangResponse } from '../interfaces/astrology-data-provider.interface';
import { LocationData } from '../../core/location/location.service';
import { TimeService } from '../../core/time/time.service';

@Injectable()
export class MuhuratEngine {
  constructor(private readonly timeService: TimeService) {}

  calculateMuhurat(
    category: string,
    date: Date,
    location: LocationData,
    panchang: PanchangResponse
  ) {
    const tithiString = panchang.tithi || '';
    const isWaxing = tithiString.toLowerCase().includes('shukla');
    const isWaning = tithiString.toLowerCase().includes('krishna');
    
    // Very basic mapping for demonstration
    let tithiNumber = 1;
    if (tithiString.toLowerCase().includes('panchami')) tithiNumber = 5;
    if (tithiString.toLowerCase().includes('dashami')) tithiNumber = 10;
    if (tithiString.toLowerCase().includes('purnima')) tithiNumber = 15;
    if (tithiString.toLowerCase().includes('chaturthi')) tithiNumber = 4;
    if (tithiString.toLowerCase().includes('navami')) tithiNumber = 9;
    if (tithiString.toLowerCase().includes('chaturdashi')) tithiNumber = 14;

    let quality = 'Neutral';
    let specificGuidance = 'A standard day. Proceed with routine activities.';
    let score = 5;

    if (category.toLowerCase().includes('buying house')) {
      if (isWaxing && tithiNumber >= 5 && tithiNumber <= 10) {
        quality = 'Excellent';
        specificGuidance = 'Highly auspicious for real estate transactions. Mars and Moon are aligned.';
        score = 9;
      } else {
        quality = 'Average';
        specificGuidance = 'Check property papers carefully. Not the most powerful alignment for real estate.';
        score = 6;
      }
    } else if (category.toLowerCase().includes('signing contract')) {
      if (isWaxing && tithiNumber !== 4 && tithiNumber !== 9 && tithiNumber !== 14) {
        quality = 'Excellent';
        specificGuidance = 'Favorable alignment for communication and legally binding agreements.';
        score = 8;
      } else {
        quality = 'Poor';
        specificGuidance = 'Rahu Kaal or Rikta tithi is active. Delay signing if possible.';
        score = 3;
      }
    } else if (isWaxing && (tithiNumber === 5 || tithiNumber === 10 || tithiNumber === 15)) {
      quality = 'Excellent';
      specificGuidance = 'Very auspicious timing (Purna Tithi). Ideal for new beginnings.';
      score = 9;
    } else if (isWaning && (tithiNumber === 4 || tithiNumber === 9 || tithiNumber === 14)) {
      quality = 'Poor';
      specificGuidance = 'Inauspicious timing (Rikta Tithi). Avoid major decisions.';
      score = 2;
    }
    
    const isRahuKaalActive = panchang.rahuKaal && panchang.rahuKaal.start !== '';
    
    return {
      success: true,
      data: {
        category,
        quality,
        score,
        specificGuidance,
        bestWindow: { 
          start: '10:15 AM', // Deterministic calculation goes here
          end: '11:45 AM' 
        },
        strength: isRahuKaalActive ? 'Moderate' : 'Excellent',
        bestFor: `Activities related to ${category.toLowerCase()}`,
        avoidWindow: isRahuKaalActive ? panchang.rahuKaal : null,
      }
    };
  }
}

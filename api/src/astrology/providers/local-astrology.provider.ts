import { Injectable, Logger } from '@nestjs/common';
import { AstrologyDataProvider, PanchangResponse, PlanetaryPosition, ProviderMetadata } from '../interfaces/astrology-data-provider.interface';
import { LocationData } from '../../core/location/location.service';
import { startOfDay, endOfDay, format } from 'date-fns';
import { Body, Equator, Ecliptic, Observer, SearchRiseSet } from 'astronomy-engine';

@Injectable()
export class LocalAstrologyProvider implements AstrologyDataProvider {
  private readonly logger = new Logger(LocalAstrologyProvider.name);

  private getAyanamsa(date: Date): number {
    // Simplified Lahiri Ayanamsa: ~24.1 for 2024
    const year = date.getFullYear();
    const t = (year - 2000) / 100;
    return 23.85 + 1.396 * t;
  }

  private createMetadata(date: Date, providerVersion: string = 'local-1.0'): ProviderMetadata {
    return {
      provider: 'LocalAstronomyEngine',
      providerVersion,
      calculationVersion: '1.0.0',
      calculatedAt: new Date(),
      validFrom: startOfDay(date),
      validUntil: endOfDay(date),
    };
  }

  // Zodiac Signs mapping
  private getSignDetails(longitude: number, date: Date): { sign: string; signIndex: number } {
    const signs = [
      'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo', 
      'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
    ];
    const ayanamsa = this.getAyanamsa(date);
    let sidereal = (longitude - ayanamsa) % 360;
    if (sidereal < 0) sidereal += 360;
    
    const signIndex = Math.floor(sidereal / 30);
    return { sign: signs[signIndex], signIndex };
  }

  private getNakshatra(longitude: number, date: Date) {
    const nakshatras = [
      'Ashwini', 'Bharani', 'Krittika', 'Rohini', 'Mrigashira', 'Ardra', 'Punarvasu', 'Pushya', 'Ashlesha',
      'Magha', 'Purva Phalguni', 'Uttara Phalguni', 'Hasta', 'Chitra', 'Swati', 'Vishakha', 'Anuradha', 'Jyeshtha',
      'Mula', 'Purva Ashadha', 'Uttara Ashadha', 'Shravana', 'Dhanishta', 'Shatabhisha', 'Purva Bhadrapada', 'Uttara Bhadrapada', 'Revati'
    ];
    const ayanamsa = this.getAyanamsa(date);
    let sidereal = (longitude - ayanamsa) % 360;
    if (sidereal < 0) sidereal += 360;
    
    const nakshatraIndex = Math.floor(sidereal / (360 / 27));
    const pada = Math.floor((sidereal % (360 / 27)) / (360 / 108)) + 1;
    return { nakshatra: nakshatras[nakshatraIndex], pada };
  }

  private calculatePlanet(body: Body, date: Date, observer: Observer): PlanetaryPosition {
    const eq = Equator(body, date, observer, true, true);
    const ecl = Ecliptic(eq.vec);
    let longitude = ecl.elon;
    if (longitude < 0) longitude += 360;

    const { sign, signIndex } = this.getSignDetails(longitude, date);
    const { nakshatra, pada } = this.getNakshatra(longitude, date);
    const nameMap: Record<string, string> = {
      [Body.Sun]: 'Sun',
      [Body.Moon]: 'Moon',
      [Body.Mars]: 'Mars',
      [Body.Mercury]: 'Mercury',
      [Body.Jupiter]: 'Jupiter',
      [Body.Venus]: 'Venus',
      [Body.Saturn]: 'Saturn',
    };

    return {
      name: nameMap[body] || body.toString(),
      longitude,
      sign,
      degree: longitude % 30,
      house: 1,
      isRetrograde: false,
      nakshatra,
      pada,
      speed: 1.0,
    };
  }

  async getPlanetaryPositions(date: Date, location: LocationData): Promise<{ data: Record<string, PlanetaryPosition>; meta: ProviderMetadata }> {
    try {
      const observer = new Observer(location.latitude, location.longitude, 0);
      
      const bodies = [Body.Sun, Body.Moon, Body.Mars, Body.Mercury, Body.Jupiter, Body.Venus, Body.Saturn];
      const data: Record<string, PlanetaryPosition> = {};
      
      for (const b of bodies) {
        const planetInfo = this.calculatePlanet(b, date, observer);
        data[planetInfo.name.toLowerCase()] = planetInfo;
      }
      
      const moonEq = Equator(Body.Moon, date, observer, true, true);
      const moonEcl = Ecliptic(moonEq.vec);
      const rahuLon = (moonEcl.elon + 180) % 360; // Simplified Rahu/Ketu
      const ketuLon = (rahuLon + 180) % 360;
      
      data['rahu'] = {
        name: 'Rahu',
        longitude: rahuLon,
        sign: this.getSignDetails(rahuLon, date).sign,
        degree: rahuLon % 30,
        house: 1,
        isRetrograde: true,
        nakshatra: this.getNakshatra(rahuLon, date).nakshatra,
        pada: this.getNakshatra(rahuLon, date).pada,
        speed: -0.05,
      };

      data['ketu'] = {
        name: 'Ketu',
        longitude: ketuLon,
        sign: this.getSignDetails(ketuLon, date).sign,
        degree: ketuLon % 30,
        house: 1,
        isRetrograde: true,
        nakshatra: this.getNakshatra(ketuLon, date).nakshatra,
        pada: this.getNakshatra(ketuLon, date).pada,
        speed: -0.05,
      };

      return { data, meta: this.createMetadata(date) };
    } catch (e) {
      this.logger.error('Astronomy engine failed: ' + e);
      throw e;
    }
  }

  async getBirthChart(dob: Date, time: string, location: LocationData): Promise<{ data: any; meta: ProviderMetadata }> {
    const observer = new Observer(location.latitude, location.longitude, 0);
    const sunPos = this.calculatePlanet(Body.Sun, dob, observer);
    
    let hours = dob.getHours() + (dob.getMinutes() / 60);
    if (time && time.includes(':')) {
      const parts = time.split(':');
      hours = parseInt(parts[0], 10) + (parseInt(parts[1], 10) / 60);
    }
    
    // Simplified Ascendant based on Sun position and time since sunrise
    const rise = SearchRiseSet(Body.Sun, observer, 1, dob, 1);
    const sunriseHours = rise ? rise.date.getHours() + (rise.date.getMinutes() / 60) : 6.0;
    
    let timeSinceSunrise = hours - sunriseHours;
    if (timeSinceSunrise < 0) timeSinceSunrise += 24;

    const ascSignIndex = (this.getSignDetails(sunPos.longitude, dob).signIndex + Math.floor(timeSinceSunrise / 2)) % 12;
    const signs = [
      'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo', 
      'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
    ];
    const ascendant = signs[ascSignIndex];
    
    const planetPositions = await this.getPlanetaryPositions(dob, location);
    
    const planetsObj: Record<string, any> = {};
    Object.values(planetPositions.data).forEach(p => {
      const pSignIndex = this.getSignDetails(p.longitude, dob).signIndex;
      let house = ((pSignIndex - ascSignIndex) % 12) + 1;
      if (house <= 0) house += 12;
      planetsObj[p.name] = { ...p, house };
    });

    return {
      data: {
        ascendant,
        planets: planetsObj,
        houses: [],
      },
      meta: this.createMetadata(dob),
    };
  }

  async getPanchang(date: Date, location: LocationData): Promise<{ data: PanchangResponse; meta: ProviderMetadata }> {
    try {
      const observer = new Observer(location.latitude, location.longitude, 0);

      // Accurate Sunrise and Sunset
      const sunrise = SearchRiseSet(Body.Sun, observer, 1, date, 1);
      const sunset = SearchRiseSet(Body.Sun, observer, -1, date, 1);

      const sunEq = Equator(Body.Sun, date, observer, true, true);
      const sunEcl = Ecliptic(sunEq.vec);
      const moonEq = Equator(Body.Moon, date, observer, true, true);
      const moonEcl = Ecliptic(moonEq.vec);

      let sunLon = sunEcl.elon;
      if (sunLon < 0) sunLon += 360;
      let moonLon = moonEcl.elon;
      if (moonLon < 0) moonLon += 360;

      const ayanamsa = this.getAyanamsa(date);
      const siderealMoon = (moonLon - ayanamsa + 360) % 360;
      const siderealSun = (sunLon - ayanamsa + 360) % 360;

      // Tithi (Lunar Day)
      let diff = moonLon - sunLon;
      if (diff < 0) diff += 360;
      const tithiNum = Math.floor(diff / 12) + 1;
      const tithiNames = [
        'Prathama', 'Dwitiya', 'Tritiya', 'Chaturthi', 'Panchami', 'Shashti', 'Saptami', 'Ashtami',
        'Navami', 'Dashami', 'Ekadashi', 'Dwadashi', 'Trayodashi', 'Chaturdashi', 'Purnima',
        'Prathama', 'Dwitiya', 'Tritiya', 'Chaturthi', 'Panchami', 'Shashti', 'Saptami', 'Ashtami',
        'Navami', 'Dashami', 'Ekadashi', 'Dwadashi', 'Trayodashi', 'Chaturdashi', 'Amavasya'
      ];
      const tithi = tithiNames[(tithiNum - 1) % 30];

      // Vara (Weekday)
      const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
      const vara = days[date.getDay()];

      // Nakshatra
      const { nakshatra } = this.getNakshatra(moonLon, date);

      // Yoga
      const yogaSum = (siderealMoon + siderealSun) % 360;
      const yogaNum = Math.floor(yogaSum / (360 / 27)) + 1;
      const yogaNames = [
        'Vishkumbha', 'Preeti', 'Ayushman', 'Saubhagya', 'Shobhana', 'Atiganda', 'Sukarma', 'Dhriti',
        'Shoola', 'Ganda', 'Vriddhi', 'Dhruva', 'Vyaghata', 'Harshana', 'Vajra', 'Siddhi', 'Vyatipata',
        'Variyana', 'Parigha', 'Shiva', 'Siddha', 'Sadhya', 'Shubha', 'Shukla', 'Brahma', 'Indra', 'Vaidhriti'
      ];
      const yoga = yogaNames[(yogaNum - 1) % 27];

      // Karana
      const karanaNum = Math.floor(diff / 6) + 1;
      const karanaNames = ['Bava', 'Balava', 'Kaulava', 'Taitila', 'Gara', 'Vanija', 'Vishti', 'Shakuni', 'Chatushpada', 'Naga', 'Kintughna'];
      let karana = 'Unknown';
      if (karanaNum === 1) karana = 'Kintughna';
      else if (karanaNum >= 2 && karanaNum <= 57) karana = karanaNames[(karanaNum - 2) % 7];
      else karana = karanaNames[karanaNum - 51];

      // Rahu Kaal Calculation (Roughly 1.5 hours based on weekday and sunrise)
      const rahuKaalStarts = [16.5, 7.5, 15.0, 12.0, 13.5, 10.5, 9.0]; // Sun to Sat
      const dayLength = sunset && sunrise ? (sunset.date.getTime() - sunrise.date.getTime()) / 3600000 : 12;
      const startHour = sunrise ? sunrise.date.getHours() + (sunrise.date.getMinutes() / 60) : 6.0;
      const period = dayLength / 8;

      const rahuIdx = [0, 1, 2, 3, 4, 5, 6][date.getDay()];
      const rahuStart = startHour + (rahuKaalStarts[rahuIdx] - 6) * (dayLength / 12);

      return {
        data: {
          tithi,
          vara,
          nakshatra,
          yoga,
          karana,
          sunrise: sunrise ? format(sunrise.date, 'hh:mm a') : '06:00 AM',
          sunset: sunset ? format(sunset.date, 'hh:mm a') : '06:00 PM',
          moonrise: '...',
          moonset: '...',
          rahuKaal: {
            start: format(new Date(date.setHours(Math.floor(rahuStart), (rahuStart % 1) * 60)), 'HH:mm'),
            end: format(new Date(date.setHours(Math.floor(rahuStart + period), ((rahuStart + period) % 1) * 60)), 'HH:mm')
          },
          yamaganda: { start: '07:30', end: '09:00' },
          gulika: { start: '10:30', end: '12:00' },
        },
        meta: this.createMetadata(date),
      };
    } catch (e) {
      this.logger.error('Failed to calculate Panchang: ' + e);
      throw e;
    }
  }
}

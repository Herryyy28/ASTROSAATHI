import { Injectable, Logger } from '@nestjs/common';
import { AstrologyDataProvider, PanchangResponse, PlanetaryPosition, ProviderMetadata } from '../interfaces/astrology-data-provider.interface';
import { LocationData } from '../../core/location/location.service';
import { startOfDay, endOfDay } from 'date-fns';
import { Astronomy, Body } from 'astronomy-engine';

@Injectable()
export class LocalAstrologyProvider implements AstrologyDataProvider {
  private readonly logger = new Logger(LocalAstrologyProvider.name);

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
  private getSignDetails(longitude: number): { sign: string; signIndex: number } {
    const signs = [
      'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo', 
      'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
    ];
    // Nirayana (Sidereal) approximation: Ayonamsa is approx 24 degrees
    const ayanamsa = 24.1;
    let sidereal = (longitude - ayanamsa) % 360;
    if (sidereal < 0) sidereal += 360;
    
    const signIndex = Math.floor(sidereal / 30);
    return { sign: signs[signIndex], signIndex };
  }

  private getNakshatra(longitude: number) {
    const nakshatras = [
      'Ashwini', 'Bharani', 'Krittika', 'Rohini', 'Mrigashira', 'Ardra', 'Punarvasu', 'Pushya', 'Ashlesha',
      'Magha', 'Purva Phalguni', 'Uttara Phalguni', 'Hasta', 'Chitra', 'Swati', 'Vishakha', 'Anuradha', 'Jyeshtha',
      'Mula', 'Purva Ashadha', 'Uttara Ashadha', 'Shravana', 'Dhanishta', 'Shatabhisha', 'Purva Bhadrapada', 'Uttara Bhadrapada', 'Revati'
    ];
    const ayanamsa = 24.1;
    let sidereal = (longitude - ayanamsa) % 360;
    if (sidereal < 0) sidereal += 360;
    
    const nakshatraIndex = Math.floor(sidereal / (360 / 27));
    const pada = Math.floor((sidereal % (360 / 27)) / (360 / 108)) + 1;
    return { nakshatra: nakshatras[nakshatraIndex], pada };
  }

  private calculatePlanet(body: Body, date: Date, observer: any): PlanetaryPosition {
    const eq = Astronomy.Equator(body, date, observer, true, true);
    const ecl = Astronomy.Ecliptic(eq.vec);
    let longitude = ecl.lon;
    if (longitude < 0) longitude += 360;

    const { sign, signIndex } = this.getSignDetails(longitude);
    const { nakshatra, pada } = this.getNakshatra(longitude);
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
      name: nameMap[body],
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
      const observer = Astronomy.MakeObserver(location.latitude, location.longitude, 0);
      
      const bodies = [Body.Sun, Body.Moon, Body.Mars, Body.Mercury, Body.Jupiter, Body.Venus, Body.Saturn];
      const data: Record<string, PlanetaryPosition> = {};
      
      for (const b of bodies) {
        const planetInfo = this.calculatePlanet(b, date, observer);
        data[planetInfo.name.toLowerCase()] = planetInfo;
      }
      
      const sunEcl = Astronomy.Ecliptic(Astronomy.Equator(Body.Sun, date, observer, true, true).vec);
      const moonEcl = Astronomy.Ecliptic(Astronomy.Equator(Body.Moon, date, observer, true, true).vec);
      const rahuLon = (moonEcl.lon + 180) % 360;
      const ketuLon = (rahuLon + 180) % 360;
      
      data['rahu'] = {
        name: 'Rahu',
        longitude: rahuLon,
        sign: this.getSignDetails(rahuLon).sign,
        degree: rahuLon % 30,
        house: 1,
        isRetrograde: true,
        nakshatra: this.getNakshatra(rahuLon).nakshatra,
        pada: this.getNakshatra(rahuLon).pada,
        speed: -0.05,
      };

      data['ketu'] = {
        name: 'Ketu',
        longitude: ketuLon,
        sign: this.getSignDetails(ketuLon).sign,
        degree: ketuLon % 30,
        house: 1,
        isRetrograde: true,
        nakshatra: this.getNakshatra(ketuLon).nakshatra,
        pada: this.getNakshatra(ketuLon).pada,
        speed: -0.05,
      };

      return { data, meta: this.createMetadata(date) };
    } catch (e) {
      this.logger.error('Astronomy engine failed: ' + e);
      throw e;
    }
  }

  async getBirthChart(dob: Date, time: string, location: LocationData): Promise<{ data: any; meta: ProviderMetadata }> {
    const observer = Astronomy.MakeObserver(location.latitude, location.longitude, 0);
    const sunPos = this.calculatePlanet(Body.Sun, dob, observer);
    
    let hours = dob.getHours() + (dob.getMinutes() / 60);
    if (time && time.includes(':')) {
      const parts = time.split(':');
      hours = parseInt(parts[0], 10) + (parseInt(parts[1], 10) / 60);
    }
    
    let shift = (hours - 6) / 2;
    if (shift < 0) shift += 12;
    
    const ascSignIndex = (this.getSignDetails(sunPos.longitude).signIndex + Math.floor(shift)) % 12;
    const signs = [
      'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo', 
      'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
    ];
    const ascendant = signs[ascSignIndex];
    
    const planetPositions = await this.getPlanetaryPositions(dob, location);
    
    const planetsObj: Record<string, any> = {};
    Object.values(planetPositions.data).forEach(p => {
      const pSignIndex = this.getSignDetails(p.longitude).signIndex;
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
    return {
      data: {
        tithi: 'Calculated Tithi',
        vara: 'Calculated Vara',
        nakshatra: 'Calculated Nakshatra',
        yoga: 'Calculated Yoga',
        karana: 'Calculated Karana',
        sunrise: '06:00 AM',
        sunset: '06:00 PM',
        moonrise: '...',
        moonset: '...',
        rahuKaal: { start: '12:00', end: '13:30' },
        yamaganda: { start: '07:30', end: '09:00' },
        gulika: { start: '10:30', end: '12:00' },
      },
      meta: this.createMetadata(date),
    };
  }
}

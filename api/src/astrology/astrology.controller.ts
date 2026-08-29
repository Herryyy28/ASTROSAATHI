import { Controller, Get, Query, Req, UseGuards } from '@nestjs/common';
import { AstrologyService } from './astrology.service';
import { AstrologySyncService } from './astrology-sync.service';
import { GamePlanEngine } from './engines/game-plan.engine';
import { MuhuratEngine } from './engines/muhurat.engine';
import { UsersService } from '../users/users.service';
import { AuthGuard } from '../auth/auth.guard';

import { MatchingService } from './matching.service';

@Controller('astrology')
export class AstrologyController {
  constructor(
    private readonly astrologyService: AstrologyService,
    private readonly syncService: AstrologySyncService,
    private readonly gamePlanEngine: GamePlanEngine,
    private readonly muhuratEngine: MuhuratEngine,
    private readonly usersService: UsersService,
    private readonly matchingService: MatchingService,
  ) { }

  private parseLocation(dateStr: string, timeStr: string, lat: string, lon: string, tz: string) {
    let date = new Date();
    if (dateStr) {
      date = new Date(dateStr);
      // Fallback for DD/MM/YYYY or DD-MM-YYYY
      if (isNaN(date.getTime())) {
        const parts = dateStr.split(/[-/]/);
        if (parts.length === 3) {
          date = new Date(`${parts[2]}-${parts[1]}-${parts[0]}T00:00:00`);
        }
      }
      if (isNaN(date.getTime())) {
        date = new Date();
      }
    }
    
    // Merge timeStr (HH:mm) into the Date object
    if (timeStr && timeStr.includes(':')) {
       const [hh, mm] = timeStr.split(':');
       date.setHours(parseInt(hh, 10) || 12);
       date.setMinutes(parseInt(mm, 10) || 0);
    }
    const location = {
      latitude: parseFloat(lat) || 28.6139,
      longitude: parseFloat(lon) || 77.2090,
      timeZone: tz || '5.5',
    };
    return { date, location };
  }

  @Get('game-plan')
  @UseGuards(AuthGuard)
  async getGamePlan(
    @Req() req: any,
    @Query('date') dateStr: string,
    @Query('lat') lat: string,
    @Query('lon') lon: string,
    @Query('tz') tz: string,
  ) {
    const { date, location } = this.parseLocation(dateStr, '12:00', lat, lon, tz);
    const { panchang, planets } = await this.syncService.getCombinedData(date, location);

    let focusWeights = { Career: 1.0, Love: 1.0, Money: 1.0 };
    try {
      // req.user is injected by AuthGuard
      const profile = await this.usersService.getProfile(req.user.uid);
      if (profile && profile.focusWeights) {
        focusWeights = profile.focusWeights as any;
      }
    } catch (e) {
      // Fallback to default if profile not found
      console.log('Profile not found, using default focus weights');
    }

    return this.gamePlanEngine.generateDailyGamePlan(date, planets, panchang, focusWeights);
  }

  @Get('panchang')
  async getPanchang(
    @Query('date') dateStr: string,
    @Query('lat') lat: string,
    @Query('lon') lon: string,
    @Query('tz') tz: string,
  ) {
    const { date, location } = this.parseLocation(dateStr, '12:00', lat, lon, tz);
    return this.syncService.syncPanchang(date, location);
  }

  @Get('muhurat')
  async getMuhurat(
    @Query('category') category: string,
    @Query('date') dateStr: string,
    @Query('lat') lat: string,
    @Query('lon') lon: string,
    @Query('tz') tz: string,
  ) {
    const { date, location } = this.parseLocation(dateStr, '12:00', lat, lon, tz);
    const { panchang } = await this.syncService.getCombinedData(date, location);
    return this.muhuratEngine.calculateMuhurat(category || 'General', date, location, panchang);
  }

  @Get('birth-chart')
  async getBirthChart(
    @Query('date') dateStr: string,
    @Query('time') timeStr: string,
    @Query('lat') lat: string,
    @Query('lon') lon: string,
    @Query('tz') tz: string,
  ) {
    const { date, location } = this.parseLocation(dateStr, timeStr || '12:00', lat, lon, tz);

    // Fetch both astro details and planetary positions
    const [chart, planets] = await Promise.all([
      this.syncService.syncBirthChart(date, timeStr || '12:00', location),
      this.syncService.syncPlanetaryPositions(date, location)
    ]);

    // Inject the real planets into the response so the UI Kundli can draw them!
    if (chart && chart.data) {
      chart.data.planets = planets.data;
    }

    return chart;
  }

  @Get('horoscope')
  async getHoroscope(
    @Query('sign') sign: string,
    @Query('timeframe') timeframe: string,
  ) {
    return this.astrologyService.getHoroscope(sign || 'Aries', timeframe || 'daily');
  }

  @Get('match')
  async getMatch(
    @Query('p1Sign') p1Sign: string,
    @Query('p2Sign') p2Sign: string,
  ) {
    return this.matchingService.calculateGunMilan(p1Sign || 'Aries', p2Sign || 'Leo');
  }
}
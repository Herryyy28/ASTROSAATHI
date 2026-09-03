import { Controller, Post, Body, Req, UseGuards } from '@nestjs/common';
import { AiService } from './ai.service';
import { AuthGuard } from '../auth/auth.guard';

@Controller('ai')
@UseGuards(AuthGuard)
export class AiController {
  constructor(private readonly aiService: AiService) {}

  @Post('ask-astro-baba')
  async askAstroBaba(
    @Req() req: any,
    @Body('question') question: string,
    @Body('date') dateStr: string,
    @Body('lat') lat: number,
    @Body('lon') lon: number,
    @Body('tz') tz: string,
  ) {
    const userId = req.user.uid;
    const date = dateStr ? new Date(dateStr) : new Date();
    const location = {
      latitude: lat || 28.6139,
      longitude: lon || 77.2090,
      timeZone: tz || '5.5',
    };
    return this.aiService.askAstroBaba(question, date, location);
  }
}

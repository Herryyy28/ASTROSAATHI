import { Controller, Post, Body } from '@nestjs/common';
import { AiService } from './ai.service';

@Controller('ai')
export class AiController {
  constructor(private readonly aiService: AiService) {}

  @Post('ask-astro-baba')
  async askAstroBaba(
    @Body('question') question: string,
    @Body('date') dateStr: string,
    @Body('lat') lat: number,
    @Body('lon') lon: number,
    @Body('tz') tz: string,
  ) {
    const date = dateStr ? new Date(dateStr) : new Date();
    const location = {
      latitude: lat || 28.6139,
      longitude: lon || 77.2090,
      timeZone: tz || '5.5',
    };
    return this.aiService.askAstroBaba(question, date, location);
  }
}

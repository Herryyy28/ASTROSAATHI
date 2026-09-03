import { Controller, Get, Post, Delete, Patch, Body, Param, Query, Req, UseGuards } from '@nestjs/common';
import { RemindersService, CreateReminderDto } from './reminders.service';
import { EventCategory } from '../database/entities/reminder.entity';
import { AuthGuard } from '../auth/auth.guard';

@Controller('reminders')
@UseGuards(AuthGuard)
export class RemindersController {
  constructor(private readonly remindersService: RemindersService) {}

  @Post()
  async createReminder(@Req() req: any, @Body() dto: CreateReminderDto) {
    const userId = req.user.uid;
    const reminder = await this.remindersService.createReminder({
      ...dto,
      userId,
    });
    return {
      success: true,
      data: reminder,
    };
  }

  @Get()
  async getUserReminders(@Req() req: any) {
    const userId = req.user.uid;
    const reminders = await this.remindersService.getUserReminders(userId);
    return {
      success: true,
      count: reminders.length,
      data: reminders,
    };
  }

  @Get('score-check')
  async checkEventScore(
    @Query('category') category: EventCategory,
    @Query('eventTime') eventTime: string,
  ) {
    const date = eventTime ? new Date(eventTime) : new Date();
    const score = this.remindersService.calculateAstroAlignmentScore(category || EventCategory.BUSINESS, date);
    return {
      success: true,
      astroScore: score,
      eventTime: date.toISOString(),
      category: category || EventCategory.BUSINESS,
    };
  }

  @Patch(':id/toggle')
  async toggleReminder(
    @Req() req: any,
    @Param('id') id: string,
    @Body('enabled') enabled: boolean,
  ) {
    const userId = req.user.uid;
    const updated = await this.remindersService.toggleReminderEnabled(id, userId, enabled);
    return {
      success: true,
      data: updated,
    };
  }

  @Delete(':id')
  async deleteReminder(@Req() req: any, @Param('id') id: string) {
    const userId = req.user.uid;
    const success = await this.remindersService.deleteReminder(id, userId);
    return {
      success,
    };
  }
}

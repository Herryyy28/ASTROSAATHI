import { Controller, Get, Post, Delete, Patch, Body, Param, Query, UseGuards } from '@nestjs/common';
import { RemindersService, CreateReminderDto } from './reminders.service';
import { EventCategory } from '../database/entities/reminder.entity';

@Controller('reminders')
export class RemindersController {
  constructor(private readonly remindersService: RemindersService) {}

  @Post()
  async createReminder(@Body() dto: CreateReminderDto) {
    const reminder = await this.remindersService.createReminder(dto);
    return {
      success: true,
      data: reminder,
    };
  }

  @Get()
  async getUserReminders(@Query('userId') userId: string) {
    const reminders = await this.remindersService.getUserReminders(userId || 'guest-user');
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
    @Param('id') id: string,
    @Query('userId') userId: string,
    @Body('enabled') enabled: boolean,
  ) {
    const updated = await this.remindersService.toggleReminderEnabled(id, userId || 'guest-user', enabled);
    return {
      success: true,
      data: updated,
    };
  }

  @Delete(':id')
  async deleteReminder(@Param('id') id: string, @Query('userId') userId: string) {
    const success = await this.remindersService.deleteReminder(id, userId || 'guest-user');
    return {
      success,
    };
  }
}

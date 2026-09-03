import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Reminder, EventCategory } from '../database/entities/reminder.entity';

export interface CreateReminderDto {
  userId: string;
  title: string;
  category: EventCategory;
  eventTime: string; // ISO String
  notes?: string;
  leadTimeMinutes?: number;
}

@Injectable()
export class RemindersService {
  constructor(
    @InjectRepository(Reminder)
    private readonly reminderRepository: Repository<Reminder>,
  ) {}

  async createReminder(dto: CreateReminderDto): Promise<Reminder> {
    const eventDate = new Date(dto.eventTime);
    const score = this.calculateAstroAlignmentScore(dto.category, eventDate);
    const recommendation = this.generateAstroRecommendation(dto.category, score);

    const reminder = this.reminderRepository.create({
      userId: dto.userId,
      title: dto.title,
      category: dto.category,
      eventTime: eventDate,
      notes: dto.notes,
      leadTimeMinutes: dto.leadTimeMinutes ?? 20,
      astroScore: score,
      astroRecommendation: recommendation,
    });

    return await this.reminderRepository.save(reminder);
  }

  async getUserReminders(userId: string): Promise<Reminder[]> {
    return await this.reminderRepository.find({
      where: { userId },
      order: { eventTime: 'ASC' },
    });
  }

  async deleteReminder(id: string, userId: string): Promise<boolean> {
    const res = await this.reminderRepository.delete({ id, userId });
    return (res.affected ?? 0) > 0;
  }

  async toggleReminderEnabled(id: string, userId: string, enabled: boolean): Promise<Reminder> {
    const reminder = await this.reminderRepository.findOne({ where: { id, userId } });
    if (!reminder) {
      throw new NotFoundException('Reminder not found');
    }
    reminder.reminderEnabled = enabled;
    return await this.reminderRepository.save(reminder);
  }

  /**
   * Deterministic Astrological Compatibility Calculator for User Scheduled Events
   */
  public calculateAstroAlignmentScore(category: EventCategory, date: Date): number {
    const hour = date.getHours();
    const day = date.getDay();

    let baseScore = 7.5;

    // Favor morning Abhijit Muhurat window (11:30 AM - 12:30 PM)
    if (hour >= 11 && hour <= 13) {
      baseScore += 1.8;
    }
    // Avoid Rahu Kaal typical afternoon windows (1:30 PM - 3:00 PM)
    else if (hour >= 13 && hour <= 15) {
      baseScore -= 1.5;
    }
    // Early morning & evening benefic planetary hours
    else if ((hour >= 8 && hour <= 10) || (hour >= 16 && hour <= 18)) {
      baseScore += 1.0;
    }

    // Category specific day modifiers
    if (category === EventCategory.BUSINESS || category === EventCategory.CONTRACT) {
      if (day === 3 || day === 4) baseScore += 0.8; // Wednesday (Mercury) / Thursday (Jupiter)
    } else if (category === EventCategory.PROPERTY || category === EventCategory.INVESTMENT) {
      if (day === 5) baseScore += 0.9; // Friday (Venus)
    } else if (category === EventCategory.MARRIAGE || category === EventCategory.PERSONAL) {
      if (day === 1 || day === 5) baseScore += 0.7; // Monday / Friday
    }

    return Math.min(10.0, Math.max(4.0, Number(baseScore.toFixed(1))));
  }

  private generateAstroRecommendation(category: EventCategory, score: number): string {
    if (score >= 8.5) {
      return `✦ Peak Astrological Alignment (${score}/10). Auspicious planetary transits favor high success for ${category.toLowerCase()} initiatives.`;
    } else if (score >= 6.5) {
      return `Favorable energy (${score}/10). Good time window for ${category.toLowerCase()}; proceed with clarity.`;
    } else {
      return `⚠️ Caution Window (${score}/10). Consider adjusting meeting time by 45 minutes to avoid Rahu Kaal influence.`;
    }
  }
}

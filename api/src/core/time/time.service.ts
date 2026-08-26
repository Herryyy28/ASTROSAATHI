import { Injectable } from '@nestjs/common';
import { format, formatInTimeZone, toZonedTime } from 'date-fns-tz';

@Injectable()
export class TimeService {
  /**
   * Returns the authoritative current UTC timestamp.
   */
  getCurrentUtcTime(): Date {
    return new Date();
  }

  /**
   * Returns the current time localized to the user's timezone.
   */
  getCurrentLocalTime(timeZone: string): Date {
    const utcDate = this.getCurrentUtcTime();
    return toZonedTime(utcDate, timeZone);
  }

  /**
   * Formats a date string in the target timezone.
   * e.g., '2023-10-25 10:30 AM'
   */
  formatLocalTime(date: Date, timeZone: string, pattern: string = 'yyyy-MM-dd hh:mm a'): string {
    return formatInTimeZone(date, timeZone, pattern);
  }

  /**
   * Gets the current hour (0-23) in a given timezone.
   */
  getCurrentLocalHour(timeZone: string): number {
    const localTime = this.getCurrentLocalTime(timeZone);
    return localTime.getHours();
  }

  /**
   * Returns the standard date string YYYY-MM-DD for a given timezone.
   */
  getCurrentLocalDateString(timeZone: string): string {
    return this.formatLocalTime(this.getCurrentUtcTime(), timeZone, 'yyyy-MM-dd');
  }
}

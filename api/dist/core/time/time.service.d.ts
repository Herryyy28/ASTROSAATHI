export declare class TimeService {
    getCurrentUtcTime(): Date;
    getCurrentLocalTime(timeZone: string): Date;
    formatLocalTime(date: Date, timeZone: string, pattern?: string): string;
    getCurrentLocalHour(timeZone: string): number;
    getCurrentLocalDateString(timeZone: string): string;
}

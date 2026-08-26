import { Processor, WorkerHost } from '@nestjs/bullmq';
import { Job } from 'bullmq';
import { Logger } from '@nestjs/common';
import { AstrologySyncService } from '../astrology-sync.service';

@Processor('astrology-sync')
export class AstrologySyncProcessor extends WorkerHost {
  private readonly logger = new Logger(AstrologySyncProcessor.name);

  constructor(private readonly syncService: AstrologySyncService) {
    super();
  }

  async process(job: Job<any, any, string>): Promise<any> {
    this.logger.log(`Processing background sync job: ${job.name} (ID: ${job.id})`);

    const { dateStr, latitude, longitude, timeZone } = job.data;
    const date = new Date(dateStr);
    const location = { latitude, longitude, timeZone };

    try {
      if (job.name === 'sync-panchang') {
        await this.syncService.syncPanchang(date, location);
        this.logger.log(`Successfully synced Panchang for ${latitude}, ${longitude}`);
      } else if (job.name === 'sync-planets') {
        await this.syncService.syncPlanetaryPositions(date, location);
        this.logger.log(`Successfully synced Planetary Positions for ${latitude}, ${longitude}`);
      }
    } catch (error) {
      this.logger.error(`Failed to process job ${job.name}: ${error.message}`);
      throw error; // Let BullMQ retry
    }
  }
}

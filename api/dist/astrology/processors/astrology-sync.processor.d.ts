import { WorkerHost } from '@nestjs/bullmq';
import { Job } from 'bullmq';
import { AstrologySyncService } from '../astrology-sync.service';
export declare class AstrologySyncProcessor extends WorkerHost {
    private readonly syncService;
    private readonly logger;
    constructor(syncService: AstrologySyncService);
    process(job: Job<any, any, string>): Promise<any>;
}

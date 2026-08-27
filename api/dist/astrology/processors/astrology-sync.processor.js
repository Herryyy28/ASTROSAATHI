"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var AstrologySyncProcessor_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.AstrologySyncProcessor = void 0;
const bullmq_1 = require("@nestjs/bullmq");
const common_1 = require("@nestjs/common");
const astrology_sync_service_1 = require("../astrology-sync.service");
let AstrologySyncProcessor = AstrologySyncProcessor_1 = class AstrologySyncProcessor extends bullmq_1.WorkerHost {
    constructor(syncService) {
        super();
        this.syncService = syncService;
        this.logger = new common_1.Logger(AstrologySyncProcessor_1.name);
    }
    async process(job) {
        this.logger.log(`Processing background sync job: ${job.name} (ID: ${job.id})`);
        const { dateStr, latitude, longitude, timeZone } = job.data;
        const date = new Date(dateStr);
        const location = { latitude, longitude, timeZone };
        try {
            if (job.name === 'sync-panchang') {
                await this.syncService.syncPanchang(date, location);
                this.logger.log(`Successfully synced Panchang for ${latitude}, ${longitude}`);
            }
            else if (job.name === 'sync-planets') {
                await this.syncService.syncPlanetaryPositions(date, location);
                this.logger.log(`Successfully synced Planetary Positions for ${latitude}, ${longitude}`);
            }
        }
        catch (error) {
            this.logger.error(`Failed to process job ${job.name}: ${error.message}`);
            throw error;
        }
    }
};
exports.AstrologySyncProcessor = AstrologySyncProcessor;
exports.AstrologySyncProcessor = AstrologySyncProcessor = AstrologySyncProcessor_1 = __decorate([
    (0, bullmq_1.Processor)('astrology-sync'),
    __metadata("design:paramtypes", [astrology_sync_service_1.AstrologySyncService])
], AstrologySyncProcessor);
//# sourceMappingURL=astrology-sync.processor.js.map
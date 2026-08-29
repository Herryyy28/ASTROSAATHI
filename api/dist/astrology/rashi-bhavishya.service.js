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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
var RashiBhavishyaService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.RashiBhavishyaService = void 0;
const common_1 = require("@nestjs/common");
const schedule_1 = require("@nestjs/schedule");
const ai_service_1 = require("../ai/ai.service");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const knowledge_rashi_entity_1 = require("../database/entities/knowledge_rashi.entity");
let RashiBhavishyaService = RashiBhavishyaService_1 = class RashiBhavishyaService {
    constructor(aiService, rashiRepo) {
        this.aiService = aiService;
        this.rashiRepo = rashiRepo;
        this.logger = new common_1.Logger(RashiBhavishyaService_1.name);
        this.dailyForecastCache = {};
    }
    async generateDailyForecasts() {
        this.logger.log('Starting daily Rashi Bhavishya generation...');
        try {
            const rashis = await this.rashiRepo.find();
            if (rashis.length === 0) {
                this.logger.warn('No Rashis found in Knowledge Database. Skip generation.');
                return;
            }
            const today = new Date();
            for (const rashi of rashis) {
                const realForecast = await this.aiService.generateRashiForecast(rashi.name, today);
                this.dailyForecastCache[rashi.name] = {
                    date: today.toISOString(),
                    ...realForecast,
                };
            }
            this.logger.log('Daily Rashi Bhavishya generation completed.');
        }
        catch (e) {
            this.logger.error('Failed to generate daily forecasts', e);
        }
    }
    getTodayForecast(rashiName) {
        if (!this.dailyForecastCache[rashiName]) {
            this.logger.log(`Cache miss for ${rashiName}, returning fallback`);
            return {
                rashi: rashiName,
                forecast: 'Today is a day of balance and karmic alignment.',
                score: 7
            };
        }
        return this.dailyForecastCache[rashiName];
    }
};
exports.RashiBhavishyaService = RashiBhavishyaService;
__decorate([
    (0, schedule_1.Cron)(schedule_1.CronExpression.EVERY_DAY_AT_MIDNIGHT),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], RashiBhavishyaService.prototype, "generateDailyForecasts", null);
exports.RashiBhavishyaService = RashiBhavishyaService = RashiBhavishyaService_1 = __decorate([
    (0, common_1.Injectable)(),
    __param(1, (0, typeorm_1.InjectRepository)(knowledge_rashi_entity_1.KnowledgeRashi)),
    __metadata("design:paramtypes", [ai_service_1.AiService,
        typeorm_2.Repository])
], RashiBhavishyaService);
//# sourceMappingURL=rashi-bhavishya.service.js.map
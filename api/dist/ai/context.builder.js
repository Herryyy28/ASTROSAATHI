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
Object.defineProperty(exports, "__esModule", { value: true });
exports.ContextBuilder = void 0;
const common_1 = require("@nestjs/common");
const astrology_sync_service_1 = require("../astrology/astrology-sync.service");
const game_plan_engine_1 = require("../astrology/engines/game-plan.engine");
const muhurat_engine_1 = require("../astrology/engines/muhurat.engine");
const time_service_1 = require("../core/time/time.service");
let ContextBuilder = class ContextBuilder {
    constructor(syncService, gamePlanEngine, muhuratEngine, timeService) {
        this.syncService = syncService;
        this.gamePlanEngine = gamePlanEngine;
        this.muhuratEngine = muhuratEngine;
        this.timeService = timeService;
    }
    async buildRealTimeContext(date, location) {
        const { panchang, planets } = await this.syncService.getCombinedData(date, location);
        const focusWeights = { Career: 1.0, Love: 1.0, Money: 1.0 };
        const gamePlan = this.gamePlanEngine.generateDailyGamePlan(date, planets, panchang, focusWeights).data;
        const muhurat = this.muhuratEngine.calculateMuhurat('General', date, location, panchang).data;
        return {
            timestamp: this.timeService.getCurrentUtcTime().toISOString(),
            timeZone: location.timeZone,
            location: { lat: location.latitude, lon: location.longitude },
            gamePlan,
            panchang,
            planets,
            muhurat,
        };
    }
};
exports.ContextBuilder = ContextBuilder;
exports.ContextBuilder = ContextBuilder = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [astrology_sync_service_1.AstrologySyncService,
        game_plan_engine_1.GamePlanEngine,
        muhurat_engine_1.MuhuratEngine,
        time_service_1.TimeService])
], ContextBuilder);
//# sourceMappingURL=context.builder.js.map
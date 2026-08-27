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
Object.defineProperty(exports, "__esModule", { value: true });
exports.AstrologyController = void 0;
const common_1 = require("@nestjs/common");
const astrology_service_1 = require("./astrology.service");
const astrology_sync_service_1 = require("./astrology-sync.service");
const game_plan_engine_1 = require("./engines/game-plan.engine");
const muhurat_engine_1 = require("./engines/muhurat.engine");
const users_service_1 = require("../users/users.service");
const auth_guard_1 = require("../auth/auth.guard");
let AstrologyController = class AstrologyController {
    constructor(astrologyService, syncService, gamePlanEngine, muhuratEngine, usersService) {
        this.astrologyService = astrologyService;
        this.syncService = syncService;
        this.gamePlanEngine = gamePlanEngine;
        this.muhuratEngine = muhuratEngine;
        this.usersService = usersService;
    }
    parseLocation(dateStr, lat, lon, tz) {
        const date = dateStr ? new Date(dateStr) : new Date();
        const location = {
            latitude: parseFloat(lat) || 28.6139,
            longitude: parseFloat(lon) || 77.2090,
            timeZone: tz || '5.5',
        };
        return { date, location };
    }
    async getGamePlan(req, dateStr, lat, lon, tz) {
        const { date, location } = this.parseLocation(dateStr, lat, lon, tz);
        const { panchang, planets } = await this.syncService.getCombinedData(date, location);
        let focusWeights = { Career: 1.0, Love: 1.0, Money: 1.0 };
        try {
            const profile = await this.usersService.getProfile(req.user.uid);
            if (profile && profile.focusWeights) {
                focusWeights = profile.focusWeights;
            }
        }
        catch (e) {
            console.log('Profile not found, using default focus weights');
        }
        return this.gamePlanEngine.generateDailyGamePlan(date, planets, panchang, focusWeights);
    }
    async getPanchang(dateStr, lat, lon, tz) {
        const { date, location } = this.parseLocation(dateStr, lat, lon, tz);
        return this.syncService.syncPanchang(date, location);
    }
    async getMuhurat(category, dateStr, lat, lon, tz) {
        const { date, location } = this.parseLocation(dateStr, lat, lon, tz);
        const { panchang } = await this.syncService.getCombinedData(date, location);
        return this.muhuratEngine.calculateMuhurat(category || 'General', date, location, panchang);
    }
    async getHoroscope(sign, timeframe) {
        return this.astrologyService.getHoroscope(sign || 'Aries', timeframe || 'daily');
    }
};
exports.AstrologyController = AstrologyController;
__decorate([
    (0, common_1.Get)('game-plan'),
    (0, common_1.UseGuards)(auth_guard_1.AuthGuard),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Query)('date')),
    __param(2, (0, common_1.Query)('lat')),
    __param(3, (0, common_1.Query)('lon')),
    __param(4, (0, common_1.Query)('tz')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String, String, String, String]),
    __metadata("design:returntype", Promise)
], AstrologyController.prototype, "getGamePlan", null);
__decorate([
    (0, common_1.Get)('panchang'),
    __param(0, (0, common_1.Query)('date')),
    __param(1, (0, common_1.Query)('lat')),
    __param(2, (0, common_1.Query)('lon')),
    __param(3, (0, common_1.Query)('tz')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, String, String]),
    __metadata("design:returntype", Promise)
], AstrologyController.prototype, "getPanchang", null);
__decorate([
    (0, common_1.Get)('muhurat'),
    __param(0, (0, common_1.Query)('category')),
    __param(1, (0, common_1.Query)('date')),
    __param(2, (0, common_1.Query)('lat')),
    __param(3, (0, common_1.Query)('lon')),
    __param(4, (0, common_1.Query)('tz')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, String, String, String]),
    __metadata("design:returntype", Promise)
], AstrologyController.prototype, "getMuhurat", null);
__decorate([
    (0, common_1.Get)('horoscope'),
    __param(0, (0, common_1.Query)('sign')),
    __param(1, (0, common_1.Query)('timeframe')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", Promise)
], AstrologyController.prototype, "getHoroscope", null);
exports.AstrologyController = AstrologyController = __decorate([
    (0, common_1.Controller)('astrology'),
    __metadata("design:paramtypes", [astrology_service_1.AstrologyService,
        astrology_sync_service_1.AstrologySyncService,
        game_plan_engine_1.GamePlanEngine,
        muhurat_engine_1.MuhuratEngine,
        users_service_1.UsersService])
], AstrologyController);
//# sourceMappingURL=astrology.controller.js.map
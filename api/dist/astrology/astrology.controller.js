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
const matching_service_1 = require("./matching.service");
const kundli_data_validator_1 = require("./validators/kundli-data.validator");
let AstrologyController = class AstrologyController {
    constructor(astrologyService, syncService, gamePlanEngine, muhuratEngine, usersService, matchingService) {
        this.astrologyService = astrologyService;
        this.syncService = syncService;
        this.gamePlanEngine = gamePlanEngine;
        this.muhuratEngine = muhuratEngine;
        this.usersService = usersService;
        this.matchingService = matchingService;
    }
    parseLocation(dateStr, timeStr, lat, lon, tz) {
        let date = new Date();
        if (dateStr) {
            date = new Date(dateStr);
            if (isNaN(date.getTime())) {
                const parts = dateStr.split(/[-/]/);
                if (parts.length === 3) {
                    date = new Date(`${parts[2]}-${parts[1]}-${parts[0]}T00:00:00`);
                }
            }
            if (isNaN(date.getTime())) {
                date = new Date();
            }
        }
        if (timeStr && timeStr.includes(':')) {
            const [hh, mm] = timeStr.split(':');
            date.setHours(parseInt(hh, 10) || 12);
            date.setMinutes(parseInt(mm, 10) || 0);
        }
        const location = {
            latitude: parseFloat(lat) || 28.6139,
            longitude: parseFloat(lon) || 77.2090,
            timeZone: tz || '5.5',
        };
        return { date, location };
    }
    async getGamePlan(req, dateStr, lat, lon, tz) {
        const { date, location } = this.parseLocation(dateStr, '12:00', lat, lon, tz);
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
        const { date, location } = this.parseLocation(dateStr, '12:00', lat, lon, tz);
        return this.syncService.syncPanchang(date, location);
    }
    async getMuhurat(category, dateStr, lat, lon, tz) {
        const { date, location } = this.parseLocation(dateStr, '12:00', lat, lon, tz);
        const { panchang } = await this.syncService.getCombinedData(date, location);
        return this.muhuratEngine.calculateMuhurat(category || 'General', date, location, panchang);
    }
    async getBirthChart(profileId, dateStr, timeStr, lat, lon, tz) {
        const { date, location } = this.parseLocation(dateStr, timeStr || '12:00', lat, lon, tz);
        const [chart, planets] = await Promise.all([
            this.syncService.syncBirthChart(date, timeStr || '12:00', location),
            this.syncService.syncPlanetaryPositions(date, location)
        ]);
        const canonicalPlanets = [];
        if (planets && planets.data) {
            for (const [key, p] of Object.entries(planets.data)) {
                canonicalPlanets.push({
                    id: p.name.toLowerCase(),
                    name: p.name,
                    rashi: p.sign,
                    rashiId: p.sign.toLowerCase(),
                    house: chart?.data?.planets?.[p.name]?.house || p.house || 1,
                    degree: p.degree,
                    nakshatra: p.nakshatra,
                    pada: p.pada,
                    retrograde: p.isRetrograde || false,
                });
            }
        }
        const moonPlanet = canonicalPlanets.find(p => p.id === 'moon');
        const canonicalKundli = {
            profileId: profileId || 'unknown_profile',
            birthDetails: {
                date: dateStr,
                time: timeStr || '12:00',
                location: `${lat},${lon}`,
                latitude: parseFloat(lat),
                longitude: parseFloat(lon),
                timezone: tz,
            },
            lagna: {
                rashi: chart?.data?.ascendant || 'Aries',
                degree: 0,
            },
            rashi: {
                id: moonPlanet?.rashiId || 'aries',
                name: moonPlanet?.rashi || 'Aries',
                englishName: moonPlanet?.rashi || 'Aries',
                degree: moonPlanet?.degree || 0,
            },
            planets: canonicalPlanets,
            houses: chart?.data?.houses || [],
            nakshatra: {},
            dasha: {},
            yogas: [],
            aspects: [],
            calculatedAt: planets?.meta?.calculatedAt || new Date().toISOString(),
            calculationVersion: planets?.meta?.calculationVersion || '1.0',
        };
        return kundli_data_validator_1.KundliDataValidator.validate(canonicalKundli);
    }
    async getHoroscope(sign, timeframe) {
        return this.astrologyService.getHoroscope(sign || 'Aries', timeframe || 'daily');
    }
    async getMatch(p1Sign, p2Sign) {
        return this.matchingService.calculateGunMilan(p1Sign || 'Aries', p2Sign || 'Leo');
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
    (0, common_1.Get)('birth-chart'),
    __param(0, (0, common_1.Query)('profileId')),
    __param(1, (0, common_1.Query)('date')),
    __param(2, (0, common_1.Query)('time')),
    __param(3, (0, common_1.Query)('lat')),
    __param(4, (0, common_1.Query)('lon')),
    __param(5, (0, common_1.Query)('tz')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, String, String, String, String]),
    __metadata("design:returntype", Promise)
], AstrologyController.prototype, "getBirthChart", null);
__decorate([
    (0, common_1.Get)('horoscope'),
    __param(0, (0, common_1.Query)('sign')),
    __param(1, (0, common_1.Query)('timeframe')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", Promise)
], AstrologyController.prototype, "getHoroscope", null);
__decorate([
    (0, common_1.Get)('match'),
    __param(0, (0, common_1.Query)('p1Sign')),
    __param(1, (0, common_1.Query)('p2Sign')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", Promise)
], AstrologyController.prototype, "getMatch", null);
exports.AstrologyController = AstrologyController = __decorate([
    (0, common_1.Controller)('astrology'),
    __metadata("design:paramtypes", [astrology_service_1.AstrologyService,
        astrology_sync_service_1.AstrologySyncService,
        game_plan_engine_1.GamePlanEngine,
        muhurat_engine_1.MuhuratEngine,
        users_service_1.UsersService,
        matching_service_1.MatchingService])
], AstrologyController);
//# sourceMappingURL=astrology.controller.js.map
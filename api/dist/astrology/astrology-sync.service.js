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
var AstrologySyncService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.AstrologySyncService = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
let AstrologySyncService = AstrologySyncService_1 = class AstrologySyncService {
    constructor(provider, configService) {
        this.provider = provider;
        this.configService = configService;
        this.logger = new common_1.Logger(AstrologySyncService_1.name);
        this.cache = new Map();
    }
    getCacheKey(endpoint, location, date) {
        const dStr = date.toISOString().split('T')[0];
        return `${endpoint}-${dStr}-${location.latitude}-${location.longitude}`;
    }
    async syncPanchang(date, location) {
        const cacheKey = this.getCacheKey('panchang', location, date);
        const cached = this.cache.get(cacheKey);
        if (cached) {
            const now = new Date();
            if (now >= cached.meta.validFrom && now <= cached.meta.validUntil) {
                this.logger.log(`Serving Panchang from valid cache for ${location.cityName || location.latitude}`);
                return cached;
            }
            else {
                this.logger.log(`Cache expired for Panchang. Refreshing.`);
            }
        }
        try {
            const result = await this.provider.getPanchang(date, location);
            this.cache.set(cacheKey, result);
            return result;
        }
        catch (error) {
            this.logger.error(`Provider failed to get Panchang: ${error.message}`);
            if (cached) {
                this.logger.warn(`Serving stale Panchang from cache due to provider failure.`);
                return cached;
            }
            throw new Error('Panchang data unavailable.');
        }
    }
    async syncPlanetaryPositions(date, location) {
        const cacheKey = this.getCacheKey('planets', location, date);
        const cached = this.cache.get(cacheKey);
        if (cached) {
            const now = new Date();
            if (now >= cached.meta.validFrom && now <= cached.meta.validUntil) {
                return cached;
            }
        }
        try {
            const result = await this.provider.getPlanetaryPositions(date, location);
            this.cache.set(cacheKey, result);
            return result;
        }
        catch (error) {
            this.logger.error(`Provider failed to get Planets: ${error.message}`);
            if (cached)
                return cached;
            throw new Error('Planetary data unavailable.');
        }
    }
    async getCombinedData(date, location) {
        const [panchang, planets] = await Promise.all([
            this.syncPanchang(date, location),
            this.syncPlanetaryPositions(date, location)
        ]);
        return {
            panchang: panchang.data,
            planets: planets.data
        };
    }
};
exports.AstrologySyncService = AstrologySyncService;
exports.AstrologySyncService = AstrologySyncService = AstrologySyncService_1 = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, common_1.Inject)('ASTROLOGY_PROVIDER')),
    __metadata("design:paramtypes", [Object, config_1.ConfigService])
], AstrologySyncService);
//# sourceMappingURL=astrology-sync.service.js.map
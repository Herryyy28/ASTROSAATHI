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
var AstrologyService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.AstrologyService = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const astrology_data_integrity_service_1 = require("./astrology-data-integrity.service");
let AstrologyService = AstrologyService_1 = class AstrologyService {
    constructor(configService, dataIntegrity) {
        this.configService = configService;
        this.dataIntegrity = dataIntegrity;
        this.logger = new common_1.Logger(AstrologyService_1.name);
        this.cache = new Map();
    }
    getCacheKey(endpoint, params) {
        const today = new Date().toISOString().split('T')[0];
        return `${endpoint}-${today}-${JSON.stringify(params)}`;
    }
    async fetchFromApi(endpoint, data) {
        const userId = this.configService.get('ASTROLOGY_USER_ID') || '657466';
        const apiKey = this.configService.get('ASTROLOGY_API_KEY') || 'ak-dbf59adeb917e54a4f3eb845c26e6181acf1e707';
        if (!userId || !apiKey) {
            this.logger.error('Astrology API credentials missing. Cannot fetch real data.');
            throw new Error('Astrology API credentials missing.');
        }
        const auth = Buffer.from(`${userId}:${apiKey}`).toString('base64');
        try {
            const response = await fetch(`https://json.astrologyapi.com/v1/${endpoint}`, {
                method: 'POST',
                headers: {
                    'Authorization': `Basic ${auth}`,
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data),
            });
            if (!response.ok) {
                const errorText = await response.text();
                this.logger.error(`API Error ${response.status}: ${errorText}`);
                require('fs').writeFileSync('astrology_api_error.txt', `Service Error ${response.status}: ${errorText}\n`);
                throw new Error(`AstrologyAPI Error: ${errorText}`);
            }
            return await response.json();
        }
        catch (error) {
            const errorMessage = error instanceof Error ? error.message : String(error);
            this.logger.error(`Failed to fetch from AstrologyAPI: ${errorMessage}`);
            return null;
        }
    }
    getApiPayload(dateStr, locationStr) {
        const date = new Date();
        return {
            day: date.getDate(),
            month: date.getMonth() + 1,
            year: date.getFullYear(),
            hour: date.getHours(),
            min: date.getMinutes(),
            lat: 28.6139,
            lon: 77.2090,
            tzone: 5.5,
        };
    }
    async getDailyGamePlan(date, location) {
        const cacheKey = this.getCacheKey('game-plan', { date, location });
        if (this.cache.has(cacheKey)) {
            return this.cache.get(cacheKey);
        }
        const payload = this.getApiPayload(date, location);
        const apiData = await this.fetchFromApi('game_plan', payload);
        if (!apiData) {
            throw new Error('Failed to retrieve daily game plan data');
        }
        const result = {
            success: true,
            data: this.dataIntegrity.normalizeGamePlan(apiData, date)
        };
        this.cache.set(cacheKey, result);
        return result;
    }
    async getPanchang(date, location) {
        const cacheKey = this.getCacheKey('advanced_panchang', { date, location });
        if (this.cache.has(cacheKey)) {
            return this.cache.get(cacheKey);
        }
        const payload = this.getApiPayload(date, location);
        const apiData = await this.fetchFromApi('advanced_panchang', payload);
        if (!apiData) {
            throw new Error('Failed to fetch Panchang data');
        }
        const resultData = this.dataIntegrity.normalizePanchang(apiData);
        const result = { success: true, data: resultData };
        this.cache.set(cacheKey, result);
        return result;
    }
    async getMuhurat(category, date, location) {
        const cacheKey = this.getCacheKey('muhurat', { category, date, location });
        if (this.cache.has(cacheKey)) {
            return this.cache.get(cacheKey);
        }
        const payload = this.getApiPayload(date, location);
        const apiData = await this.fetchFromApi('muhurat', payload);
        if (!apiData) {
            throw new Error('Failed to retrieve Muhurat data');
        }
        const result = {
            success: true,
            data: this.dataIntegrity.normalizeMuhurat(apiData, category)
        };
        this.cache.set(cacheKey, result);
        return result;
    }
    generatePlanetaryStateHash(sign, timeframe) {
        const today = new Date().toISOString().split('T')[0];
        return require('crypto').createHash('md5').update(`${sign}-${timeframe}-${today}`).digest('hex');
    }
    async getHoroscope(sign, timeframe) {
        const planetaryStateHash = this.generatePlanetaryStateHash(sign, timeframe);
        const cacheKey = `horoscope-${sign}-${timeframe}-${planetaryStateHash}`;
        if (this.cache.has(cacheKey)) {
            return this.cache.get(cacheKey);
        }
        if (this.configService.get('USE_MOCK_PROVIDER') === 'true') {
            const result = {
                success: true,
                data: {
                    sign,
                    timeframe,
                    reading: `According to your calculated birth chart, your personalized reading for ${sign} today shows positive transits. The underlying astrological context emphasizes grounding and focus.`,
                    luckyNumber: 7,
                    luckyColor: 'Blue',
                },
            };
            this.cache.set(cacheKey, result);
            return result;
        }
        const apiEndpoint = timeframe === 'daily' ? `sun_sign_prediction/daily/${sign.toLowerCase()}` : null;
        let apiData = null;
        if (apiEndpoint) {
            apiData = await this.fetchFromApi(apiEndpoint, {});
        }
        if (!apiData) {
            throw new Error('Failed to retrieve Horoscope data');
        }
        const result = {
            success: true,
            data: {
                sign,
                timeframe,
                reading: apiData.prediction,
                luckyNumber: apiData.lucky_number || 7,
                luckyColor: apiData.lucky_color || 'White',
            },
        };
        this.cache.set(cacheKey, result);
        return result;
    }
};
exports.AstrologyService = AstrologyService;
exports.AstrologyService = AstrologyService = AstrologyService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [config_1.ConfigService,
        astrology_data_integrity_service_1.AstrologyDataIntegrityService])
], AstrologyService);
//# sourceMappingURL=astrology.service.js.map
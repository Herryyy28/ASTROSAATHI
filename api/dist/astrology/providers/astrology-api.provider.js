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
var AstrologyApiProvider_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.AstrologyApiProvider = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const date_fns_1 = require("date-fns");
let AstrologyApiProvider = AstrologyApiProvider_1 = class AstrologyApiProvider {
    constructor(configService) {
        this.configService = configService;
        this.logger = new common_1.Logger(AstrologyApiProvider_1.name);
    }
    createMetadata(date, providerVersion = 'api-v1') {
        return {
            provider: 'AstrologyAPI',
            providerVersion,
            calculationVersion: '1.0.0',
            calculatedAt: new Date(),
            validFrom: (0, date_fns_1.startOfDay)(date),
            validUntil: (0, date_fns_1.endOfDay)(date),
        };
    }
    async fetchFromApi(endpoint, payload) {
        const userId = this.configService.get('ASTROLOGY_USER_ID') || '657466';
        const apiKey = this.configService.get('ASTROLOGY_API_KEY') || 'ak-dbf59adeb917e54a4f3eb845c26e6181acf1e707';
        if (!userId || !apiKey) {
            throw new Error('Astrology API credentials missing');
        }
        const auth = Buffer.from(`${userId}:${apiKey}`).toString('base64');
        const response = await fetch(`https://json.astrologyapi.com/v1/${endpoint}`, {
            method: 'POST',
            headers: {
                'Authorization': `Basic ${auth}`,
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(payload),
        });
        if (!response.ok) {
            const errorText = await response.text();
            this.logger.error(`API Error ${response.status}: ${errorText}`);
            require('fs').writeFileSync('astrology_api_error.txt', `Provider Error ${response.status}: ${errorText}\n`);
            throw new Error(`AstrologyAPI Error: ${errorText}`);
        }
        return await response.json();
    }
    getApiPayload(date, location) {
        return {
            day: date.getDate(),
            month: date.getMonth() + 1,
            year: date.getFullYear(),
            hour: date.getHours(),
            min: date.getMinutes(),
            lat: location.latitude,
            lon: location.longitude,
            tzone: parseFloat(location.timeZone) || 5.5,
        };
    }
    async getPlanetaryPositions(date, location) {
        const payload = this.getApiPayload(date, location);
        const apiData = await this.fetchFromApi('planets', payload);
        const data = {};
        if (Array.isArray(apiData)) {
            apiData.forEach((p) => {
                data[p.name] = {
                    name: p.name,
                    longitude: p.normDegree,
                    sign: p.sign,
                    degree: p.normDegree,
                    house: p.house,
                    isRetrograde: p.isRetro === 'true',
                    nakshatra: p.nakshatra,
                    pada: p.nakshatra_pada,
                    speed: p.speed,
                };
            });
        }
        return { data, meta: this.createMetadata(date) };
    }
    async getBirthChart(dob, time, location) {
        const payload = this.getApiPayload(dob, location);
        const apiData = await this.fetchFromApi('astro_details', payload);
        return { data: apiData, meta: this.createMetadata(dob) };
    }
    async getPanchang(date, location) {
        const payload = this.getApiPayload(date, location);
        const apiData = await this.fetchFromApi('advanced_panchang', payload);
        return {
            data: {
                tithi: apiData.tithi?.details?.tithi_name || '',
                vara: apiData.day || '',
                nakshatra: apiData.nakshatra?.details?.nak_name || '',
                yoga: apiData.yoga?.details?.yoga_name || '',
                karana: apiData.karana?.details?.karana_name || '',
                sunrise: apiData.sunrise || '',
                sunset: apiData.sunset || '',
                moonrise: apiData.moonrise || '',
                moonset: apiData.moonset || '',
                rahuKaal: { start: apiData.rahukaal?.start || '', end: apiData.rahukaal?.end || '' },
                yamaganda: { start: apiData.yamghant_kaal?.start || '', end: apiData.yamghant_kaal?.end || '' },
                gulika: { start: apiData.guliKaal?.start || '', end: apiData.guliKaal?.end || '' },
            },
            meta: this.createMetadata(date),
        };
    }
};
exports.AstrologyApiProvider = AstrologyApiProvider;
exports.AstrologyApiProvider = AstrologyApiProvider = AstrologyApiProvider_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [config_1.ConfigService])
], AstrologyApiProvider);
//# sourceMappingURL=astrology-api.provider.js.map
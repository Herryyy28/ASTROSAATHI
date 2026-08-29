"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var AstrologyDataIntegrityService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.AstrologyDataIntegrityService = void 0;
const common_1 = require("@nestjs/common");
let AstrologyDataIntegrityService = AstrologyDataIntegrityService_1 = class AstrologyDataIntegrityService {
    constructor() {
        this.logger = new common_1.Logger(AstrologyDataIntegrityService_1.name);
    }
    normalizePanchang(apiData) {
        if (!apiData || !apiData.tithi || !apiData.nakshatra) {
            this.logger.error('Invalid Panchang API response payload.');
            throw new common_1.ServiceUnavailableException('Astrology data provider returned invalid Panchang structure.');
        }
        return {
            tithi: apiData.tithi.details.tithi_name,
            vara: apiData.day,
            nakshatra: apiData.nakshatra.details.nak_name,
            yoga: apiData.yoga.details.yoga_name,
            karana: apiData.karana.details.karana_name,
            sunrise: apiData.sunrise,
            sunset: apiData.sunset,
            rahuKaal: apiData.rahukaal ? { start: apiData.rahukaal.start, end: apiData.rahukaal.end } : null,
            calculatedAt: new Date().toISOString(),
        };
    }
    normalizeMuhurat(apiData, category) {
        if (!apiData) {
            throw new common_1.ServiceUnavailableException('Muhurat data missing from provider.');
        }
        return {
            category,
            bestWindow: apiData.bestWindow || { start: 'N/A', end: 'N/A' },
            avoidWindow: apiData.avoidWindow || null,
            strength: apiData.strength || 'Average',
            bestFor: apiData.bestFor || 'Routine activities',
            calculatedAt: new Date().toISOString(),
        };
    }
    normalizeGamePlan(apiData, date) {
        if (!apiData) {
            throw new common_1.ServiceUnavailableException('Game plan data missing from provider.');
        }
        return {
            date,
            dayScore: typeof apiData.dayScore === 'number' ? apiData.dayScore : 5.0,
            doList: Array.isArray(apiData.doList) ? apiData.doList : [],
            beCarefulList: Array.isArray(apiData.beCarefulList) ? apiData.beCarefulList : [],
            avoidList: Array.isArray(apiData.avoidList) ? apiData.avoidList : [],
            bestWindow: apiData.bestWindow || { start: 'N/A', end: 'N/A' },
            categories: apiData.categories || {},
            calculatedAt: new Date().toISOString(),
        };
    }
    normalizeBirthChart(apiData) {
        if (!apiData || !apiData.ascendant) {
            throw new common_1.ServiceUnavailableException('Birth chart data missing required ascendant fields.');
        }
        return {
            ascendant: apiData.ascendant,
            ascendantDegree: apiData.ascendantDegree || 0,
            planets: apiData.planets || [],
            houses: apiData.houses || [],
            calculatedAt: new Date().toISOString(),
        };
    }
};
exports.AstrologyDataIntegrityService = AstrologyDataIntegrityService;
exports.AstrologyDataIntegrityService = AstrologyDataIntegrityService = AstrologyDataIntegrityService_1 = __decorate([
    (0, common_1.Injectable)()
], AstrologyDataIntegrityService);
//# sourceMappingURL=astrology-data-integrity.service.js.map
"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MockAstrologyProvider = void 0;
const common_1 = require("@nestjs/common");
const date_fns_1 = require("date-fns");
let MockAstrologyProvider = class MockAstrologyProvider {
    createMetadata(date, providerVersion = '1.0.0') {
        return {
            provider: 'MockAstrologyProvider',
            providerVersion,
            calculationVersion: '1.0.0',
            calculatedAt: new Date(),
            validFrom: (0, date_fns_1.startOfDay)(date),
            validUntil: (0, date_fns_1.endOfDay)(date),
        };
    }
    async getPlanetaryPositions(date, location) {
        return {
            data: {
                sun: { name: 'Sun', longitude: 15.5, sign: 'Aries', degree: 15, house: 1, isRetrograde: false, nakshatra: 'Ashwini', pada: 1, speed: 1.0 },
                moon: { name: 'Moon', longitude: 45.2, sign: 'Taurus', degree: 15, house: 2, isRetrograde: false, nakshatra: 'Rohini', pada: 2, speed: 13.5 },
            },
            meta: this.createMetadata(date, 'mock-1.0'),
        };
    }
    async getBirthChart(dob, time, location) {
        return {
            data: {
                ascendant: 'Leo',
                planets: {
                    Sun: { name: 'Sun', house: 1, sign: 'Leo' },
                    Moon: { name: 'Moon', house: 2, sign: 'Virgo' },
                    Mars: { name: 'Mars', house: 4, sign: 'Scorpio' },
                    Mercury: { name: 'Mercury', house: 1, sign: 'Leo' },
                    Jupiter: { name: 'Jupiter', house: 9, sign: 'Aries' },
                    Venus: { name: 'Venus', house: 12, sign: 'Cancer' },
                    Saturn: { name: 'Saturn', house: 7, sign: 'Aquarius' },
                    Rahu: { name: 'Rahu', house: 10, sign: 'Taurus' },
                    Ketu: { name: 'Ketu', house: 4, sign: 'Scorpio' }
                },
                houses: [],
            },
            meta: this.createMetadata(dob, 'mock-1.0'),
        };
    }
    async getPanchang(date, location) {
        return {
            data: {
                tithi: 'Shukla Paksha Dashami',
                vara: 'Wednesday',
                nakshatra: 'Rohini',
                yoga: 'Shiva',
                karana: 'Taitila',
                sunrise: '06:12 AM',
                sunset: '06:45 PM',
                moonrise: '08:00 PM',
                moonset: '07:30 AM',
                rahuKaal: { start: '12:00 PM', end: '01:30 PM' },
                yamaganda: { start: '07:30 AM', end: '09:00 AM' },
                gulika: { start: '10:30 AM', end: '12:00 PM' },
            },
            meta: this.createMetadata(date, 'mock-1.0'),
        };
    }
};
exports.MockAstrologyProvider = MockAstrologyProvider;
exports.MockAstrologyProvider = MockAstrologyProvider = __decorate([
    (0, common_1.Injectable)()
], MockAstrologyProvider);
//# sourceMappingURL=mock-astrology.provider.js.map
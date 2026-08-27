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
exports.MuhuratEngine = void 0;
const common_1 = require("@nestjs/common");
const time_service_1 = require("../../core/time/time.service");
let MuhuratEngine = class MuhuratEngine {
    constructor(timeService) {
        this.timeService = timeService;
    }
    calculateMuhurat(category, date, location, panchang) {
        const tithiString = panchang.tithi || '';
        const isWaxing = tithiString.toLowerCase().includes('shukla');
        const isWaning = tithiString.toLowerCase().includes('krishna');
        let tithiNumber = 1;
        if (tithiString.toLowerCase().includes('panchami'))
            tithiNumber = 5;
        if (tithiString.toLowerCase().includes('dashami'))
            tithiNumber = 10;
        if (tithiString.toLowerCase().includes('purnima'))
            tithiNumber = 15;
        if (tithiString.toLowerCase().includes('chaturthi'))
            tithiNumber = 4;
        if (tithiString.toLowerCase().includes('navami'))
            tithiNumber = 9;
        if (tithiString.toLowerCase().includes('chaturdashi'))
            tithiNumber = 14;
        let quality = 'Neutral';
        let specificGuidance = 'A standard day. Proceed with routine activities.';
        let score = 5;
        if (category.toLowerCase().includes('buying house')) {
            if (isWaxing && tithiNumber >= 5 && tithiNumber <= 10) {
                quality = 'Excellent';
                specificGuidance = 'Highly auspicious for real estate transactions. Mars and Moon are aligned.';
                score = 9;
            }
            else {
                quality = 'Average';
                specificGuidance = 'Check property papers carefully. Not the most powerful alignment for real estate.';
                score = 6;
            }
        }
        else if (category.toLowerCase().includes('signing contract')) {
            if (isWaxing && tithiNumber !== 4 && tithiNumber !== 9 && tithiNumber !== 14) {
                quality = 'Excellent';
                specificGuidance = 'Favorable alignment for communication and legally binding agreements.';
                score = 8;
            }
            else {
                quality = 'Poor';
                specificGuidance = 'Rahu Kaal or Rikta tithi is active. Delay signing if possible.';
                score = 3;
            }
        }
        else if (isWaxing && (tithiNumber === 5 || tithiNumber === 10 || tithiNumber === 15)) {
            quality = 'Excellent';
            specificGuidance = 'Very auspicious timing (Purna Tithi). Ideal for new beginnings.';
            score = 9;
        }
        else if (isWaning && (tithiNumber === 4 || tithiNumber === 9 || tithiNumber === 14)) {
            quality = 'Poor';
            specificGuidance = 'Inauspicious timing (Rikta Tithi). Avoid major decisions.';
            score = 2;
        }
        const isRahuKaalActive = panchang.rahuKaal && panchang.rahuKaal.start !== '';
        return {
            success: true,
            data: {
                category,
                quality,
                score,
                specificGuidance,
                bestWindow: {
                    start: '10:15 AM',
                    end: '11:45 AM'
                },
                strength: isRahuKaalActive ? 'Moderate' : 'Excellent',
                bestFor: `Activities related to ${category.toLowerCase()}`,
                avoidWindow: isRahuKaalActive ? panchang.rahuKaal : null,
            }
        };
    }
};
exports.MuhuratEngine = MuhuratEngine;
exports.MuhuratEngine = MuhuratEngine = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [time_service_1.TimeService])
], MuhuratEngine);
//# sourceMappingURL=muhurat.engine.js.map
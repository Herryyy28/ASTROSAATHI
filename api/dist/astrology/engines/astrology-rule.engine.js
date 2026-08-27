"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AstrologyRuleEngine = void 0;
const common_1 = require("@nestjs/common");
let AstrologyRuleEngine = class AstrologyRuleEngine {
    evaluateDayRules(planets, panchang, focusWeights = { Career: 1.0, Love: 1.0, Money: 1.0 }) {
        let baseScore = 5.0;
        const doList = [];
        const avoidList = [];
        const categories = {
            Career: 5.0,
            Love: 5.0,
            Money: 5.0,
        };
        const moon = planets['moon'];
        if (moon) {
            if (moon.sign === 'Taurus' || moon.sign === 'Cancer') {
                baseScore += 1.5;
                categories.Love += 2.0;
                doList.push('Focus on nurturing relationships today.');
            }
            else if (moon.sign === 'Scorpio') {
                baseScore -= 1.0;
                categories.Love -= 1.0;
                avoidList.push('Avoid getting into deep emotional arguments.');
            }
        }
        const sun = planets['sun'];
        if (sun) {
            if (sun.sign === 'Aries' || sun.sign === 'Leo') {
                baseScore += 1.0;
                categories.Career += 2.5;
                doList.push('Take charge of important professional projects.');
            }
        }
        if (panchang.yoga.toLowerCase().includes('shiva') || panchang.yoga.toLowerCase().includes('siddhi')) {
            baseScore += 1.0;
            categories.Money += 1.5;
            doList.push('Auspicious energy for financial planning.');
        }
        if (panchang.tithi.toLowerCase().includes('amavasya')) {
            baseScore -= 1.5;
            avoidList.push('Not an ideal day for starting completely new ventures.');
        }
        const jupiter = planets['jupiter'];
        if (moon && jupiter) {
            const distance = Math.abs(moon.house - jupiter.house);
            if (distance === 0 || distance === 3 || distance === 6 || distance === 9) {
                baseScore += 2.0;
                categories.Career += 3.0;
                categories.Money += 2.0;
                doList.push('Excellent day for major career decisions and leadership (Gajakesari Yoga active).');
            }
        }
        const mars = planets['mars'];
        if (mars && mars.house === 10) {
            baseScore += 1.0;
            categories.Career += 2.0;
            doList.push('High energy for professional tasks. Be assertive.');
            avoidList.push('Avoid being too aggressive with colleagues.');
        }
        const finalScore = ((categories.Career * (focusWeights.Career || 1.0)) +
            (categories.Love * (focusWeights.Love || 1.0)) +
            (categories.Money * (focusWeights.Money || 1.0))) / 3;
        return {
            score: Math.min(Math.max(baseScore + (finalScore * 0.2), 1), 10),
            doList,
            avoidList,
            categories: {
                Career: Math.min(Math.max(categories.Career, 1), 10),
                Love: Math.min(Math.max(categories.Love, 1), 10),
                Money: Math.min(Math.max(categories.Money, 1), 10),
            }
        };
    }
};
exports.AstrologyRuleEngine = AstrologyRuleEngine;
exports.AstrologyRuleEngine = AstrologyRuleEngine = __decorate([
    (0, common_1.Injectable)()
], AstrologyRuleEngine);
//# sourceMappingURL=astrology-rule.engine.js.map
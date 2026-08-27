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
exports.GamePlanEngine = void 0;
const common_1 = require("@nestjs/common");
const astrology_rule_engine_1 = require("./astrology-rule.engine");
let GamePlanEngine = class GamePlanEngine {
    constructor(ruleEngine) {
        this.ruleEngine = ruleEngine;
    }
    generateDailyGamePlan(date, planets, panchang, focusWeights) {
        const rulesResult = this.ruleEngine.evaluateDayRules(planets, panchang, focusWeights);
        let bestStart = '10:00 AM';
        let bestEnd = '12:00 PM';
        if (panchang.rahuKaal.start && panchang.rahuKaal.start.includes('10:') || panchang.rahuKaal.start.includes('11:')) {
            bestStart = '02:00 PM';
            bestEnd = '04:00 PM';
        }
        return {
            success: true,
            data: {
                date: date.toISOString().split('T')[0],
                dayScore: Number(rulesResult.score.toFixed(1)),
                doList: rulesResult.doList.length > 0 ? rulesResult.doList : ['Trust your intuition today.'],
                beCarefulList: ['Double check details during communications.'],
                avoidList: rulesResult.avoidList.length > 0 ? rulesResult.avoidList : ['Avoid rushing into major financial decisions.'],
                bestWindow: { start: bestStart, end: bestEnd },
                categories: rulesResult.categories,
            }
        };
    }
};
exports.GamePlanEngine = GamePlanEngine;
exports.GamePlanEngine = GamePlanEngine = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [astrology_rule_engine_1.AstrologyRuleEngine])
], GamePlanEngine);
//# sourceMappingURL=game-plan.engine.js.map
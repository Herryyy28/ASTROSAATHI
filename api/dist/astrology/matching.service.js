"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MatchingService = void 0;
const common_1 = require("@nestjs/common");
let MatchingService = class MatchingService {
    constructor() {
        this.zodiacSigns = [
            'Aries', 'Taurus', 'Gemini', 'Cancer',
            'Leo', 'Virgo', 'Libra', 'Scorpio',
            'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
        ];
    }
    calculateGunMilan(sign1, sign2) {
        const p1 = this.normalizeSign(sign1);
        const p2 = this.normalizeSign(sign2);
        const idx1 = this.zodiacSigns.indexOf(p1);
        const idx2 = this.zodiacSigns.indexOf(p2);
        const varna1 = Math.floor(idx1 / 3);
        const varna2 = Math.floor(idx2 / 3);
        const varnaScore = varna1 >= varna2 ? 1.0 : 0.5;
        const isSameElement = (idx1 % 3) === (idx2 % 3);
        const vashyaScore = isSameElement ? 2.0 : (Math.abs(idx1 - idx2) <= 3 ? 1.5 : 1.0);
        const distance = (idx2 - idx1 + 12) % 12;
        const taraRem = distance % 9;
        const taraScore = (taraRem === 3 || taraRem === 5 || taraRem === 7) ? 1.5 : 3.0;
        const yoniScore = (idx1 === idx2) ? 4.0 : (isSameElement ? 3.0 : 2.0);
        const lordMap = {
            'Aries': 'Mars', 'Scorpio': 'Mars',
            'Taurus': 'Venus', 'Libra': 'Venus',
            'Gemini': 'Mercury', 'Virgo': 'Mercury',
            'Cancer': 'Moon', 'Leo': 'Sun',
            'Sagittarius': 'Jupiter', 'Pisces': 'Jupiter',
            'Capricorn': 'Saturn', 'Aquarius': 'Saturn'
        };
        const l1 = lordMap[p1];
        const l2 = lordMap[p2];
        const maitriScore = (l1 === l2) ? 5.0 : (this.areFriends(l1, l2) ? 4.0 : 1.0);
        const ganaMap = { 0: 1, 1: 2, 2: 3, 3: 1, 4: 2, 5: 3, 6: 1, 7: 2, 8: 3, 9: 1, 10: 2, 11: 3 };
        const g1 = ganaMap[idx1];
        const g2 = ganaMap[idx2];
        let ganaScore = 6.0;
        if (g1 !== g2) {
            if ((g1 === 1 && g2 === 3) || (g1 === 3 && g2 === 1))
                ganaScore = 1.0;
            else
                ganaScore = 3.5;
        }
        const houseDiff = (idx2 - idx1 + 12) % 12 + 1;
        let bhakootScore = 7.0;
        if (houseDiff === 2 || houseDiff === 12 || houseDiff === 6 || houseDiff === 8) {
            bhakootScore = 0.0;
        }
        let nadiScore = 8.0;
        if (idx1 % 3 === idx2 % 3 && idx1 !== idx2) {
            nadiScore = 0.0;
        }
        const totalScore = Number((varnaScore + vashyaScore + taraScore + yoniScore + maitriScore + ganaScore + bhakootScore + nadiScore).toFixed(1));
        let grade = 'Good';
        if (totalScore >= 31)
            grade = 'Exceptional';
        else if (totalScore >= 25)
            grade = 'Excellent';
        else if (totalScore >= 18)
            grade = 'Good';
        else if (totalScore >= 12)
            grade = 'Average';
        else
            grade = 'Challenging';
        const p1Mangal = (idx1 === 0 || idx1 === 7 || idx1 === 9);
        const p2Mangal = (idx2 === 0 || idx2 === 7 || idx2 === 9);
        const isCancelled = p1Mangal && p2Mangal;
        let summary = `${p1} and ${p2} achieve an authentic Ashtakoota compatibility score of ${totalScore} out of 36 Gunas (${grade} match). `;
        if (bhakootScore === 0)
            summary += 'Bhakoot Dosh present — financial and emotional alignment requires remedies. ';
        if (nadiScore === 0)
            summary += 'Nadi Dosh observed — Mahamrityunjaya Japa recommended for health harmony. ';
        if (isCancelled)
            summary += 'Mangal Dosha is mutually cancelled between both charts.';
        return {
            partner1Sign: p1,
            partner2Sign: p2,
            varna: { score: varnaScore, max: 1 },
            vashya: { score: vashyaScore, max: 2 },
            tara: { score: taraScore, max: 3 },
            yoni: { score: yoniScore, max: 4 },
            maitri: { score: maitriScore, max: 5 },
            gana: { score: ganaScore, max: 6 },
            bhakoot: { score: bhakootScore, max: 7 },
            nadi: { score: nadiScore, max: 8 },
            totalScore,
            maxScore: 36,
            mangalDosha: {
                partner1: p1Mangal,
                partner2: p2Mangal,
                cancelation: isCancelled,
                summary: isCancelled ? 'Mutually Cancelled' : (p1Mangal || p2Mangal ? 'Active Mangal Dosh' : 'No Mangal Dosh'),
            },
            compatibilityGrade: grade,
            bhavishyavaniSummary: summary,
        };
    }
    normalizeSign(sign) {
        if (!sign)
            return 'Aries';
        const capitalized = sign.charAt(0).toUpperCase() + sign.slice(1).toLowerCase();
        return this.zodiacSigns.includes(capitalized) ? capitalized : 'Aries';
    }
    areFriends(l1, l2) {
        if (l1 === l2)
            return true;
        const friends = {
            'Sun': ['Moon', 'Mars', 'Jupiter'],
            'Moon': ['Sun', 'Mercury'],
            'Mars': ['Sun', 'Moon', 'Jupiter'],
            'Mercury': ['Sun', 'Venus'],
            'Jupiter': ['Sun', 'Moon', 'Mars'],
            'Venus': ['Mercury', 'Saturn'],
            'Saturn': ['Mercury', 'Venus']
        };
        return (friends[l1] || []).includes(l2);
    }
};
exports.MatchingService = MatchingService;
exports.MatchingService = MatchingService = __decorate([
    (0, common_1.Injectable)()
], MatchingService);
//# sourceMappingURL=matching.service.js.map
export interface AshtakootaMilanResult {
    partner1Sign: string;
    partner2Sign: string;
    varna: {
        score: number;
        max: number;
    };
    vashya: {
        score: number;
        max: number;
    };
    tara: {
        score: number;
        max: number;
    };
    yoni: {
        score: number;
        max: number;
    };
    maitri: {
        score: number;
        max: number;
    };
    gana: {
        score: number;
        max: number;
    };
    bhakoot: {
        score: number;
        max: number;
    };
    nadi: {
        score: number;
        max: number;
    };
    totalScore: number;
    maxScore: number;
    mangalDosha: {
        partner1: boolean;
        partner2: boolean;
        cancelation: boolean;
        summary: string;
    };
    compatibilityGrade: 'Exceptional' | 'Excellent' | 'Good' | 'Average' | 'Challenging';
    bhavishyavaniSummary: string;
}
export declare class MatchingService {
    private readonly zodiacSigns;
    calculateGunMilan(sign1: string, sign2: string): AshtakootaMilanResult;
    private normalizeSign;
    private areFriends;
}

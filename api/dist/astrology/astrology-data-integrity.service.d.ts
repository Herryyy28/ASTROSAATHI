import { CanonicalPanchang, CanonicalMuhurat, CanonicalGamePlan, CanonicalBirthChart } from './dto/canonical-models';
export declare class AstrologyDataIntegrityService {
    private readonly logger;
    normalizePanchang(apiData: any): CanonicalPanchang;
    normalizeMuhurat(apiData: any, category: string): CanonicalMuhurat;
    normalizeGamePlan(apiData: any, date: string): CanonicalGamePlan;
    normalizeBirthChart(apiData: any): CanonicalBirthChart;
}

import { PanchangResponse } from '../interfaces/astrology-data-provider.interface';
import { LocationData } from '../../core/location/location.service';
import { TimeService } from '../../core/time/time.service';
export declare class MuhuratEngine {
    private readonly timeService;
    constructor(timeService: TimeService);
    calculateMuhurat(category: string, date: Date, location: LocationData, panchang: PanchangResponse): {
        success: boolean;
        data: {
            category: string;
            quality: string;
            score: number;
            specificGuidance: string;
            bestWindow: {
                start: string;
                end: string;
            };
            strength: string;
            bestFor: string;
            avoidWindow: {
                start: string;
                end: string;
            } | null;
        };
    };
}

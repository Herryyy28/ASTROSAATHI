import { User } from './user.entity';
export declare class UserProfile {
    id: string;
    user: User;
    name: string;
    dob: Date;
    birthTime: string;
    birthLatitude: number;
    birthLongitude: number;
    birthTimeZone: string;
    currentLatitude: number;
    currentLongitude: number;
    currentTimeZone: string;
    focusWeights: Record<string, number>;
    createdAt: Date;
    updatedAt: Date;
}

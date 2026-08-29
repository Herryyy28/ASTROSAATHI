import { User } from './user.entity';
export declare class BirthProfile {
    id: string;
    userId: string;
    user: User;
    name: string;
    relationship: string;
    dob: string;
    birthTime: string;
    birthPlace: string;
    latitude: number;
    longitude: number;
    timezone: string;
    isPrimary: boolean;
    createdAt: Date;
    updatedAt: Date;
}

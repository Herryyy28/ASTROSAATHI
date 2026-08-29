import { UserProfile } from './profile.entity';
import { BirthProfile } from './birth_profile.entity';
export declare class User {
    id: string;
    email: string;
    firebaseUid: string;
    createdAt: Date;
    updatedAt: Date;
    profiles: UserProfile[];
    birthProfiles: BirthProfile[];
}

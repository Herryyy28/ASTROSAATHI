import { UserProfile } from './profile.entity';
export declare class User {
    id: string;
    email: string;
    firebaseUid: string;
    createdAt: Date;
    updatedAt: Date;
    profiles: UserProfile[];
}

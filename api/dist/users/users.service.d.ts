import { Repository } from 'typeorm';
import { User } from '../database/entities/user.entity';
import { UserProfile } from '../database/entities/profile.entity';
export declare class UsersService {
    private readonly userRepository;
    private readonly profileRepository;
    private readonly logger;
    constructor(userRepository: Repository<User>, profileRepository: Repository<UserProfile>);
    findOrCreateUser(firebaseUid: string, email: string): Promise<User>;
    upsertProfile(firebaseUid: string, profileData: Partial<UserProfile>): Promise<UserProfile>;
    getProfile(firebaseUid: string): Promise<UserProfile>;
}

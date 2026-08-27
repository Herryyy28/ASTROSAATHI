import { UsersService } from './users.service';
export declare class UsersController {
    private readonly usersService;
    constructor(usersService: UsersService);
    syncUser(req: any): Promise<{
        success: boolean;
        data: import("../database/entities/user.entity").User;
    }>;
    updateProfile(req: any, profileData: any): Promise<{
        success: boolean;
        data: import("../database/entities/profile.entity").UserProfile;
    }>;
    getProfile(req: any): Promise<{
        success: boolean;
        data: import("../database/entities/profile.entity").UserProfile;
    }>;
}

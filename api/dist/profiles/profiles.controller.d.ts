import { ProfilesService, BirthProfileDto } from './profiles.service';
export declare class ProfilesController {
    private readonly profilesService;
    constructor(profilesService: ProfilesService);
    getProfiles(): Promise<{
        success: boolean;
        data: BirthProfileDto[];
    }>;
    createProfile(body: BirthProfileDto): Promise<{
        success: boolean;
        data: BirthProfileDto;
    }>;
    setPrimary(id: string): Promise<{
        success: boolean;
        data: BirthProfileDto | null;
    }>;
    deleteProfile(id: string): Promise<{
        success: boolean;
    }>;
}

export interface BirthProfileDto {
    id?: string;
    userId: string;
    name: string;
    relationship: string;
    dob: string;
    birthTime: string;
    birthPlace: string;
    latitude: number;
    longitude: number;
    timezone: string;
    isPrimary?: boolean;
}
export declare class ProfilesService {
    private profilesStore;
    getProfiles(userId: string): Promise<BirthProfileDto[]>;
    createProfile(dto: BirthProfileDto): Promise<BirthProfileDto>;
    setPrimary(userId: string, profileId: string): Promise<BirthProfileDto | null>;
    deleteProfile(profileId: string): Promise<boolean>;
}

import { Injectable } from '@nestjs/common';

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

@Injectable()
export class ProfilesService {
  private profilesStore: BirthProfileDto[] = [];

  async getProfiles(userId: string): Promise<BirthProfileDto[]> {
    return this.profilesStore.filter((p) => p.userId === userId);
  }

  async createProfile(userId: string, dto: Omit<BirthProfileDto, 'userId'>): Promise<BirthProfileDto> {
    const newProfile: BirthProfileDto = {
      ...dto,
      userId,
      id: `profile-${Date.now()}-${Math.floor(Math.random() * 1000)}`,
      isPrimary: dto.isPrimary ?? false,
    };
    if (newProfile.isPrimary) {
      this.profilesStore.forEach((p) => {
        if (p.userId === userId) {
          p.isPrimary = false;
        }
      });
    }
    this.profilesStore.push(newProfile);
    return newProfile;
  }

  async setPrimary(userId: string, profileId: string): Promise<BirthProfileDto | null> {
    let found: BirthProfileDto | null = null;
    // Check ownership first
    const profile = this.profilesStore.find((p) => p.id === profileId && p.userId === userId);
    if (!profile) {
      return null;
    }
    this.profilesStore.forEach((p) => {
      if (p.userId === userId) {
        if (p.id === profileId) {
          p.isPrimary = true;
          found = p;
        } else {
          p.isPrimary = false;
        }
      }
    });
    return found;
  }

  async deleteProfile(userId: string, profileId: string): Promise<boolean> {
    const initialLen = this.profilesStore.length;
    this.profilesStore = this.profilesStore.filter(
      (p) => !(p.id === profileId && p.userId === userId),
    );
    return this.profilesStore.length < initialLen;
  }
}

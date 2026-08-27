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
  private profilesStore: BirthProfileDto[] = [
    {
      id: 'default-primary-1',
      userId: 'user-123',
      name: 'My Kundli (Self)',
      relationship: 'Self',
      dob: '1996-08-15',
      birthTime: '07:30',
      birthPlace: 'New Delhi, India',
      latitude: 28.6139,
      longitude: 77.2090,
      timezone: '5.5',
      isPrimary: true,
    },
    {
      id: 'default-partner-2',
      userId: 'user-123',
      name: 'Priya (Partner)',
      relationship: 'Partner',
      dob: '1998-05-20',
      birthTime: '14:15',
      birthPlace: 'Mumbai, India',
      latitude: 19.0760,
      longitude: 72.8777,
      timezone: '5.5',
      isPrimary: false,
    },
  ];

  async getProfiles(userId: string): Promise<BirthProfileDto[]> {
    return this.profilesStore.filter((p) => p.userId === userId || p.userId === 'user-123');
  }

  async createProfile(dto: BirthProfileDto): Promise<BirthProfileDto> {
    const newProfile: BirthProfileDto = {
      ...dto,
      id: `profile-${Date.now()}`,
      isPrimary: dto.isPrimary ?? false,
    };
    if (newProfile.isPrimary) {
      this.profilesStore.forEach((p) => (p.isPrimary = false));
    }
    this.profilesStore.push(newProfile);
    return newProfile;
  }

  async setPrimary(userId: string, profileId: string): Promise<BirthProfileDto | null> {
    let found: BirthProfileDto | null = null;
    this.profilesStore.forEach((p) => {
      if (p.id === profileId) {
        p.isPrimary = true;
        found = p;
      } else {
        p.isPrimary = false;
      }
    });
    return found;
  }

  async deleteProfile(profileId: string): Promise<boolean> {
    const initialLen = this.profilesStore.length;
    this.profilesStore = this.profilesStore.filter((p) => p.id !== profileId);
    return this.profilesStore.length < initialLen;
  }
}

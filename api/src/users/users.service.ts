import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../database/entities/user.entity';
import { UserProfile } from '../database/entities/profile.entity';

@Injectable()
export class UsersService {
  private readonly logger = new Logger(UsersService.name);

  constructor(
    @InjectRepository(User) private readonly userRepository: Repository<User>,
    @InjectRepository(UserProfile) private readonly profileRepository: Repository<UserProfile>,
  ) {}

  async findOrCreateUser(firebaseUid: string, email: string, authProvider: string = 'GOOGLE'): Promise<User> {
    let user = await this.userRepository.findOne({ where: { firebaseUid } });
    if (!user) {
      user = this.userRepository.create({ firebaseUid, email, authProvider });
      await this.userRepository.save(user);
    } else if (authProvider && user.authProvider !== authProvider) {
      user.authProvider = authProvider;
      await this.userRepository.save(user);
    }
    return user;
  }

  async upsertProfile(firebaseUid: string, profileData: Partial<UserProfile>): Promise<UserProfile> {
    const user = await this.userRepository.findOne({ where: { firebaseUid }, relations: ['profiles'] });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    let profile = user.profiles.length > 0 ? user.profiles[0] : null;

    if (profile) {
      Object.assign(profile, profileData);
    } else {
      profile = this.profileRepository.create({
        ...profileData,
        user,
      });
    }

    return this.profileRepository.save(profile);
  }

  async getProfile(firebaseUid: string): Promise<UserProfile> {
    const user = await this.userRepository.findOne({ where: { firebaseUid }, relations: ['profiles'] });
    if (!user || user.profiles.length === 0) {
      throw new NotFoundException('Profile not found');
    }
    return user.profiles[0];
  }
}

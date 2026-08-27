import { Controller, Get, Post, Body, Param, Delete, Patch } from '@nestjs/common';
import { ProfilesService, BirthProfileDto } from './profiles.service';

@Controller('profiles')
export class ProfilesController {
  constructor(private readonly profilesService: ProfilesService) {}

  @Get()
  async getProfiles() {
    const userId = 'user-123';
    const data = await this.profilesService.getProfiles(userId);
    return { success: true, data };
  }

  @Post()
  async createProfile(@Body() body: BirthProfileDto) {
    const data = await this.profilesService.createProfile(body);
    return { success: true, data };
  }

  @Patch(':id/set-primary')
  async setPrimary(@Param('id') id: string) {
    const userId = 'user-123';
    const data = await this.profilesService.setPrimary(userId, id);
    return { success: true, data };
  }

  @Delete(':id')
  async deleteProfile(@Param('id') id: string) {
    const success = await this.profilesService.deleteProfile(id);
    return { success };
  }
}

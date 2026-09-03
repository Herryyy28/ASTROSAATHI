import { Controller, Get, Post, Body, Param, Delete, Patch, Req, UseGuards, ForbiddenException } from '@nestjs/common';
import { ProfilesService, BirthProfileDto } from './profiles.service';
import { AuthGuard } from '../auth/auth.guard';

@Controller('profiles')
@UseGuards(AuthGuard)
export class ProfilesController {
  constructor(private readonly profilesService: ProfilesService) {}

  @Get()
  async getProfiles(@Req() req: any) {
    const userId = req.user.uid;
    const data = await this.profilesService.getProfiles(userId);
    return { success: true, data };
  }

  @Post()
  async createProfile(@Req() req: any, @Body() body: Omit<BirthProfileDto, 'userId'>) {
    const userId = req.user.uid;
    const data = await this.profilesService.createProfile(userId, body);
    return { success: true, data };
  }

  @Patch(':id/set-primary')
  async setPrimary(@Req() req: any, @Param('id') id: string) {
    const userId = req.user.uid;
    const data = await this.profilesService.setPrimary(userId, id);
    if (!data) {
      throw new ForbiddenException('Profile not found or access denied');
    }
    return { success: true, data };
  }

  @Delete(':id')
  async deleteProfile(@Req() req: any, @Param('id') id: string) {
    const userId = req.user.uid;
    const success = await this.profilesService.deleteProfile(userId, id);
    if (!success) {
      throw new ForbiddenException('Profile not found or access denied');
    }
    return { success: true };
  }
}

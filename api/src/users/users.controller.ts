import { Controller, Post, Get, Body, Req, UseGuards } from '@nestjs/common';
import { UsersService } from './users.service';
import { AuthGuard } from '../auth/auth.guard';

@Controller('users')
@UseGuards(AuthGuard)
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post('sync')
  async syncUser(@Req() req: any, @Body() body: any) {
    const provider = body?.authProvider || req.user?.firebase?.sign_in_provider === 'password' ? 'EMAIL_PASSWORD' : 'GOOGLE';
    const user = await this.usersService.findOrCreateUser(req.user.uid, req.user.email, provider);
    return { success: true, data: user };
  }

  @Post('profile')
  async updateProfile(@Req() req: any, @Body() profileData: any) {
    const profile = await this.usersService.upsertProfile(req.user.uid, profileData);
    return { success: true, data: profile };
  }

  @Get('profile')
  async getProfile(@Req() req: any) {
    const profile = await this.usersService.getProfile(req.user.uid);
    return { success: true, data: profile };
  }
}

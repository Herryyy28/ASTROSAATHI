import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CronService } from './cron.service';
import { UserProfile } from '../database/entities/profile.entity';
import { AstrologyModule } from '../astrology/astrology.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([UserProfile]),
    AstrologyModule,
  ],
  providers: [CronService],
})
export class NotificationsModule {}

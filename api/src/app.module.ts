import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AstrologyModule } from './astrology/astrology.module';
import { AiModule } from './ai/ai.module';
import { DatabaseModule } from './database/database.module';
import { CoreModule } from './core/core.module';
// import { BullModule } from '@nestjs/bullmq';
import { ScheduleModule } from '@nestjs/schedule';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { NotificationsModule } from './notifications/notifications.module';

import { ProfilesModule } from './profiles/profiles.module';
import { PaymentsModule } from './payments/payments.module';
import { AdminModule } from './admin/admin.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    ScheduleModule.forRoot(),
    /*
    BullModule.forRoot({
      connection: {
        host: process.env.REDIS_HOST || 'localhost',
        port: parseInt(process.env.REDIS_PORT || '6379', 10),
      },
      // Prevent crash if Redis is unavailable
      defaultJobOptions: {
        removeOnComplete: true,
        attempts: 3,
      },
    }),
    */
    DatabaseModule,
    CoreModule,
    AuthModule,
    UsersModule,
    ProfilesModule,
    NotificationsModule,
    AstrologyModule, 
    AiModule,
    PaymentsModule,
    AdminModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}

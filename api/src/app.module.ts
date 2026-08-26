import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AstrologyModule } from './astrology/astrology.module';
import { AiModule } from './ai/ai.module';
import { DatabaseModule } from './database/database.module';
import { CoreModule } from './core/core.module';
import { BullModule } from '@nestjs/bullmq';
import { ScheduleModule } from '@nestjs/schedule';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { NotificationsModule } from './notifications/notifications.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    ScheduleModule.forRoot(),
    BullModule.forRoot({
      connection: {
        host: process.env.REDIS_HOST || 'localhost',
        port: parseInt(process.env.REDIS_PORT || '6379', 10),
      },
    }),
    DatabaseModule,
    CoreModule,
    AuthModule,
    UsersModule,
    NotificationsModule,
    AstrologyModule, 
    AiModule
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}

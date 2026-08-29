import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { User } from './entities/user.entity';
import { UserProfile } from './entities/profile.entity';
import { KnowledgeRashi } from './entities/knowledge_rashi.entity';
import { KnowledgeBhava } from './entities/knowledge_bhava.entity';
import { KnowledgeGraha } from './entities/knowledge_graha.entity';
import { BirthProfile } from './entities/birth_profile.entity';
import { AstroMessage } from './entities/astro_message.entity';

@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (configService: ConfigService) => {
        const isDev = configService.get<string>('NODE_ENV') === 'development' || !configService.get('DB_HOST');

        if (isDev) {
          return {
            type: 'sqlite',
            database: 'database.sqlite',
            entities: [User, UserProfile, KnowledgeRashi, KnowledgeBhava, KnowledgeGraha, BirthProfile, AstroMessage],
            synchronize: true,
          };
        }

        return {
          type: 'postgres',
          host: configService.get<string>('DB_HOST', 'localhost'),
          port: configService.get<number>('DB_PORT', 5432),
          username: configService.get<string>('DB_USERNAME', 'postgres'),
          password: configService.get<string>('DB_PASSWORD', 'postgres'),
          database: configService.get<string>('DB_DATABASE', 'astrosaathi'),
          entities: [User, UserProfile, KnowledgeRashi, KnowledgeBhava, KnowledgeGraha, BirthProfile, AstroMessage],
          synchronize: true,
        };
      },
      inject: [ConfigService],
    }),
    TypeOrmModule.forFeature([User, UserProfile, KnowledgeRashi, KnowledgeBhava, KnowledgeGraha, BirthProfile, AstroMessage]),
  ],
  exports: [TypeOrmModule],
})
export class DatabaseModule {}

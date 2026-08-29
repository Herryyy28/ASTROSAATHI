"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.DatabaseModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const config_1 = require("@nestjs/config");
const user_entity_1 = require("./entities/user.entity");
const profile_entity_1 = require("./entities/profile.entity");
const knowledge_rashi_entity_1 = require("./entities/knowledge_rashi.entity");
const knowledge_bhava_entity_1 = require("./entities/knowledge_bhava.entity");
const knowledge_graha_entity_1 = require("./entities/knowledge_graha.entity");
const birth_profile_entity_1 = require("./entities/birth_profile.entity");
const astro_message_entity_1 = require("./entities/astro_message.entity");
let DatabaseModule = class DatabaseModule {
};
exports.DatabaseModule = DatabaseModule;
exports.DatabaseModule = DatabaseModule = __decorate([
    (0, common_1.Module)({
        imports: [
            typeorm_1.TypeOrmModule.forRootAsync({
                imports: [config_1.ConfigModule],
                useFactory: (configService) => {
                    const isDev = configService.get('NODE_ENV') === 'development' || !configService.get('DB_HOST');
                    if (isDev) {
                        return {
                            type: 'sqlite',
                            database: 'database.sqlite',
                            entities: [user_entity_1.User, profile_entity_1.UserProfile, knowledge_rashi_entity_1.KnowledgeRashi, knowledge_bhava_entity_1.KnowledgeBhava, knowledge_graha_entity_1.KnowledgeGraha, birth_profile_entity_1.BirthProfile, astro_message_entity_1.AstroMessage],
                            synchronize: true,
                        };
                    }
                    return {
                        type: 'postgres',
                        host: configService.get('DB_HOST', 'localhost'),
                        port: configService.get('DB_PORT', 5432),
                        username: configService.get('DB_USERNAME', 'postgres'),
                        password: configService.get('DB_PASSWORD', 'postgres'),
                        database: configService.get('DB_DATABASE', 'astrosaathi'),
                        entities: [user_entity_1.User, profile_entity_1.UserProfile, knowledge_rashi_entity_1.KnowledgeRashi, knowledge_bhava_entity_1.KnowledgeBhava, knowledge_graha_entity_1.KnowledgeGraha, birth_profile_entity_1.BirthProfile, astro_message_entity_1.AstroMessage],
                        synchronize: true,
                    };
                },
                inject: [config_1.ConfigService],
            }),
            typeorm_1.TypeOrmModule.forFeature([user_entity_1.User, profile_entity_1.UserProfile, knowledge_rashi_entity_1.KnowledgeRashi, knowledge_bhava_entity_1.KnowledgeBhava, knowledge_graha_entity_1.KnowledgeGraha, birth_profile_entity_1.BirthProfile, astro_message_entity_1.AstroMessage]),
        ],
        exports: [typeorm_1.TypeOrmModule],
    })
], DatabaseModule);
//# sourceMappingURL=database.module.js.map
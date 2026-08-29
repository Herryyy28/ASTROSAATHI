"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AstrologyModule = void 0;
const common_1 = require("@nestjs/common");
const astrology_service_1 = require("./astrology.service");
const astrology_controller_1 = require("./astrology.controller");
const astrology_sync_service_1 = require("./astrology-sync.service");
const astrology_api_provider_1 = require("./providers/astrology-api.provider");
const mock_astrology_provider_1 = require("./providers/mock-astrology.provider");
const astrology_rule_engine_1 = require("./engines/astrology-rule.engine");
const game_plan_engine_1 = require("./engines/game-plan.engine");
const muhurat_engine_1 = require("./engines/muhurat.engine");
const rashi_bhavishya_service_1 = require("./rashi-bhavishya.service");
const users_module_1 = require("../users/users.module");
const core_module_1 = require("../core/core.module");
const astrology_data_integrity_service_1 = require("./astrology-data-integrity.service");
const matching_service_1 = require("./matching.service");
const knowledge_rashi_entity_1 = require("../database/entities/knowledge_rashi.entity");
const typeorm_1 = require("@nestjs/typeorm");
const ai_module_1 = require("../ai/ai.module");
const common_2 = require("@nestjs/common");
let AstrologyModule = class AstrologyModule {
};
exports.AstrologyModule = AstrologyModule;
exports.AstrologyModule = AstrologyModule = __decorate([
    (0, common_1.Module)({
        imports: [
            users_module_1.UsersModule,
            core_module_1.CoreModule,
            typeorm_1.TypeOrmModule.forFeature([knowledge_rashi_entity_1.KnowledgeRashi]),
            (0, common_2.forwardRef)(() => ai_module_1.AiModule)
        ],
        providers: [
            astrology_service_1.AstrologyService,
            astrology_sync_service_1.AstrologySyncService,
            matching_service_1.MatchingService,
            astrology_api_provider_1.AstrologyApiProvider,
            mock_astrology_provider_1.MockAstrologyProvider,
            astrology_rule_engine_1.AstrologyRuleEngine,
            game_plan_engine_1.GamePlanEngine,
            muhurat_engine_1.MuhuratEngine,
            rashi_bhavishya_service_1.RashiBhavishyaService,
            astrology_data_integrity_service_1.AstrologyDataIntegrityService,
            {
                provide: 'ASTROLOGY_PROVIDER',
                useClass: process.env.USE_MOCK_PROVIDER === 'true' ? mock_astrology_provider_1.MockAstrologyProvider : astrology_api_provider_1.AstrologyApiProvider,
            },
        ],
        controllers: [astrology_controller_1.AstrologyController],
        exports: [astrology_service_1.AstrologyService, astrology_sync_service_1.AstrologySyncService, matching_service_1.MatchingService, game_plan_engine_1.GamePlanEngine, muhurat_engine_1.MuhuratEngine, rashi_bhavishya_service_1.RashiBhavishyaService],
    })
], AstrologyModule);
//# sourceMappingURL=astrology.module.js.map
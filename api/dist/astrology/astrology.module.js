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
const bullmq_1 = require("@nestjs/bullmq");
const astrology_service_1 = require("./astrology.service");
const astrology_controller_1 = require("./astrology.controller");
const astrology_sync_service_1 = require("./astrology-sync.service");
const astrology_api_provider_1 = require("./providers/astrology-api.provider");
const mock_astrology_provider_1 = require("./providers/mock-astrology.provider");
const astrology_sync_processor_1 = require("./processors/astrology-sync.processor");
const astrology_rule_engine_1 = require("./engines/astrology-rule.engine");
const game_plan_engine_1 = require("./engines/game-plan.engine");
const muhurat_engine_1 = require("./engines/muhurat.engine");
const users_module_1 = require("../users/users.module");
const core_module_1 = require("../core/core.module");
let AstrologyModule = class AstrologyModule {
};
exports.AstrologyModule = AstrologyModule;
exports.AstrologyModule = AstrologyModule = __decorate([
    (0, common_1.Module)({
        imports: [
            bullmq_1.BullModule.registerQueue({
                name: 'astrology-sync',
            }),
            users_module_1.UsersModule,
            core_module_1.CoreModule,
        ],
        providers: [
            astrology_service_1.AstrologyService,
            astrology_sync_service_1.AstrologySyncService,
            astrology_api_provider_1.AstrologyApiProvider,
            mock_astrology_provider_1.MockAstrologyProvider,
            astrology_sync_processor_1.AstrologySyncProcessor,
            astrology_rule_engine_1.AstrologyRuleEngine,
            game_plan_engine_1.GamePlanEngine,
            muhurat_engine_1.MuhuratEngine,
            {
                provide: 'ASTROLOGY_PROVIDER',
                useClass: process.env.USE_MOCK_PROVIDER === 'true' ? mock_astrology_provider_1.MockAstrologyProvider : astrology_api_provider_1.AstrologyApiProvider,
            },
        ],
        controllers: [astrology_controller_1.AstrologyController],
        exports: [astrology_service_1.AstrologyService, astrology_sync_service_1.AstrologySyncService, game_plan_engine_1.GamePlanEngine, muhurat_engine_1.MuhuratEngine],
    })
], AstrologyModule);
//# sourceMappingURL=astrology.module.js.map
"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
var KnowledgeRetrievalService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.KnowledgeRetrievalService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const knowledge_rashi_entity_1 = require("../database/entities/knowledge_rashi.entity");
const knowledge_bhava_entity_1 = require("../database/entities/knowledge_bhava.entity");
const knowledge_graha_entity_1 = require("../database/entities/knowledge_graha.entity");
let KnowledgeRetrievalService = KnowledgeRetrievalService_1 = class KnowledgeRetrievalService {
    constructor(rashiRepo, bhavaRepo, grahaRepo) {
        this.rashiRepo = rashiRepo;
        this.bhavaRepo = bhavaRepo;
        this.grahaRepo = grahaRepo;
        this.logger = new common_1.Logger(KnowledgeRetrievalService_1.name);
    }
    async retrieveContextualKnowledge(query, currentTransitRashi) {
        const knowledgeChunks = [];
        try {
            if (currentTransitRashi) {
                const rashiKnowledge = await this.rashiRepo.findOne({
                    where: { name: currentTransitRashi },
                });
                if (rashiKnowledge) {
                    knowledgeChunks.push({
                        type: 'rashi_context',
                        rashi: rashiKnowledge.name,
                        lord: rashiKnowledge.lord,
                        nature: rashiKnowledge.nature,
                        careerThemes: rashiKnowledge.careerThemes,
                    });
                }
            }
            const grahas = ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn', 'Rahu', 'Ketu'];
            for (const g of grahas) {
                if (query.toLowerCase().includes(g.toLowerCase())) {
                    const grahaKnowledge = await this.grahaRepo.findOne({ where: { name: g } });
                    if (grahaKnowledge) {
                        knowledgeChunks.push({
                            type: 'graha_context',
                            graha: grahaKnowledge.name,
                            nature: grahaKnowledge.nature,
                            karakatwa: grahaKnowledge.karakatwa,
                        });
                    }
                }
            }
        }
        catch (e) {
            this.logger.error('Failed to retrieve knowledge chunks', e);
        }
        return knowledgeChunks;
    }
};
exports.KnowledgeRetrievalService = KnowledgeRetrievalService;
exports.KnowledgeRetrievalService = KnowledgeRetrievalService = KnowledgeRetrievalService_1 = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(knowledge_rashi_entity_1.KnowledgeRashi)),
    __param(1, (0, typeorm_1.InjectRepository)(knowledge_bhava_entity_1.KnowledgeBhava)),
    __param(2, (0, typeorm_1.InjectRepository)(knowledge_graha_entity_1.KnowledgeGraha)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository])
], KnowledgeRetrievalService);
//# sourceMappingURL=knowledge-retrieval.service.js.map
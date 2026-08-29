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
Object.defineProperty(exports, "__esModule", { value: true });
exports.KnowledgeBhava = void 0;
const typeorm_1 = require("typeorm");
let KnowledgeBhava = class KnowledgeBhava {
    constructor() {
        this.primaryThemes = [];
        this.secondaryThemes = [];
        this.traditionalAssociations = [];
        this.lifeAreas = [];
        this.naturalSignificators = [];
        this.positiveManifestations = [];
        this.challengingManifestations = [];
    }
};
exports.KnowledgeBhava = KnowledgeBhava;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)('uuid'),
    __metadata("design:type", String)
], KnowledgeBhava.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], KnowledgeBhava.prototype, "houseNumber", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", String)
], KnowledgeBhava.prototype, "sanskritName", void 0);
__decorate([
    (0, typeorm_1.Column)('simple-array', { nullable: true }),
    __metadata("design:type", Array)
], KnowledgeBhava.prototype, "primaryThemes", void 0);
__decorate([
    (0, typeorm_1.Column)('simple-array', { nullable: true }),
    __metadata("design:type", Array)
], KnowledgeBhava.prototype, "secondaryThemes", void 0);
__decorate([
    (0, typeorm_1.Column)('simple-array', { nullable: true }),
    __metadata("design:type", Array)
], KnowledgeBhava.prototype, "traditionalAssociations", void 0);
__decorate([
    (0, typeorm_1.Column)('simple-array', { nullable: true }),
    __metadata("design:type", Array)
], KnowledgeBhava.prototype, "lifeAreas", void 0);
__decorate([
    (0, typeorm_1.Column)('simple-array', { nullable: true }),
    __metadata("design:type", Array)
], KnowledgeBhava.prototype, "naturalSignificators", void 0);
__decorate([
    (0, typeorm_1.Column)('simple-array', { nullable: true }),
    __metadata("design:type", Array)
], KnowledgeBhava.prototype, "positiveManifestations", void 0);
__decorate([
    (0, typeorm_1.Column)('simple-array', { nullable: true }),
    __metadata("design:type", Array)
], KnowledgeBhava.prototype, "challengingManifestations", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)(),
    __metadata("design:type", Date)
], KnowledgeBhava.prototype, "createdAt", void 0);
__decorate([
    (0, typeorm_1.UpdateDateColumn)(),
    __metadata("design:type", Date)
], KnowledgeBhava.prototype, "updatedAt", void 0);
exports.KnowledgeBhava = KnowledgeBhava = __decorate([
    (0, typeorm_1.Entity)('knowledge_bhava')
], KnowledgeBhava);
//# sourceMappingURL=knowledge_bhava.entity.js.map
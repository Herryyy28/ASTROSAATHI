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
var UsersService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.UsersService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const user_entity_1 = require("../database/entities/user.entity");
const profile_entity_1 = require("../database/entities/profile.entity");
let UsersService = UsersService_1 = class UsersService {
    constructor(userRepository, profileRepository) {
        this.userRepository = userRepository;
        this.profileRepository = profileRepository;
        this.logger = new common_1.Logger(UsersService_1.name);
    }
    async findOrCreateUser(firebaseUid, email) {
        let user = await this.userRepository.findOne({ where: { firebaseUid } });
        if (!user) {
            user = this.userRepository.create({ firebaseUid, email });
            await this.userRepository.save(user);
        }
        return user;
    }
    async upsertProfile(firebaseUid, profileData) {
        const user = await this.userRepository.findOne({ where: { firebaseUid }, relations: ['profiles'] });
        if (!user) {
            throw new common_1.NotFoundException('User not found');
        }
        let profile = user.profiles.length > 0 ? user.profiles[0] : null;
        if (profile) {
            Object.assign(profile, profileData);
        }
        else {
            profile = this.profileRepository.create({
                ...profileData,
                user,
            });
        }
        return this.profileRepository.save(profile);
    }
    async getProfile(firebaseUid) {
        const user = await this.userRepository.findOne({ where: { firebaseUid }, relations: ['profiles'] });
        if (!user || user.profiles.length === 0) {
            throw new common_1.NotFoundException('Profile not found');
        }
        return user.profiles[0];
    }
};
exports.UsersService = UsersService;
exports.UsersService = UsersService = UsersService_1 = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __param(1, (0, typeorm_1.InjectRepository)(profile_entity_1.UserProfile)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository])
], UsersService);
//# sourceMappingURL=users.service.js.map
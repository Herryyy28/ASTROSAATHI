"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProfilesService = void 0;
const common_1 = require("@nestjs/common");
let ProfilesService = class ProfilesService {
    constructor() {
        this.profilesStore = [
            {
                id: 'default-primary-1',
                userId: 'user-123',
                name: 'My Kundli (Self)',
                relationship: 'Self',
                dob: '1996-08-15',
                birthTime: '07:30',
                birthPlace: 'New Delhi, India',
                latitude: 28.6139,
                longitude: 77.2090,
                timezone: '5.5',
                isPrimary: true,
            },
            {
                id: 'default-partner-2',
                userId: 'user-123',
                name: 'Priya (Partner)',
                relationship: 'Partner',
                dob: '1998-05-20',
                birthTime: '14:15',
                birthPlace: 'Mumbai, India',
                latitude: 19.0760,
                longitude: 72.8777,
                timezone: '5.5',
                isPrimary: false,
            },
        ];
    }
    async getProfiles(userId) {
        return this.profilesStore.filter((p) => p.userId === userId || p.userId === 'user-123');
    }
    async createProfile(dto) {
        const newProfile = {
            ...dto,
            id: `profile-${Date.now()}`,
            isPrimary: dto.isPrimary ?? false,
        };
        if (newProfile.isPrimary) {
            this.profilesStore.forEach((p) => (p.isPrimary = false));
        }
        this.profilesStore.push(newProfile);
        return newProfile;
    }
    async setPrimary(userId, profileId) {
        let found = null;
        this.profilesStore.forEach((p) => {
            if (p.id === profileId) {
                p.isPrimary = true;
                found = p;
            }
            else {
                p.isPrimary = false;
            }
        });
        return found;
    }
    async deleteProfile(profileId) {
        const initialLen = this.profilesStore.length;
        this.profilesStore = this.profilesStore.filter((p) => p.id !== profileId);
        return this.profilesStore.length < initialLen;
    }
};
exports.ProfilesService = ProfilesService;
exports.ProfilesService = ProfilesService = __decorate([
    (0, common_1.Injectable)()
], ProfilesService);
//# sourceMappingURL=profiles.service.js.map
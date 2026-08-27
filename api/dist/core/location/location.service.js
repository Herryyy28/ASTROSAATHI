"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.LocationService = void 0;
const common_1 = require("@nestjs/common");
let LocationService = class LocationService {
    isValidLocation(location) {
        return (location.latitude !== undefined &&
            location.longitude !== undefined &&
            !!location.timeZone);
    }
    hasLocationChanged(oldLocation, newLocation) {
        if (!oldLocation)
            return true;
        const latDiff = Math.abs(oldLocation.latitude - newLocation.latitude);
        const lonDiff = Math.abs(oldLocation.longitude - newLocation.longitude);
        return latDiff > 0.1 || lonDiff > 0.1 || oldLocation.timeZone !== newLocation.timeZone;
    }
};
exports.LocationService = LocationService;
exports.LocationService = LocationService = __decorate([
    (0, common_1.Injectable)()
], LocationService);
//# sourceMappingURL=location.service.js.map
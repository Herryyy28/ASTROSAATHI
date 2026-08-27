"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.TimeService = void 0;
const common_1 = require("@nestjs/common");
const date_fns_tz_1 = require("date-fns-tz");
let TimeService = class TimeService {
    getCurrentUtcTime() {
        return new Date();
    }
    getCurrentLocalTime(timeZone) {
        const utcDate = this.getCurrentUtcTime();
        return (0, date_fns_tz_1.toZonedTime)(utcDate, timeZone);
    }
    formatLocalTime(date, timeZone, pattern = 'yyyy-MM-dd hh:mm a') {
        return (0, date_fns_tz_1.formatInTimeZone)(date, timeZone, pattern);
    }
    getCurrentLocalHour(timeZone) {
        const localTime = this.getCurrentLocalTime(timeZone);
        return localTime.getHours();
    }
    getCurrentLocalDateString(timeZone) {
        return this.formatLocalTime(this.getCurrentUtcTime(), timeZone, 'yyyy-MM-dd');
    }
};
exports.TimeService = TimeService;
exports.TimeService = TimeService = __decorate([
    (0, common_1.Injectable)()
], TimeService);
//# sourceMappingURL=time.service.js.map
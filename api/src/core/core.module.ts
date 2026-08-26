import { Module } from '@nestjs/common';
import { TimeService } from './time/time.service';
import { LocationService } from './location/location.service';

@Module({
  providers: [TimeService, LocationService],
  exports: [TimeService, LocationService],
})
export class CoreModule {}

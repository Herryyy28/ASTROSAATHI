import { Injectable } from '@nestjs/common';

export interface LocationData {
  latitude: number;
  longitude: number;
  timeZone: string;
  cityName?: string;
}

@Injectable()
export class LocationService {
  
  /**
   * Validates if a location is complete enough for astrological calculations.
   */
  isValidLocation(location: LocationData): boolean {
    return (
      location.latitude !== undefined &&
      location.longitude !== undefined &&
      !!location.timeZone
    );
  }

  /**
   * Determines if the current location has changed significantly from the cached location.
   * A change in city or a significant change in lat/lon invalidates location-sensitive data.
   */
  hasLocationChanged(oldLocation: LocationData, newLocation: LocationData): boolean {
    if (!oldLocation) return true;
    
    // Simple tolerance check (e.g., ~10km radius)
    const latDiff = Math.abs(oldLocation.latitude - newLocation.latitude);
    const lonDiff = Math.abs(oldLocation.longitude - newLocation.longitude);
    
    return latDiff > 0.1 || lonDiff > 0.1 || oldLocation.timeZone !== newLocation.timeZone;
  }
}

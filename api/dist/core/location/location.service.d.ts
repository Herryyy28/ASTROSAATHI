export interface LocationData {
    latitude: number;
    longitude: number;
    timeZone: string;
    cityName?: string;
}
export declare class LocationService {
    isValidLocation(location: LocationData): boolean;
    hasLocationChanged(oldLocation: LocationData, newLocation: LocationData): boolean;
}

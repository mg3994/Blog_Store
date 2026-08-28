import '../../features/catalog/domain/entities/user_location.dart';

enum LocationPermissionStatus {
  denied,
  deniedForever,
  whileInUse,
  always,
  unableToDetermine,
}

abstract class LocationService {
  /// Checks whether location services are enabled on the device.
  Future<bool> isLocationServiceEnabled();

  /// Checks the current location permission status.
  Future<LocationPermissionStatus> checkPermissionStatus();

  /// Requests location permission from the user.
  Future<LocationPermissionStatus> requestPermission();

  /// Gets the user's current device position and attempts reverse geocoding to return a [UserLocation].
  Future<UserLocation?> getCurrentLocation();

  /// Performs reverse geocoding for given latitude and longitude coordinates.
  Future<UserLocation?> getLocationFromCoordinates(
    double latitude,
    double longitude,
  );

  /// Performs forward geocoding for a given address string.
  Future<List<UserLocation>> getLocationsFromAddress(String address);
}

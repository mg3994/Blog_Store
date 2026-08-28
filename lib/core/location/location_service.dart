import 'package:geocoding/geocoding.dart' show Placemark, Location;
import 'package:geolocator/geolocator.dart' as gl;
import 'package:material_ui/material_ui.dart' show Locale;

import '../../features/catalog/domain/entities/user_location.dart';

abstract class LocationService {
  /// Checks whether location services are enabled on the device.
  Future<bool> isLocationServiceEnabled();

  /// Checks the current location permission status.
  Future<gl.LocationPermission> checkPermissionStatus();

  /// Requests location permission from the user.
  Future<gl.LocationPermission> requestPermission();

  Future<bool> openAppSettings();

  Future<bool> openLocationSettings();

  /// Retrieves the raw device coordinates after handling permissions and service checks.
  Future<gl.Position?> getUserCoordinates();

  /// Performs forward geocoding for a given address string.
  Future<List<Location>> getLocationsFromAddress(
    String address, {
    Locale? locale,
  });

  /// Performs reverse geocoding for given latitude and longitude coordinates.
  Future<List<Placemark>> placemarkFromCoordinates(
    double latitude,
    double longitude, {
    Locale? locale,
  });
  //
  Future<List<Placemark>> placemarkFromAddress(
    String address, {
    Locale? locale,
  });

  /// Gets the user's current device position and attempts reverse geocoding to return a list of [UserLocation].
  Future<List<Placemark?>> getCurrentLocationAddress({Locale? locale});

  double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  );

  double bearingBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  );
}

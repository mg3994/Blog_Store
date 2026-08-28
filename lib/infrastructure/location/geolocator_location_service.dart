import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart' as gl;
import 'package:material_ui/material_ui.dart' show Locale;

import '../../core/location/location_service.dart';

class GeolocatorLocationService implements LocationService {
  GeolocatorLocationService([geo.Geocoding? geocoding])
    : _geocoding = geocoding ?? geo.Geocoding();

  final geo.Geocoding _geocoding;

  @override
  Future<bool> isLocationServiceEnabled() =>
      gl.Geolocator.isLocationServiceEnabled();

  @override
  Future<gl.LocationPermission> checkPermissionStatus() =>
      gl.Geolocator.checkPermission();

  @override
  Future<gl.LocationPermission> requestPermission() =>
      gl.Geolocator.requestPermission();

  @override
  Future<bool> openAppSettings() => gl.Geolocator.openAppSettings();

  @override
  Future<bool> openLocationSettings() => gl.Geolocator.openLocationSettings();

  @override
  Future<gl.Position?> getUserCoordinates() async {
    final isEnabled = await isLocationServiceEnabled();
    if (!isEnabled) {
      return null;
    }

    var permissionStatus = await checkPermissionStatus();
    if (permissionStatus == gl.LocationPermission.denied) {
      permissionStatus = await requestPermission();
    }

    if (permissionStatus == gl.LocationPermission.deniedForever ||
        permissionStatus == gl.LocationPermission.unableToDetermine) {
      await openLocationSettings();
      return null;
    }

    if (permissionStatus != gl.LocationPermission.whileInUse &&
        permissionStatus != gl.LocationPermission.always) {
      return null;
    }
    try {
      return await gl.Geolocator.getCurrentPosition(
        locationSettings: const gl.LocationSettings(
          accuracy: gl.LocationAccuracy.high,
        ),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<geo.Location>> getLocationsFromAddress(
    String address, {
    Locale? locale,
  }) async => _geocoding.locationFromAddress(address, locale: locale);

  @override
  Future<List<geo.Placemark>> placemarkFromCoordinates(
    double latitude,
    double longitude, {
    Locale? locale,
  }) async =>
      _geocoding.placemarkFromCoordinates(latitude, longitude, locale: locale);

  @override
  Future<List<geo.Placemark>> placemarkFromAddress(
    String address, {
    Locale? locale,
  }) async => _geocoding.placemarkFromAddress(address, locale: locale);

  @override
  Future<List<geo.Placemark?>> getCurrentLocationAddress({
    Locale? locale,
  }) async {
    try {
      final position = await getUserCoordinates();

      if (position == null) {
        return [];
      }

      return await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        locale: locale,
      );
    } catch (e) {
      return [];
    }
  }

  @override
  double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) => gl.Geolocator.distanceBetween(
    startLatitude,
    startLongitude,
    endLatitude,
    endLongitude,
  );

  @override
  double bearingBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) => gl.Geolocator.bearingBetween(
    startLatitude,
    startLongitude,
    endLatitude,
    endLongitude,
  );

  // @override
  // Future<bool> isLocationServiceEnabled() async {
  //   return gl.Geolocator.isLocationServiceEnabled();
  // }

  // @override
  // Future<gl.LocationPermission> checkPermissionStatus() async {
  //   return gl.Geolocator.checkPermission();
  // }

  // @override
  // Future<gl.LocationPermission> requestPermission() async {
  //   return gl.Geolocator.requestPermission();
  // }

  // @override
  // Future<gl.Position?> getUserCoordinates() async {
  //   final isEnabled = await isLocationServiceEnabled();
  //   if (!isEnabled) {
  //     return null;
  //   }

  //   var permissionStatus = await checkPermissionStatus();
  //   if (permissionStatus == gl.LocationPermission.denied) {
  //     permissionStatus = await requestPermission();
  //   }

  //   if (permissionStatus == gl.LocationPermission.deniedForever ||
  //       permissionStatus == gl.LocationPermission.unableToDetermine) {
  //     await gl.Geolocator.openLocationSettings();
  //     return null;
  //   }

  //   if (permissionStatus != gl.LocationPermission.whileInUse &&
  //       permissionStatus != gl.LocationPermission.always) {
  //     return null;
  //   }

  //   try {
  //     return await gl.Geolocator.getCurrentPosition(
  //       locationSettings: const gl.LocationSettings(
  //         accuracy: gl.LocationAccuracy.high,
  //       ),
  //     );
  //   } catch (_) {
  //     return null;
  //   }
  // }

  // @override
  // Future<List<geo.Placemark>> getCurrentLocationAddress() async {
  //   final position = await getUserCoordinates();
  //   if (position == null) {
  //     return [];
  //   }

  //   return getLocationFromCoordinates(position.latitude, position.longitude);
  // }

  // @override
  // Future<List<geo.Placemark>> getLocationFromCoordinates(
  //   double latitude,
  //   double longitude, [
  //   Locale? locale,
  // ]) async {
  //   try {
  //     final placemarks = await _geocoding.placemarkFromCoordinates(
  //       latitude,
  //       longitude,
  //       locale: locale,
  //     );

  //     if (placemarks.isNotEmpty) {
  //       return placemarks;
  //     }
  //   } catch (_) {
  //     // Fallback if geocoding service is unavailable or fails
  //   }

  //   return [];
  // }

  // @override
  // Future<List<geo.Location>> getLocationsFromAddress(String address) async {
  //   try {
  //     final locations = await _geocoding.locationFromAddress(address);
  //     final userLocations = <UserLocation>[];

  //     for (final loc in locations) {
  //       final converted = await getLocationFromCoordinates(
  //         loc.latitude,
  //         loc.longitude,
  //       );
  //       userLocations.addAll(converted);
  //     }

  //     return userLocations;
  //   } catch (_) {
  //     return [];
  //   }
  // }

  // UserLocation _mapPlacemarkToUserLocation(
  //   geo.Placemark placemark, {
  //   required double latitude,
  //   required double longitude,
  // }) {
  //   final country = placemark.country ?? placemark.isoCountryCode ?? '';
  //   final state = placemark.administrativeArea;
  //   final city = placemark.locality ?? placemark.subAdministrativeArea;
  //   final postalCode = placemark.postalCode;

  //   return UserLocation(
  //     country: country,
  //     state: state,
  //     city: city,
  //     postalCode: postalCode,
  //     latitude: latitude,
  //     longitude: longitude,
  //   );
  // }
}

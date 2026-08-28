import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart' as gl;

import '../../features/catalog/domain/entities/user_location.dart';
import '../../core/location/location_service.dart';

class GeolocatorLocationService implements LocationService {
  GeolocatorLocationService([geo.Geocoding? geocoding])
      : _geocoding = geocoding ?? geo.Geocoding();

  final geo.Geocoding _geocoding;

  @override
  Future<bool> isLocationServiceEnabled() async {
    return gl.Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<LocationPermissionStatus> checkPermissionStatus() async {
    final permission = await gl.Geolocator.checkPermission();
    return _mapLocationPermission(permission);
  }

  @override
  Future<LocationPermissionStatus> requestPermission() async {
    final permission = await gl.Geolocator.requestPermission();
    return _mapLocationPermission(permission);
  }

  @override
  Future<UserLocation?> getCurrentLocation() async {
    final isEnabled = await isLocationServiceEnabled();
    if (!isEnabled) {
      return null;
    }

    var permissionStatus = await checkPermissionStatus();
    if (permissionStatus == LocationPermissionStatus.denied) {
      permissionStatus = await requestPermission();
    }

    if (permissionStatus != LocationPermissionStatus.whileInUse &&
        permissionStatus != LocationPermissionStatus.always) {
      return null;
    }

    final position = await gl.Geolocator.getCurrentPosition(
      locationSettings: const gl.LocationSettings(
        accuracy: gl.LocationAccuracy.high,
      ),
    );

    return getLocationFromCoordinates(position.latitude, position.longitude);
  }

  @override
  Future<UserLocation?> getLocationFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await _geocoding.placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return _mapPlacemarkToUserLocation(
          placemark,
          latitude: latitude,
          longitude: longitude,
        );
      }
    } catch (_) {
      // Fallback if geocoding service is unavailable or fails
    }

    return UserLocation(
      country: '',
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<List<UserLocation>> getLocationsFromAddress(String address) async {
    try {
      final locations = await _geocoding.locationFromAddress(address);
      final userLocations = <UserLocation>[];

      for (final loc in locations) {
        final converted = await getLocationFromCoordinates(
          loc.latitude,
          loc.longitude,
        );
        if (converted != null) {
          userLocations.add(converted);
        }
      }

      return userLocations;
    } catch (_) {
      return const [];
    }
  }

  LocationPermissionStatus _mapLocationPermission(
    gl.LocationPermission permission,
  ) {
    switch (permission) {
      case gl.LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case gl.LocationPermission.deniedForever:
        return LocationPermissionStatus.deniedForever;
      case gl.LocationPermission.whileInUse:
        return LocationPermissionStatus.whileInUse;
      case gl.LocationPermission.always:
        return LocationPermissionStatus.always;
      case gl.LocationPermission.unableToDetermine:
        return LocationPermissionStatus.unableToDetermine;
    }
  }

  UserLocation _mapPlacemarkToUserLocation(
    geo.Placemark placemark, {
    required double latitude,
    required double longitude,
  }) {
    final country = placemark.country ?? placemark.isoCountryCode ?? '';
    final state = placemark.administrativeArea;
    final city = placemark.locality ?? placemark.subAdministrativeArea;
    final postalCode = placemark.postalCode;

    return UserLocation(
      country: country,
      state: state,
      city: city,
      postalCode: postalCode,
      latitude: latitude,
      longitude: longitude,
    );
  }
}

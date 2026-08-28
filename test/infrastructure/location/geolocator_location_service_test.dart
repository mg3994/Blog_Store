import 'package:flutter_test/flutter_test.dart';
import 'package:blogstore/core/location/location_service.dart';
import 'package:blogstore/features/catalog/domain/entities/user_location.dart';

class MockLocationService implements LocationService {
  bool serviceEnabled = true;
  LocationPermissionStatus permissionStatus = LocationPermissionStatus.whileInUse;
  UserLocation? mockUserLocation;

  @override
  Future<bool> isLocationServiceEnabled() async => serviceEnabled;

  @override
  Future<LocationPermissionStatus> checkPermissionStatus() async => permissionStatus;

  @override
  Future<LocationPermissionStatus> requestPermission() async => permissionStatus;

  @override
  Future<UserLocation?> getCurrentLocation() async {
    if (!serviceEnabled) return null;
    if (permissionStatus != LocationPermissionStatus.whileInUse &&
        permissionStatus != LocationPermissionStatus.always) {
      return null;
    }
    return mockUserLocation;
  }

  @override
  Future<UserLocation?> getLocationFromCoordinates(double latitude, double longitude) async {
    return UserLocation(
      country: 'United States',
      state: 'California',
      city: 'San Francisco',
      postalCode: '94103',
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<List<UserLocation>> getLocationsFromAddress(String address) async {
    return [
      const UserLocation(
        country: 'United States',
        state: 'California',
        city: 'San Francisco',
        postalCode: '94103',
        latitude: 37.7749,
        longitude: -122.4194,
      ),
    ];
  }
}

void main() {
  group('LocationService Tests', () {
    late MockLocationService locationService;

    setUp(() {
      locationService = MockLocationService();
    });

    test('should return location when service enabled and permission granted', () async {
      const expectedLocation = UserLocation(
        country: 'United States',
        state: 'California',
        city: 'San Francisco',
        postalCode: '94103',
        latitude: 37.7749,
        longitude: -122.4194,
      );
      locationService.mockUserLocation = expectedLocation;

      final location = await locationService.getCurrentLocation();

      expect(location, equals(expectedLocation));
      expect(location?.country, 'United States');
      expect(location?.city, 'San Francisco');
    });

    test('should return null when location service is disabled', () async {
      locationService.serviceEnabled = false;

      final location = await locationService.getCurrentLocation();

      expect(location, isNull);
    });

    test('should return null when permission is denied', () async {
      locationService.permissionStatus = LocationPermissionStatus.denied;

      final location = await locationService.getCurrentLocation();

      expect(location, isNull);
    });

    test('should resolve location from coordinates via geocoding', () async {
      final location = await locationService.getLocationFromCoordinates(37.7749, -122.4194);

      expect(location, isNotNull);
      expect(location?.latitude, 37.7749);
      expect(location?.longitude, -122.4194);
      expect(location?.country, 'United States');
    });

    test('should resolve locations from address via forward geocoding', () async {
      final locations = await locationService.getLocationsFromAddress('San Francisco');

      expect(locations, isNotEmpty);
      expect(locations.first.city, 'San Francisco');
    });
  });
}

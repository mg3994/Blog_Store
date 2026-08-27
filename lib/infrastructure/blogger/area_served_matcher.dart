import '../../features/catalog/domain/entities/location_model.dart';

class AreaServedMatcher {
  /// Determines whether a schema's `areaServed` field matches the user's current location.
  static bool isServiceable({
    required dynamic areaServed,
    required LocationModel? userLocation,
  }) {
    if (areaServed == null) return true;
    if (userLocation == null) return true;

    final userCity = userLocation.city?.toLowerCase().trim();
    final userState = userLocation.state?.toLowerCase().trim();
    final userCountry = userLocation.country?.toLowerCase().trim();
    final userPostalCode = userLocation.postalCode?.toLowerCase().trim();

    final areas = areaServed is List ? areaServed : [areaServed];

    for (final area in areas) {
      if (area is String) {
        final areaStr = area.toLowerCase().trim();
        if (_matchString(areaStr, userCity, userState, userCountry, userPostalCode)) {
          return true;
        }
      } else if (area is Map<String, dynamic>) {
        final type = area['@type']?.toString().toLowerCase();
        final name = area['name']?.toString().toLowerCase().trim();
        final postalCode = area['postalCode']?.toString().toLowerCase().trim();
        final addressCountry = area['addressCountry']?.toString().toLowerCase().trim();
        final addressRegion = area['addressRegion']?.toString().toLowerCase().trim();
        final addressLocality = area['addressLocality']?.toString().toLowerCase().trim();

        if (type == 'country') {
          final countryName = name ?? addressCountry;
          if (countryName != null && userCountry != null && (countryName == userCountry || userCountry.contains(countryName))) {
            return true;
          }
        } else if (type == 'state' || type == 'administrativearea') {
          final stateName = name ?? addressRegion;
          if (stateName != null && userState != null && (stateName == userState || userState.contains(stateName))) {
            return true;
          }
        } else if (type == 'city') {
          final cityName = name ?? addressLocality;
          if (cityName != null && userCity != null && (cityName == userCity || userCity.contains(cityName))) {
            return true;
          }
        } else if (postalCode != null && userPostalCode != null && postalCode == userPostalCode) {
          return true;
        } else if (name != null) {
          if (_matchString(name, userCity, userState, userCountry, userPostalCode)) {
            return true;
          }
        }
      }
    }

    return false;
  }

  static bool _matchString(
    String areaStr,
    String? userCity,
    String? userState,
    String? userCountry,
    String? userPostalCode,
  ) {
    if (userCity != null && userCity.isNotEmpty && areaStr.contains(userCity)) return true;
    if (userState != null && userState.isNotEmpty && areaStr.contains(userState)) return true;
    if (userCountry != null && userCountry.isNotEmpty && areaStr.contains(userCountry)) return true;
    if (userPostalCode != null && userPostalCode.isNotEmpty && areaStr.contains(userPostalCode)) return true;
    return false;
  }
}

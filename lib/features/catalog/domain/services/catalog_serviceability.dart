import '../entities/service_area.dart';

final class CatalogServiceability {
  const CatalogServiceability();

  bool isServiceable({
    required List<ServiceArea> areas,
    required String country,
    String? state,
    String? city,
    String? postalCode,
  }) {
    if (areas.isEmpty) return true;
    return areas.any(
      (area) => _matches(
        area,
        country: country,
        state: state,
        city: city,
        postalCode: postalCode,
      ),
    );
  }

  bool _matches(
    ServiceArea area, {
    required String country,
    String? state,
    String? city,
    String? postalCode,
  }) {
    final type = area.type.toLowerCase();
    final name = area.name.trim().toLowerCase();
    if (type == 'country') return name == country.trim().toLowerCase();
    if (type == 'state' || type == 'administrativearea') {
      return state != null && name == state.trim().toLowerCase();
    }
    if (type == 'city' || type == 'locality') {
      return city != null && name == city.trim().toLowerCase();
    }
    if (type == 'postalcode') {
      return postalCode != null && name == postalCode.trim().toLowerCase();
    }
    return name == city?.trim().toLowerCase() ||
        name == state?.trim().toLowerCase();
  }
}

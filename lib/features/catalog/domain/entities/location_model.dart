class LocationModel {
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final double? latitude;
  final double? longitude;

  const LocationModel({
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.latitude,
    this.longitude,
  });

  LocationModel copyWith({
    String? city,
    String? state,
    String? country,
    String? postalCode,
    double? latitude,
    double? longitude,
  }) {
    return LocationModel(
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      postalCode: json['postalCode'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModel &&
          runtimeType == other.runtimeType &&
          city == other.city &&
          state == other.state &&
          country == other.country &&
          postalCode == other.postalCode &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode =>
      city.hashCode ^
      state.hashCode ^
      country.hashCode ^
      postalCode.hashCode ^
      latitude.hashCode ^
      longitude.hashCode;

  @override
  String toString() {
    final parts = [city, state, country].where((p) => p != null && p.isNotEmpty);
    return parts.isEmpty ? 'Unknown Location' : parts.join(', ');
  }
}

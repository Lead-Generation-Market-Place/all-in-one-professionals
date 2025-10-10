// location_entity.dart
class DistanceEntity {
  final BasicInfo basicInfo;
  final AddressComponents addressComponents;
  final Geometry geometry;
  final ServiceArea serviceArea;
  final GoogleMapsData googleMapsData;
  final Metadata metadata;

  const DistanceEntity({
    required this.basicInfo,
    required this.addressComponents,
    required this.geometry,
    required this.serviceArea,
    required this.googleMapsData,
    required this.metadata,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DistanceEntity &&
        other.basicInfo == basicInfo &&
        other.addressComponents == addressComponents &&
        other.geometry == geometry &&
        other.serviceArea == serviceArea &&
        other.googleMapsData == googleMapsData &&
        other.metadata == metadata;
  }

  @override
  int get hashCode {
    return Object.hash(
      basicInfo,
      addressComponents,
      geometry,
      serviceArea,
      googleMapsData,
      metadata,
    );
  }

  @override
  String toString() {
    return 'DistanceEntity(basicInfo: $basicInfo, addressComponents: $addressComponents, geometry: $geometry, serviceArea: $serviceArea, googleMapsData: $googleMapsData, metadata: $metadata)';
  }
}

class BasicInfo {
  final Coordinates coordinates;
  final String formattedAddress;
  final String placeId;
  final List<String> types;

  const BasicInfo({
    required this.coordinates,
    required this.formattedAddress,
    required this.placeId,
    required this.types,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicInfo &&
        other.coordinates == coordinates &&
        other.formattedAddress == formattedAddress &&
        other.placeId == placeId &&
        _listEquals(other.types, types);
  }

  @override
  int get hashCode {
    return Object.hash(
      coordinates,
      formattedAddress,
      placeId,
      Object.hashAll(types),
    );
  }

  @override
  String toString() {
    return 'BasicInfo(coordinates: $coordinates, formattedAddress: $formattedAddress, placeId: $placeId, types: $types)';
  }
}

class Coordinates {
  final double latitude;
  final double longitude;

  const Coordinates({required this.latitude, required this.longitude});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Coordinates &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() {
    return 'Coordinates(latitude: $latitude, longitude: $longitude)';
  }
}

class AddressComponents {
  final AddressComponent? streetNumber;
  final AddressComponent? route;
  final AddressComponent? locality;
  final AddressComponent? state;
  final AddressComponent? county;
  final AddressComponent? country;
  final AddressComponent? postalCode;
  final AddressComponent? postalCodeSuffix;
  final AddressComponent? neighborhood;
  final AddressComponent? sublocality;
  final AddressComponent? sublocalityLevel1;
  final AddressComponent? premise;
  final AddressComponent? subpremise;
  final AddressComponent? plusCode;

  const AddressComponents({
    this.streetNumber,
    this.route,
    this.locality,
    this.state,
    this.county,
    this.country,
    this.postalCode,
    this.postalCodeSuffix,
    this.neighborhood,
    this.sublocality,
    this.sublocalityLevel1,
    this.premise,
    this.subpremise,
    this.plusCode,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddressComponents &&
        other.streetNumber == streetNumber &&
        other.route == route &&
        other.locality == locality &&
        other.state == state &&
        other.county == county &&
        other.country == country &&
        other.postalCode == postalCode &&
        other.postalCodeSuffix == postalCodeSuffix &&
        other.neighborhood == neighborhood &&
        other.sublocality == sublocality &&
        other.sublocalityLevel1 == sublocalityLevel1 &&
        other.premise == premise &&
        other.subpremise == subpremise &&
        other.plusCode == plusCode;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      streetNumber,
      route,
      locality,
      state,
      county,
      country,
      postalCode,
      postalCodeSuffix,
      neighborhood,
      sublocality,
      sublocalityLevel1,
      premise,
      subpremise,
      plusCode,
    ]);
  }

  @override
  String toString() {
    return 'AddressComponents(streetNumber: $streetNumber, route: $route, locality: $locality, state: $state, county: $county, country: $country, postalCode: $postalCode, postalCodeSuffix: $postalCodeSuffix, neighborhood: $neighborhood, sublocality: $sublocality, sublocalityLevel1: $sublocalityLevel1, premise: $premise, subpremise: $subpremise, plusCode: $plusCode)';
  }
}

class AddressComponent {
  final String long;
  final String short;

  const AddressComponent({required this.long, required this.short});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddressComponent &&
        other.long == long &&
        other.short == short;
  }

  @override
  int get hashCode => Object.hash(long, short);

  @override
  String toString() {
    return 'AddressComponent(long: $long, short: $short)';
  }
}

class Geometry {
  final Coordinates location;
  final String locationType;
  final Viewport viewport;
  final Bounds? bounds;

  const Geometry({
    required this.location,
    required this.locationType,
    required this.viewport,
    this.bounds,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Geometry &&
        other.location == location &&
        other.locationType == locationType &&
        other.viewport == viewport &&
        other.bounds == bounds;
  }

  @override
  int get hashCode {
    return Object.hash(location, locationType, viewport, bounds);
  }

  @override
  String toString() {
    return 'Geometry(location: $location, locationType: $locationType, viewport: $viewport, bounds: $bounds)';
  }
}

class Viewport {
  final Coordinates northeast;
  final Coordinates southwest;

  const Viewport({required this.northeast, required this.southwest});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Viewport &&
        other.northeast == northeast &&
        other.southwest == southwest;
  }

  @override
  int get hashCode => Object.hash(northeast, southwest);

  @override
  String toString() {
    return 'Viewport(northeast: $northeast, southwest: $southwest)';
  }
}

class Bounds {
  final Coordinates northeast;
  final Coordinates southwest;

  const Bounds({required this.northeast, required this.southwest});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Bounds &&
        other.northeast == northeast &&
        other.southwest == southwest;
  }

  @override
  int get hashCode => Object.hash(northeast, southwest);

  @override
  String toString() {
    return 'Bounds(northeast: $northeast, southwest: $southwest)';
  }
}

class ServiceArea {
  final double radiusMiles;
  final double radiusMeters;
  final double radiusKilometers;

  const ServiceArea({
    required this.radiusMiles,
    required this.radiusMeters,
    required this.radiusKilometers,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceArea &&
        other.radiusMiles == radiusMiles &&
        other.radiusMeters == radiusMeters &&
        other.radiusKilometers == radiusKilometers;
  }

  @override
  int get hashCode {
    return Object.hash(radiusMiles, radiusMeters, radiusKilometers);
  }

  @override
  String toString() {
    return 'ServiceArea(radiusMiles: $radiusMiles, radiusMeters: $radiusMeters, radiusKilometers: $radiusKilometers)';
  }
}

class GoogleMapsData {
  final Map<String, dynamic> geocodingResponse;
  final PlusCode? plusCode;

  const GoogleMapsData({required this.geocodingResponse, this.plusCode});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GoogleMapsData &&
        _mapEquals(other.geocodingResponse, geocodingResponse) &&
        other.plusCode == plusCode;
  }

  @override
  int get hashCode {
    return Object.hash(Object.hashAll(geocodingResponse.entries), plusCode);
  }

  @override
  String toString() {
    return 'GoogleMapsData(geocodingResponse: $geocodingResponse, plusCode: $plusCode)';
  }
}

class PlusCode {
  final String compoundCode;
  final String globalCode;

  const PlusCode({required this.compoundCode, required this.globalCode});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlusCode &&
        other.compoundCode == compoundCode &&
        other.globalCode == globalCode;
  }

  @override
  int get hashCode => Object.hash(compoundCode, globalCode);

  @override
  String toString() {
    return 'PlusCode(compoundCode: $compoundCode, globalCode: $globalCode)';
  }
}

class Metadata {
  final String selectedAddress;
  final String searchQuery;
  final String timestamp;
  final String locationType;
  final bool partialMatch;

  const Metadata({
    required this.selectedAddress,
    required this.searchQuery,
    required this.timestamp,
    required this.locationType,
    required this.partialMatch,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Metadata &&
        other.selectedAddress == selectedAddress &&
        other.searchQuery == searchQuery &&
        other.timestamp == timestamp &&
        other.locationType == locationType &&
        other.partialMatch == partialMatch;
  }

  @override
  int get hashCode {
    return Object.hash(
      selectedAddress,
      searchQuery,
      timestamp,
      locationType,
      partialMatch,
    );
  }

  @override
  String toString() {
    return 'Metadata(selectedAddress: $selectedAddress, searchQuery: $searchQuery, timestamp: $timestamp, locationType: $locationType, partialMatch: $partialMatch)';
  }
}

// Helper functions for list and map comparisons
bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

bool _mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key) || a[key] != b[key]) return false;
  }
  return true;
}

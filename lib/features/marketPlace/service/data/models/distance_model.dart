

import 'package:yelpax_pro/features/marketPlace/service/domain/entities/distance_entity.dart';

class DistanceModel extends DistanceEntity {
  const DistanceModel({
    required super.basicInfo,
    required super.addressComponents,
    required super.geometry,
    required super.serviceArea,
    required super.googleMapsData,
    required super.metadata,
  });

  factory DistanceModel.fromJson(Map<String, dynamic> json) {
    return DistanceModel(
      basicInfo: BasicInfoModel.fromJson(json['basic_info']),
      addressComponents: AddressComponentsModel.fromJson(
        json['address_components'],
      ),
      geometry: GeometryModel.fromJson(json['geometry']),
      serviceArea: ServiceAreaModel.fromJson(json['service_area']),
      googleMapsData: GoogleMapsDataModel.fromJson(json['google_maps_data']),
      metadata: MetadataModel.fromJson(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'basic_info': (basicInfo as BasicInfoModel).toJson(),
      'address_components': (addressComponents as AddressComponentsModel)
          .toJson(),
      'geometry': (geometry as GeometryModel).toJson(),
      'service_area': (serviceArea as ServiceAreaModel).toJson(),
      'google_maps_data': (googleMapsData as GoogleMapsDataModel).toJson(),
      'metadata': (metadata as MetadataModel).toJson(),
    };
  }

  // Helper method to create from your comprehensive location data
  factory DistanceModel.fromComprehensiveData(Map<String, dynamic> data) {
    return DistanceModel(
      basicInfo: BasicInfoModel(
        coordinates: CoordinatesModel(
          latitude: data['basic_info']['coordinates']['latitude'],
          longitude: data['basic_info']['coordinates']['longitude'],
        ),
        formattedAddress: data['basic_info']['formatted_address'],
        placeId: data['basic_info']['place_id'],
        types: List<String>.from(data['basic_info']['types'] ?? []),
      ),
      addressComponents: AddressComponentsModel.fromMap(
        data['address_components'],
      ),
      geometry: GeometryModel.fromMap(data['geometry']),
      serviceArea: ServiceAreaModel(
        radiusMiles: data['service_area']['radius_miles'],
        radiusMeters: data['service_area']['radius_meters'],
        radiusKilometers: data['service_area']['radius_kilometers'],
      ),
      googleMapsData: GoogleMapsDataModel(
        geocodingResponse: data['google_maps_data']['geocoding_response'],
        plusCode: data['google_maps_data']['plus_code'] != null
            ? PlusCodeModel.fromMap(data['google_maps_data']['plus_code'])
            : null,
      ),
      metadata: MetadataModel(
        selectedAddress: data['metadata']['selected_address'],
        searchQuery: data['metadata']['search_query'],
        timestamp: data['metadata']['timestamp'],
        locationType: data['metadata']['location_type'],
        partialMatch: data['metadata']['partial_match'] ?? false,
      ),
    );
  }
}

class BasicInfoModel extends BasicInfo {
  const BasicInfoModel({
    required super.coordinates,
    required super.formattedAddress,
    required super.placeId,
    required super.types,
  });

  factory BasicInfoModel.fromJson(Map<String, dynamic> json) {
    return BasicInfoModel(
      coordinates: CoordinatesModel.fromJson(json['coordinates']),
      formattedAddress: json['formatted_address'],
      placeId: json['place_id'],
      types: List<String>.from(json['types']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coordinates': (coordinates as CoordinatesModel).toJson(),
      'formatted_address': formattedAddress,
      'place_id': placeId,
      'types': types,
    };
  }
}

class CoordinatesModel extends Coordinates {
  const CoordinatesModel({required super.latitude, required super.longitude});

  factory CoordinatesModel.fromJson(Map<String, dynamic> json) {
    return CoordinatesModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }
}

class AddressComponentsModel extends AddressComponents {
  const AddressComponentsModel({
    super.streetNumber,
    super.route,
    super.locality,
    super.state,
    super.county,
    super.country,
    super.postalCode,
    super.postalCodeSuffix,
    super.neighborhood,
    super.sublocality,
    super.sublocalityLevel1,
    super.premise,
    super.subpremise,
    super.plusCode,
  });

  factory AddressComponentsModel.fromJson(Map<String, dynamic> json) {
    return AddressComponentsModel.fromMap(json);
  }

  factory AddressComponentsModel.fromMap(Map<String, dynamic> map) {
    return AddressComponentsModel(
      streetNumber: map['street_number'] != null
          ? AddressComponentModel.fromMap(map['street_number'])
          : null,
      route: map['route'] != null
          ? AddressComponentModel.fromMap(map['route'])
          : null,
      locality: map['locality'] != null
          ? AddressComponentModel.fromMap(map['locality'])
          : null,
      state: map['state'] != null
          ? AddressComponentModel.fromMap(map['state'])
          : null,
      county: map['county'] != null
          ? AddressComponentModel.fromMap(map['county'])
          : null,
      country: map['country'] != null
          ? AddressComponentModel.fromMap(map['country'])
          : null,
      postalCode: map['postal_code'] != null
          ? AddressComponentModel.fromMap(map['postal_code'])
          : null,
      postalCodeSuffix: map['postal_code_suffix'] != null
          ? AddressComponentModel.fromMap(map['postal_code_suffix'])
          : null,
      neighborhood: map['neighborhood'] != null
          ? AddressComponentModel.fromMap(map['neighborhood'])
          : null,
      sublocality: map['sublocality'] != null
          ? AddressComponentModel.fromMap(map['sublocality'])
          : null,
      sublocalityLevel1: map['sublocality_level_1'] != null
          ? AddressComponentModel.fromMap(map['sublocality_level_1'])
          : null,
      premise: map['premise'] != null
          ? AddressComponentModel.fromMap(map['premise'])
          : null,
      subpremise: map['subpremise'] != null
          ? AddressComponentModel.fromMap(map['subpremise'])
          : null,
      plusCode: map['plus_code'] != null
          ? AddressComponentModel.fromMap(map['plus_code'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (streetNumber != null) {
      json['street_number'] = (streetNumber! as AddressComponentModel).toJson();
    }
    if (route != null) {
      json['route'] = (route! as AddressComponentModel).toJson();
    }
    if (locality != null) {
      json['locality'] = (locality! as AddressComponentModel).toJson();
    }
    if (state != null) {
      json['state'] = (state! as AddressComponentModel).toJson();
    }
    if (county != null) {
      json['county'] = (county! as AddressComponentModel).toJson();
    }
    if (country != null) {
      json['country'] = (country! as AddressComponentModel).toJson();
    }
    if (postalCode != null) {
      json['postal_code'] = (postalCode! as AddressComponentModel).toJson();
    }
    if (postalCodeSuffix != null) {
      json['postal_code_suffix'] = (postalCodeSuffix! as AddressComponentModel)
          .toJson();
    }
    if (neighborhood != null) {
      json['neighborhood'] = (neighborhood! as AddressComponentModel).toJson();
    }
    if (sublocality != null) {
      json['sublocality'] = (sublocality! as AddressComponentModel).toJson();
    }
    if (sublocalityLevel1 != null) {
      json['sublocality_level_1'] =
          (sublocalityLevel1! as AddressComponentModel).toJson();
    }
    if (premise != null) {
      json['premise'] = (premise! as AddressComponentModel).toJson();
    }
    if (subpremise != null) {
      json['subpremise'] = (subpremise! as AddressComponentModel).toJson();
    }
    if (plusCode != null) {
      json['plus_code'] = (plusCode! as AddressComponentModel).toJson();
    }
    return json;
  }
}

class AddressComponentModel extends AddressComponent {
  const AddressComponentModel({required super.long, required super.short});

  factory AddressComponentModel.fromJson(Map<String, dynamic> json) {
    return AddressComponentModel.fromMap(json);
  }

  factory AddressComponentModel.fromMap(Map<String, dynamic> map) {
    return AddressComponentModel(long: map['long'], short: map['short']);
  }

  Map<String, dynamic> toJson() {
    return {'long': long, 'short': short};
  }
}

class GeometryModel extends Geometry {
  const GeometryModel({
    required super.location,
    required super.locationType,
    required super.viewport,
    super.bounds,
  });

  factory GeometryModel.fromJson(Map<String, dynamic> json) {
    return GeometryModel.fromMap(json);
  }

  factory GeometryModel.fromMap(Map<String, dynamic> map) {
    return GeometryModel(
      location: CoordinatesModel(
        latitude: map['location']['lat'],
        longitude: map['location']['lng'],
      ),
      locationType: map['location_type'],
      viewport: ViewportModel.fromMap(map['viewport']),
      bounds: map['bounds'] != null ? BoundsModel.fromMap(map['bounds']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': {'lat': location.latitude, 'lng': location.longitude},
      'location_type': locationType,
      'viewport': (viewport as ViewportModel).toJson(),
      'bounds': bounds != null ? (bounds! as BoundsModel).toJson() : null,
    };
  }
}

class ViewportModel extends Viewport {
  const ViewportModel({required super.northeast, required super.southwest});

  factory ViewportModel.fromJson(Map<String, dynamic> json) {
    return ViewportModel.fromMap(json);
  }

  factory ViewportModel.fromMap(Map<String, dynamic> map) {
    return ViewportModel(
      northeast: CoordinatesModel(
        latitude: map['northeast']['lat'],
        longitude: map['northeast']['lng'],
      ),
      southwest: CoordinatesModel(
        latitude: map['southwest']['lat'],
        longitude: map['southwest']['lng'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'northeast': (northeast as CoordinatesModel).toJson(),
      'southwest': (southwest as CoordinatesModel).toJson(),
    };
  }
}

class BoundsModel extends Bounds {
  const BoundsModel({required super.northeast, required super.southwest});

  factory BoundsModel.fromJson(Map<String, dynamic> json) {
    return BoundsModel.fromMap(json);
  }

  factory BoundsModel.fromMap(Map<String, dynamic> map) {
    return BoundsModel(
      northeast: CoordinatesModel(
        latitude: map['northeast']['lat'],
        longitude: map['northeast']['lng'],
      ),
      southwest: CoordinatesModel(
        latitude: map['southwest']['lat'],
        longitude: map['southwest']['lng'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'northeast': (northeast as CoordinatesModel).toJson(),
      'southwest': (southwest as CoordinatesModel).toJson(),
    };
  }
}

class ServiceAreaModel extends ServiceArea {
  const ServiceAreaModel({
    required super.radiusMiles,
    required super.radiusMeters,
    required super.radiusKilometers,
  });

  factory ServiceAreaModel.fromJson(Map<String, dynamic> json) {
    return ServiceAreaModel(
      radiusMiles: (json['radius_miles'] as num).toDouble(),
      radiusMeters: (json['radius_meters'] as num).toDouble(),
      radiusKilometers: (json['radius_kilometers'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'radius_miles': radiusMiles,
      'radius_meters': radiusMeters,
      'radius_kilometers': radiusKilometers,
    };
  }
}

class GoogleMapsDataModel extends GoogleMapsData {
  const GoogleMapsDataModel({required super.geocodingResponse, super.plusCode});

  factory GoogleMapsDataModel.fromJson(Map<String, dynamic> json) {
    return GoogleMapsDataModel(
      geocodingResponse: Map<String, dynamic>.from(json['geocoding_response']),
      plusCode: json['plus_code'] != null
          ? PlusCodeModel.fromMap(json['plus_code'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'geocoding_response': geocodingResponse,
      'plus_code': plusCode != null
          ? (plusCode! as PlusCodeModel).toJson()
          : null,
    };
  }
}

class PlusCodeModel extends PlusCode {
  const PlusCodeModel({required super.compoundCode, required super.globalCode});

  factory PlusCodeModel.fromJson(Map<String, dynamic> json) {
    return PlusCodeModel.fromMap(json);
  }

  factory PlusCodeModel.fromMap(Map<String, dynamic> map) {
    return PlusCodeModel(
      compoundCode: map['compound_code'],
      globalCode: map['global_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'compound_code': compoundCode, 'global_code': globalCode};
  }
}

class MetadataModel extends Metadata {
  const MetadataModel({
    required super.selectedAddress,
    required super.searchQuery,
    required super.timestamp,
    required super.locationType,
    required super.partialMatch,
  });

  factory MetadataModel.fromJson(Map<String, dynamic> json) {
    return MetadataModel(
      selectedAddress: json['selected_address'],
      searchQuery: json['search_query'],
      timestamp: json['timestamp'],
      locationType: json['location_type'],
      partialMatch: json['partial_match'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selected_address': selectedAddress,
      'search_query': searchQuery,
      'timestamp': timestamp,
      'location_type': locationType,
      'partial_match': partialMatch,
    };
  }
}

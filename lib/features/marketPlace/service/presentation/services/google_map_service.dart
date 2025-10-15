import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class GoogleMapsService {
  final String apiKey = dotenv.env['MAPS_API_KEY'] ?? '';
  final Logger _logger = Logger();

  Future<Map<String, dynamic>?> getPlaceAutocomplete(String query) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=${Uri.encodeComponent(query)}&key=$apiKey&types=geocode',
      );
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        return data;
      } else {
        _logger.e('Autocomplete failed: ${data['status']}');
        return null;
      }
    } catch (e) {
      _logger.e('Autocomplete Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=$placeId&key=$apiKey'
        '&fields=name,formatted_address,geometry,address_components',
      );
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        return data['result'];
      } else {
        _logger.e('Place details failed: ${data['status']}');
        return null;
      }
    } catch (e) {
      _logger.e('Place Details Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getGoogleMapsGeocodingData(
    LatLng coordinates,
  ) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json'
        '?latlng=${coordinates.latitude},${coordinates.longitude}&key=$apiKey',
      );
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        return data;
      } else {
        _logger.e('Geocoding failed: ${data['status']}');
        return null;
      }
    } catch (e) {
      _logger.e('Geocoding Error: $e');
      return null;
    }
  }

  /// Extracts important address components into a map.
  Map<String, Map<String, String>> extractAddressComponents(
    List<dynamic> components,
  ) {
    final Map<String, Map<String, String>> result = {};

    for (var component in components) {
      final types = component['types'] as List<dynamic>;
      final longName = component['long_name'];
      final shortName = component['short_name'];

      for (var type in types) {
        result[type] = {'long': longName, 'short': shortName};
      }
    }

    return result;
  }
}

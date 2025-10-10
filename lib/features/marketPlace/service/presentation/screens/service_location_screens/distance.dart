import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/features/authentication/presentation/controllers/auth_user_controller.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/location_data_model.dart';
import 'dart:convert';

import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/controllers/service_controller.dart';

class DistanceInMiles {
  final int id;
  final String name;
  DistanceInMiles(this.name, this.id);
}

class Distance extends StatefulWidget {
  const Distance({super.key});

  @override
  State<Distance> createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<Distance> {
  final List<DistanceInMiles> _distances = [
    DistanceInMiles('1 Mile', 1),
    DistanceInMiles('5 Miles', 5),
    DistanceInMiles('10 Miles', 10),
    DistanceInMiles('20 Miles', 20),
    DistanceInMiles('50 Miles', 50),
  ];

  DistanceInMiles? _selectedDistance;
  late final AuthUserController authUserController;
  late final ServiceController serviceController;
  late GoogleMapController _mapController;

  final TextEditingController _searchController = TextEditingController();
  late String _mapsApiKey;
  CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 12,
  );

  List<Placemark> _searchResults = [];
  List<dynamic> _autocompleteResults = []; // New list for autocomplete results
  LatLng? _selectedLatLng;
  String _selectedAddress = '';
  bool _isNextLoading = false;

  @override
  void initState() {
    _mapsApiKey = dotenv.env['MAPS_API_KEY'] ?? '';
    authUserController = Provider.of(context, listen: false);
    serviceController = Provider.of(context, listen: false);
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  // Google Maps Geocoding API - Get detailed address from coordinates
  Future<Map<String, dynamic>?> _getGoogleMapsGeocodingData(
    LatLng coordinates,
  ) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${coordinates.latitude},${coordinates.longitude}&key=$_mapsApiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          Logger().d('---------------------data----${data}');
          return data;
        } else {
          print('Google Maps Geocoding API error: ${data['status']}');
          return null;
        }
      } else {
        print('HTTP error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching Google Maps geocoding data: $e');
      return null;
    }
  }

  // Google Maps Places Autocomplete API
  Future<Map<String, dynamic>?> _getPlaceAutocomplete(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$encodedQuery&key=$_mapsApiKey&types=geocode',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['predictions'].isNotEmpty) {
          return data;
        } else {
          print('Places Autocomplete API error: ${data['status']}');
          return null;
        }
      } else {
        print('HTTP error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching place autocomplete data: $e');
      return null;
    }
  }

  // Google Maps Place Details API
  Future<Map<String, dynamic>?> _getPlaceDetails(String placeId) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_mapsApiKey&fields=name,formatted_address,geometry,address_components,types,place_id,plus_code,url,utc_offset,vicinity,adr_address,formatted_phone_number,international_phone_number,opening_hours,price_level,rating,reviews,user_ratings_total,website,photos',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          return data['result'];
        } else {
          print('Place Details API error: ${data['status']}');
          return null;
        }
      } else {
        print('HTTP error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching place details: $e');
      return null;
    }
  }

  // Extract comprehensive address components
  Map<String, dynamic> _extractAddressComponents(
    List<dynamic> addressComponents,
  ) {
    final Map<String, dynamic> components = {};

    for (var component in addressComponents) {
      final types = List<String>.from(component['types']);
      final longName = component['long_name'];
      final shortName = component['short_name'];

      if (types.contains('street_number')) {
        components['street_number'] = {'long': longName, 'short': shortName};
      } else if (types.contains('route')) {
        components['route'] = {'long': longName, 'short': shortName};
      } else if (types.contains('locality')) {
        components['locality'] = {'long': longName, 'short': shortName};
      } else if (types.contains('administrative_area_level_1')) {
        components['state'] = {'long': longName, 'short': shortName};
      } else if (types.contains('administrative_area_level_2')) {
        components['county'] = {'long': longName, 'short': shortName};
      } else if (types.contains('country')) {
        components['country'] = {'long': longName, 'short': shortName};
      } else if (types.contains('postal_code')) {
        components['postal_code'] = {'long': longName, 'short': shortName};
      } else if (types.contains('postal_code_suffix')) {
        components['postal_code_suffix'] = {
          'long': longName,
          'short': shortName,
        };
      } else if (types.contains('neighborhood')) {
        components['neighborhood'] = {'long': longName, 'short': shortName};
      } else if (types.contains('sublocality')) {
        components['sublocality'] = {'long': longName, 'short': shortName};
      } else if (types.contains('sublocality_level_1')) {
        components['sublocality_level_1'] = {
          'long': longName,
          'short': shortName,
        };
      } else if (types.contains('premise')) {
        components['premise'] = {'long': longName, 'short': shortName};
      } else if (types.contains('subpremise')) {
        components['subpremise'] = {'long': longName, 'short': shortName};
      } else if (types.contains('plus_code')) {
        components['plus_code'] = {'long': longName, 'short': shortName};
      }
    }

    return components;
  }

  // Extract geometry data
  Map<String, dynamic> _extractGeometry(Map<String, dynamic> geometry) {
    return {
      'location': geometry['location'],
      'location_type': geometry['location_type'],
      'viewport': geometry['viewport'],
      'bounds': geometry['bounds'],
    };
  }

  // New method to handle search and show suggestions
  Future<void> _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _autocompleteResults = [];
        _searchResults = [];
      });
      return;
    }

    try {
      // Use Google Places Autocomplete for suggestions
      final autocompleteData = await _getPlaceAutocomplete(query);

      if (autocompleteData != null &&
          autocompleteData['predictions'].isNotEmpty) {
        setState(() {
          _autocompleteResults = autocompleteData['predictions'];
          _searchResults = []; // Clear geocoding results
        });
      } else {
        // Fallback to geocoding if no autocomplete results
        setState(() {
          _autocompleteResults = [];
        });
      }
    } catch (e) {
      print('Error in search: $e');
      setState(() {
        _autocompleteResults = [];
        _searchResults = [];
      });
    }
  }

  // Method to select an autocomplete result
  Future<void> _selectAutocompleteResult(dynamic prediction) async {
    final placeId = prediction['place_id'];
    final description = prediction['description'];

    _searchController.text = description;
    setState(() {
      _autocompleteResults = [];
      _searchResults = [];
    });

    try {
      // Get detailed place information
      final placeDetails = await _getPlaceDetails(placeId);

      if (placeDetails != null) {
        final geometry = placeDetails['geometry'];
        final location = geometry['location'];
        final latLng = LatLng(location['lat'], location['lng']);

        setState(() {
          _selectedLatLng = latLng;
          _selectedAddress = placeDetails['formatted_address'] ?? description;
        });

        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: 14),
          ),
        );
      }
    } catch (e) {
      print('Error selecting autocomplete result: $e');
      // Fallback to regular search
      await _searchLocation(description);
    }
  }

  // Original search method (for fallback)
  Future<void> _searchLocation(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);

      if (locations.isNotEmpty) {
        final Location loc = locations.first;
        final LatLng target = LatLng(loc.latitude, loc.longitude);

        // Get address from coordinates using Google Maps API
        final geocodingData = await _getGoogleMapsGeocodingData(target);

        String formattedAddress = '';
        if (geocodingData != null && geocodingData['results'].isNotEmpty) {
          formattedAddress = geocodingData['results'][0]['formatted_address'];
        } else {
          // Fallback to local geocoding
          List<Placemark> placemarks = await placemarkFromCoordinates(
            loc.latitude,
            loc.longitude,
          );
          formattedAddress = _formatAddress(placemarks.first);
        }

        setState(() {
          _selectedLatLng = target;
          _selectedAddress = formattedAddress;
          _searchResults = [];
          _autocompleteResults = [];
        });

        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: target, zoom: 14),
          ),
        );
      }
    } catch (e) {
      print('Error searching location: $e');
      setState(() {
        _searchResults = [];
        _autocompleteResults = [];
      });
    }
  }

  String _formatAddress(Placemark placemark) {
    final parts = [
      placemark.street,
      placemark.locality,
      placemark.administrativeArea,
      placemark.postalCode,
      placemark.country,
    ].where((part) => part != null && part.isNotEmpty).toList();

    return parts.join(', ');
  }

  void _selectSearchResult(Placemark placemark) async {
    final query =
        "${placemark.name}, ${placemark.locality}, ${placemark.country}";
    _searchController.text = query;
    setState(() => _searchResults = []);
    await _searchLocation(query);
  }

  // Update the _addLocation method in your Distance screen

  Future<void> _addLocation() async {
    if (_selectedLatLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a location first")),
      );
      return;
    }

    if (_selectedDistance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a distance radius")),
      );
      return;
    }

    setState(() {
      _isNextLoading = true;
    });

    try {
      // Get comprehensive data from Google Maps APIs
      final geocodingData = await _getGoogleMapsGeocodingData(_selectedLatLng!);

      if (geocodingData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to get location details from Google Maps"),
          ),
        );
        return;
      }

      final firstResult = geocodingData['results'][0];
      final addressComponents = _extractAddressComponents(
        firstResult['address_components'],
      );

      // Create the location entity with clean backend data
      final locationEntity = LocationDataEntity(
        professionalId: authUserController.professionalId.value,
        serviceId: serviceController.selectedService!.id,
        type: 'service', // or whatever type you need
        country: addressComponents['country']?['long'] ?? 'USA',
        state: addressComponents['state']?['long'],
        city: addressComponents['locality']?['long'],
        zipcode: addressComponents['postal_code']?['long'],
        addressLine: firstResult['formatted_address'],
        coordinates: LocationCoordinates.fromLatLng(_selectedLatLng!),
        serviceArea: ServiceArea(
          radiusMiles: _selectedDistance!.id,
          radiusMeters: _selectedDistance!.id * 1609.34,
          radiusKilometers: _selectedDistance!.id * 1.60934,
        ),
      );

      // Convert to model for sending to backend
      final locationModel = LocationDataModel.fromEntity(locationEntity);

      // Print clean backend data
      print("=== CLEAN BACKEND LOCATION DATA ===");
      print(json.encode(locationModel.toJson()));
      print("===================================");

      // Send to your backend
      // await locationRepository.createLocation(locationModel);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location added successfully")),
      );

      Navigator.pushNamed(context, AppRouter.add_location);
    } catch (e) {
      print('Error adding location: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error adding location: $e")));
    } finally {
      setState(() {
        _isNextLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Location'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Note
              Text(
                'Note:- Please select your coverage area carefully. '
                'This will determine where your services are available and can impact your visibility to potential customers.',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),

              // Search Input
              TextField(
                controller: _searchController,
                onChanged: _onSearchChanged, // Updated to use new method
                decoration: InputDecoration(
                  hintText: 'Search by name or address',
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Autocomplete Results (Google Places API)
              if (_autocompleteResults.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _autocompleteResults.length,
                    itemBuilder: (context, index) {
                      final prediction = _autocompleteResults[index];
                      final description = prediction['description'];

                      return ListTile(
                        leading: const Icon(Icons.location_on, size: 20),
                        title: Text(
                          description,
                          style: const TextStyle(fontSize: 14),
                        ),
                        onTap: () => _selectAutocompleteResult(prediction),
                      );
                    },
                  ),
                ),

              // Search Results (Geocoding fallback)
              if (_searchResults.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final placemark = _searchResults[index];
                      final locationText =
                          "${placemark.name ?? ''}, ${placemark.locality ?? ''}, ${placemark.country ?? ''}";
                      return ListTile(
                        title: Text(locationText),
                        onTap: () => _selectSearchResult(placemark),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 20),

              // Map
              SizedBox(
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GoogleMap(
                    initialCameraPosition: _initialPosition,
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    markers: _selectedLatLng != null
                        ? {
                            Marker(
                              markerId: const MarkerId("selected"),
                              position: _selectedLatLng!,
                              infoWindow: InfoWindow(
                                title: 'Selected Location',
                                snippet: _selectedAddress,
                              ),
                            ),
                          }
                        : {},
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Distance Dropdown
              DropdownButtonFormField<DistanceInMiles>(
                initialValue: _selectedDistance,
                decoration: InputDecoration(
                  labelText: 'Service Radius',
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                items: _distances.map((DistanceInMiles distance) {
                  return DropdownMenuItem<DistanceInMiles>(
                    value: distance,
                    child: Text(distance.name),
                  );
                }).toList(),
                onChanged: (DistanceInMiles? value) {
                  setState(() {
                    _selectedDistance = value;
                  });
                },
                hint: const Text('Select Distance'),
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 30),

              // Add Location Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isNextLoading ? null : _addLocation,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isNextLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text('Add Location'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

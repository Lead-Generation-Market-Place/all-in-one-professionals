import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/controllers/service_controller.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/models/location_model.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final List<Map<String, dynamic>> _tabOptions = [
    {'label': 'By Distance', 'value': 'distance'},
    {'label': 'Advanced', 'value': 'advanced'},
  ];

  String _activeTab = 'distance';
  double _radiusMiles = 10;
  LatLng? _center;
  LatLng? _selectedLocation;
  bool _isLoading = true;
  bool _isNextLoading = false;
  bool _mapError = false;
  GoogleMapController? _mapController;
  final loc.Location _locationService = loc.Location();
  final TextEditingController _searchController = TextEditingController();
  late String _mapsApiKey; // Remove hardcoded value


  @override
  void initState() {
    super.initState();
    _mapsApiKey = dotenv.env['MAPS_API_KEY'] ?? '';
    _initLocation();
  }



  Future<void> _initLocation() async {
    try {
      await _getCurrentLocation();
    } catch (e) {
      setState(() {
        _mapError = true;
        _isLoading = false;
        _center = const LatLng(0, 0);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      var status = await Permission.location.request();
      if (!status.isGranted) {
        throw Exception('Location permission denied');
      }

      bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService.requestService();
        if (!serviceEnabled) {
          throw Exception('Location services disabled');
        }
      }

      final currentLocation = await _locationService.getLocation();
      setState(() {
        _center = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _selectedLocation = _center;
        _isLoading = false;
        _mapError = false;
      });
      _animateToLocation(_center!);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _mapError = true;
        _center = const LatLng(0, 0);
      });
    }
  }

  double _milesToMeters(double miles) => miles * 1609.34;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onRadiusChanged(double value) {
    setState(() {
      _radiusMiles = value;
    });
    if (_center != null) {
      _animateToLocation(_center!);
    }
  }

  void _handleTabChange(String value) {
    setState(() {
      _activeTab = value;
    });
  }

  Future<void> _animateToLocation(LatLng location) async {
    await _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(location, 12),
    );
  }

  Future<List<Map<String, dynamic>>> _getPlacePredictions(String query) async {
    if (query.isEmpty) return [];
    if (_mapsApiKey.isEmpty) {
      print('Google Maps API key is missing');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google Maps API key not configured'),
          backgroundColor: Colors.red,
        ),
      );
      return [];
    }

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$_mapsApiKey&types=geocode',
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          return List<Map<String, dynamic>>.from(data['predictions'] ?? []);
        } else {
          print('Places API error: ${data['status']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Search error: ${data['status']}'),
              backgroundColor: Colors.orange,
            ),
          );
          return [];
        }
      } else {
        print('HTTP error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching place predictions: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> _getPlaceDetails(String placeId) async {
    if (_mapsApiKey.isEmpty) {
      print('Google Maps API key is missing');
      return null;
    }

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_mapsApiKey&fields=geometry,formatted_address,name',
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          return data['result'];
        } else {
          print('Place details error: ${data['status']}');
          return null;
        }
      }
      return null;
    } catch (e) {
      print('Error fetching place details: $e');
      return null;
    }
  }

  Future<void> _onPlaceSelected(Map<String, dynamic> prediction) async {
    final details = await _getPlaceDetails(prediction['place_id']);
    if (details != null) {
      final geometry = details['geometry'];
      if (geometry != null && geometry['location'] != null) {
        final location = geometry['location'];
        final latLng = LatLng(location['lat'], location['lng']);

        setState(() {
          _center = latLng;
          _selectedLocation = latLng;
          _searchController.text =
              prediction['description'] ?? details['formatted_address'] ?? '';
        });

        _animateToLocation(latLng);
      }
    }
  }

  // Method to create location data for backend
  
// Method to get country name from coordinates using reverse geocoding
  Future<String?> _getCountryFromCoordinates(LatLng coordinates) async {
    if (_mapsApiKey.isEmpty) {
      print('Google Maps API key is missing');
      return null;
    }

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${coordinates.latitude},${coordinates.longitude}&key=$_mapsApiKey',
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final result = data['results'][0];
          final addressComponents = result['address_components'];

          // Find country component
          for (var component in addressComponents) {
            final types = List<String>.from(component['types']);
            if (types.contains('country')) {
              final countryName = component['long_name'];
              print('Found country: $countryName');
              return countryName;
            }
          }
        }
      }
      return null;
    } catch (e) {
      print('Error in reverse geocoding: $e');
      return null;
    }
  }

  // Method to get complete address details from coordinates
  Future<Map<String, String?>> _getAddressDetailsFromCoordinates(
    LatLng coordinates,
  ) async {
    if (_mapsApiKey.isEmpty) {
      return {};
    }

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${coordinates.latitude},${coordinates.longitude}&key=$_mapsApiKey',
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final result = data['results'][0];
          final addressComponents = result['address_components'];
          final formattedAddress = result['formatted_address'];

          String? country, state, city, zipcode;

          for (var component in addressComponents) {
            final types = List<String>.from(component['types']);
            final value = component['long_name'];

            if (types.contains('country')) {
              country = value;
            } else if (types.contains('administrative_area_level_1')) {
              state = value;
            } else if (types.contains('locality')) {
              city = value;
            } else if (types.contains('postal_code')) {
              zipcode = value;
            }
          }

          return {
            'country': country,
            'state': state,
            'city': city,
            'zipcode': zipcode,
            'formattedAddress': formattedAddress,
          };
        }
      }
      return {};
    } catch (e) {
      print('Error getting address details: $e');
      return {};
    }
  }

  // Updated method to create location data for backend
  Future<LocationModel> _createLocationData(String type) async {
    // Get complete address details from coordinates
    final addressDetails = await _getAddressDetailsFromCoordinates(
      _selectedLocation!,
    );

    return LocationModel(
      type: type,
      coordinates: _selectedLocation!,
      country: addressDetails['country'],
      state: addressDetails['state'],
      city: addressDetails['city'],
      zipcode: addressDetails['zipcode'],
      addressLine: (addressDetails['formattedAddress'] != null)
          ? addressDetails['formattedAddress']
          : (_searchController.text.isNotEmpty
              ? _searchController.text
              : 'Selected Location'),
      // Add other IDs as needed based on the context
    );
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Select Location'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _mapError
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 20),
                  const Text('Failed to load map'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _initLocation,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Tabs
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDarkMode
                            ? Colors.grey[700]!
                            : Colors.grey[300]!,
                      ),
                    ),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _tabOptions.length,
                    itemBuilder: (context, index) {
                      final tab = _tabOptions[index];
                      return GestureDetector(
                        onTap: () => _handleTabChange(tab['value']),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 2,
                                color: _activeTab == tab['value']
                                    ? const Color(0xFF0077B6)
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                          child: Text(
                            tab['label'],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: _activeTab == tab['value']
                                  ? const Color(0xFF0077B6)
                                  : (isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600]),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Content based on active tab
                Expanded(
                  child: _activeTab == 'distance'
                      ? _buildDistanceTab()
                      : _buildAdvancedTab(),
                ),
              ],
            ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton(
            onPressed: _isNextLoading ? null : _confirmLocation,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0077B6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
            child: _isNextLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Confirm Location',
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }

 Future<void> _confirmLocation() async {
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location first')),
      );
      return;
    }

    setState(() {
      _isNextLoading = true;
    });

    try {
      // Create location data for backend - ADD AWAIT HERE
      final locationData = await _createLocationData(
        'user',
      ); // Change type as needed

      // Here you would typically send this to your backend
      print('=== LOCATION DATA TO SAVE ===');
      print('Type: ${locationData.type}');
      print(
        'Coordinates: ${locationData.coordinates.latitude}, ${locationData.coordinates.longitude}',
      );
      print('Country: ${locationData.country}');
      print('State: ${locationData.state}');
      print('City: ${locationData.city}');
      print('Zipcode: ${locationData.zipcode}');
      print('Address: ${locationData.addressLine}');
      print('Full JSON: ${locationData.toJson()}');
      print('============================');

      // Show confirmation dialog with the data
      _showLocationConfirmation(locationData);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isNextLoading = false;
      });
    }
  }
void _showLocationConfirmation(LocationModel locationData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // ... existing dialog content ...
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Edit'),
          ),
          ElevatedButton(
            onPressed: () {
              // Update controller with location data
              final controller = context.read<ServiceController>();
              controller.updateLocationData(locationData);

              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.budget);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
  Widget _buildDistanceTab() {
    return Column(
      children: [
        // Search and controls at top
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Set the max distance from your location',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TypeAheadField<Map<String, dynamic>>(
                controller: _searchController,
                builder: (context, controller, focusNode) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: 'Search any location worldwide...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      isDense: true,
                    ),
                  );
                },
                suggestionsCallback: (pattern) async {
                  return await _getPlacePredictions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(
                      suggestion['description'] ?? 'Unknown location',
                    ),
                  );
                },
                onSelected: _onPlaceSelected,

                loadingBuilder: (context) => const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Distance radius',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        '${_radiusMiles.round()} miles',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF0077B6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _radiusMiles,
                    min: 1,
                    max: 50,
                    divisions: 49,
                    label: _radiusMiles.round().toString(),
                    activeColor: const Color(0xFF0077B6),
                    onChanged: _onRadiusChanged,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Map takes remaining space
        Expanded(
          child: Stack(
            children: [
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center ?? const LatLng(0, 0),
                  zoom: _center != null ? 12 : 2,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                circles: _center != null
                    ? {
                        Circle(
                          circleId: const CircleId('radius'),
                          center: _center!,
                          radius: _milesToMeters(_radiusMiles),
                          fillColor: const Color(0xFF0077B6).withOpacity(0.2),
                          strokeColor: const Color(0xFF0077B6),
                          strokeWidth: 2,
                        ),
                      }
                    : {},
                onTap: (latLng) {
                  setState(() {
                    _center = latLng;
                    _selectedLocation = latLng;
                    _searchController.clear();
                  });
                  _animateToLocation(latLng);
                },
              ),
              Positioned(
                top: 16,
                right: 16,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: _getCurrentLocation,
                  child: const Icon(Icons.my_location, color: Colors.black),
                ),
              ),
              if (_center != null)
                const Center(
                  child: Icon(Icons.location_pin, color: Colors.red, size: 40),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.tune, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Advanced Filters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon: More advanced filtering options for precise location targeting.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

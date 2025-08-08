import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final String _mapsApiKey = 'AIzaSyAt4uYXRmuxOopP1eGh70qY_sNt5Fpt8AM'; // Replace with your API key

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      await _getCurrentLocation();
    } catch (e) {
      setState(() {
        _mapError = true;
        _isLoading = false;
        _center = const LatLng(0, 0); // Default to global view
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
        _center = const LatLng(0, 0); // Fallback to global view
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

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$_mapsApiKey&types=geocode'
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['predictions'] ?? []);
    }
    return [];
  }

  Future<Map<String, dynamic>> _getPlaceDetails(String placeId) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_mapsApiKey&fields=geometry,name,formatted_address'
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body)['result'] ?? {};
    }
    return {};
  }

  Future<void> _onPlaceSelected(Map<String, dynamic> prediction) async {
    final details = await _getPlaceDetails(prediction['place_id']);
    final geometry = details['geometry'];
    if (geometry != null && geometry['location'] != null) {
      final location = geometry['location'];
      final latLng = LatLng(location['lat'], location['lng']);

      setState(() {
        _center = latLng;
        _selectedLocation = latLng;
        _searchController.text = prediction['description'] ?? details['formatted_address'] ?? '';
      });

      _animateToLocation(latLng);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
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
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                            : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
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
            onPressed: () {
              if (_selectedLocation == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a location first')),
                );
                return;
              }
              Navigator.pop(context, {
                'location': _selectedLocation,
                'radius': _radiusMiles,
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0077B6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text(
              'Confirm Location',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
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
                    title: Text(suggestion['description']),
                  );
                },
                onSelected: (suggestion) {
                  _onPlaceSelected(suggestion);
                },

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
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
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
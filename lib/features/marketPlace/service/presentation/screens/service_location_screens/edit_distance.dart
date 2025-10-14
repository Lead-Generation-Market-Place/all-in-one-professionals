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
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/mile_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/controllers/service_controller.dart';
import 'package:yelpax_pro/shared/widgets/custom_flutter_toast.dart';

class EditDistance extends StatefulWidget {
  const EditDistance({super.key, required this.location});
  final LocationDataEntity location;

  @override
  State<EditDistance> createState() => _EditDistanceScreenState();
}

class _EditDistanceScreenState extends State<EditDistance> {
  MileEntity? _selectedMile;
  AuthUserController? authUserController;
  ServiceController? serviceController;
  late GoogleMapController _mapController;

  final TextEditingController _searchController = TextEditingController();
  late String _mapsApiKey;
  late CameraPosition _initialPosition;

  List<Placemark> _searchResults = [];
  List<dynamic> _autocompleteResults = [];
  LatLng? _selectedLatLng;
  String _selectedAddress = '';
  bool _isNextLoading = false;
  bool _isInitialized = false;
  bool _milesLoaded = false;

  @override
  void initState() {
    super.initState();
    _mapsApiKey = dotenv.env['MAPS_API_KEY'] ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeControllers();
    });
  }

  void _initializeControllers() {
    try {
      authUserController = Provider.of<AuthUserController>(
        context,
        listen: false,
      );
      serviceController = Provider.of<ServiceController>(
        context,
        listen: false,
      );

      _initializeWithLocationData();
    } catch (e) {
      CustomFlutterToast.showErrorToast('Error initializing controllers');
      _initializeWithLocationData();
    }
  }

  void _initializeWithLocationData() async {
    try {
      List<double> coords = widget.location.coordinates.coordinates;
      if (coords.length >= 2) {
        _selectedLatLng = LatLng(coords[1], coords[0]);
      } else {
        _selectedLatLng = LatLng(51.6393693, 8.5067607);
      }

      _initialPosition = CameraPosition(target: _selectedLatLng!, zoom: 14);
      _selectedAddress = widget.location.addressLine ?? 'Unknown Address';
      _searchController.text = _selectedAddress;

      // Wait for miles to be loaded
      if (serviceController != null) {
        if (serviceController!.miles.isEmpty) {
          await serviceController!.fetchAllMiles();
        }

        // Small delay to ensure miles are loaded
        await Future.delayed(const Duration(milliseconds: 100));

        _setSelectedMile();
        setState(() {
          _milesLoaded = true;
          _isInitialized = true;
        });
      } else {
        setState(() {
          _isInitialized = true;
        });
      }

    } catch (e) {
      print('Error initializing location data: $e');
      _selectedLatLng = LatLng(51.6393693, 8.5067607);
      _initialPosition = CameraPosition(target: _selectedLatLng!, zoom: 14);
      _selectedAddress = 'Krumme G. 6, 59590 Geseke, Germany';
      _searchController.text = _selectedAddress;

      setState(() {
        _isInitialized = true;
      });
    }
  }

  void _setSelectedMile() {
    if (serviceController == null || serviceController!.miles.isEmpty) {
      print('No miles available in service controller');
      return;
    }

    print('Available miles: ${serviceController!.miles.map((m) => m.mile).toList()}');
    print('Location mileEntity: ${widget.location.mileEntity}');

    // Priority 1: If the location already has a valid mileEntity with mile value > 0
    if (widget.location.mileEntity.mile > 0) {
      try {
        // Try to find the exact match in available miles
        final matchingMile = serviceController!.miles.firstWhere(
              (mile) => mile.mile == widget.location.mileEntity.mile,
        );
        _selectedMile = matchingMile;
        print('Found matching mile by value: ${_selectedMile?.mile} miles');
        return;
      } catch (e) {
        print('Could not find mile with value: ${widget.location.mileEntity.mile}');
      }
    }

    // Priority 2: Use the mileEntity ID if available
    if (widget.location.mileEntity.id.isNotEmpty) {
      try {
        final matchingMile = serviceController!.miles.firstWhere(
              (mile) => mile.id == widget.location.mileEntity.id,
        );
        _selectedMile = matchingMile;
        print('Found matching mile by ID: ${_selectedMile?.mile} miles');
        return;
      } catch (e) {
        print('Could not find mile with ID: ${widget.location.mileEntity.id}');
      }
    }

    // Priority 3: Calculate from serviceArea radius
    if (widget.location.serviceArea != null) {
      final radiusKilometers = widget.location.serviceArea!.radiusKilometers;
      final radiusMiles = (radiusKilometers * 0.621371).round();
      print('Calculated radius from serviceArea: $radiusMiles miles');

      try {
        final matchingMile = serviceController!.miles.firstWhere(
              (mile) => mile.mile == radiusMiles,
        );
        _selectedMile = matchingMile;
        print('Found matching mile by radius: ${_selectedMile?.mile} miles');
        return;
      } catch (e) {
        print('No exact match for $radiusMiles miles, finding closest...');
        _selectedMile = _findClosestMile(radiusMiles);
        print('Using closest mile: ${_selectedMile?.mile} miles');
        return;
      }
    }

    // Priority 4: Fallback to default (first available mile)
    _selectedMile = serviceController!.miles.first;
    print('Using fallback mile: ${_selectedMile?.mile} miles');
  }

  MileEntity _findClosestMile(int targetMiles) {
    if (serviceController == null || serviceController!.miles.isEmpty) {
      return MileEntity(id: 'default', mile: 5); // Default fallback
    }

    return serviceController!.miles.reduce((a, b) {
      final diffA = (a.mile - targetMiles).abs();
      final diffB = (b.mile - targetMiles).abs();
      return diffA < diffB ? a : b;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    if (_selectedLatLng != null) {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _selectedLatLng!, zoom: 14),
        ),
      );
    }
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
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
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
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
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
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
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
      final autocompleteData = await _getPlaceAutocomplete(query);

      if (autocompleteData != null &&
          autocompleteData['predictions'].isNotEmpty) {
        setState(() {
          _autocompleteResults = autocompleteData['predictions'];
          _searchResults = [];
        });
      } else {
        setState(() {
          _autocompleteResults = [];
        });
      }
    } catch (e) {
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

        final geocodingData = await _getGoogleMapsGeocodingData(target);

        String formattedAddress = '';
        if (geocodingData != null && geocodingData['results'].isNotEmpty) {
          formattedAddress = geocodingData['results'][0]['formatted_address'];
        } else {
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

  Future<void> _updateLocation() async {
    if (_selectedLatLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a location first")),
      );
      return;
    }

    if (_selectedMile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a distance radius")),
      );
      return;
    }

    if (authUserController == null || serviceController == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Controllers not initialized")),
      );
      return;
    }

    setState(() {
      _isNextLoading = true;
    });

    try {
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

      // Create the location entity with the existing ID
      final locationEntity = LocationDataEntity(
        id: widget.location.id, // Preserve the original ID
        professionalId: authUserController?.professionalId.value,
        serviceId: serviceController?.selectedService!.id,
        type: 'service',
        country: addressComponents['country']?['long'] ?? 'USA',
        state: addressComponents['state']?['long'],
        city: addressComponents['locality']?['long'],
        zipcode: addressComponents['postal_code']?['long'],
        addressLine: firstResult['formatted_address'],
        coordinates: LocationCoordinates.fromLatLng(_selectedLatLng!),
        serviceArea: ServiceArea(
          radiusMiles: _selectedMile!.mile,
          radiusMeters: _selectedMile!.mile * 1609.34,
          radiusKilometers: _selectedMile!.mile * 1.60934,
        ),
        mileEntity: _selectedMile!,
      );

      await serviceController!.updateLocationData(locationEntity);

      CustomFlutterToast.showSuccessToast('Location updated successfully');
      Navigator.pushReplacementNamed(
        context,
        AppRouter.add_location,
      );


    } catch (e) {
      print('Error updating location: $e');
      CustomFlutterToast.showErrorToast('Error updating location: $e');
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
        title: const Text('Edit Service Location'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: !_isInitialized || _selectedLatLng == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Edit Mode Indicator
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Editing existing location - ${widget.location.addressLine ?? "Unknown"}',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

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
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search by name or address',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
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
                        onTap: () =>
                            _selectAutocompleteResult(prediction),
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

              // Selected Location Preview
              if (_selectedAddress.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[100]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green[700],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected Location',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedAddress,
                              style: const TextStyle(fontSize: 13),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

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
                          title: 'Updated Location',
                          snippet: _selectedAddress,
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueOrange,
                        ),
                      ),
                    }
                        : {},
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Distance Dropdown using backend data
              Consumer<ServiceController>(
                builder: (context, controller, child) {
                  if (!_milesLoaded) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return DropdownButtonFormField<MileEntity>(
                    value: _selectedMile,
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
                    items: controller.miles.map((MileEntity mile) {
                      return DropdownMenuItem<MileEntity>(
                        value: mile,
                        child: Text('${mile.mile} Miles'),
                      );
                    }).toList(),
                    onChanged: (MileEntity? value) {
                      setState(() {
                        _selectedMile = value;
                      });
                    },
                    hint: const Text('Select Distance'),
                  );
                },
              ),

              const SizedBox(height: 30),

              // Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isNextLoading ? null : _updateLocation,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.orange,
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
                      : const Text('Update Location'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
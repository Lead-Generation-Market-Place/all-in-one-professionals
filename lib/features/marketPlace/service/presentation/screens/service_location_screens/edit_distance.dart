import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/features/authentication/presentation/controllers/auth_user_controller.dart';

import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/mile_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/minute_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/vehicle_type_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/controllers/service_controller.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/services/google_map_service.dart';
import 'package:yelpax_pro/shared/widgets/custom_flutter_toast.dart';

class EditDistance extends StatefulWidget {
  const EditDistance({super.key, required this.location});
  final LocationDataEntity location;

  @override
  State<EditDistance> createState() => _EditDistanceScreenState();
}

class _EditDistanceScreenState extends State<EditDistance> {
  MileEntity? _selectedMile;
  MinuteEntity? _selectedMinute;
  VehicleTypeEntity? _selectedVehicleType;
  AuthUserController? authUserController;
  ServiceController? serviceController;
  late GoogleMapController _mapController;

  final TextEditingController _searchController = TextEditingController();
  final GoogleMapsService _locationHelper = GoogleMapsService();
  late CameraPosition _initialPosition;

  List<dynamic> _autocompleteResults = [];
  LatLng? _selectedLatLng;
  String _selectedAddress = '';
  bool _isNextLoading = false;
  bool _isInitialized = false;
  bool _milesLoaded = false;

  @override
  void initState() {
    super.initState();
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

      // Wait for lookups to be loaded
      if (serviceController != null) {
        if (serviceController!.miles.isEmpty) {
          await serviceController!.fetchAllMiles();
        }
        if (serviceController!.minute.isEmpty) {
          await serviceController!.fetchAllMinute();
        }
        if (serviceController!.vehicleType.isEmpty) {
          await serviceController!.fetchAllVehicleTypes();
        }

        // Small delay to ensure miles are loaded
        await Future.delayed(const Duration(milliseconds: 100));

        _setSelectedMile();
        _setSelectedMinute();
        _setSelectedVehicleType();
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

    print(
      'Available miles: ${serviceController!.miles.map((m) => m.mile).toList()}',
    );
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
        print(
          'Could not find mile with value: ${widget.location.mileEntity.mile}',
        );
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

  void _setSelectedMinute() {
    if (serviceController == null || serviceController!.minute.isEmpty) {
      return;
    }

    // Try by value first
    final existing = widget.location.minuteEntity;
    try {
      _selectedMinute = serviceController!.minute.firstWhere(
        (m) => m.minute == existing.minute,
      );
      return;
    } catch (_) {}

    // Fallback by id
    if (existing.id.isNotEmpty) {
      try {
        _selectedMinute = serviceController!.minute.firstWhere(
          (m) => m.id == existing.id,
        );
        return;
      } catch (_) {}
    }

    // Final fallback
    _selectedMinute = serviceController!.minute.first;
  }

  void _setSelectedVehicleType() {
    if (serviceController == null || serviceController!.vehicleType.isEmpty) {
      return;
    }

    final existing = widget.location.vehicleTypeEntity;
    if (existing == null) {
      // Don't preselect if not provided on the location
      return;
    }

    // Try by id first
    try {
      _selectedVehicleType = serviceController!.vehicleType.firstWhere(
        (v) => v.id == existing.id,
      );
      return;
    } catch (_) {}

    // Fallback by value
    try {
      _selectedVehicleType = serviceController!.vehicleType.firstWhere(
        (v) => v.vehicle_type == existing.vehicle_type,
      );
      return;
    } catch (_) {}
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

  // New method to handle search and show suggestions
  Future<void> _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _autocompleteResults = [];
      });
      return;
    }

    try {
      final autocompleteData = await _locationHelper.getPlaceAutocomplete(
        query,
      );
      final List<dynamic> predictions =
          (autocompleteData != null && autocompleteData['predictions'] is List)
          ? (autocompleteData['predictions'] as List)
          : <dynamic>[];

      setState(() {
        _autocompleteResults = predictions;
      });
    } catch (e) {
      setState(() {
        _autocompleteResults = [];
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
    });

    try {
      final placeDetails = await _locationHelper.getPlaceDetails(placeId);

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
    } catch (e) {}
  }

  // Removed geocoding fallback; using Google Places exclusively

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

    if (_selectedMinute == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a travel time")),
      );
      return;
    }

    if (_selectedVehicleType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a vehicle type")),
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
      final geocodingData = await _locationHelper.getGoogleMapsGeocodingData(
        _selectedLatLng!,
      );

      if (geocodingData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to get location details from Google Maps"),
          ),
        );
        return;
      }

      final firstResult = geocodingData['results'][0];
      final addressComponents = _locationHelper.extractAddressComponents(
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
        minuteEntity: _selectedMinute!,
        vehicleTypeEntity: _selectedVehicleType,
      );

      await serviceController!.updateLocationData(locationEntity);

      CustomFlutterToast.showSuccessToast('Location updated successfully');
      Navigator.pushReplacementNamed(context, AppRouter.add_location);
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

                    // Geocoding fallback removed
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

                    // Distance, Travel Time and Vehicle Type Dropdowns using backend data
                    Consumer<ServiceController>(
                      builder: (context, controller, child) {
                        if (!_milesLoaded) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Column(
                          children: [
                            DropdownButtonFormField<MileEntity>(
                              value: _selectedMile,
                              decoration: InputDecoration(
                                labelText: 'Service Radius',
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
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
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<MinuteEntity>(
                              value: _selectedMinute,
                              decoration: InputDecoration(
                                labelText: 'Travel Time',
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              items: controller.minute.map((
                                MinuteEntity minute,
                              ) {
                                return DropdownMenuItem<MinuteEntity>(
                                  value: minute,
                                  child: Text('${minute.minute} Minutes'),
                                );
                              }).toList(),
                              onChanged: (MinuteEntity? value) {
                                setState(() {
                                  _selectedMinute = value;
                                });
                              },
                              hint: const Text('Select Travel Time'),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<VehicleTypeEntity>(
                              value: _selectedVehicleType,
                              decoration: InputDecoration(
                                labelText: 'Vehicle Type',
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              items: controller.vehicleType.map((
                                VehicleTypeEntity vehicle,
                              ) {
                                return DropdownMenuItem<VehicleTypeEntity>(
                                  value: vehicle,
                                  child: Text(vehicle.vehicle_type),
                                );
                              }).toList(),
                              onChanged: (VehicleTypeEntity? value) {
                                setState(() {
                                  _selectedVehicleType = value;
                                });
                              },
                              hint: const Text('Select Vehicle Type'),
                            ),
                          ],
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

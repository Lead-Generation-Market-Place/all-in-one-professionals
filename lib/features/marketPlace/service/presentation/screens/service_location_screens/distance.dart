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

class Distance extends StatefulWidget {
  const Distance({super.key});

  @override
  State<Distance> createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<Distance> {
  final TextEditingController _searchController = TextEditingController();

  late AuthUserController authUserController;
  late ServiceController serviceController;
  late GoogleMapController _mapController;

  final GoogleMapsService _locationHelper = GoogleMapsService();

  CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 12,
  );

  List<dynamic> _autocompleteResults = [];
  LatLng? _selectedLatLng;
  String _selectedAddress = '';
  bool _isNextLoading = false;
  Map<String, dynamic>? _selectedPlaceDetails;

  MileEntity? _selectedMile;
  MinuteEntity? _selectedMinute;
  VehicleTypeEntity? _selectedVehicleType;

  @override
  void initState() {
    super.initState();
    authUserController = Provider.of<AuthUserController>(
      context,
      listen: false,
    );
    serviceController = Provider.of<ServiceController>(context, listen: false);
    init();
  }

  Future<void> init() async {
    try {
      await serviceController.fetchAllMiles();
      await serviceController.fetchAllMinute();
      await serviceController.fetchAllVehicleTypes();
    } catch (e) {
      CustomFlutterToast.showErrorToast('Failed to load dropdown data.');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() => _autocompleteResults = []);
      return;
    }
    final data = await _locationHelper.getPlaceAutocomplete(query);

    if (!mounted) return;
    if (data != null && data['predictions'] is List) {
      setState(() => _autocompleteResults = data['predictions']);
    } else {
      setState(() => _autocompleteResults = []);
    }
  }

  Future<void> _selectAutocompleteResult(dynamic prediction) async {
    final placeDetails = await _locationHelper.getPlaceDetails(
      prediction['place_id'],
    );
    if (placeDetails == null) return;

    final location = placeDetails['geometry']['location'];
    final latLng = LatLng(location['lat'], location['lng']);

    setState(() {
      _selectedLatLng = latLng;
      _selectedAddress = placeDetails['formatted_address'];
      _selectedPlaceDetails = placeDetails;
      _searchController.text = _selectedAddress;
      _autocompleteResults = [];
    });

    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 14)),
    );
  }

  Future<void> _addLocation() async {
    if (_selectedLatLng == null ||
        _selectedMile == null ||
        _selectedMinute == null ||
        _selectedVehicleType == null) {
      CustomFlutterToast.showErrorToast('Please complete all selections.');
      return;
    }

    setState(() => _isNextLoading = true);

    try {
      Map<String, dynamic>? components;
      String? formattedAddress;

      if (_selectedPlaceDetails != null &&
          _selectedPlaceDetails!['address_components'] is List) {
        components = _locationHelper.extractAddressComponents(
          _selectedPlaceDetails!['address_components'],
        );
        formattedAddress = _selectedPlaceDetails!['formatted_address'];
      } else {
        final geocodingData = await _locationHelper.getGoogleMapsGeocodingData(
          _selectedLatLng!,
        );

        if (geocodingData == null ||
            geocodingData['results'] == null ||
            (geocodingData['results'] as List).isEmpty) {
          CustomFlutterToast.showErrorToast('Failed to fetch address details.');
          return;
        }

        final firstResult = geocodingData['results'][0];
        components = _locationHelper.extractAddressComponents(
          firstResult['address_components'],
        );
        formattedAddress = firstResult['formatted_address'];
      }

      final LocationDataEntity locationEntity = LocationDataEntity(
        professionalId: authUserController.professionalId.value,
        serviceId: serviceController.selectedService!.id,
        type: 'service',
        country: ((components['country'] as Map?)?['long'] as String?) ?? 'USA',
        state: (components['state'] as Map?)?['long'] as String?,
        city: (components['locality'] as Map?)?['long'] as String?,
        zipcode: (components['postal_code'] as Map?)?['long'] as String?,
        addressLine: formattedAddress,
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

      await serviceController.addLocationData(locationEntity);

      CustomFlutterToast.showSuccessToast('Location added successfully');
      Navigator.pushReplacementNamed(context, AppRouter.add_location);
    } catch (e) {
      CustomFlutterToast.showErrorToast('Error adding location: $e');
    } finally {
      setState(() => _isNextLoading = false);
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
            children: [
              TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search address...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              if (_autocompleteResults.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _autocompleteResults.length,
                  itemBuilder: (context, index) {
                    final prediction = _autocompleteResults[index];
                    return ListTile(
                      title: Text(prediction['description']),
                      onTap: () => _selectAutocompleteResult(prediction),
                    );
                  },
                ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: GoogleMap(
                  initialCameraPosition: _initialPosition,
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  markers: _selectedLatLng != null
                      ? {
                          Marker(
                            markerId: const MarkerId('selected'),
                            position: _selectedLatLng!,
                            infoWindow: InfoWindow(title: _selectedAddress),
                          ),
                        }
                      : {},
                ),
              ),
              const SizedBox(height: 20),
              Consumer<ServiceController>(
                builder: (context, controller, _) {
                  return Column(
                    children: [
                      DropdownButtonFormField<MileEntity>(
                        decoration: const InputDecoration(
                          labelText: 'Service Radius (Miles)',
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                        initialValue: _selectedMile,
                        items: controller.miles
                            .map(
                              (mile) => DropdownMenuItem(
                                value: mile,
                                child: Text('${mile.mile} Miles'),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedMile = value),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<MinuteEntity>(
                        decoration: const InputDecoration(
                          labelText: 'Travel Time (Minutes)',
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                        initialValue: _selectedMinute,
                        items: controller.minute
                            .map(
                              (minute) => DropdownMenuItem(
                                value: minute,
                                child: Text('${minute.minute} Minutes'),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedMinute = value),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<VehicleTypeEntity>(
                        decoration: const InputDecoration(
                          labelText: 'Vehicle Type',
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                        initialValue: _selectedVehicleType,
                        items: controller.vehicleType
                            .map(
                              (vehicle) => DropdownMenuItem(
                                value: vehicle,
                                child: Text(vehicle.vehicle_type),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedVehicleType = value),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isNextLoading ? null : _addLocation,
                  child: _isNextLoading
                      ? const CircularProgressIndicator()
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

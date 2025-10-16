// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:location/location.dart' as loc;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'dart:convert';

// import 'package:yelpax_pro/config/routes/router.dart';
// import 'package:yelpax_pro/features/marketPlace/service/domain/entities/langEntity.dart';

// import 'package:yelpax_pro/features/marketPlace/service/presentation/controllers/service_controller.dart';
// import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_entity.dart';

// class MultiLocationScreen extends StatefulWidget {
//   const MultiLocationScreen({super.key});

//   @override
//   State<MultiLocationScreen> createState() => _MultiLocationScreenState();
// }

// class _MultiLocationScreenState extends State<MultiLocationScreen> {
//   final List<Map<String, dynamic>> _tabOptions = [
//     {'label': 'By Distance', 'value': 'distance'},
//     {'label': 'Advanced', 'value': 'advanced'},
//   ];

//   String _activeTab = 'distance';
//   double _radiusMiles = 10;
//   LatLng? _center;
//   LatLng? _selectedLocation;
//   bool _isLoading = true;
//   bool _isNextLoading = false;
//   bool _mapError = false;
//   GoogleMapController? _mapController;
//   final loc.Location _locationService = loc.Location();
//   final TextEditingController _searchController = TextEditingController();
//   final TextEditingController _locationNameController = TextEditingController();
//   late String _mapsApiKey;

//   // List to store multiple locations
//   List<ServiceLocationEntity> _locations = [];
//   int _selectedLocationIndex = -1; // -1 means adding new location

//   @override
//   void initState() {
//     super.initState();
//     _mapsApiKey = dotenv.env['MAPS_API_KEY'] ?? '';
//     _initLocation();
//     _loadExistingLocations();
//   }

//   void _loadExistingLocations() {
//     // Load existing locations from controller if any
//     final controller = context.read<ServiceController>();
//     // if (controller.registrationData.locations != null) {
//     //   setState(() {
//     //     _locations = List.from(controller.registrationData.locations!);
//     //   });
//     // }
//   }

//   Future<void> _initLocation() async {
//     try {
//       await _getCurrentLocation();
//     } catch (e) {
//       setState(() {
//         _mapError = true;
//         _isLoading = false;
//         _center = const LatLng(0, 0);
//       });
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       var status = await Permission.location.request();
//       if (!status.isGranted) {
//         throw Exception('Location permission denied');
//       }

//       bool serviceEnabled = await _locationService.serviceEnabled();
//       if (!serviceEnabled) {
//         serviceEnabled = await _locationService.requestService();
//         if (!serviceEnabled) {
//           throw Exception('Location services disabled');
//         }
//       }

//       final currentLocation = await _locationService.getLocation();
//       setState(() {
//         _center = LatLng(currentLocation.latitude!, currentLocation.longitude!);
//         _selectedLocation = _center;
//         _isLoading = false;
//         _mapError = false;
//       });
//       _animateToLocation(_center!);
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _mapError = true;
//         _center = const LatLng(0, 0);
//       });
//     }
//   }

//   double _milesToMeters(double miles) => miles * 1609.34;

//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//   }

//   void _onRadiusChanged(double value) {
//     setState(() {
//       _radiusMiles = value;
//     });
//     if (_center != null) {
//       _animateToLocation(_center!);
//     }
//   }

//   void _handleTabChange(String value) {
//     setState(() {
//       _activeTab = value;
//     });
//   }

//   Future<void> _animateToLocation(LatLng location) async {
//     await _mapController?.animateCamera(
//       CameraUpdate.newLatLngZoom(location, 12),
//     );
//   }

//   // Place Autocomplete API
//   Future<List<Map<String, dynamic>>> _getPlacePredictions(String query) async {
//     if (query.isEmpty) return [];
//     if (_mapsApiKey.isEmpty) {
//       print('Google Maps API key is missing');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Google Maps API key not configured'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return [];
//     }

//     try {
//       final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$_mapsApiKey&types=geocode',
//       );

//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == 'OK') {
//           return List<Map<String, dynamic>>.from(data['predictions'] ?? []);
//         } else {
//           print('Places API error: ${data['status']}');
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Search error: ${data['status']}'),
//               backgroundColor: Colors.orange,
//             ),
//           );
//           return [];
//         }
//       } else {
//         print('HTTP error: ${response.statusCode}');
//         return [];
//       }
//     } catch (e) {
//       print('Error fetching place predictions: $e');
//       return [];
//     }
//   }

//   // Place Details API
//   Future<Map<String, dynamic>?> _getPlaceDetails(String placeId) async {
//     if (_mapsApiKey.isEmpty) {
//       print('Google Maps API key is missing');
//       return null;
//     }

//     try {
//       final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_mapsApiKey&fields=geometry,formatted_address,name,address_components',
//       );

//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == 'OK') {
//           return data['result'];
//         } else {
//           print('Place details error: ${data['status']}');
//           return null;
//         }
//       }
//       return null;
//     } catch (e) {
//       print('Error fetching place details: $e');
//       return null;
//     }
//   }

//   // Handle place selection
//   Future<void> _onPlaceSelected(Map<String, dynamic> prediction) async {
//     final details = await _getPlaceDetails(prediction['place_id']);
//     if (details != null) {
//       final geometry = details['geometry'];
//       if (geometry != null && geometry['location'] != null) {
//         final location = geometry['location'];
//         final latLng = LatLng(location['lat'], location['lng']);

//         setState(() {
//           _center = latLng;
//           _selectedLocation = latLng;
//           _searchController.text =
//               prediction['description'] ?? details['formatted_address'] ?? '';
//         });

//         _animateToLocation(latLng);
//       }
//     }
//   }

//   // Method to get complete address details from coordinates
//   Future<Map<String, String?>> _getAddressDetailsFromCoordinates(
//     LatLng coordinates,
//   ) async {
//     if (_mapsApiKey.isEmpty) {
//       return {};
//     }

//     try {
//       final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/geocode/json?latlng=${coordinates.latitude},${coordinates.longitude}&key=$_mapsApiKey',
//       );

//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == 'OK' && data['results'].isNotEmpty) {
//           final result = data['results'][0];
//           final addressComponents = result['address_components'];
//           final formattedAddress = result['formatted_address'];

//           String? country, state, city, zipcode;

//           for (var component in addressComponents) {
//             final types = List<String>.from(component['types']);
//             final value = component['long_name'];

//             if (types.contains('country')) {
//               country = value;
//             } else if (types.contains('administrative_area_level_1')) {
//               state = value;
//             } else if (types.contains('locality')) {
//               city = value;
//             } else if (types.contains('postal_code')) {
//               zipcode = value;
//             }
//           }

//           return {
//             'country': country,
//             'state': state,
//             'city': city,
//             'zipcode': zipcode,
//             'formattedAddress': formattedAddress,
//           };
//         }
//       }
//       return {};
//     } catch (e) {
//       print('Error getting address details: $e');
//       return {};
//     }
//   }

//   // Method to get country name from coordinates using reverse geocoding
//   Future<String?> _getCountryFromCoordinates(LatLng coordinates) async {
//     if (_mapsApiKey.isEmpty) {
//       print('Google Maps API key is missing');
//       return null;
//     }

//     try {
//       final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/geocode/json?latlng=${coordinates.latitude},${coordinates.longitude}&key=$_mapsApiKey',
//       );

//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == 'OK' && data['results'].isNotEmpty) {
//           final result = data['results'][0];
//           final addressComponents = result['address_components'];

//           // Find country component
//           for (var component in addressComponents) {
//             final types = List<String>.from(component['types']);
//             if (types.contains('country')) {
//               final countryName = component['long_name'];
//               print('Found country: $countryName');
//               return countryName;
//             }
//           }
//         }
//       }
//       return null;
//     } catch (e) {
//       print('Error in reverse geocoding: $e');
//       return null;
//     }
//   }

//   // Updated method to create location data
//   Future<ServiceLocationEntity> _createLocationData(String type) async {
//     final addressDetails = await _getAddressDetailsFromCoordinates(
//       _selectedLocation!,
//     );

//     final locationName = _locationNameController.text.isNotEmpty
//         ? _locationNameController.text
//         : 'Location ${_locations.length + 1}';

//     return ServiceLocationEntity(
//       type: type,
//       coordinates: LangEntity(
//         latitude: _selectedLocation!.latitude,
//         longitude: _selectedLocation!.longitude,
//       ),
//       country: addressDetails['country'] ?? 'USA',
//       state: addressDetails['state'],
//       city: addressDetails['city'],
//       zipcode: addressDetails['zipcode'],
//       addressLine: addressDetails['formattedAddress'] ?? _searchController.text,
//       radiusMiles: _radiusMiles,
//       isPrimary: _locations.isEmpty, // First location is primary by default
//     );
//   }

//   // Add new location
//   Future<void> _addLocation() async {
//     if (_selectedLocation == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a location first')),
//       );
//       return;
//     }

//     setState(() {
//       _isNextLoading = true;
//     });

//     try {
//       final newLocation = await _createLocationData('service');

//       setState(() {
//         _locations.add(newLocation);
//         _selectedLocationIndex = _locations.length - 1;
//         _locationNameController.clear();
//         _searchController.clear();
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Location added successfully!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error adding location: $e')));
//     } finally {
//       setState(() {
//         _isNextLoading = false;
//       });
//     }
//   }

//   // Edit existing location
//   void _editLocation(int index) {
//     final location = _locations[index];
//     setState(() {
//       _selectedLocationIndex = index;
//       _selectedLocation = LatLng(
//         location.coordinates!.latitude,
//         location.coordinates!.longitude,
//       );
//       _radiusMiles = location.radiusMiles ?? 10;
//       _searchController.text = location.addressLine ?? '';
//       _locationNameController.text = 'Location ${index + 1}';
//     });
//     _animateToLocation(_selectedLocation!);
//   }

//   // Remove location
//   void _removeLocation(int index) {
//     setState(() {
//       final wasPrimary = _locations[index].isPrimary;
//       _locations.removeAt(index);

//       // If we removed the primary location and there are other locations, make the first one primary
//       if (wasPrimary && _locations.isNotEmpty) {
//         _locations[0] = _locations[0].copyWith(isPrimary: true);
//       }

//       if (_selectedLocationIndex == index) {
//         _selectedLocationIndex = -1;
//         _locationNameController.clear();
//         _searchController.clear();
//       } else if (_selectedLocationIndex > index) {
//         _selectedLocationIndex--;
//       }
//     });
//   }

//   // Set location as primary
//   void _setPrimaryLocation(int index) {
//     setState(() {
//       _locations = _locations
//           .asMap()
//           .entries
//           .map((entry) => entry.value.copyWith(isPrimary: entry.key == index))
//           .toList();
//     });
//   }

//   // Update existing location
//   Future<void> _updateLocation() async {
//     if (_selectedLocationIndex == -1 || _selectedLocation == null) return;

//     setState(() {
//       _isNextLoading = true;
//     });

//     try {
//       final updatedLocation = await _createLocationData('service');

//       setState(() {
//         _locations[_selectedLocationIndex] = updatedLocation;
//         _selectedLocationIndex = -1;
//         _locationNameController.clear();
//         _searchController.clear();
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Location updated successfully!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error updating location: $e')));
//     } finally {
//       setState(() {
//         _isNextLoading = false;
//       });
//     }
//   }

//   // Save all locations and continue
//   Future<void> _saveLocationsAndContinue() async {
//     if (_locations.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please add at least one location')),
//       );
//       return;
//     }

//     setState(() {
//       _isNextLoading = true;
//     });

//     try {
//       final controller = context.read<ServiceController>();
//       controller.updateLocations(_locations);

//       Navigator.pushNamed(context, AppRouter.budget);
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error saving locations: $e')));
//     } finally {
//       setState(() {
//         _isNextLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('Service Locations'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _mapError
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, size: 50, color: Colors.red),
//                   const SizedBox(height: 20),
//                   const Text('Failed to load map'),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _initLocation,
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             )
//           : Column(
//               children: [
//                 // Locations List
//                 if (_locations.isNotEmpty) _buildLocationsList(),

//                 // Tabs
//                 Container(
//                   height: 48,
//                   decoration: BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(
//                         color: isDarkMode
//                             ? Colors.grey[700]!
//                             : Colors.grey[300]!,
//                       ),
//                     ),
//                   ),
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: _tabOptions.length,
//                     itemBuilder: (context, index) {
//                       final tab = _tabOptions[index];
//                       return GestureDetector(
//                         onTap: () => _handleTabChange(tab['value']),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                           decoration: BoxDecoration(
//                             border: Border(
//                               bottom: BorderSide(
//                                 width: 2,
//                                 color: _activeTab == tab['value']
//                                     ? const Color(0xFF0077B6)
//                                     : Colors.transparent,
//                               ),
//                             ),
//                           ),
//                           child: Text(
//                             tab['label'],
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               color: _activeTab == tab['value']
//                                   ? const Color(0xFF0077B6)
//                                   : (isDarkMode
//                                         ? Colors.grey[400]
//                                         : Colors.grey[600]),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),

//                 // Content based on active tab
//                 Expanded(
//                   child: _activeTab == 'distance'
//                       ? _buildDistanceTab()
//                       : _buildAdvancedTab(),
//                 ),
//               ],
//             ),
//       bottomNavigationBar: _buildBottomNavigationBar(),
//     );
//   }

//   Widget _buildLocationsList() {
//     return Container(
//       height: 120,
//       decoration: BoxDecoration(
//         border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 const Text(
//                   'Service Locations',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(width: 8),
//                 Chip(
//                   label: Text('${_locations.length}'),
//                   backgroundColor: const Color(0xFF0077B6),
//                   labelStyle: const TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: _locations.length,
//               itemBuilder: (context, index) {
//                 final location = _locations[index];
//                 return _buildLocationCard(location, index);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLocationCard(ServiceLocationEntity location, int index) {
//     return Card(
//       margin: const EdgeInsets.all(4),
//       color: location.isPrimary ? Colors.blue[50] : null,
//       child: Container(
//         width: 200,
//         padding: const EdgeInsets.all(8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     location.city ?? 'Unknown City',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: location.isPrimary ? Colors.blue[800] : null,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 if (location.isPrimary)
//                   const Icon(Icons.star, color: Colors.amber, size: 16),
//               ],
//             ),
//             Text(
//               '${location.state ?? ''} ${location.zipcode ?? ''}'.trim(),
//               style: const TextStyle(fontSize: 12),
//               overflow: TextOverflow.ellipsis,
//             ),
//             Text(
//               '${location.radiusMiles?.round() ?? _radiusMiles.round()} miles',
//               style: const TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//             const Spacer(),
//             Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.edit, size: 16),
//                   onPressed: () => _editLocation(index),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete, size: 16),
//                   onPressed: () => _removeLocation(index),
//                 ),
//                 if (!location.isPrimary)
//                   IconButton(
//                     icon: const Icon(Icons.star_border, size: 16),
//                     onPressed: () => _setPrimaryLocation(index),
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomNavigationBar() {
//     return BottomAppBar(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         child: Row(
//           children: [
//             // Add/Update Location Button
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: _isNextLoading
//                     ? null
//                     : _selectedLocationIndex == -1
//                     ? _addLocation
//                     : _updateLocation,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF0077B6),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   minimumSize: const Size(0, 48),
//                 ),
//                 child: _isNextLoading
//                     ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             Colors.white,
//                           ),
//                         ),
//                       )
//                     : Text(
//                         _selectedLocationIndex == -1
//                             ? 'Add Location'
//                             : 'Update Location',
//                         style: const TextStyle(color: Colors.white),
//                       ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             // Continue Button
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: _locations.isEmpty
//                     ? null
//                     : _saveLocationsAndContinue,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _locations.isEmpty
//                       ? Colors.grey
//                       : Colors.green,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   minimumSize: const Size(0, 48),
//                 ),
//                 child: const Text(
//                   'Continue',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDistanceTab() {
//     return Column(
//       children: [
//         // Location Name Input
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: TextField(
//             controller: _locationNameController,
//             decoration: InputDecoration(
//               labelText: 'Location Name (Optional)',
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               hintText: 'e.g., Downtown Office, North Branch, etc.',
//             ),
//           ),
//         ),

//         // Search and controls
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Set the service area radius',
//                 style: TextStyle(fontSize: 14),
//               ),
//               const SizedBox(height: 16),
//               TypeAheadField<Map<String, dynamic>>(
//                 controller: _searchController,
//                 builder: (context, controller, focusNode) {
//                   return TextField(
//                     controller: controller,
//                     focusNode: focusNode,
//                     decoration: InputDecoration(
//                       hintText: 'Search any location worldwide...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       prefixIcon: const Icon(Icons.search),
//                       contentPadding: const EdgeInsets.symmetric(vertical: 12),
//                       isDense: true,
//                     ),
//                   );
//                 },
//                 suggestionsCallback: (pattern) async {
//                   return await _getPlacePredictions(pattern);
//                 },
//                 itemBuilder: (context, suggestion) {
//                   return ListTile(
//                     leading: const Icon(Icons.location_on),
//                     title: Text(
//                       suggestion['description'] ?? 'Unknown location',
//                     ),
//                   );
//                 },
//                 onSelected: _onPlaceSelected,
//                 loadingBuilder: (context) => const Padding(
//                   padding: EdgeInsets.all(12.0),
//                   child: Center(child: CircularProgressIndicator()),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Service radius',
//                         style: TextStyle(fontSize: 14),
//                       ),
//                       Text(
//                         '${_radiusMiles.round()} miles',
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Color(0xFF0077B6),
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Slider(
//                     value: _radiusMiles,
//                     min: 1,
//                     max: 50,
//                     divisions: 49,
//                     label: _radiusMiles.round().toString(),
//                     activeColor: const Color(0xFF0077B6),
//                     onChanged: _onRadiusChanged,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),

//         // Map
//         Expanded(
//           child: Stack(
//             children: [
//               GoogleMap(
//                 onMapCreated: _onMapCreated,
//                 initialCameraPosition: CameraPosition(
//                   target: _center ?? const LatLng(0, 0),
//                   zoom: _center != null ? 12 : 2,
//                 ),
//                 myLocationEnabled: true,
//                 myLocationButtonEnabled: false,
//                 circles: _center != null
//                     ? {
//                         Circle(
//                           circleId: const CircleId('radius'),
//                           center: _center!,
//                           radius: _milesToMeters(_radiusMiles),
//                           fillColor: const Color(0xFF0077B6).withOpacity(0.2),
//                           strokeColor: const Color(0xFF0077B6),
//                           strokeWidth: 2,
//                         ),
//                       }
//                     : {},
//                 onTap: (latLng) {
//                   setState(() {
//                     _center = latLng;
//                     _selectedLocation = latLng;
//                     _searchController.clear();
//                   });
//                   _animateToLocation(latLng);
//                 },
//               ),
//               Positioned(
//                 top: 16,
//                 right: 16,
//                 child: FloatingActionButton(
//                   mini: true,
//                   backgroundColor: Colors.white,
//                   onPressed: _getCurrentLocation,
//                   child: const Icon(Icons.my_location, color: Colors.black),
//                 ),
//               ),
//               if (_center != null)
//                 const Center(
//                   child: Icon(Icons.location_pin, color: Colors.red, size: 40),
//                 ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAdvancedTab() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.tune, size: 48, color: Colors.grey),
//             const SizedBox(height: 16),
//             const Text(
//               'Advanced Location Settings',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Coming soon: Custom service areas, multiple radius settings, and advanced geographic targeting.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Theme.of(context).brightness == Brightness.dark
//                     ? Colors.grey[400]
//                     : Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _locationNameController.dispose();
//     super.dispose();
//   }
// }

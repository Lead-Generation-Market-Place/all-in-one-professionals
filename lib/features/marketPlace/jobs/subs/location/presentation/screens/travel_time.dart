import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/subs/location/presentation/widgets/build_location_card.dart';
import 'package:yelpax_pro/shared/widgets/custom_advanced_dropdown.dart';

class DistanceInMiles {
  final int id;
  final String name;
  DistanceInMiles(this.name, this.id);
}

class TravelTime extends StatefulWidget {
  const TravelTime({super.key});

  @override
  State<TravelTime> createState() => _TravelTimeState();
}

class _TravelTimeState extends State<TravelTime> {
  final List<DistanceInMiles> _distances = [
    DistanceInMiles('1 Mile', 1),
    DistanceInMiles('5 Miles', 5),
    DistanceInMiles('10 Miles', 10),
    DistanceInMiles('20 Miles', 20),
    DistanceInMiles('50 Miles', 50),
  ];

  DistanceInMiles? _selectedDistance;

  late GoogleMapController _mapController;
  final TextEditingController _searchController = TextEditingController();

  CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 12,
  );

  List<Placemark> _searchResults = [];
  LatLng? _selectedLatLng;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _searchLocation(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      // List<Placemark> placemarks = await placemarkFromAddress(query);

      // setState(() {
      //   _searchResults = placemarks;
      // });

      if (locations.isNotEmpty) {
        final Location loc = locations.first;
        final LatLng target = LatLng(loc.latitude, loc.longitude);

        _selectedLatLng = target;

        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: target, zoom: 14),
          ),
        );
      }
    } catch (e) {
      print('Error searching location: $e');
      setState(() => _searchResults = []);
    }
  }

  void _selectSearchResult(Placemark placemark) async {
    final query =
        "${placemark.name}, ${placemark.locality}, ${placemark.country}";
    _searchController.text = query;

    setState(() => _searchResults = []);

    await _searchLocation(query);
  }

  void _addLocation() {
    if (_selectedLatLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a location first")),
      );
      return;
    }

    // Add your saving logic here
    print(
      "Location added: $_selectedLatLng with distance: ${_selectedDistance?.name ?? 'Not selected'}",
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Location added successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Time'),
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
              Text(
                'Note:- Please select your coverage area carefully. '
                'This will determine where your services are available and can impact your visibility to potential customers.',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),
              /// 🔍 Search input
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _searchLocation(value);
                  } else {
                    setState(() => _searchResults = []);
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Search by name or address',
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// 📍 Suggestion list
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

              /// 🗺️ Google Map
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
                            ),
                          }
                        : {},
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 📏 Distance Dropdown
              AdvancedDropdown<DistanceInMiles>(
                items: _distances,
                enableSearch: false,
                hintText: 'Select Distance',
                itemToString: (item) => item.name,
                onChanged: (value) {
                  setState(() => _selectedDistance = value);
                },
              ),

              const SizedBox(height: 20),

              /// 🛠️ Services Card
              LocationCard(
                icon: Icons.miscellaneous_services,
                title: 'Services',
                subtitle: 'Select the services you offer at this location',
                color: Colors.green,
                onTap: () {
                  _openServicesBottomSheet();
                },
              ),

              const SizedBox(height: 30),

              /// ✅ Add Location Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addLocation,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Add Location'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openServicesBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) => _buildServicesBottomSheet(),
    );
  }

  Widget _buildServicesBottomSheet() {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Services',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    CheckboxListTile(
                      title: const Text('Service 1'),
                      value: true,
                      onChanged: (val) {},
                    ),
                    CheckboxListTile(
                      title: const Text('Service 2'),
                      value: false,
                      onChanged: (val) {},
                    ),
                    // Add more services as needed
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

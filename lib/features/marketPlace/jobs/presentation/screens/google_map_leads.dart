import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yelpax_pro/config/routes/router.dart';

class GoogleMapLeads extends StatefulWidget {
  const GoogleMapLeads({super.key});

  @override
  State<GoogleMapLeads> createState() => _GoogleMapLeadsState();
}

class _GoogleMapLeadsState extends State<GoogleMapLeads> {
  final List<Lead> leads = [
    Lead(
      name: 'Planer',
      locations: [
        'Ruislip',
        'Harrow',
        'Wembley',
        'Greenford',
        'Hayes',
        'Southall',
        'EALING',
        'HAMMERSM',
        'Feltham',
        'Abu',
        'London, TW5',
      ],
      service: 'House Cleaning',
      details: 'Flat or Apartment / 3 bedrooms / 1 bathroom / Once a month service',
      isFrequentUser: true,
    ),
    Lead(
      name: 'CleanHome',
      locations: ['Harrow', 'Wembley'],
      service: 'Deep Cleaning',
      details: 'House / 2 bedrooms / 1 bathroom / Weekly service',
      isFrequentUser: false,
    ),
    Lead(
      name: 'SparkleClean',
      locations: ['Greenford', 'Southall'],
      service: 'Standard Cleaning',
      details: 'Flat / 1 bedroom / 1 bathroom / Bi-weekly service',
      isFrequentUser: true,
    ),
  ];

  late GoogleMapController mapController;
  final PageController _pageController = PageController(viewportFraction: 0.8);
  Set<Marker> markers = {};
  int _currentPage = 0;
  int _currentNavIndex = 0;

  LatLng _getCoordinatesForLocation(String location) {
    final mockLocations = {
      'Ruislip': const LatLng(51.5734, -0.4234),
      'Harrow': const LatLng(51.5807, -0.3417),
      'Wembley': const LatLng(51.5524, -0.2962),
      'Greenford': const LatLng(51.5287, -0.3496),
      'Hayes': const LatLng(51.5028, -0.4214),
      'Southall': const LatLng(51.5060, -0.3782),
      'EALING': const LatLng(51.5139, -0.3059),
      'HAMMERSM': const LatLng(51.4927, -0.2229),
      'Feltham': const LatLng(51.4479, -0.4086),
      'Abu': const LatLng(51.5074, -0.1278),
      'London, TW5': const LatLng(51.4813, -0.3762),
    };
    return mockLocations[location] ?? const LatLng(51.5074, -0.1278);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _updateMapForLead(int index) {
    if (index >= leads.length) return;

    final lead = leads[index];
    final location = lead.locations.first;

    setState(() {
      _currentPage = index;
      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId(lead.name),
          position: _getCoordinatesForLocation(location),
          infoWindow: InfoWindow(
            title: lead.name,
            snippet: location,
          ),
        ),
      );

      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_getCoordinatesForLocation(location), 12),
      );
    });
  }

  void _onNavItemTapped(int index, BuildContext context) {
    if (index == _currentNavIndex) return;

    setState(() {
      _currentNavIndex = index;
    });

    switch (index) {
      case 0:
      // Already on Leads screen
        break;
      case 1:
        Navigator.pushNamed(context, AppRouter.responses);
        break;
      case 2:
        // Navigator.pushNamed(context, AppRouter.reminders);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final newPage = _pageController.page?.round();
      if (newPage != null && newPage != _currentPage) {
        _updateMapForLead(newPage);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateMapForLead(0);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads'),
        centerTitle: true,
        leading:IconButton(onPressed: (){
          Navigator.pushNamedAndRemoveUntil(context,AppRouter.homeServicesJobs, (route) => false,);
        }, icon: Icon(Icons.arrow_back)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(51.5074, -0.1278),
              zoom: 10,
            ),
            markers: markers,
            myLocationEnabled: true,
          ),

          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${leads.length} matching leads',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${leads.map((e) => e.service).toSet().length} services ● ${leads.expand((e) => e.locations).toSet().length} locations',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.filter_list, color: Colors.blue),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 160,
              child: PageView.builder(
                controller: _pageController,
                itemCount: leads.length,
                itemBuilder: (context, index) {
                  final lead = leads[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  lead.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (lead.isFrequentUser)
                                  const Chip(
                                    label: Text('Frequent user'),
                                    backgroundColor: Colors.greenAccent,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              lead.service,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              lead.details,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 32,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: lead.locations.map((location) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Chip(
                                      label: Text(location),
                                      backgroundColor: index == _currentPage
                                          ? Colors.blue[100]
                                          : Colors.grey[200],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => _onNavItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Leads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.email),
            label: 'Responses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Reminders',
          ),
        ],
      ),
    );
  }
}

class Lead {
  final String name;
  final List<String> locations;
  final String service;
  final String details;
  final bool isFrequentUser;

  Lead({
    required this.name,
    required this.locations,
    required this.service,
    required this.details,
    required this.isFrequentUser,
  });
}
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
      details:
          'Flat or Apartment / 3 bedrooms / 1 bathroom / Once a month service',
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

  GoogleMapController? _mapController;
  final PageController _pageController = PageController(viewportFraction: 0.8);
  Set<Marker> _markers = {};
  int _currentPage = 0;
  int _currentNavIndex = 0;
  bool _isMapReady = false;
  bool _isDisposed = false;

  // Simplified coordinates map
  static const Map<String, LatLng> _locationCoordinates = {
    'Ruislip': LatLng(51.5734, -0.4234),
    'Harrow': LatLng(51.5807, -0.3417),
    'Wembley': LatLng(51.5524, -0.2962),
    'Greenford': LatLng(51.5287, -0.3496),
    'Hayes': LatLng(51.5028, -0.4214),
    'Southall': LatLng(51.5060, -0.3782),
    'EALING': LatLng(51.5139, -0.3059),
    'HAMMERSM': LatLng(51.4927, -0.2229),
    'Feltham': LatLng(51.4479, -0.4086),
    'Abu': LatLng(51.5074, -0.1278),
    'London, TW5': LatLng(51.4813, -0.3762),
  };

  static const LatLng _defaultLocation = LatLng(51.5074, -0.1278);

  LatLng _getCoordinatesForLocation(String location) {
    return _locationCoordinates[location] ?? _defaultLocation;
  }

  void _onMapCreated(GoogleMapController controller) {
    if (_isDisposed) return;

    _mapController = controller;
    _isMapReady = true;

    // Initialize with first lead
    if (leads.isNotEmpty) {
      _updateMapForLead(0);
    }
  }

  void _updateMapForLead(int index) {
    if (_isDisposed || index >= leads.length) return;

    final lead = leads[index];
    final location = lead.locations.first;
    final coordinates = _getCoordinatesForLocation(location);

    setState(() {
      _currentPage = index;
      _markers = {
        Marker(
          markerId: MarkerId(lead.name),
          position: coordinates,
          infoWindow: InfoWindow(title: lead.name, snippet: location),
        ),
      };
    });

    // Animate camera with error handling
    if (_isMapReady && _mapController != null) {
      try {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(coordinates, 12),
        );
      } catch (e) {
        debugPrint('Map animation error: $e');
      }
    }
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
        Navigator.pushNamed(context, AppRouter.reminders);
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize first lead's marker
    if (leads.isNotEmpty) {
      final lead = leads[0];
      final location = lead.locations.first;
      _markers = {
        Marker(
          markerId: MarkerId(lead.name),
          position: _getCoordinatesForLocation(location),
          infoWindow: InfoWindow(title: lead.name, snippet: location),
        ),
      };
    }

    // Add page controller listener
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    if (_isDisposed) return;

    final newPage = _pageController.page?.round();
    if (newPage != null && newPage != _currentPage && newPage < leads.length) {
      _updateMapForLead(newPage);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads'),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRouter.homeServicesJobs,
              (route) => false,
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          // Optimized Google Map
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: _defaultLocation,
              zoom: 10,
            ),
            markers: _markers,
            myLocationEnabled: false, // Disabled to reduce overhead
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            tiltGesturesEnabled: false,
            rotateGesturesEnabled: false,
            liteModeEnabled: false,
            trafficEnabled: false,
            indoorViewEnabled: false,
            buildingsEnabled: false,
            // Add performance optimizations
            minMaxZoomPreference: const MinMaxZoomPreference(8, 18),
            cameraTargetBounds: CameraTargetBounds.unbounded,
          ),

          // Stats Card
          Positioned(
            top:
                MediaQuery.of(context).size.height *
                0.02, // Responsive top margin
            left:
                MediaQuery.of(context).size.width *
                0.04, // Responsive left margin
            right:
                MediaQuery.of(context).size.width *
                0.04, // Responsive right margin
            child: Card(
              elevation: 2,
              color: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.03,
                ), // Responsive padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${leads.length} matching leads',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${leads.map((e) => e.service).toSet().length} services ● ${leads.expand((e) => e.locations).toSet().length} locations',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.filter_list, color: colorScheme.primary),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // My Location Button
          Positioned(
            top:
                MediaQuery.of(context).size.height *
                0.12, // Responsive top position
            right:
                MediaQuery.of(context).size.width *
                0.04, // Responsive right margin
            child: FloatingActionButton.small(
              onPressed: () {
                // Handle my location
              },
              backgroundColor: colorScheme.surface,
              foregroundColor: colorScheme.onSurface,
              child: const Icon(Icons.my_location),
            ),
          ),

          // Leads Cards
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Container(
              height:
                  MediaQuery.of(context).size.height *
                  0.25, // Responsive height
              child: PageView.builder(
                controller: _pageController,
                itemCount: leads.length,
                itemBuilder: (context, index) {
                  final lead = leads[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          MediaQuery.of(context).size.width *
                          0.04, // Responsive padding
                    ),
                    child: Card(
                      elevation: 2,
                      color: colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.03,
                        ), // Responsive padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    lead.name,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (lead.isFrequentUser)
                                  Chip(
                                    label: Text(
                                      'Frequent user',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: colorScheme.tertiary,
                                          ),
                                    ),
                                    backgroundColor: colorScheme.tertiary
                                        .withOpacity(0.12),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ), // Responsive spacing
                            Text(
                              lead.service,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ), // Responsive spacing
                            Expanded(
                              child: Text(
                                lead.details,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ), // Responsive spacing
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height *
                                  0.04, // Responsive height
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: lead.locations.map((location) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      right:
                                          MediaQuery.of(context).size.width *
                                          0.02, // Responsive padding
                                    ),
                                    child: Chip(
                                      label: Text(
                                        location,
                                        style: theme.textTheme.labelSmall,
                                      ),
                                      backgroundColor: index == _currentPage
                                          ? colorScheme.primary.withOpacity(
                                              0.12,
                                            )
                                          : colorScheme.surfaceContainerHighest,
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentNavIndex,
        onDestinationSelected: (index) => _onNavItemTapped(index, context),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Leads'),
          NavigationDestination(icon: Icon(Icons.email), label: 'Responses'),
          NavigationDestination(
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

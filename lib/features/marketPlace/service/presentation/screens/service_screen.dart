import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/presentation/widgets/finish_setup.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  bool isSetupFinished = false;
  late GoogleMapController _mapController;

  final LatLng _initialPosition = const LatLng(37.7749, -122.4194); // San Francisco

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (!isSetupFinished)
            ProfileCompletionBanner(
              stepNumber: 3,
              onFinishSetupPressed: () {
                Navigator.pushNamed(context, AppRouter.signUpProcessScreen);
              },
            ),

          // Custom AppBar
          PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBar(
              title: const Text('Services'),
              automaticallyImplyLeading: false,
            ),
          ),

          // Google Map
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 12,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}

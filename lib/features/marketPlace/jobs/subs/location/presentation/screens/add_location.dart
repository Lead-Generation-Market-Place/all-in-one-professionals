import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/subs/location/presentation/widgets/build_location_card.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Location',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Location Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose how you want to define your service area',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Distance Card
            // Inside your build method
            LocationCard(
              icon: Icons.place_rounded,
              title: 'Distance',
              subtitle:
                  'Enter a postcode or city and then choose how far from there - as the crow flies.',
              color: Colors.blue,
              onTap: () {
                Navigator.pushNamed(context, AppRouter.distance);
              },
            ),

            const SizedBox(height: 16),

            LocationCard(
              icon: Icons.directions_car_rounded,
              title: 'Travel Time',
              subtitle:
                  'Enter a postcode or city and tell us how long you want your maximum drive to be.',
              color: Colors.green,
              onTap: () {
                Navigator.pushNamed(context, AppRouter.travel_time);
              },
            ),

            const SizedBox(height: 16),

            LocationCard(
              icon: Icons.public_rounded,
              title: 'Nationwide',
              subtitle:
                  'Choose the nationwide location if you provide services across the whole country.',
              color: Colors.purple,
              onTap: () {
                Navigator.pushNamed(context, AppRouter.nationwide);
              },
            ),

            const SizedBox(height: 32),

            // Additional Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Colors.blue,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your location settings will be visible to customers searching for services in your area.',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

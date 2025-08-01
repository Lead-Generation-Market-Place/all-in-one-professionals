import 'package:flutter/material.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/presentation/widgets/finish_setup.dart';
import 'package:yelpax_pro/shared/widgets/bottom_navbar.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  bool isSetupFinished = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavbar(),
      body: Column(
        children: [
          if (!isSetupFinished)
            ProfileCompletionBanner(
              stepNumber: 3,
              onFinishSetupPressed: () {
                Navigator.pushNamed(context, AppRouter.signUpProcessScreen);
              },
            ),

          // Manually add AppBar here below the banner
          PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBar(
              title: const Text('Services'),

              automaticallyImplyLeading: false,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  // Your other content here
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

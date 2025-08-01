import 'package:flutter/material.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/presentation/widgets/finish_setup.dart';
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/screens/m_services_categories.dart';
import 'package:yelpax_pro/shared/widgets/bottom_navbar.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  @override
  void initState() {
    super.initState();

    // Show bottom sheet after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showServiceSelectionBottomSheet();
    });
  }

  void _showServiceSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.85, // Show 85% of the screen height
        child: MServicesCategories(),
      ),
    );
  }

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
              title: const Text('Jobs'),

              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.home,
                    (route) => false,
                  );
                },
              ),
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

import 'package:flutter/material.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/presentation/widgets/finish_setup.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool isSetupFinished = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [

            if (!isSetupFinished)
              ProfileCompletionBanner(
                stepNumber: 3,
                onFinishSetupPressed: () {
                  Navigator.pushNamed(context, AppRouter.signUpProcessScreen);
                },
              ),
            Material(
              elevation: 4,
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: SizedBox(
                height: kToolbarHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRouter.homeServicesNotifications,
                              );
                              debugPrint("Settings tapped");
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRouter.settingsScreen,
                              );
                              debugPrint("Settings tapped");
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
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
      ),
    );
  }
}

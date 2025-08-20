// widgets/restaurant_screen.dart
import 'package:flutter/material.dart';

import '../../../../config/routes/router.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.settingsScreen);
              debugPrint("Settings tapped");
            },
          ),
        ],
      ),
      body: Center(
        child: Container(child: Column(children: [Text('Restaurant')])),
      ),
    );
  }
}

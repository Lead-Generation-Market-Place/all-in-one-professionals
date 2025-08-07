// widgets/grocery_screen.dart
import 'package:flutter/material.dart';
import 'package:yelpax_pro/shared/widgets/bottom_navbar.dart';

import '../../../../config/routes/router.dart';

class GroceryScreen extends StatelessWidget {
  const GroceryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text('Grocery Store'),
      automaticallyImplyLeading: false,
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
      child: Container(
        child: Column(
          children: [
            Text('Grocery Store')
          ],
        ),
      ),
    ),);
  }
}

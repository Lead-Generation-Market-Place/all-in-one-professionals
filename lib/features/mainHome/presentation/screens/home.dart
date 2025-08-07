import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/features/mainHome/presentation/controllers/business_context_controller.dart';
import 'package:yelpax_pro/features/mainHome/presentation/widgets/grocery_screen.dart';

import 'package:yelpax_pro/features/marketPlace/jobs/presentation/screens/jobs_screen.dart';
import 'package:yelpax_pro/shared/services/bottom_navbar_notifier.dart';
import 'package:yelpax_pro/shared/widgets/bottom_navbar.dart';

import '../widgets/resturant_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final contextProvider = Provider.of<BusinessContextProvider>(context);
    final navProvider = Provider.of<BottomNavProvider>(context);

    return Scaffold(

      body: _getCurrentScreen(
        contextProvider.currentContext.type,
        navProvider.selectedIndex,
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }

  // Widget _buildBusinessTypeDropdown(
  //     BuildContext context, BusinessContextProvider provider) {
  //   return DropdownButton<BusinessContext>(
  //     value: provider.currentContext,
  //     items: provider.availableContexts.map((context) {
  //       return DropdownMenuItem<BusinessContext>(
  //         value: context,
  //         child: Text(context.name),
  //       );
  //     }).toList(),
  //     onChanged: (newContext) {
  //       if (newContext != null) {
  //         provider.switchContext(newContext);
  //         Provider.of<BottomNavProvider>(context, listen: false).changeIndex(0);
  //       }
  //     },
  //   );
  // }

  Widget _getCurrentScreen(BusinessType type, int index) {
    switch (type) {
      case BusinessType.restaurant:
        return _getRestaurantTab(index);
      case BusinessType.grocery:
        return _getGroceryTab(index);
      case BusinessType.marketplace:
        return _getMarketplaceTab(index);
    }
  }

  String _getAppBarTitle(BusinessType type, int index) {
    switch (type) {
      case BusinessType.restaurant:
        switch (index) {
          case 0:
            return 'Restaurant Menu';
          case 1:
            return 'Reviews';
          case 2:
            return 'Settings';
          default:
            return 'Restaurant';
        }
      case BusinessType.grocery:
        switch (index) {
          case 0:
            return 'Grocery Store';
          case 1:
            return 'Shopping Cart';
          case 2:
            return 'Settings';
          default:
            return 'Grocery';
        }
      case BusinessType.marketplace:
        switch (index) {
          case 0:
            return 'Jobs';
          case 1:
            return 'Search';
          case 2:
            return 'Services';
          case 3:
            return 'Notifications';
          case 4:
            return 'Profile';
          default:
            return 'Marketplace';
        }
    }
  }

  Widget _getRestaurantTab(int index) {
    switch (index) {
      case 0:
        return const RestaurantScreen();
      case 1:
        return const Center(child: Text("Restaurant Reviews"));
      case 2:
        return const Center(child: Text("Restaurant Settings"));
      default:
        return const RestaurantScreen();
    }
  }

  Widget _getGroceryTab(int index) {
    switch (index) {
      case 0:
        return const GroceryScreen();
      case 1:
        return const Center(child: Text("Grocery Cart"));
      case 2:
        return const Center(child: Text("Grocery Settings"));
      default:
        return const GroceryScreen();
    }
  }

  Widget _getMarketplaceTab(int index) {
    switch (index) {
      case 0:
        return  JobsScreen();
      case 1:
        return const Center(child: Text("Search"));
      case 2:
        return const Center(child: Text("Services"));
      case 3:
        return const Center(child: Text("Notifications"));
      case 4:
        return const Center(child: Text("Profile"));
      default:
        return const JobsScreen();
    }
  }
}
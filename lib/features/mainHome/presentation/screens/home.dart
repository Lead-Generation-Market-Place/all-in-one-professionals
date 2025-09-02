import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/features/mainHome/presentation/controllers/business_context_controller.dart';
import 'package:yelpax_pro/features/mainHome/presentation/widgets/grocery_screen.dart';
import 'package:yelpax_pro/features/mainHome/presentation/widgets/resturant_screen.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/presentation/screens/jobs_screen.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/screens/profile_screen.dart';
import 'package:yelpax_pro/features/marketPlace/search/presentation/screens/search_screen.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/screens/service_screen.dart';
import 'package:yelpax_pro/shared/services/bottom_navbar_notifier.dart';
import 'package:yelpax_pro/shared/widgets/bottom_navbar.dart';

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
        context, // Pass context for navigation if needed
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }

  // Update to accept BuildContext
  Widget _getCurrentScreen(BusinessType type, int index, BuildContext context) {
    switch (type) {
      case BusinessType.restaurant:
        return _getRestaurantTab(index, context);
      case BusinessType.grocery:
        return _getGroceryTab(index, context);
      case BusinessType.homeServices:
        return _getMarketplaceTab(index, context);
    }
  }

  // Update other methods to accept BuildContext
  Widget _getRestaurantTab(int index, BuildContext context) {
    switch (index) {
      case 0:
        return const RestaurantScreen();
      case 1:
      // return const RestaurantReviewsScreen(); // Create this widget
      case 2:
      // return const RestaurantSettingsScreen(); // Create this widget
      default:
        return const RestaurantScreen();
    }
  }

  Widget _getGroceryTab(int index, BuildContext context) {
    switch (index) {
      case 0:
        return const GroceryScreen();
      case 1:
      // return const GroceryCartScreen(); // Create this widget
      case 2:
      // return const GrocerySettingsScreen(); // Create this widget
      default:
        return const GroceryScreen();
    }
  }

  Widget _getMarketplaceTab(int index, BuildContext context) {
    switch (index) {
      case 0:
        return const JobsScreen();
      case 1:
        return const SearchScreen(); // Create this widget
      case 2:
        return const ServiceScreen(); // Create this widget
      case 3:
        return const ProfileScreen(); // Create this widget
      default:
        return const JobsScreen();
    }
  }
}

Widget _getCurrentScreen(BusinessType type, int index) {
  switch (type) {
    case BusinessType.restaurant:
      return _getRestaurantTab(index);
    case BusinessType.grocery:
      return _getGroceryTab(index);
    case BusinessType.homeServices:
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
    case BusinessType.homeServices:
      switch (index) {
        case 0:
          return 'Leads';
        case 1:
          return 'Search';
        case 2:
          return 'Services';
        case 3:
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
      return const JobsScreen();
    case 1:
      return const Center(child: Text("Search"));
    case 2:
      return const Center(child: Text("Services"));
    case 3:
      return const Center(child: Text("Profile"));
    default:
      return const JobsScreen();
  }
}

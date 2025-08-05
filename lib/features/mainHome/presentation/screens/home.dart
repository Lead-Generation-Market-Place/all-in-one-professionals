import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';
import 'package:yelpax_pro/features/mainHome/presentation/controllers/business_context_controller.dart';
import 'package:yelpax_pro/shared/widgets/bottom_navbar.dart';
import 'package:yelpax_pro/shared/services/bottom_navbar_notifier.dart';

import 'package:yelpax_pro/features/mainHome/presentation/widgets/grocery_screen.dart';
import 'package:yelpax_pro/features/mainHome/presentation/widgets/market_place.dart';
import 'package:yelpax_pro/features/mainHome/presentation/widgets/resturant_screen.dart';

import '../../../../config/themes/theme_mode_type.dart';
import '../../../../config/themes/theme_provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final contextProvider = Provider.of<BusinessContextProvider>(context);
    final navProvider = Provider.of<BottomNavProvider>(context);

    final currentContext = contextProvider.currentContext;
    final selectedIndex = navProvider.selectedIndex;

    Widget _getScreen(BusinessType type, int tabIndex) {
      switch (type) {
        case BusinessType.restaurant:
          return _getRestaurantTab(tabIndex);
        case BusinessType.grocery:
          return _getGroceryTab(tabIndex);
        case BusinessType.marketplace:
          return _getMarketplaceTab(tabIndex);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(currentContext.name),
        actions: [
          // 🌐 Context Switcher Dropdown
          DropdownButton<String>(
            value: currentContext.name,
            onChanged: (val) {
              final newCtx = contextProvider.availableContexts.firstWhere(
                    (ctx) => ctx.name == val,
              );
              contextProvider.switchContext(newCtx);
              navProvider.resetIndex(); // Reset tab index when context changes
            },
            items: contextProvider.availableContexts
                .map(
                  (ctx) => DropdownMenuItem<String>(
                value: ctx.name,
                child: Text(ctx.name),
              ),
            )
                .toList(),
          ),

          const SizedBox(width: 12),

          // 🎨 Theme Switcher Dropdown
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return DropdownButton<ThemeModeType>(
                value: themeProvider.currentTheme,
                onChanged: (newTheme) {
                  if (newTheme != null) {
                    themeProvider.setTheme(newTheme);
                  }
                },
                dropdownColor: AppColors.black,
                icon: const Icon(Icons.color_lens, color: Colors.black),
                items: ThemeModeType.values.map((theme) {
                  return DropdownMenuItem(
                    value: theme,
                    child: Text(
                      theme.name.toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      bottomNavigationBar: const BottomNavbar(),
      body: _getScreen(currentContext.type, selectedIndex),
    );
  }

  // Add screen builders for each tab for each business type
  Widget _getRestaurantTab(int index) {
    switch (index) {
      case 0:
        return const Center(child: Text("Restaurant Menu"));
      case 1:
        return const Center(child: Text("Restaurant Reviews"));
      case 2:
        return const Center(child: Text("Restaurant Settings"));

      case 3:
        return const Center(child: Text("Restaurant Settings"));
      default:
        return const RestaurantScreen();
    }
  }

  Widget _getGroceryTab(int index) {
    switch (index) {
      case 0:
        return const Center(child: Text("Grocery Store"));
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
        return const Center(child: Text("Marketplace"));
      case 1:
        return const Center(child: Text("Wishlist"));
      case 2:
        return const Center(child: Text("Marketplace Settings"));
      default:
        return const MarketplaceScreen();
    }
  }
}

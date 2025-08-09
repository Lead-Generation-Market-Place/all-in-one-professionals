import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/features/mainHome/presentation/controllers/business_context_controller.dart';
import 'package:yelpax_pro/shared/services/bottom_navbar_notifier.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<BottomNavProvider>(context);
    final contextProvider = Provider.of<BusinessContextProvider>(context);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SafeArea(
            child: BottomNavigationBar(
              backgroundColor: theme.colorScheme.surface,
              currentIndex: navProvider.selectedIndex,
              onTap: (index) {
                navProvider.changeIndex(index);
                _navigateTo(context, contextProvider.currentContext.type, index);
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: theme.colorScheme.primary,
              unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
              selectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              elevation: 0,
              items: _buildItems(contextProvider.currentContext.type),
            ),
          ),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildItems(BusinessType businessType) {
    switch (businessType) {
      case BusinessType.restaurant:
        return [
          const BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
          const BottomNavigationBarItem(icon: Icon(Icons.reviews), label: 'Reviews'),
          const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ];
      case BusinessType.grocery:
        return [
          const BottomNavigationBarItem(icon: Icon(Icons.local_grocery_store), label: 'Store'),
          const BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ];
      case BusinessType.homeServices:
        return [
          const BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: 'Jobs'),
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          const BottomNavigationBarItem(icon: Icon(Icons.design_services), label: 'Services'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ];
    }
  }

// Update the _navigateTo method in BottomNavbar
  void _navigateTo(BuildContext context, BusinessType type, int index) {
    // Instead of pushing named routes, just update the selected index
    // The Home widget will handle displaying the correct screen
    final navProvider = Provider.of<BottomNavProvider>(context, listen: false);
    navProvider.changeIndex(index);

  }
}

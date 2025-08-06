import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';
import 'package:yelpax_pro/features/mainHome/presentation/controllers/business_context_controller.dart';
import 'package:yelpax_pro/shared/services/bottom_navbar_notifier.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<BottomNavProvider>(context);
    final contextProvider = Provider.of<BusinessContextProvider>(context);

    final businessType = contextProvider.currentContext.type;

    List<BottomNavigationBarItem> _buildItems(BusinessType businessType) {
      switch (businessType) {
        case BusinessType.restaurant:
          return [
            const BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              label: 'Menu',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.reviews),
              label: 'Reviews',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ];
        case BusinessType.grocery:
          return [
            const BottomNavigationBarItem(
              icon: Icon(Icons.local_grocery_store),
              label: 'Store',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ];
        case BusinessType.marketplace:
          return [
            const BottomNavigationBarItem(
              icon: Icon(Icons.work_outline), // Jobs
              label: 'Jobs',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search), // Search
              label: 'Search',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.design_services), // Services
              label: 'Services',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none), // Notifications
              label: 'Notifications',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), // Profile
              label: 'Profile',
            ),
          ];
      }
    }

    void _handleTabNavigation(BusinessType type, int index) {
      final navigator = Navigator.of(context);

      switch (type) {
        case BusinessType.restaurant:
          switch (index) {
            case 0:
              navigator.pushReplacementNamed('/restaurant/menu');
              break;
            case 1:
              navigator.pushReplacementNamed('/restaurant/reviews');
              break;
            case 2:
              navigator.pushReplacementNamed('/restaurant/settings');
              break;
          }
          break;
        case BusinessType.grocery:
          switch (index) {
            case 0:
              navigator.pushReplacementNamed('/grocery/store');
              break;
            case 1:
              navigator.pushReplacementNamed('/grocery/cart');
              break;
            case 2:
              navigator.pushReplacementNamed('/grocery/settings');
              break;
          }
          break;
        case BusinessType.marketplace:
          switch (index) {
            case 0:
              navigator.pushNamed(AppRouter.marketplaceJobs);
              break;
            case 1:
              navigator.pushNamed(AppRouter.marketplaceSearch);
              break;
            case 2:
              navigator.pushNamed(AppRouter.marketplaceServices);
              break;
            case 3:
              navigator.pushNamed(AppRouter.marketplaceNotifications);
              break;
            case 4:
              navigator.pushNamed(AppRouter.marketplaceProfile);
              break;
          }
          break;
      }
    }

    return Consumer<BusinessContextProvider>(
      builder: (context, contextProvider, _) {
        final businessType = contextProvider.currentContext.type;
        final theme = Theme.of(context);

        return Padding(
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
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
                    _handleTabNavigation(businessType, index);
                  },
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: theme.colorScheme.primary,
                  unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
                  selectedLabelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  elevation: 0,
                  items: _buildItems(businessType),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

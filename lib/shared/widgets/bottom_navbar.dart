import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yelpax_pro/features/mainHome/presentation/controllers/business_context_controller.dart';
import 'package:yelpax_pro/shared/services/bottom_navbar_notifier.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<BottomNavProvider>(context);
    final contextProvider = Provider.of<BusinessContextProvider>(context);
    final theme = Theme.of(context);

    // Determine if dark mode is active
    final bool isDark = theme.brightness == Brightness.dark;
    final Color backgroundColor = isDark ? Colors.black : Colors.white;
    final Color iconColor = isDark ? Colors.white : Colors.black;
    final Color selectedDotColor = theme.colorScheme.primary; // always primary

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SafeArea(
            child: BottomNavigationBar(
              backgroundColor: backgroundColor,
              currentIndex: navProvider.selectedIndex,
              onTap: (index) {
                navProvider.changeIndex(index);
                _navigateTo(
                  context,
                  contextProvider.currentContext.type,
                  index,
                );
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: iconColor,
              unselectedItemColor: iconColor.withOpacity(0.6),
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
              items: _buildItems(
                contextProvider.currentContext.type,
                navProvider.selectedIndex,
                iconColor,
                selectedDotColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconWithDot(
    IconData icon,
    bool isSelected,
    Color iconColor,
    Color dotColor,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon, color: iconColor),
        if (isSelected)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  List<BottomNavigationBarItem> _buildItems(
    BusinessType businessType,
    int selectedIndex,
    Color iconColor,
    Color selectedDotColor,
  ) {
    switch (businessType) {
      case BusinessType.restaurant:
        return [
          BottomNavigationBarItem(
            icon: _iconWithDot(
              Icons.restaurant_menu,
              selectedIndex == 0,
              iconColor,
              selectedDotColor,
            ),
            activeIcon: _iconWithDot(
              Icons.restaurant_menu,
              selectedIndex == 0,
              iconColor,
              selectedDotColor,
            ),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: _iconWithDot(
              Icons.reviews,
              selectedIndex == 1,
              iconColor,
              selectedDotColor,
            ),
            activeIcon: _iconWithDot(
              Icons.reviews,
              selectedIndex == 1,
              iconColor,
              selectedDotColor,
            ),
            label: 'Reviews',
          ),
          BottomNavigationBarItem(
            icon: _iconWithDot(
              Icons.settings,
              selectedIndex == 2,
              iconColor,
              selectedDotColor,
            ),
            activeIcon: _iconWithDot(
              Icons.settings,
              selectedIndex == 2,
              iconColor,
              selectedDotColor,
            ),
            label: 'Settings',
          ),
        ];
      case BusinessType.grocery:
        return [
          BottomNavigationBarItem(
            icon: _iconWithDot(
              Icons.local_grocery_store,
              selectedIndex == 0,
              iconColor,
              selectedDotColor,
            ),
            activeIcon: _iconWithDot(
              Icons.local_grocery_store,
              selectedIndex == 0,
              iconColor,
              selectedDotColor,
            ),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: _iconWithDot(
              Icons.shopping_cart,
              selectedIndex == 1,
              iconColor,
              selectedDotColor,
            ),
            activeIcon: _iconWithDot(
              Icons.shopping_cart,
              selectedIndex == 1,
              iconColor,
              selectedDotColor,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: _iconWithDot(
              Icons.settings,
              selectedIndex == 2,
              iconColor,
              selectedDotColor,
            ),
            activeIcon: _iconWithDot(
              Icons.settings,
              selectedIndex == 2,
              iconColor,
              selectedDotColor,
            ),
            label: 'Settings',
          ),
        ];
      case BusinessType.homeServices:
        return [
          BottomNavigationBarItem(
            icon: _iconWithDot(
              Icons.work_outline,
              selectedIndex == 0,
              iconColor,
              selectedDotColor,
            ),
            activeIcon: _iconWithDot(
              Icons.work,
              selectedIndex == 0,
              iconColor,
              selectedDotColor,
            ),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: _iconWithDot(
              Icons.search_outlined,
              selectedIndex == 1,
              iconColor,
              selectedDotColor,
            ),
            activeIcon: _iconWithDot(
              Icons.search,
              selectedIndex == 1,
              iconColor,
              selectedDotColor,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: _iconWithDot(
              Icons.miscellaneous_services_outlined,
              selectedIndex == 2,
              iconColor,
              selectedDotColor,
            ),
            activeIcon: _iconWithDot(
              Icons.miscellaneous_services,
              selectedIndex == 2,
              iconColor,
              selectedDotColor,
            ),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: _iconWithDot(
              Icons.person_outline,
              selectedIndex == 3,
              iconColor,
              selectedDotColor,
            ),
            activeIcon: _iconWithDot(
              Icons.person,
              selectedIndex == 3,
              iconColor,
              selectedDotColor,
            ),
            label: 'Profile',
          ),
        ];
    }
  }

  void _navigateTo(BuildContext context, BusinessType type, int index) {
    final navProvider = Provider.of<BottomNavProvider>(context, listen: false);
    navProvider.changeIndex(index);
  }
}

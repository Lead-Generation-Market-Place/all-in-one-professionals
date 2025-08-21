import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
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
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(isDark ? 0.6 : 0.85),
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withOpacity(0.06),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.35)
                      : Colors.grey.withOpacity(0.12),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SafeArea(
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                currentIndex: navProvider.selectedIndex,
                onTap: (index) {
                  HapticFeedback.lightImpact();
                  navProvider.changeIndex(index);
                  _navigateTo(
                    context,
                    contextProvider.currentContext.type,
                    index,
                  );
                },
                selectedItemColor: iconColor,
                unselectedItemColor: iconColor.withOpacity(0.6),
                selectedIconTheme: const IconThemeData(size: 26),
                unselectedIconTheme: const IconThemeData(size: 22),
                selectedLabelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                showSelectedLabels: true,
                showUnselectedLabels: true,
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
      ),
    );
  }

  Widget _iconWithDot(
    IconData icon,
    bool isSelected,
    Color iconColor,
    Color dotColor,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: EdgeInsets.symmetric(
        horizontal: isSelected ? 12 : 0,
        vertical: isSelected ? 8 : 0,
      ),
      decoration: isSelected
          ? BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  dotColor.withOpacity(0.22),
                  dotColor.withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            )
          : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: isSelected ? 1.08 : 1.0,
            curve: Curves.easeOut,
            child: Icon(icon, color: iconColor),
          ),
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
      ),
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

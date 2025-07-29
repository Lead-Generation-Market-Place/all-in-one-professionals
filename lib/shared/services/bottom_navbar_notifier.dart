// providers/bottom_nav_provider.dart
import 'package:flutter/material.dart';

class BottomNavProvider with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void changeIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void resetIndex() {
    _selectedIndex = 0;
    notifyListeners();
  }
}

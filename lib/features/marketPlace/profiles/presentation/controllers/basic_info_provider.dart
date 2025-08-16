import 'package:flutter/material.dart';

class BasicInfoProvider extends ChangeNotifier {
  String imageUrl = '';
  bool _isLoading = false;
  bool get isLoading => _isLoading;


  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final TextEditingController businessNameController = TextEditingController();

  Future<void> addBasicInfo() async {
    try {
      isLoading = true;
    } catch (e) {
    } finally {
      isLoading = false;
    }
  }
}

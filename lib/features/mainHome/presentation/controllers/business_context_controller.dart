// providers/business_context_provider.dart
import 'package:flutter/material.dart';


class BusinessContextProvider extends ChangeNotifier {
  BusinessContext _currentContext = BusinessContext(
    name: "Restaurant",
    type: BusinessType.restaurant,
  );

  final List<BusinessContext> _availableContexts = [
    BusinessContext(name: "Restaurant", type: BusinessType.restaurant),
    BusinessContext(name: "Grocery", type: BusinessType.grocery),
    BusinessContext(name: "Marketplace", type: BusinessType.marketplace),
  ];

  BusinessContext get currentContext => _currentContext;
  List<BusinessContext> get availableContexts => _availableContexts;

  void switchContext(BusinessContext newContext) {
    _currentContext = newContext;
    notifyListeners();
  }
}

enum BusinessType { restaurant, grocery, marketplace }

class BusinessContext {
  final String name;
  final BusinessType type;

  BusinessContext({required this.name, required this.type});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessContext &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type;

  @override
  int get hashCode => name.hashCode ^ type.hashCode;

  @override
  String toString() => 'BusinessContext(name: $name, type: $type)';
}

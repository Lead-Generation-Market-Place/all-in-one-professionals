// features/marketPlace/service/presentation/models/budget_model.dart
class BudgetModel {
  final bool limitBudget;
  final double? weeklyBudget;
  final PaymentInfo? paymentInfo;
  final String pricingType;

  BudgetModel({required this.limitBudget, this.weeklyBudget, this.paymentInfo})
    : pricingType = limitBudget ? 'limited' : 'fixed';

  Map<String, dynamic> toJson() {
    return {
      'limit_budget': limitBudget,
      'weekly_budget': weeklyBudget,
      'pricing_type': pricingType,
      'payment_info': paymentInfo?.toJson(),
    };
  }

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      limitBudget: json['limit_budget'] ?? false,
      weeklyBudget: json['weekly_budget']?.toDouble(),
      paymentInfo: json['payment_info'] != null
          ? PaymentInfo.fromJson(json['payment_info'])
          : null,
    );
  }

  BudgetModel copyWith({
    bool? limitBudget,
    double? weeklyBudget,
    PaymentInfo? paymentInfo,
  }) {
    return BudgetModel(
      limitBudget: limitBudget ?? this.limitBudget,
      weeklyBudget: weeklyBudget ?? this.weeklyBudget,
      paymentInfo: paymentInfo ?? this.paymentInfo,
    );
  }
}

class PaymentInfo {
  final String fullName;
  final String cardNumber;
  final String expiryDate;
  final String cvv;

  PaymentInfo({
    required this.fullName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'card_number': cardNumber,
      'expiry_date': expiryDate,
      'cvv': cvv,
    };
  }

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      fullName: json['full_name'] ?? '',
      cardNumber: json['card_number'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
      cvv: json['cvv'] ?? '',
    );
  }

  PaymentInfo copyWith({
    String? fullName,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
  }) {
    return PaymentInfo(
      fullName: fullName ?? this.fullName,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
    );
  }

  // Validation methods
  bool get isValid {
    return fullName.isNotEmpty &&
        cardNumber.isNotEmpty &&
        expiryDate.isNotEmpty &&
        cvv.isNotEmpty;
  }

  String? validateCardNumber() {
    if (cardNumber.isEmpty) return 'Card number is required';
    if (cardNumber.length < 16) return 'Card number must be 16 digits';
    return null;
  }

  String? validateExpiryDate() {
    if (expiryDate.isEmpty) return 'Expiry date is required';
    // Add more validation logic for MM/YY format
    return null;
  }

  String? validateCVV() {
    if (cvv.isEmpty) return 'CVV is required';
    if (cvv.length < 3) return 'CVV must be 3 digits';
    return null;
  }
}

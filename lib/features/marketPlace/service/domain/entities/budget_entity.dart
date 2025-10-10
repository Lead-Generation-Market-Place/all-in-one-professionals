class BudgetEntity {
  final bool limitBudget;
  final double? weeklyBudget;
  final PaymentInfoEntity? paymentInfo;
  final String pricingType;

  BudgetEntity({
    required this.limitBudget,
    this.weeklyBudget,
    this.paymentInfo,
  }) : pricingType = limitBudget ? 'limited' : 'fixed';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BudgetEntity &&
        other.limitBudget == limitBudget &&
        other.weeklyBudget == weeklyBudget &&
        other.paymentInfo == paymentInfo &&
        other.pricingType == pricingType;
  }

  @override
  int get hashCode {
    return Object.hash(
      limitBudget,
      weeklyBudget,
      paymentInfo,
      pricingType,
    );
  }

  BudgetEntity copyWith({
    bool? limitBudget,
    double? weeklyBudget,
    PaymentInfoEntity? paymentInfo,
  }) {
    return BudgetEntity(
      limitBudget: limitBudget ?? this.limitBudget,
      weeklyBudget: weeklyBudget ?? this.weeklyBudget,
      paymentInfo: paymentInfo ?? this.paymentInfo,
    );
  }
}

class PaymentInfoEntity {
  final String fullName;
  final String cardNumber;
  final String expiryDate;
  final String cvv;

  PaymentInfoEntity({
    required this.fullName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentInfoEntity &&
        other.fullName == fullName &&
        other.cardNumber == cardNumber &&
        other.expiryDate == expiryDate &&
        other.cvv == cvv;
  }

  @override
  int get hashCode {
    return Object.hash(
      fullName,
      cardNumber,
      expiryDate,
      cvv,
    );
  }

  PaymentInfoEntity copyWith({
    String? fullName,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
  }) {
    return PaymentInfoEntity(
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

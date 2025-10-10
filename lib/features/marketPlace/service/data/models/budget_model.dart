import '../../domain/entities/budget_entity.dart';

class BudgetModel extends BudgetEntity {
  BudgetModel({
    required super.limitBudget,
    super.weeklyBudget,
    super.paymentInfo,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      limitBudget: json['limit_budget'] ?? false,
      weeklyBudget: json['weekly_budget']?.toDouble(),
      paymentInfo: json['payment_info'] != null
          ? PaymentInfoModel.fromJson(json['payment_info'])
          : null,
    );
  }

  factory BudgetModel.fromEntity(BudgetEntity entity) {
    return BudgetModel(
      limitBudget: entity.limitBudget,
      weeklyBudget: entity.weeklyBudget,
      paymentInfo: entity.paymentInfo != null
          ? PaymentInfoModel.fromEntity(entity.paymentInfo!)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'limit_budget': limitBudget,
      'weekly_budget': weeklyBudget,
      'pricing_type': pricingType,
      'payment_info': paymentInfo != null
          ? (paymentInfo as PaymentInfoModel).toJson()
          : null,
    };
  }
}

class PaymentInfoModel extends PaymentInfoEntity {
  PaymentInfoModel({
    required super.fullName,
    required super.cardNumber,
    required super.expiryDate,
    required super.cvv,
  });

  factory PaymentInfoModel.fromJson(Map<String, dynamic> json) {
    return PaymentInfoModel(
      fullName: json['full_name'] ?? '',
      cardNumber: json['card_number'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
      cvv: json['cvv'] ?? '',
    );
  }

  factory PaymentInfoModel.fromEntity(PaymentInfoEntity entity) {
    return PaymentInfoModel(
      fullName: entity.fullName,
      cardNumber: entity.cardNumber,
      expiryDate: entity.expiryDate,
      cvv: entity.cvv,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'card_number': cardNumber,
      'expiry_date': expiryDate,
      'cvv': cvv,
    };
  }
}

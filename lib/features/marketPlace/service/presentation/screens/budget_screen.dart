import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/controllers/service_controller.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/budget_entity.dart';
import 'package:yelpax_pro/shared/widgets/custom_input.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TextEditingController creditController = TextEditingController(
    text: '20',
  );
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  bool limitBudget = false;
  bool isNextLoading = false;

  @override
  void dispose() {
    creditController.dispose();
    fullNameController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  void _onDoNotLimitPressed() {
    setState(() {
      limitBudget = false;
    });

    // Create budget data without limits
    final budgetData = BudgetEntity(
      limitBudget: false,
      weeklyBudget: null,
      paymentInfo: null,
    );

    // Update controller FIRST
    final controller = context.read<ServiceController>();
    controller.updateBudgetData(budgetData);

    // THEN submit
    _submitRegistration(controller);
  }

  void _onLimitPressed() {
    setState(() {
      limitBudget = true;
    });
  }

  void _onConfirmPayment() {
    if (!_validatePaymentInfo()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all payment fields correctly'),
        ),
      );
      return;
    }

    // Create payment info
    final paymentInfo = PaymentInfoEntity(
      fullName: fullNameController.text.trim(),
      cardNumber: cardNumberController.text.trim(),
      expiryDate: expiryDateController.text.trim(),
      cvv: cvvController.text.trim(),
    );

    // Create budget data with limits
    final budgetData = BudgetEntity(
      limitBudget: true,
      weeklyBudget: double.tryParse(creditController.text) ?? 20.0,
      paymentInfo: paymentInfo,
    );

    // Update controller FIRST
    final controller = context.read<ServiceController>();
    controller.updateBudgetData(budgetData);

    // THEN submit
    _submitRegistration(controller);
  }

  bool _validatePaymentInfo() {
    return fullNameController.text.trim().isNotEmpty &&
        cardNumberController.text.trim().isNotEmpty &&
        expiryDateController.text.trim().isNotEmpty &&
        cvvController.text.trim().isNotEmpty;
  }

  Future<void> _submitRegistration(ServiceController controller) async {
    setState(() {
      isNextLoading = true;
    });

    try {
      final success = await controller.submitCompleteRegistration();

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Service registered successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to success screen or dashboard
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/success', // Replace with your success route
          (route) => false,
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to register service. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isNextLoading = false;
        });
      }
    }
  }

  Widget _buildPaymentCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Information',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.lock, color: Colors.green, size: 18),
                SizedBox(width: 6),
                Text(
                  '256-bit SSL Encryption',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'PCI DSS Compliant',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              'Your payment information is processed securely. We do not store your credit card details.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 20),

            // Input Fields
            CustomInputField(
              controller: fullNameController,
              hintText: 'Full Name',
              inputType: TextInputType.name,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            CustomInputField(
              controller: cardNumberController,
              hintText: 'Card Number',
              inputType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: CustomInputField(
                    controller: expiryDateController,
                    hintText: 'Expiry Date (MM/YY)',
                    inputType: TextInputType.datetime,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomInputField(
                    controller: cvvController,
                    hintText: 'CVV',
                    inputType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isNextLoading ? null : _onConfirmPayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isNextLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Complete Registration'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoLimitConfirmation() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.credit_card_off, size: 48, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              'No Budget Limit Set',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'You will receive all leads that match your service criteria without spending limits.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isNextLoading ? null : _onDoNotLimitPressed,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isNextLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Complete Registration'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Registration'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose how to budget your spending',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your budget helps determine how many leads you will get. Update your budget anytime.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 30),

            // Do Not Limit Budget Button
            ElevatedButton(
              onPressed: _onDoNotLimitPressed,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: limitBudget
                    ? Colors.grey[400]
                    : Colors.blueGrey[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Do not limit my budget',
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 8),
            Text(
              'This allows you to get all the leads that fit your exact job preferences. You can always change this later.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 32),

            // Limit Budget Button
            ElevatedButton(
              onPressed: _onLimitPressed,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: limitBudget
                    ? theme.colorScheme.primary
                    : Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Limit my budget',
                style: TextStyle(
                  color: limitBudget ? Colors.white : Colors.grey[600],
                ),
              ),
            ),

            const SizedBox(height: 8),
            Text(
              'Set a limit on how much you will spend per week.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
            ),

            if (limitBudget) ...[
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomInputField(
                  controller: creditController,
                  hintText: 'Credits (weekly budget)',
                  inputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Show appropriate confirmation card
            if (limitBudget)
              _buildPaymentCard()
            else
              _buildNoLimitConfirmation(),
          ],
        ),
      ),
    );
  }
}

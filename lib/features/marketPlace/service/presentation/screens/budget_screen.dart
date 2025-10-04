import 'package:flutter/material.dart';
import 'package:yelpax_pro/shared/widgets/custom_input.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen>
    with SingleTickerProviderStateMixin {
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
      limitBudget = false; // Hide payment inputs and credit input
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Proceeding without budget limit')),
    );
  }

  void _onLimitPressed() {
    setState(() {
      limitBudget = true; // Show payment inputs and credit input
    });
  }

  void _onConfirmPayment() {
    // Implement your validation and payment logic here
    setState(() {
      isNextLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isNextLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Payment info submitted')));
    });
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
            // Header with security info
            Text(
              'Payment Information',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Column(
              children: const [
                Icon(Icons.lock, color: Colors.green, size: 18),
                SizedBox(width: 6),
                Text(
                  '256-bit SSL Encryption',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'PCI DSS Compliant',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            const Text(
              'Your payment information is processed securely. We do not store your credit card details.',
              style: TextStyle(color: Colors.grey),
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
                    : const Text('Confirm Payment'),
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
      appBar: AppBar(title: const Text('Payment'), centerTitle: true),
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

            ElevatedButton(
              onPressed: _onDoNotLimitPressed,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: limitBudget
                    ? Colors.grey[400]
                    : Colors.blueGrey[700], // Visual toggle
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Do not limit my budget'),
            ),

            const SizedBox(height: 8),
            Text(
              'This allows you to get all the leads that fit your exact job preferences. You can always change this later.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 32),

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
              child: const Text('Limit my budget'),
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
              _buildPaymentCard(),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';
import 'package:yelpax_pro/shared/widgets/custom_input.dart';

class CardDetails extends StatefulWidget {
  const CardDetails({super.key});

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  bool isLoading = false;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Simulate loading
      setState(() => isLoading = true);
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => isLoading = false);
        Navigator.pushNamed(context, '/step11'); // Navigate to step 11
      });
    }
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Payment",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                // Full Name
                CustomInputField(
                  label: 'Full name',
                  hintText: 'Full name*',
                  validator: (value) =>
                      value!.isEmpty ? 'Full name is required' : null,
                ),

                const SizedBox(height: 16),
                // Card Number
                CustomInputField(
                  label: 'Card number*',
                  hintText: 'xxxx-xxxx-xxxx-xxxx',
                  validator: (value) =>
                      value!.isEmpty ? 'Card name is required' : null,
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    // Expiration
                    Expanded(
                      child: CustomInputField(
                        label: 'Expiration*',
                        hintText: 'Expiration*',
                        validator: (value) => value!.isEmpty
                            ? 'Expiration name is required'
                            : null,
                      ),
                    ),

                    const SizedBox(width: 16),
                    // CVV
                    Expanded(
                      child: CustomInputField(
                        label: 'CVV*',
                        hintText: 'CVV*',
                        validator: (value) =>
                            value!.isEmpty ? 'CVV name is required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomButton(text: 'Pay Now', onPressed: () {}),
                const SizedBox(height: 30),
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: _goBack,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text("Back"),
                    ),
                    CustomButton(text: 'Next', enabled: true, onPressed: () {}),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF374151)
          : Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide.none,
      ),
      labelStyle: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : Colors.black87,
        fontSize: 14,
      ),
      hintStyle: const TextStyle(fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

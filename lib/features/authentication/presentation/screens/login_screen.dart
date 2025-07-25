
import 'package:flutter/material.dart';

import 'package:yelpax_pro/core/constants/app_colors.dart';

import 'package:yelpax_pro/shared/widgets/custom_button.dart';
import 'package:yelpax_pro/shared/widgets/custom_flutter_toast.dart';
import 'package:yelpax_pro/shared/widgets/custom_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  final List<String> _countries = ['United States', 'Canada', 'UK'];
  String? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),

            /// Logo
            Center(
              child: Image.asset(
                'assets/images/y_logo.png',
                width: 100,
                height: 80,
              ),
            ),

            const SizedBox(height: 32),

            /// Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      /// Email
                      CustomInputField(
                        label: 'Email Address',
                        hintText: 'Enter your email',
                        controller: _emailController,
                        inputType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      /// Password
                      CustomInputField(
                        label: 'Password',
                        hintText: 'Enter your password',
                        isPassword: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      /// Country Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          // color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.neutral200),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedCountry ?? _countries.first,
                          items: _countries.map((country) {
                            return DropdownMenuItem<String>(
                              value: country,
                              child: Text(country),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _selectedCountry = value!;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// Login Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: 'Log In',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              Navigator.of(context).pushReplacementNamed('/home');
                              // Uncomment this to use actual login flow
                              // await context.read<AuthUserController>().login(
                              //   email: _emailController.text,
                              //   password: _passwordController.text,
                              //   onSuccess: () => Navigator.of(context).pushReplacementNamed('/home'),
                              //   onFailure: () => Navigator.of(context).pushReplacementNamed('/login'),
                              // );
                            }
                          },
                          isLoading: _isLoading,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// Forgot / Need Help Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(color: AppColors.primaryBlue),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Need help?',
                              style: TextStyle(color: AppColors.primaryBlue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Footer Links
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      CustomFlutterToast.showInfoToast(context, 'Coming Soon..');
                    },
                    child: Text(
                      'Want to Shop on Groupon?',
                      style: TextStyle(color: AppColors.primaryBlue),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      CustomFlutterToast.showInfoToast(context, 'Coming Soon..');
                    },
                    child: Text(
                      'Get the Groupon app.',
                      style: TextStyle(color: AppColors.primaryBlue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';
import 'package:yelpax_pro/features/authentication/presentation/widgets/forgot_password.dart';
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
  bool _isButtonEnabled = false;

  final List<String> _countries = ['United States', 'Canada', 'UK'];
  String? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final email = _emailController.text;
    final password = _passwordController.text;

    final isEmailValid = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email);
    final isPasswordValid = password.length >= 8;
    final isCountrySelected = _selectedCountry != null;

    setState(() {
      _isButtonEnabled = isEmailValid && isPasswordValid && isCountrySelected;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

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
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      /// Country Dropdown
                      /// Country Dropdown
                      CustomDropdown<String>(
                        decoration: CustomDropdownDecoration(
                          closedFillColor: Theme.of(context).highlightColor,
                          expandedFillColor: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        hintText: 'Select a Country',
                        items: _countries,
                        initialItem: _selectedCountry,
                        onChanged: (value) {
                          setState(() {
                            _selectedCountry = value;
                          });
                          _validateForm();
                        },
                      ),


                      const SizedBox(height: 24),

                      /// Login Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: 'Log In',
                          onPressed: _isButtonEnabled
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => _isLoading = true);
                                    // Simulated login logic
                                    await Future.delayed(
                                      const Duration(seconds: 1),
                                    );
                                    setState(() => _isLoading = false);
                                    Navigator.of(
                                      context,
                                    ).pushReplacementNamed(AppRouter.businessCategorySelectionScreen);
                                  }
                                }
                              : null,
                          isLoading: _isLoading,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// Forgot / Need Help Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) =>
                                    ForgotPasswordBottomSheet(),
                              );
                            },
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(color: Colors.black),
                            ),

                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRouter.signUpAsProfessional,
                              );
                            },
                            child: Text(
                              'Sign Up as Professional',
                              style: TextStyle(color: Colors.black),
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
                      CustomFlutterToast.showInfoToast(
                        context,
                        'Coming Soon..',
                      );
                    },
                    child: Text(
                      'Want to Shop on Groupon?',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      CustomFlutterToast.showInfoToast(
                        context,
                        'Coming Soon..',
                      );
                    },
                    child: Text(
                      'Get the Groupon app.',
                      style: TextStyle(color: Colors.black),
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

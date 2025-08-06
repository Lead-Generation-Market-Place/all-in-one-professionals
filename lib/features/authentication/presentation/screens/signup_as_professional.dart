import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';
import 'package:yelpax_pro/shared/widgets/custom_input.dart';

class Countries {
  final int id;
  final String countryName;
  Countries({required this.id, required this.countryName});
}

class Categories {
  final int id;
  final String categoryName;
  Categories({required this.id, required this.categoryName});
}

class SignupAsProfessional extends StatefulWidget {
  const SignupAsProfessional({super.key});

  @override
  State<SignupAsProfessional> createState() => _SignupAsProfessionalState();
}

class _SignupAsProfessionalState extends State<SignupAsProfessional> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final _formKey = GlobalKey<FormState>();

  // Business Info Controllers
  final _businessNameController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _socialMediaController = TextEditingController();
  final _postalCodeController = TextEditingController();

  // Personal Info Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  List<Countries> countriesList = [
    Countries(id: 1, countryName: 'Afghanistan'),
    Countries(id: 2, countryName: 'United States'),
    Countries(id: 3, countryName: 'Canada'),
    Countries(id: 4, countryName: 'Australia'),
    Countries(id: 5, countryName: 'India'),
  ];

  List<Categories> categoriesList = [
    Categories(id: 1, categoryName: 'Home Services'),
    Categories(id: 2, categoryName: 'Restaurant'),
    Categories(id: 3, categoryName: 'IT Services'),
    Categories(id: 4, categoryName: 'Shopping'),
    Categories(id: 5, categoryName: 'Deals'),
  ];

  int? selectedCountryId;
  int? selectedCategoryId;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _businessNameController.dispose();
    _streetAddressController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    _socialMediaController.dispose();
    _postalCodeController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final countriesName = countriesList.map((e) => e.countryName).toList();
    final categoryName = categoriesList.map((e) => e.categoryName).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Professional Signup',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,

          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, AppRouter.login),
        ),

        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                // Progress indicator
                LinearProgressIndicator(
                  value: (_currentPage + 1) / 2,

                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.black),
                  minHeight: 6,
                ),
                const SizedBox(height: 10),

                // Page indicator
                Text(
                  'Step ${_currentPage + 1} of 2',
                  style: const TextStyle(

                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildStepOne(countriesName, categoryName),
                      _buildStepTwo(),
                    ],
                  ),
                ),

                // Navigation buttons
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage > 0)
                        OutlinedButton(
                          onPressed: () => _goToPreviousPage(),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(120, 50),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Back',
                            style: TextStyle(

                              fontSize: 16,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 120), // Placeholder for alignment
                      CustomButton(
                        text: '${_currentPage == 1 ? "Submit" : "Next"}',
                        enabled: true,
                        onPressed: _isSubmitting
                            ? null
                            : () => _handleNavigation(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepOne(List<String> countriesName, List<String> categoryName) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 30),
            child: Text(
              'Business Information',
              style: TextStyle(

                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          CustomInputField(
            controller: _businessNameController,
            label: 'Business Name',
            hintText: 'Enter your business name',
            prefixIcon: Icons.business,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Business name is required';
              }
              if (value.length < 3) {
                return 'Business name too short';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Country Dropdown
          const Text(
            'Country',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,

            ),
          ),
          const SizedBox(height: 8),
          CustomDropdown.search(
            hintText: 'Select your country',
            items: countriesName,
            initialItem: selectedCountryId != null
                ? countriesList
                      .firstWhere((c) => c.id == selectedCountryId)
                      .countryName
                : null,
            onChanged: (selectedName) {
              final selectedCountry = countriesList.firstWhere(
                (c) => c.countryName == selectedName,
              );
              setState(() {
                selectedCountryId = selectedCountry.id;
              });
              Logger().i(
                'Selected Country id: ${selectedCountry.id}, Country Name: ${selectedCountry.countryName}',
              );
            },
            decoration: CustomDropdownDecoration(
              searchFieldDecoration: SearchFieldDecoration(fillColor: Theme.of(context).colorScheme.surface),
              closedFillColor: Theme.of(context).highlightColor,
              expandedFillColor: Theme.of(
                context,
              ).scaffoldBackgroundColor,
            ),
            validator: (value) {
              if (selectedCountryId == null) {
                return 'Please select a country';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Business Type Dropdown
          const Text(
            'Business Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,

            ),
          ),
          const SizedBox(height: 8),
          CustomDropdown.search(
            decoration: CustomDropdownDecoration(
              searchFieldDecoration: SearchFieldDecoration(fillColor: Theme.of(context).colorScheme.surface),
              closedFillColor: Theme.of(context).highlightColor,
              expandedFillColor: Theme.of(
                context,
              ).scaffoldBackgroundColor,
            ),
            hintText: 'Select your business type',
            items: categoryName,
            initialItem: selectedCategoryId != null
                ? categoriesList
                      .firstWhere((c) => c.id == selectedCategoryId)
                      .categoryName
                : null,
            onChanged: (selectedName) {
              final selectedCategory = categoriesList.firstWhere(
                (c) => c.categoryName == selectedName,
              );
              setState(() {
                selectedCategoryId = selectedCategory.id;
              });
              Logger().i(
                'Selected Category id: ${selectedCategory.id}, Category Name: ${selectedCategory.categoryName}',
              );
            },

            validator: (value) {
              if (selectedCategoryId == null) {
                return 'Please select a business type';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          CustomInputField(
            controller: _streetAddressController,
            label: 'Street Address',
            hintText: 'Enter your business address',
            prefixIcon: Icons.location_on,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Address is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomInputField(
                  controller: _cityController,
                  label: 'City',
                  hintText: 'City',
                  prefixIcon: Icons.location_city,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'City is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: CustomInputField(
                  controller: _zipCodeController,
                  label: 'ZIP Code',
                  hintText: 'ZIP',
                  prefixIcon: Icons.numbers,
                  inputType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'ZIP code is required';
                    }
                    if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return 'Enter valid ZIP code';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          CustomInputField(
            controller: _socialMediaController,
            label: 'Social Media (Optional)',
            hintText: 'e.g., instagram.com/yourbusiness',
            prefixIcon: Icons.link,
          ),
          const SizedBox(height: 20),

          CustomInputField(
            controller: _postalCodeController,
            label: 'Postal Code (Optional)',
            hintText: 'Enter postal code if different',
            prefixIcon: Icons.markunread_mailbox,
            inputType: TextInputType.number,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStepTwo() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 30),
            child: Text(
              'Personal Information',
              style: TextStyle(

                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Center(
            child: Image.asset(
              'assets/images/signup.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(
                child: CustomInputField(
                  controller: _firstNameController,
                  label: 'First Name',
                  hintText: 'Enter your first name',
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'First name is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: CustomInputField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  hintText: 'Enter your last name',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Last name is required';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          CustomInputField(
            controller: _emailController,
            label: 'Email Address',
            hintText: 'Enter your email',
            prefixIcon: Icons.email,
            inputType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Terms and conditions checkbox
          Row(
            children: [
              Checkbox(
                value: true, // You should manage this state properly
                onChanged: (value) {},

              ),
              const Expanded(
                child: Text(
                  'I agree to the Terms of Service and Privacy Policy',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _goToPreviousPage() {
    setState(() {
      _currentPage--;
    });
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _handleNavigation() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_currentPage < 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      _submitForm();
    }
  }

  void _submitForm() {
    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isSubmitting = false;
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success!'),
          content: const Text(
            'Your professional account has been created successfully.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pushNamed(
                  context,
                  AppRouter.login,
                ); // Redirect to login
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

      Logger().i("Form submitted successfully");
    });
  }
}

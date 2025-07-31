import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/controllers/profile_provider.dart';
import 'package:yelpax_pro/shared/widgets/bottom_navbar.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';
import 'package:yelpax_pro/shared/widgets/custom_input.dart';

class BusinessInfo extends StatelessWidget {
  BusinessInfo({super.key});
  final _formKeyBusinessInfo = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isSetupFinished = false;
    int stepNumber = 2;
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: const BottomNavbar(),
        body: Column(
          children: [
            // Black label banner
            if (!isSetupFinished) _buildProfileCompletionBanner(),
            // AppBar-like container with elevation
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Business Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),

                  CustomButton(
                    text: 'Save',
                    onPressed: () {
                      if (_formKeyBusinessInfo.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Save'),
                            content: const Text(
                              'Are you sure you want to save your business information?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context); // Close dialog
                                  await profileProvider.saveBusinessInfo();
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewPadding.bottom + 80,
                  left: 16,
                  right: 16,
                ),
                child: Form(
                  key: _formKeyBusinessInfo,
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'About your business',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      CustomInputField(
                        controller: profileProvider.yearFoundedController,
                        label: 'Year Founded',
                        hintText: '2000',
                        inputType: TextInputType.number,
                        
                      ),
                      const SizedBox(height: 24),

                      CustomInputField(
                        controller: profileProvider.employeesController,
                        label: 'Number of employees',
                        hintText: '5',
                        inputType: TextInputType.number,
                      ),
                      const SizedBox(height: 32),

                      const Text(
                        'Contact information',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      CustomInputField(
                        controller: profileProvider.phoneController,
                        label: 'Phone number',
                        hintText: '(202) 590-4857',
                        inputType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      CustomInputField(
                        controller: profileProvider.addressController,
                        label: 'Address',
                        hintText: '5601 Seminary',
                        inputType: TextInputType.text,
                      ),
                      const SizedBox(height: 16),

                      CustomInputField(
                        controller: profileProvider.suiteController,
                        label: 'Suite/Apt',
                        hintText: '2026N',
                        inputType: TextInputType.text,
                      ),
                      const SizedBox(height: 16),

                      CustomInputField(
                        controller: profileProvider.zipCodeController,
                        label: 'Zip code',
                        hintText: '22041',
                        inputType: TextInputType.number,
                        validator: (value) =>
                            value!.isEmpty ? 'Zip code is required' : null,
                      ),
                      const SizedBox(height: 16),

                      CustomInputField(
                        controller: profileProvider.websiteController,
                        label: 'Website',
                        inputType: TextInputType.url,
                        hintText: 'Website',
                      ),
                      const SizedBox(height: 32),

                      const Text(
                        'Payment methods accepted',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Consumer<ProfileProvider>(
                        builder: (context, provider, child) {
                          return Column(
                            children: provider.availablePaymentMethods.map((
                              method,
                            ) {
                              return CheckboxListTile(
                                title: Text(method),
                                value: provider.selectedPaymentMethods.contains(
                                  method,
                                ),
                                onChanged: (bool? value) {
                                  provider.togglePaymentMethod(method);
                                },
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 32),

                      const Text(
                        'Social media',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      CustomInputField(
                        controller: profileProvider.facebookController,
                        label: 'Facebook',
                        inputType: TextInputType.text,
                        hintText: 'http://facebook.com',
                      ),
                      const SizedBox(height: 16),

                      CustomInputField(
                        controller: profileProvider.twitterController,
                        label: 'Twitter',
                        hintText: 'http://twitter.com',
                      ),
                      const SizedBox(height: 16),

                      CustomInputField(
                        controller: profileProvider.instagramController,
                        label: 'Instagram',
                        hintText: 'http://instagram.com',
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCompletionBanner() {
    return Container(
      color: AppColors.black,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wrap the Text with Flexible to allow wrapping
          Flexible(
            child:
                // Replace your static Text widget with:
                Selector<ProfileProvider, int>(
                  selector: (_, provider) => provider.stepNumber,
                  builder: (context, stepnumber, child) {
                    return Text(
                      'Only $stepnumber setup tasks left before you can start getting leads.',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      softWrap: true,
                      maxLines: 2, // Optional: limit to 2 lines
                      overflow: TextOverflow
                          .ellipsis, // Optional: fade or ellipsis if too long
                    );
                  },
                ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Finish Setup'),
          ),
        ],
      ),
    );
  }
}

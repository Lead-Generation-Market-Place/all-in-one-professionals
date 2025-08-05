import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/presentation/widgets/finish_setup.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/controllers/profile_provider.dart';
import 'package:yelpax_pro/shared/widgets/bottom_navbar.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';
import 'package:yelpax_pro/shared/widgets/custom_input.dart';

class BusinessInfo extends StatelessWidget {
  BusinessInfo({super.key});
  final _formKeyBusinessInfo = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isSetupFinished = false;

    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: const BottomNavbar(),
        body: Column(
          children: [
            if (!isSetupFinished)
              ProfileCompletionBanner(
                stepNumber: 3,
                onFinishSetupPressed: () {
                  Navigator.pushNamed(context, AppRouter.signUpProcessScreen);
                },
              ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
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
                        icon: Icon(
                          Icons.arrow_back,
                          color: theme.iconTheme.color,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Business Information',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
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
                            backgroundColor: theme.cardTheme.color,
                            title: Text(
                              'Confirm Save',
                              style: theme.textTheme.titleMedium,
                            ),
                            content: Text(
                              'Are you sure you want to save your business information?',
                              style: theme.textTheme.bodyMedium,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'No',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await profileProvider.saveBusinessInfo();
                                },
                                child: Text(
                                  'Yes',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
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
                      Text(
                        'About your business',
                        style: theme.textTheme.headlineSmall?.copyWith(
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

                      Text(
                        'Contact information',
                        style: theme.textTheme.headlineSmall?.copyWith(
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

                      Text(
                        'Payment methods accepted',
                        style: theme.textTheme.headlineSmall?.copyWith(
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
                                title: Text(
                                  method,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                value: provider.selectedPaymentMethods.contains(
                                  method,
                                ),
                                onChanged: (bool? value) {
                                  provider.togglePaymentMethod(method);
                                },
                                activeColor: theme.colorScheme.primary,
                                checkColor: theme.colorScheme.onPrimary,
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 32),

                      Text(
                        'Social media',
                        style: theme.textTheme.headlineSmall?.copyWith(
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
}
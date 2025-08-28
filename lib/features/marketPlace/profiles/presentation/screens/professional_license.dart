import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/controllers/profile_provider.dart';
import 'package:yelpax_pro/shared/widgets/custom_advanced_dropdown.dart';
import 'package:yelpax_pro/shared/widgets/custom_input.dart';

class ProfessionalLicense extends StatelessWidget {
  const ProfessionalLicense({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await profileProvider.fetchLicenses();
      await profileProvider.fetchStates();
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Professional License'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: theme.cardTheme.color,
                  title: Text(
                    'Confirm Save',
                    style: theme.textTheme.titleMedium,
                  ),
                  content: Text(
                    'Are you sure you want to save your license information?',
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
                        await profileProvider.saveProfessionalLicense();
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
            },
            child: Text(
              'Save',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<ProfileProvider>(
                  builder: (context, provider, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customers prefer to hire licensed professionals.\nThumbstack will check the license information you provide against the state\'s public licensing database.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: AdvancedDropdown<String>(
                          items: provider.states,
                          selectedItem: provider.selectedState.isNotEmpty
                              ? provider.selectedState
                              : null,
                          hintText: 'Select state',
                          itemToString: (item) => item,
                          onChanged: (value) {
                            if (value != null) {
                              provider.setSelectedState(value);
                            }
                          },
                        ),

                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: AdvancedDropdown<String>(
                          items: provider.licenseTypes,
                          selectedItem: provider.selectedLicenseType.isNotEmpty
                              ? provider.selectedLicenseType
                              : null,
                          hintText: 'Select license type',
                          itemToString: (item) => item,
                          onChanged: (value) {
                            if (value != null) {
                              provider.setSelectedLicenseType(value);
                            }
                          },
                        ),

                      ),
                      const SizedBox(height: 25),


                      CustomInputField(
                        controller: provider.licenseNumberController,
                        label: 'License number',
                        hintText: 'Enter your license number',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'License number is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
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

BoxBorder? _getBoxBorderFromInputBorder(InputBorder? inputBorder) {
  if (inputBorder == null) return null;
  if (inputBorder is OutlineInputBorder) {
    return Border.all(
      color: inputBorder.borderSide.color,
      width: inputBorder.borderSide.width,
      style: inputBorder.borderSide.style,
    );
  }
  return null;
}

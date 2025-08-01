import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/controllers/profile_provider.dart';
import 'package:yelpax_pro/shared/widgets/custom_input.dart';

class ProfessionalLicense extends StatelessWidget {
  const ProfessionalLicense({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await profileProvider.fetchLicenses();
      await profileProvider.fetchStates();
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.5),
                ),
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
                        'Professional License',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Save'),
                          content: const Text(
                            'Are you sure you want to save your license information?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await profileProvider.saveProfessionalLicense();
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<ProfileProvider>(
                  builder: (context, provider, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Customers prefer to hire licensed professionals.\nThumbstack will check the license information you provide against the state\'s public licensing database.',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 25),
                      CustomDropdown<String>(
                        hintText: 'Select state',
                        items: provider.states,
                        initialItem: provider.selectedState.isNotEmpty
                            ? provider.selectedState
                            : null,
                        onChanged: (value) =>
                            provider.setSelectedState(value.toString()),
                      ),
                      const SizedBox(height: 25),
                      CustomDropdown<String>(
                        hintText: 'Select license type',
                        items: provider.licenseTypes,
                        initialItem: provider.selectedLicenseType.isNotEmpty
                            ? provider.selectedLicenseType
                            : null,
                        onChanged: (value) =>
                            provider.setSelectedLicenseType(value.toString()),
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

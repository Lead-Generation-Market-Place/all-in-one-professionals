import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/controllers/profile_provider.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerTheme.color ?? Colors.grey,
                    width: 0.5,
                  ),
                ),
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
                        'Professional License',
                        style: theme.textTheme.titleMedium?.copyWith(
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
            ),
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
                        decoration: BoxDecoration(
                          color: theme.inputDecorationTheme.fillColor,
                          borderRadius: BorderRadius.circular(12),
                          border: _getBoxBorderFromInputBorder(theme.inputDecorationTheme.border),
                        ),
                        child: CustomDropdown<String>(
                          hintText: 'Select state',
                          items: provider.states,
                          initialItem: provider.selectedState.isNotEmpty
                              ? provider.selectedState
                              : null,
                          onChanged: (value) =>
                              provider.setSelectedState(value.toString()),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        decoration: BoxDecoration(
                          color: theme.inputDecorationTheme.fillColor,
                          borderRadius: BorderRadius.circular(12),
                          border: _getBoxBorderFromInputBorder(theme.inputDecorationTheme.border),
                        ),
                        child: CustomDropdown<String>(
                          hintText: 'Select license type',
                          items: provider.licenseTypes,
                          initialItem: provider.selectedLicenseType.isNotEmpty
                              ? provider.selectedLicenseType
                              : null,
                          onChanged: (value) =>
                              provider.setSelectedLicenseType(value.toString()),
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


}BoxBorder? _getBoxBorderFromInputBorder(InputBorder? inputBorder) {
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
import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/controllers/m_professional_signup_controller.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';
import 'package:yelpax_pro/shared/widgets/custom_input.dart';

class BusinessType {
  final int id;
  final String businessTypeName;

  BusinessType({required this.id, required this.businessTypeName});
}

class BusinessNameLogo extends StatefulWidget {
  const BusinessNameLogo({super.key});

  @override
  State<BusinessNameLogo> createState() => _BusinessNameLogoState();
}

class _BusinessNameLogoState extends State<BusinessNameLogo> {
  final _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;

  List<BusinessType> businessTypeList = [
    BusinessType(id: 1, businessTypeName: 'Company'),
    BusinessType(id: 2, businessTypeName: 'Individual'),
    BusinessType(id: 3, businessTypeName: 'Sub-Contractor'),
  ];

  String? selectedBusinessType;
  final TextEditingController _yearFoundedController = TextEditingController();
  final TextEditingController _businessDetailsController =
      TextEditingController();

  bool get showEmployeeField =>
      selectedBusinessType == 'Company' ||
      selectedBusinessType == 'Sub-Contractor';

  Future<void> _handleSubmit() async {
    // Validate the form when submit is pressed
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouter.professionalRating,
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _yearFoundedController.dispose();
    _businessDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final professionalSignUpProvider = Provider.of<ProfessionalSignUpProvider>(
      context,
    );
    final businessList = businessTypeList
        .map((b) => b.businessTypeName)
        .toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Business Information'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Tell us about your business',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This information helps customers understand your business better',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Profile image with edit button
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Selector<ProfessionalSignUpProvider, String>(
                                selector: (_, provider) =>
                                    provider.businessImageUrl,
                                builder: (context, imageUrl, child) {
                                  return Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: colorScheme.outlineVariant,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: colorScheme.shadow.withOpacity(
                                            0.1,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: imageUrl.isNotEmpty
                                        ? ClipOval(
                                            child: Image.file(
                                              File(imageUrl),
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => _buildPlaceholder(),
                                            ),
                                          )
                                        : _buildPlaceholder(),
                                  );
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  professionalSignUpProvider
                                      .showImagePickerBottomSheet(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: colorScheme.surface,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorScheme.shadow.withOpacity(
                                          0.2,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Business Logo',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Business Name
                  CustomInputField(
                    label: 'Business Name',
                    hintText: 'Enter your business name',
                    controller:
                        professionalSignUpProvider.businessNameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your business name.';
                      } else if (value.length > 50) {
                        return 'Maximum 50 characters allowed.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Year Founded
                  CustomInputField(
                    label: 'Year Founded',
                    hintText: 'e.g., 2020',
                    controller: _yearFoundedController,
                    inputType: TextInputType.number,
                    validator: _validateYearFounded,
                  ),
                  const SizedBox(height: 24),

                  // Business Type Dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Business Type',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomDropdown<String>(
                        decoration: CustomDropdownDecoration(
                          closedFillColor: colorScheme.surfaceContainerHighest,
                          expandedFillColor: colorScheme.surface,
                          headerStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                          listItemStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                          closedBorderRadius: BorderRadius.circular(12),
                          expandedBorderRadius: BorderRadius.circular(12),
                          closedBorder: Border.all(
                            color: colorScheme.outlineVariant,
                          ),
                          expandedBorder: Border.all(
                            color: colorScheme.primary,
                          ),
                        ),
                        hintText: 'Select Business Type',
                        items: businessList,
                        initialItem: selectedBusinessType,
                        onChanged: (value) {
                          setState(() {
                            selectedBusinessType = value;
                          });
                          professionalSignUpProvider.setBusinessType(value!);
                        },
                      ),
                    ],
                  ),

                  if (showEmployeeField) ...[
                    const SizedBox(height: 24),
                    CustomInputField(
                      label: 'Number of Employees',
                      hintText: 'e.g., 5',
                      inputType: TextInputType.number,
                      controller:
                          professionalSignUpProvider.employeesCountController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter employee count.';
                        }
                        final count = int.tryParse(value);
                        if (count == null || count <= 0) {
                          return 'Please enter a valid number.';
                        }
                        return null;
                      },
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Business Details Multiline
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Business Description',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _businessDetailsController,
                        minLines: 4,
                        maxLines: 6,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText:
                              'Describe your business, services, and what makes you unique...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: colorScheme.error),
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validator: _validateBusinessDetails,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_businessDetailsController.text.length}/500 characters',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Save & Continue Button (always enabled)
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: isSubmitting ? 'Saving...' : 'Save & Continue',
                      onPressed: isSubmitting ? null : _handleSubmit,
                      enabled: true, // Always enabled
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateYearFounded(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter year founded.';
    }

    final year = int.tryParse(value);
    if (year == null) {
      return 'Please enter a valid year.';
    }

    final currentYear = DateTime.now().year;
    if (year < 1900 || year > currentYear) {
      return 'Year must be between 1900 and $currentYear.';
    }

    return null;
  }

  String? _validateBusinessDetails(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please provide details about your business.';
    }

    if (value.trim().length < 20) {
      return 'Please provide at least 20 characters.';
    }

    if (value.trim().length > 500) {
      return 'Maximum 500 characters allowed.';
    }

    return null;
  }

  Widget _buildPlaceholder() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
      ),
      child: const Icon(Icons.camera_alt, size: 40, color: Colors.white),
    );
  }
}

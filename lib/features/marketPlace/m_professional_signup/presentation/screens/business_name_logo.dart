import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';
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
  bool isFormValid = false;

  List<BusinessType> businessTypeList = [
    BusinessType(id: 1, businessTypeName: 'Company'),
    BusinessType(id: 2, businessTypeName: 'Individual'),
    BusinessType(id: 3, businessTypeName: 'Sub-Contractor'),
  ];

  String? selectedBusinessType;

  bool get showEmployeeField =>
      selectedBusinessType == 'Company' ||
      selectedBusinessType == 'Sub-Contractor';

  void validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() {
      isFormValid = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final professionalSignUpProvider = Provider.of<ProfessionalSignUpProvider>(
      context,
    );
    final businessList = businessTypeList
        .map((b) => b.businessTypeName)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Business Information',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            onChanged: validateForm,
            child: Column(
              children: [
                // --- Profile image with edit button ---
                Container(
                  width: 180,
                  height: 180,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Selector<ProfessionalSignUpProvider, String>(
                        selector: (_, provider) => provider.businessImageUrl,
                        builder: (context, imageUrl, child) {
                          return Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.black,
                                width: 2,
                              ),
                            ),
                            child: imageUrl.isNotEmpty
                                ? ClipOval(
                                    child: Image.file(
                                      File(imageUrl),
                                      width: 180,
                                      height: 180,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              _buildPlaceholder(),
                                    ),
                                  )
                                : _buildPlaceholder(),
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          professionalSignUpProvider.showImagePickerBottomSheet(
                            context,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // --- Business Name ---
                CustomInputField(
                  label: 'Business Name',
                  hintText: 'Enter your business name',
                  controller: professionalSignUpProvider.businessNameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your business name.';
                    } else if (value.length > 50) {
                      return 'Maximum 50 characters allowed.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    professionalSignUpProvider.onBusinessNameChanged(value);
                  },
                ),
                const SizedBox(height: 24),

                // --- Year Founded ---
                CustomInputField(
                  label: 'Year Founded',
                  hintText: 'Enter your business founded year',
                  inputType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter year founded.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // --- Business Type Dropdown ---
                CustomDropdown<String>(
                  hintText: 'Select Business Type',
                  items: businessList,
                  initialItem: selectedBusinessType,
                  onChanged: (value) {
                    setState(() {
                      selectedBusinessType = value;
                    });
                    professionalSignUpProvider.setBusinessType(value!);
                    validateForm();
                  },
                ),

                if (showEmployeeField) ...[
                  const SizedBox(height: 24),
                  CustomInputField(
                    label: 'Employees Count',
                    hintText: 'Enter number of employees',
                    inputType: TextInputType.number,
                    controller:
                        professionalSignUpProvider.employeesCountController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter employee count.';
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 24),

                // --- Business Details Multiline ---
                TextFormField(
                  minLines: 5,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: 'Details about your business',
                    hintText: 'Type your details...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please provide details about your business.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // --- Save & Continue Button ---
                CustomButton(
                  text: 'Save & Continue',
                  onPressed: isFormValid
                      ? () {
                          if (_formKey.currentState?.validate() ?? false) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRouter.professionalRating,
                              (route) => false,
                            );
                          }
                        }
                      : null,
                  enabled: isFormValid,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

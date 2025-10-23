import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/features/authentication/presentation/controllers/auth_user_controller.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/professional_services_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/service_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/subcategory_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/controllers/service_controller.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

class EditService extends StatefulWidget {
  const EditService({super.key, required this.service});
  final ProfessionalServicesModel service;

  @override
  State<EditService> createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  late final ServiceController controller;
  String? _selectedSubCategoryId;
  String? _selectedServiceId;
  bool _isInitialized = false;

  @override
  void initState() {
    controller = context.read<ServiceController>();
    init();
    super.initState();
  }

  Future<void> init() async {
    try {
      await controller.fetchAllSubCategories();
      await controller.fetchAllServices();

      Logger().d('Editing service: ${widget.service.serviceEntity.name}');

      await controller.previousSubcategoryAndService(
        widget.service.serviceEntity,
        widget.service.subCategoryEntity,
      );

      // Set the IDs for dropdowns instead of objects
      _selectedSubCategoryId = controller.selectedSubCategory?.id;
      _selectedServiceId = controller.selectedService?.id;

      Logger().d(
        'Controller selectedService: ${controller.selectedService?.id} (${controller.selectedService?.id})',
      );
      Logger().d(
        'Controller selectedSubCategory: ${controller.selectedSubCategory?.name} (${controller.selectedSubCategory?.id})',
      );
      Logger().d('Selected SubCategory ID: $_selectedSubCategoryId');
      Logger().d('Selected Service ID: $_selectedServiceId');

      // Mark as initialized and trigger rebuild
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      Logger().e('Error initializing edit screen: $e');
    }
  }

  // Helper method to find subcategory by ID
  SubCategoryEntity? _findSubCategoryById(String? id) {
    if (id == null) return null;
    try {
      return controller.subCategories.firstWhere((sc) => sc.id == id);
    } catch (e) {
      return null;
    }
  }

  // Helper method to find service by ID
  ServiceEntity? _findServiceById(String? id) {
    if (id == null) return null;
    try {
      return controller.filteredServices.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ServiceController>();
    final authController = context.watch<AuthUserController>();
    final theme = Theme.of(context);

    // Debug current state
    if (_isInitialized) {
      Logger().d(
        'Build - SubCategory ID: $_selectedSubCategoryId, Service ID: $_selectedServiceId',
      );
      Logger().d('Available SubCategories: ${controller.subCategories.length}');
      Logger().d(
        'Available Filtered Services: ${controller.filteredServices.length}',
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Edit service")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Subcategory Dropdown
            Text('Subcategory', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              initialValue: _selectedSubCategoryId,
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              hint: const Text('Select Subcategory'),
              items: controller.subCategories.map((subCategory) {
                return DropdownMenuItem<String>(
                  value: subCategory.id,
                  child: Text(subCategory.name),
                );
              }).toList(),
              onChanged: (subCategoryId) {
                if (subCategoryId != null) {
                  final subCategory = _findSubCategoryById(subCategoryId);
                  if (subCategory != null) {
                    setState(() {
                      _selectedSubCategoryId = subCategoryId;
                      _selectedServiceId =
                          null; // Reset service when subcategory changes
                    });
                    controller.selectSubCategory(subCategory);
                  }
                }
              },
            ),

            const SizedBox(height: 24),

            /// Service Dropdown - Only show when subcategory is selected
            if (_selectedSubCategoryId != null && _isInitialized) ...[
              Text('Service', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              controller.isServicesLoading
                  ? const SizedBox(
                      height: 56,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : DropdownButtonFormField<String>(
                      initialValue: _selectedServiceId,
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                      ),
                      hint: const Text('Select Service'),
                      items: controller.filteredServices.map((service) {
                        return DropdownMenuItem<String>(
                          value: service.id,
                          child: Text(service.name),
                        );
                      }).toList(),
                      onChanged: (serviceId) {
                        if (serviceId != null) {
                          final service = _findServiceById(serviceId);
                          if (service != null) {
                            setState(() {
                              _selectedServiceId = serviceId;
                            });
                            controller.selectService(service);
                          }
                        }
                      },
                    ),
              const Spacer(),
            ],

            /// Submit Button (Next)
            CustomButton(
              text: 'Next',
              onPressed: _selectedServiceId != null
                  ? () async {
                      await controller.updateService(
                        context,
                        widget
                            .service
                            .professionalServiceId,
                        authController.professionalId.value!,
                        widget.service
       
                      );
                    }
                  : null,

            ),
          ],
        ),
      ),
    );
  }
}

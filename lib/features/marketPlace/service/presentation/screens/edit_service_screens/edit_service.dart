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

      Logger().d('Editing service: ${widget.service}');

      await controller.previousSubcategoryAndService(
        widget.service.serviceEntity,
        widget.service.subCategoryEntity,
      );

      Logger().d(
        'Controller selectedService: ${controller.selectedService?.name}',
      );
      Logger().d(
        'Controller selectedSubCategory: ${controller.selectedSubCategory?.name}',
      );
    } catch (e) {
      Logger().e('Error initializing edit screen: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ServiceController>();
    final authController = context.watch<AuthUserController>();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("Edit service")),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Subcategory Dropdown
            Text('Subcategory', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),

            // Fixed: Remove initialValue and use value instead
          DropdownButtonFormField<SubCategoryEntity>(
  initialValue: controller.selectedSubCategory,
  isExpanded: true,
  decoration: InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    filled: true,
  ),
  hint: const Text('Select Subcategory'),
  items: controller.subCategories.map((subCategory) {
    return DropdownMenuItem(
      value: subCategory,
      child: Text(subCategory.name),
    );
  }).toList(),
  onChanged: (subCategory) {
    if (subCategory != null) {
      controller.selectSubCategory(subCategory);
    }
  },
)
,

            const SizedBox(height: 24),

            /// Service Dropdown - Only show when subcategory is selected
            if (controller.selectedSubCategory != null) ...[
              Text('Service', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              controller.isServicesLoading
                  ? const SizedBox(
                      height: 56,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  :
                    // Fixed: Remove initialValue and use value instead
               DropdownButtonFormField<ServiceEntity>(
  initialValue: controller.selectedService,
  isExpanded: true,
  decoration: InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    filled: true,
  ),
  hint: const Text('Select Service'),
  items: controller.filteredServices.map((service) {
    return DropdownMenuItem(
      value: service,
      child: Text(service.name),
    );
  }).toList(),
  onChanged: (service) {
    if (service != null) {
      controller.selectService(service);
    }
  },
)
,
              const Spacer(),
            ],

            /// Submit Button (Next)
            CustomButton(
              text: 'Next',
              onPressed: controller.selectedService != null
                  ? () async {
                      await controller.addService(
                        context,
                        authController.professionalId.value!,
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

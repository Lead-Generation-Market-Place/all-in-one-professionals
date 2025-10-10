import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/controllers/service_controller.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/service_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/subcategory_entity.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({Key? key}) : super(key: key);

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  late final ServiceController controller;
  @override
  void initState() {
    super.initState();

    // Schedule the fetch after the first build

    controller = context.read<ServiceController>();
    init();
  }

  Future<void> init() async {
    try {
      await controller.fetchAllSubCategories();
      await controller.fetchAllServices();
    } catch (e) {
      Logger().e('Error initiazing service screen.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ServiceController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Service'), centerTitle: true),
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
              // REMOVED: initialValue: controller.selectedSubCategory,
              initialValue: controller
                  .selectedSubCategory, // Use value instead of initialValue
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
                return DropdownMenuItem<SubCategoryEntity>(
                  value: subCategory,
                  child: Text(subCategory.name),
                );
              }).toList(),
              onChanged: (subCategory) {
                if (subCategory != null) {
                  controller.selectSubCategory(subCategory);
                }
              },
            ),

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
                      // REMOVED: initialValue: controller.selectedService,
                      initialValue: controller
                          .selectedService, // Use value instead of initialValue
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
                        return DropdownMenuItem<ServiceEntity>(
                          value: service,
                          child: Text(service.name),
                        );
                      }).toList(),
                      onChanged: (service) {
                        if (service != null) {
                          controller.selectService(service);
                        }
                      },
                    ),
              const Spacer(),
            ],

            /// Submit Button (Next)
            CustomButton(
              text: 'Next',
              onPressed: controller.selectedService != null
                  ? () {
                      Navigator.pushNamed(context, AppRouter.add_location);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

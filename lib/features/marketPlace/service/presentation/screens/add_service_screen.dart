import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/model/service_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/model/subCategory.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/controllers/service_controller.dart';
import 'package:yelpax_pro/features/marketPlace/service/service_d_i.dart';
import 'package:yelpax_pro/shared/widgets/custom_advanced_dropdown.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({Key? key}) : super(key: key);

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  _AddServiceScreenState();

  @override
  void initState() {
    Future.microtask(() async {
      final controller = context.read<ServiceController>();
      await controller.fetchInitialData();
    });
    super.initState();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subcategory Dropdown
            Text('Subcategory', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),

            // Show loader or dropdown for subcategories
            AdvancedDropdown<SubCategory>(
              items: controller.subCategories,
              selectedItem: controller.selectedSubCategory,
              hintText: 'Select Subcategory',
              enableSearch: true,
              itemToString: (sub) => sub.name,
              onChanged: (subCategory) {
                if (subCategory != null) {
                  controller.selectSubCategory(subCategory);
                }
              },
              // pass a custom decoration with a suffix icon loader when loading
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.8),
                  width: 1.5,
                ),
                color: Theme.of(context).colorScheme.surface,
              ),
              suffix: controller.isSubCategoriesLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 1,
                        ),
                      ),
                    )
                  : null,
            ),

            const SizedBox(height: 24),

            // Services Dropdown: show only if subcategory selected
            if (controller.selectedSubCategory != null) ...[
              Text('Service', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),

              // Show loader or dropdown for services
              controller.isServicesLoading
                  ? SizedBox(
                      height: 56,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : AdvancedDropdown<Services>(
                      items: controller.filteredServices,
                      selectedItem: controller.selectedService,
                      hintText: 'Select Service',
                      enableSearch: true,
                      itemToString: (service) => service.serviceName,
                      onChanged: (service) {
                        if (service != null) {
                          controller.selectService(service);
                        }
                      },
                    ),
            ],

            const Spacer(),

            // Save Button enabled only if a service is selected
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: controller.selectedService != null ? 1.0 : 0.5,
              child: CustomButton(
                text: 'Next',
                onPressed: controller.selectedService != null
                    ? () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.businessAvailability,
                        );
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

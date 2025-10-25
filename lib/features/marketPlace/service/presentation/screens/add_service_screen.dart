import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/features/authentication/presentation/controllers/auth_user_controller.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/controllers/service_controller.dart';
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
    controller = context.read<ServiceController>();
    init();
    super.initState();
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
    final authController = context.watch<AuthUserController>();
    final theme = Theme.of(context);
    // Use the selected service id for the service dropdown value.
    final String? selectedServiceId = controller.selectedService?.id;

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

            // Use `value` (not initialValue) so the field correctly reflects
            // controller changes during rebuilds.
            DropdownButtonFormField<SubCategoryEntity>(
              initialValue: controller.selectedSubCategory,
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
                  : DropdownButtonFormField<String>(
                      initialValue:
                          controller.filteredServices.any(
                            (s) => s.id == selectedServiceId,
                          )
                          ? selectedServiceId
                          : null,
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
                          final svc = controller.filteredServices.firstWhere(
                            (s) => s.id == serviceId,
                            orElse: () => controller.filteredServices.first,
                          );
                          controller.selectService(svc);
                        }
                      },
                    ),
              const Spacer(),
            ],

            /// Submit Button (Next)
            CustomButton(
              text: 'Next',
              onPressed: controller.selectedService != null
                  ? () async {
                      await controller.addService(
                        context,
                        authController.professionalId.value,
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

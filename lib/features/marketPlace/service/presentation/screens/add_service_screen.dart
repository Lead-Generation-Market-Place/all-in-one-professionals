import 'package:flutter/material.dart';
import 'package:yelpax_pro/shared/widgets/custom_advanced_dropdown.dart' show AdvancedDropdown;
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

class Services {
  final String name;
  final int id;
  final int subCategoryId;

  Services({required this.name, required this.id, required this.subCategoryId});

  @override
  String toString() => name;
}

class SubCategory {
  final String name;
  final int id;

  SubCategory({required this.name, required this.id});

  @override
  String toString() => name;
}

final List<SubCategory> subCategories = [
  SubCategory(name: 'Plumber', id: 1),
  SubCategory(name: 'Electrician', id: 2),
  SubCategory(name: 'Carpenter', id: 3),
  SubCategory(name: 'Painter', id: 4),
  SubCategory(name: 'Cleaner', id: 5),
];

final List<Services> allServices = [
  Services(name: 'Pipe Fixing', id: 1, subCategoryId: 1),
  Services(name: 'Drain Cleaning', id: 2, subCategoryId: 1),
  Services(name: 'Wiring', id: 3, subCategoryId: 2),
  Services(name: 'Fan Installation', id: 4, subCategoryId: 2),
  Services(name: 'Wood Repair', id: 5, subCategoryId: 3),
  Services(name: 'Furniture Assembly', id: 6, subCategoryId: 3),
  Services(name: 'Wall Painting', id: 7, subCategoryId: 4),
  Services(name: 'Graffiti Removal', id: 8, subCategoryId: 4),
  Services(name: 'Floor Cleaning', id: 9, subCategoryId: 5),
  Services(name: 'Window Cleaning', id: 10, subCategoryId: 5),
];

/// Paste the AdvancedDropdown widget code here or import it from a separate file

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  SubCategory? selectedSubCategory;
  Services? selectedService;
  List<Services> filteredServices = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Service'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,

        foregroundColor: theme.colorScheme.onBackground,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.build_circle_outlined,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Service Category',
                        style: theme.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Choose a subcategory and service you offer',
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.onBackground.withOpacity(
                            0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            /// Subcategory Dropdown
            Text(
              'Subcategory',
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),

            AdvancedDropdown<SubCategory>(
              items: subCategories,
              selectedItem: selectedSubCategory,
              hintText: 'Select Subcategory',
              enableSearch: true,
              itemToString: (sub) => sub.name,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.dividerColor),
              ),
              onChanged: (sub) {
                if (sub != null) {
                  setState(() {
                    selectedSubCategory = sub;
                    filteredServices = allServices
                        .where((service) => service.subCategoryId == sub.id)
                        .toList();
                    selectedService = null;
                  });
                }
              },
            ),

            const SizedBox(height: 25),

            /// Services Dropdown
            Text(
              'Service',
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),

            AdvancedDropdown<Services>(
              items: filteredServices,
              selectedItem: selectedService,
              hintText: selectedSubCategory == null
                  ? 'Please select a subcategory first'
                  : 'Select Service',
              enableSearch: true,
              itemToString: (service) => service.name,
              decoration: BoxDecoration(
                color: selectedSubCategory == null
                    ? theme.disabledColor.withOpacity(0.12)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.dividerColor),
              ),
              onChanged: selectedSubCategory == null
                  ? null
                  : (service) {
                      if (service != null) {
                        setState(() {
                          selectedService = service;
                        });
                      }
                    },
            ),

            const SizedBox(height: 30),

            if (selectedSubCategory != null && selectedService != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Selected Service',
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${selectedSubCategory!.name} • ${selectedService!.name}',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'SubCategory ID: ${selectedSubCategory!.id} • Service ID: ${selectedService!.id}',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

            const Spacer(),

            // Save button with smooth animation
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: selectedService != null ? 1.0 : 0.6,
              child: CustomButton(
                text: 'Save Service',
                onPressed: selectedService != null
                    ? () {
                        // Save service logic
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

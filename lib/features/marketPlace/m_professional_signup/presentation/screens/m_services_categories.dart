import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

class MSubCategory {
  final int id;
  final String categoryName;

  MSubCategory({required this.id, required this.categoryName});

  @override
  String toString() => categoryName;
}

class MService {
  final int id;
  final String serviceName;
  final int subCategoryId;

  MService({
    required this.id,
    required this.serviceName,
    required this.subCategoryId,
  });

  @override
  String toString() => serviceName;
}

class MServicesCategories extends StatefulWidget {
  const MServicesCategories({super.key});

  @override
  State<MServicesCategories> createState() => _MServicesCategoriesState();
}

class _MServicesCategoriesState extends State<MServicesCategories> {
  List<MSubCategory> subCategories = [
    MSubCategory(id: 1, categoryName: 'Web Development'),
    MSubCategory(id: 2, categoryName: 'Graphic Design'),
    MSubCategory(id: 3, categoryName: 'Digital Marketing'),
    MSubCategory(id: 4, categoryName: 'Content Writing'),
  ];

  List<MService> allServices = [
    MService(id: 1, serviceName: 'Website Design', subCategoryId: 1),
    MService(id: 2, serviceName: 'SEO Optimization', subCategoryId: 3),
    MService(id: 3, serviceName: 'Logo Design', subCategoryId: 2),
    MService(id: 4, serviceName: 'Social Media Management', subCategoryId: 3),
    MService(id: 5, serviceName: 'Blog Writing', subCategoryId: 4),
  ];

  List<MSubCategory> selectedSubCategories = [];
  List<MService> filteredServices = [];
  List<MService> selectedServices = [];

  void onSubCategoriesChanged(List<dynamic> selected) {
    setState(() {
      selectedSubCategories = selected.cast<MSubCategory>();

      // Filter services based on selected subcategories
      final selectedIds = selectedSubCategories.map((e) => e.id).toSet();

      filteredServices = allServices
          .where((service) => selectedIds.contains(service.subCategoryId))
          .toList();

      // Reset previously selected services if not in filtered list
      selectedServices = selectedServices
          .where((s) => filteredServices.contains(s))
          .toList();
    });
  }

  void onServicesChanged(List<dynamic> selected) {
    setState(() {
      selectedServices = selected.cast<MService>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Services you offer',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          actions: [
            if (selectedSubCategories.isNotEmpty && selectedServices.isNotEmpty)
              CustomButton(
                text: 'Save',
                onPressed: () {
                  Navigator.pop(context, selectedServices);
                },
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 40),

              CustomDropdown.multiSelectSearch(
                hintText: "Select Subcategories",
                items: subCategories,
                initialItems: selectedSubCategories,
                onListChanged: onSubCategoriesChanged,
              ),
              const SizedBox(height: 20),
              if (filteredServices.isNotEmpty)
                CustomDropdown.multiSelectSearch(
                  hintText: "Select Services",
                  items: filteredServices,
                  initialItems: selectedServices,
                  onListChanged: onServicesChanged,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

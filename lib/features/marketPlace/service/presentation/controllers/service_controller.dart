import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/model/category_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/model/service_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/model/subCategory.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/service_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/category_use_case.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/services_usecase.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/sub_category_usecase.dart';

class ServiceController extends ChangeNotifier {
  final SubCategoryUsecase subCategoryUsecase;
  final CategoryUsecase categoryUsecase;
  final ServicesUsecase serviceUsecase;
bool isSubCategoriesLoading = false;
  bool isServicesLoading = false;

  List<SubCategory> subCategories = [];
  List<Category> categories = [];
  List<Services> services = []; // all services fetched from API

  SubCategory? selectedSubCategory;
  Category? selectedCategory;
  Services? selectedService; // selected service

  bool isLoading = true;

  ServiceController({
    required this.subCategoryUsecase,
    required this.categoryUsecase,
    required this.serviceUsecase,
  });


  Future<void> fetchInitialData() async {
    try {
      isLoading = true;
          isSubCategoriesLoading = true;
      notifyListeners();

      final servicesEntities = await serviceUsecase({});
      services = servicesEntities.map((e) => Services.fromEntity(e)).toList();

      final subcategoryEntities = await subCategoryUsecase({});
      subCategories = subcategoryEntities
          .map((e) => SubCategory.fromEntity(e))
          .toList();

      final categoryEntities = await categoryUsecase();
      categories = categoryEntities.map((e) => Category.fromEntity(e)).toList();

      isLoading = false;
      isSubCategoriesLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      // handle error
      notifyListeners();
    }
  }

  void selectCategory(Category category) {
    selectedCategory = category;
    notifyListeners();
    // Optionally filter subcategories here if you want
  }

  void selectSubCategory(SubCategory subCategory) {
    selectedSubCategory = subCategory;
    selectedService = null; // Reset selected service when subcategory changes
    notifyListeners();
  }

  void selectService(Services service) {
    selectedService = service;
    notifyListeners();
  }

  // Filter services by selectedSubCategory id
  List<Services> get filteredServices {
    if (selectedSubCategory == null) return [];
    return services
        .where((s) => s.subCategoryId == selectedSubCategory!.id)
        .toList();
  }
}

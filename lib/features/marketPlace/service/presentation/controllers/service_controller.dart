import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/datasource/question_data_source.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/model/category_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/model/service_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/model/subCategory.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/question_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/service_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/category_use_case.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/services_usecase.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/sub_category_usecase.dart';

class ServiceController extends ChangeNotifier {
  final SubCategoryUsecase subCategoryUsecase;
  final CategoryUsecase categoryUsecase;
  final ServicesUsecase serviceUsecase;
  final QuestionDataSource questionDataSource;
  bool isSubCategoriesLoading = false;
  bool isServicesLoading = false;
  bool isQuestionsLoading = false;
  List<SubCategory> subCategories = [];
  List<Category> categories = [];
  List<Services> services = [];
  List<QuestionEntity> questions = [];

  SubCategory? selectedSubCategory;
  Category? selectedCategory;
  Services? selectedService;

  bool isLoading = true;
  final Map<String, dynamic> answers = {};
  bool isSubmitting = false;
  ServiceController({
    required this.subCategoryUsecase,
    required this.categoryUsecase,
    required this.serviceUsecase,
    required this.questionDataSource,
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
    Logger().d('Selected service: ${service.id}');
    notifyListeners();
  }

  // Filter services by selectedSubCategory id
  List<Services> get filteredServices {
    if (selectedSubCategory == null) return [];
    return services
        .where((s) => s.subCategoryId == selectedSubCategory!.id)
        .toList();
  }

  Future<void> fetchQuestionsForSelectedService() async {
    if (selectedService == null) {
      log('No service selected');
      questions.clear();
      notifyListeners();
      return;
    }

    try {
      isQuestionsLoading = true;
      notifyListeners();
      Logger().d('Fetching questions for service ID: ${selectedService!.id}');
      questions = await questionDataSource.getQuestions(selectedService!.id);
      Logger().d('Fetched questions: $questions');
      // Initialize answers map
      answers.clear();
      for (var question in questions) {
        answers[question.id] = _getDefaultAnswer(question);
      }

      isQuestionsLoading = false;
      notifyListeners();
    } catch (e) {
      isQuestionsLoading = false;
      questions.clear();
      log('Error fetching questions: $e');
      notifyListeners();
    }
  }

  dynamic _getDefaultAnswer(QuestionEntity question) {
    switch (question.formType) {
      case 'checkbox':
        return [];
      case 'radio':
      case 'select':
        return question.options.isNotEmpty ? question.options.first : '';
      default:
        return '';
    }
  }

  void updateAnswer(String questionId, dynamic value) {
    answers[questionId] = value;
    notifyListeners();
  }

  Future<bool> submitAnswers() async {
    try {
      isSubmitting = true;
      notifyListeners();

      // Here you would typically send the answers to your backend
      log('Submitting answers: $answers');

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  // Helper getters for the UI
  bool get _isLoading =>
      isSubCategoriesLoading || isServicesLoading || isQuestionsLoading;

  int get completedAnswersCount {
    return answers.values.where((answer) {
      if (answer is List) return answer.isNotEmpty;
      if (answer is String) return answer.isNotEmpty;
      return answer != null;
    }).length;
  }
}

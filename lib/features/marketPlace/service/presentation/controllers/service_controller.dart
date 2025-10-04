import 'package:flutter/material.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/models/question_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/models/service_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/models/subcategory_model.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';

class ServiceController extends ChangeNotifier {
  final ApiService apiService;

  ServiceController({required this.apiService});

  /// Subcategories
  List<SubCategory> _subCategories = [];
  List<SubCategory> get subCategories => _subCategories;

  SubCategory? _selectedSubCategory;
  SubCategory? get selectedSubCategory => _selectedSubCategory;

  bool isSubCategoriesLoading = false;

  Future<void> fetchAllSubCategories() async {
    isSubCategoriesLoading = true;
    notifyListeners();

    try {
      final response = await apiService.get('/subcategories');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']; // ✅ Fix here
        _subCategories = data
            .map((json) => SubCategory.fromJson(json))
            .toList();
      }
    } catch (e) {
      print('Error fetching subcategories: $e');
    }

    isSubCategoriesLoading = false;
    notifyListeners();
  }

  void selectSubCategory(SubCategory subCategory) {
    _selectedSubCategory = subCategory;
    _selectedService = null; // Reset selected service
    notifyListeners();
  }

  /// Services
  List<ServiceModel> _services = [];
  List<ServiceModel> get services => _services;

  ServiceModel? _selectedService;
  ServiceModel? get selectedService => _selectedService;

  bool isServicesLoading = false;

  Future<void> fetchAllServices() async {
    isServicesLoading = true;
    notifyListeners();

    try {
      final response = await apiService.get('/services');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        _services = data
            .map((json) => ServiceModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        print("Failed to fetch services. Status: ${response.statusCode}");
      }
    } catch (e) {
      print('Error fetching services: $e');
    }

    isServicesLoading = false;
    notifyListeners();
  }

  void selectService(ServiceModel service) {
    _selectedService = service;
    notifyListeners();
  }

  /// Filter services by selected subcategory
  List<ServiceModel> get filteredServices {
    if (_selectedSubCategory == null) return [];
    return _services
        .where((s) => s.subcategoryId == _selectedSubCategory!.id)
        .toList();
  }

  /// Questions
  List<QuestionEntity> _questions = [];
  List<QuestionEntity> get questions => _questions;

  final Map<String, dynamic> _answers = {};
  Map<String, dynamic> get answers => _answers;

  bool isQuestionsLoading = false;
  bool isSubmitting = false;

  int get completedAnswersCount {
    return _answers.entries.where((entry) {
      final question = _questions.firstWhere(
        (q) => q.id == entry.key,
        orElse: () => QuestionEntity(
          id: '',
          serviceId: '',
          questionName: '',
          formType: 'text',
          options: [],
          required: false,
          order: 0,
          active: true,
        ),
      );

      if (entry.value == null) return false;

      if (entry.value is List) {
        return (entry.value as List).isNotEmpty;
      } else if (entry.value is String) {
        return (entry.value as String).trim().isNotEmpty;
      }

      return true;
    }).length;
  }

  Future<void> fetchQuestionsForSelectedService() async {
    if (_selectedService == null) return;

    isQuestionsLoading = true;
    notifyListeners();

    try {
      final response = await apiService.get(
        '/questions/service/${_selectedService!.id}',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        _questions = data
            .map((json) => QuestionModel.fromJson(json).toEntity())
            .toList();

        // Initialize answers map
        _answers.clear();
        for (final question in _questions) {
          _answers[question.id] = _getDefaultAnswer(question);
        }
      } else {
        print("Failed to fetch questions. Status: ${response.statusCode}");
        _questions = [];
      }
    } catch (e) {
      print('Error fetching questions: $e');
      _questions = [];
    }

    isQuestionsLoading = false;
    notifyListeners();
  }

  dynamic _getDefaultAnswer(QuestionEntity question) {
    switch (question.formType) {
      case 'checkbox':
        return [];
      case 'radio':
      case 'select':
        return null;
      default: // text, number, date
        return '';
    }
  }

  void updateAnswer(String questionId, dynamic answer) {
    _answers[questionId] = answer;
    notifyListeners();
  }

  Future<bool> submitAnswers() async {
    if (_selectedService == null) return false;

    isSubmitting = true;
    notifyListeners();

    try {
      // // Prepare answers data
      // final List<Map<String, dynamic>> answersData = [];

      // for (final question in _questions) {
      //   final answer = _answers[question.id];

      //   // Skip if required question is not answered
      //   if (question.required && _isEmptyAnswer(answer)) {
      //     isSubmitting = false;
      //     notifyListeners();
      //     return false;
      //   }

      //   if (!_isEmptyAnswer(answer)) {
      //     answersData.add({'question_id': question.id, 'answer': answer});
      //   }
      // }

      // Submit to backend
      // final response = await apiService.post(
      //   '/answers/${_selectedService!.id}',
      //   data: {'answers': answersData},
      // );
      // final response = await apiService.post(
      //   '/answers/${_selectedService!.id}',

      // );
      isSubmitting = false;
      notifyListeners();

      // return response.statusCode == 200 || response.statusCode == 201;
      return true;
    } catch (e) {
      print('Error submitting answers: $e');
      isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  bool _isEmptyAnswer(dynamic answer) {
    if (answer == null) return true;
    if (answer is String) return answer.trim().isEmpty;
    if (answer is List) return answer.isEmpty;
    return false;
  }

  void clearAnswers() {
    _answers.clear();
    _questions.clear();
    notifyListeners();
  }
}

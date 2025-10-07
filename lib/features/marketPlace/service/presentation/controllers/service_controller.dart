import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/models/budget_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/models/business_availability.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/models/location_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/models/question_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/models/service_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/models/service_registering_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/models/subcategory_model.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';

class ServiceController extends ChangeNotifier {
  final String professionalId;
  final ApiService apiService;
  late final ServiceRegistrationModel _registrationData;

  ServiceController({required this.professionalId, required this.apiService}) {
    _registrationData = ServiceRegistrationModel(
      professionalId: professionalId,
    );
  }

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

  // void selectSubCategory(SubCategory subCategory) {
  //   _selectedSubCategory = subCategory;
  //   _selectedService = null; // Reset selected service
  //   notifyListeners();
  // }

  /// Services
  List<ServiceModel> _services = [];
  List<ServiceModel> get services => _services;

  ServiceModel? _selectedServices;
  ServiceModel? get selectedService => _selectedServices;

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

  // void selectService(ServiceModel service) {
  //   _selectedService = service;
  //   notifyListeners();
  // }

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
      final dynamic value = entry.value;
      if (value == null) return false;
      if (value is List) return value.isNotEmpty;
      if (value is String) return value.trim().isNotEmpty;
      return true;
    }).length;
  }

  Future<void> fetchQuestionsForSelectedService() async {
    if (_selectedServices == null) return;

    isQuestionsLoading = true;
    notifyListeners();

    try {
      final response = await apiService.get(
        '/questions/service/${_selectedServices!.id}',
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
    if (_selectedServices == null) return false;

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

  // removed unused _isEmptyAnswer

  void clearAnswers() {
    _answers.clear();
    _questions.clear();
    notifyListeners();
  }

  ServiceRegistrationModel get registrationData => _registrationData;

  void selectService(ServiceModel service) {
    Logger().d('🐛 Selected ServiceModel: ${service.id}');
    _selectedServices = service;
    Logger().d('--------------=-=-${_selectedServices!.id}');
    // Persist selected service id and details on registration data
    _registrationData.selectedService = _selectedServices!.id;
    _registrationData.selectedServiceDetails = _selectedServices;
    // Debug to verify
    Logger().d(
      '✅ Set in registrationData: ${_registrationData.selectedService}',
    );
    Logger().d('✅ Service ID: ${service.id}');
    Logger().d('✅ Service Name: ${service.serviceName}');

    notifyListeners();
  }

  void setSelectedServiceId(String id) {}
  // Override selectSubCategory if needed
  void selectSubCategory(SubCategory subCategory) {
    _selectedSubCategory = subCategory;
    _selectedServices = null; // Reset selected service
    _registrationData.selectedService = null; // Also reset in registration data
    notifyListeners();
  }

  // Update other methods to ensure data sync
  void updateAvailabilityData(BusinessAvailabilityModel availability) {
    _registrationData.availability = availability;
    notifyListeners();
  }

  void updateQuestionAnswers(Map<String, dynamic> answers) {
    _registrationData.questionAnswers = answers;
    notifyListeners();
  }

  void updateLocationData(LocationModel location) {
    _registrationData.location = location;
    notifyListeners();
  }

  void updateBudgetData(BudgetModel budget) {
    _registrationData.budget = budget;
    notifyListeners();
  }

  void setProfessionalId(String proId) {
    _registrationData.professionalId = proId; // set from parameter
    notifyListeners();
    print(
      '✅ Professional ID set in ServiceController:  got from service controler $professionalId',
    );
  }

  // Enhanced validation with better error messages

  // Enhanced submission with better logging
  Future<bool> submitCompleteRegistration() async {
    print('🔄 Starting complete registration submission...');
    debugPrint("Professsssssssssssssssssssssssssssssional ID $professionalId");
    // Debug: Print current registration data

    // Apply sensible defaults for optional steps if missing
    if (_registrationData.availability == null) {
      print('ℹ️ No availability set. Defaulting to availableAnytime=true');
      _registrationData.availability = BusinessAvailabilityModel(
        availableAnytime: true,
      );
    }
    if (_registrationData.budget == null) {
      print('ℹ️ No budget set. Defaulting to unlimited (no weekly limit)');
      _registrationData.budget = BudgetModel(
        limitBudget: false,
        weeklyBudget: null,
        paymentInfo: null,
      );
    }

    if (!_validateRegistrationData()) {
      print('❌ Registration validation failed');
      return false;
    }

    // // Ensure professional ID is set
    // if (_registrationData.professionalId == null) {
    //   print('❌ Professional ID not set');
    //   return false;
    // }

    isSubmitting = true;
    notifyListeners();

    try {
      print('📤 Sending professional service data to backend...');
      final professionalServiceJson = _registrationData.toJson();

      // Debug the final JSON
      print('📦 Professional Service JSON:');
      print(professionalServiceJson);

      final response = await apiService.post(
        '/services/asp', // Your professional services assignment endpoint
        data: professionalServiceJson,
      );

      isSubmitting = false;
      notifyListeners();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Professional service registered successfully!');
        print('Response: ${response.data}');
        _clearRegistrationData();
        return true;
      } else {
        print('❌ Registration failed with status: ${response.statusCode}');
        print('Response: ${response.data}');
        return false;
      }
    } catch (e) {
      print('❌ Error in registration: $e');
      isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  // Enhanced validation
  bool _validateRegistrationData() {
    if (_registrationData.selectedService == null) {
      print('❌ Service validation failed: No service selected');
      return false;
    }

    if (_registrationData.availability == null) {
      print('❌ Availability validation failed: No availability set');
      return false;
    }

    if (_registrationData.location == null) {
      print('❌ Location validation failed: No location set');
      return false;
    }

    if (_registrationData.budget == null) {
      print('❌ Budget validation failed: No budget set');
      return false;
    }

    // if (professionalId == null) {
    //   print('❌ Professional ID validation failed: No professional ID set');
    //   return false;
    // }

    print('✅ All registration data validated successfully');
    return true;
  }

  void _clearRegistrationData() {
    _selectedServices = null;
    _selectedSubCategory = null;
    _answers.clear();
    _questions.clear();
    notifyListeners();
  }

  // Helper method to get current registration progress
  double get registrationProgress {
    int completedSteps = 0;
    const int totalSteps =
        5; // service, availability, questions, location, budget

    if (_registrationData.selectedService != null) completedSteps++;
    if (_registrationData.availability != null) completedSteps++;
    if (_registrationData.questionAnswers != null &&
        _registrationData.questionAnswers!.isNotEmpty)
      completedSteps++;
    if (_registrationData.location != null) completedSteps++;
    if (_registrationData.budget != null) completedSteps++;

    return completedSteps / totalSteps;
  }
}

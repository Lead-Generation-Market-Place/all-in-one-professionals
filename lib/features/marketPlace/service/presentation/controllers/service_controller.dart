import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/add_location.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/screens/service_location_screens/add_location.dart';
import '../../domain/entities/budget_entity.dart';

import '../../domain/entities/question_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/service_registration_entity.dart';
import '../../domain/entities/subcategory_entity.dart';
import '../../domain/usecases/get_all_services.dart';
import '../../domain/usecases/get_all_subcategories.dart';
import '../../domain/usecases/get_questions_for_service.dart';
import '../../domain/usecases/get_services_by_subcategory.dart';
import '../../domain/usecases/submit_service_registration.dart';

class ServiceController extends ChangeNotifier {
  final GetAllSubCategories getAllSubCategories;
  final GetAllServices getAllServices;
  final GetServicesBySubCategory getServicesBySubCategory;
  final GetQuestionsForService getQuestionsForService;
  final SubmitServiceRegistration submitServiceRegistration;
  final AddLocationUseCase addLocation;
  ServiceController({
    required this.getAllSubCategories,
    required this.getAllServices,
    required this.getServicesBySubCategory,
    required this.getQuestionsForService,
    required this.submitServiceRegistration,
    required this.addLocation,
  });

  // Registration data
  late final ServiceRegistrationEntity _registrationData;
  ServiceRegistrationEntity get registrationData => _registrationData;

  void initializeRegistrationData(String professionalId) {
    _registrationData = ServiceRegistrationEntity(
      professionalId: professionalId,
    );
  }

  void updateProfessionalId(String professionalId) {
    if (_registrationData.professionalId != professionalId) {
      _registrationData = _registrationData.copyWith(
        professionalId: professionalId,
      );
      notifyListeners();
    }
  }

  // Subcategories
  List<SubCategoryEntity> _subCategories = [];
  List<SubCategoryEntity> get subCategories => _subCategories;

  SubCategoryEntity? _selectedSubCategory;
  SubCategoryEntity? get selectedSubCategory => _selectedSubCategory;

  bool isSubCategoriesLoading = false;
  String? subCategoriesError;

  Future<void> fetchAllSubCategories() async {
    isSubCategoriesLoading = true;
    subCategoriesError = null;

    try {
      _subCategories = await getAllSubCategories();
    } catch (e) {
      subCategoriesError = e.toString();
      _subCategories = [];
    }

    isSubCategoriesLoading = false;
    notifyListeners();
  }

  void selectSubCategory(SubCategoryEntity subCategory) {
    _selectedSubCategory = subCategory;

    _selectedService = null;
    notifyListeners();
  }

  // Services
  List<ServiceEntity> _services = [];
  List<ServiceEntity> get services => _services;

  ServiceEntity? _selectedService;
  ServiceEntity? get selectedService => _selectedService;

  bool isServicesLoading = false;
  String? servicesError;

  Future<void> fetchAllServices() async {
    isServicesLoading = true;
    servicesError = null;
    notifyListeners();

    try {
      _services = await getAllServices();
    } catch (e) {
      servicesError = e.toString();
      _services = [];
    }

    isServicesLoading = false;
    notifyListeners();
  }

  // Filter services by selected subcategory
  List<ServiceEntity> get filteredServices {
    Logger().d(_selectedSubCategory);
    if (_selectedSubCategory == null) return [];
    return _services
        .where((s) => s.subcategoryId == _selectedSubCategory!.id)
        .toList();
  }

  void selectService(ServiceEntity service) {
    Logger().d('🐛 Selected Service: ${service.id}');
    _selectedService = service;

    // _registrationData = _registrationData.copyWith(
    //   selectedService: service.id,
    //   selectedServiceDetails: service,
    // );

    // Logger().d(
    //   '✅ Set in registrationData: ${_registrationData.selectedService}',
    // );
    // Logger().d('✅ Service ID: ${service.id}');
    // Logger().d('✅ Service Name: ${service.name}');

    notifyListeners();
  }

  ///////////-Location-////////////
  Future<String> addLocationData(LocationDataEntity locationDataEntity) async {
    try {
      final response = await addLocation(locationDataEntity);
      if (response.isEmpty) {
        throw Exception('Error returning service id.');
      }
      return response;
    } catch (e) {
      Logger().e('Error adding location.');
      return Future.error('Failed to add location: $e');
    }
  }

  // Questions
  List<QuestionEntity> _questions = [];
  List<QuestionEntity> get questions => _questions;

  final Map<String, dynamic> _answers = {};
  Map<String, dynamic> get answers => _answers;

  bool isQuestionsLoading = false;
  bool isSubmitting = false;
  String? questionsError;
  String? submitError;

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
    if (_selectedService == null) return;

    isQuestionsLoading = true;
    questionsError = null;
    notifyListeners();

    try {
      _questions = await getQuestionsForService(_selectedService!.id);
      // Initialize answers map
      _answers.clear();
      for (final question in _questions) {
        _answers[question.id] = _getDefaultAnswer(question);
      }
    } catch (e) {
      questionsError = e.toString();
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
    _registrationData = _registrationData.copyWith(
      questionAnswers: Map.from(_answers),
    );
    notifyListeners();
  }

  // Method for backward compatibility
  Future<bool> submitAnswers() async {
    // This method is kept for backward compatibility
    // The actual submission is done in submitCompleteRegistration
    return true;
  }

  // Method for backward compatibility
  void updateQuestionAnswers(Map<String, dynamic> answers) {
    _registrationData = _registrationData.copyWith(questionAnswers: answers);
    notifyListeners();
  }

  // Registration submission
  Future<bool> submitCompleteRegistration() async {
    print('🔄 Starting complete registration submission...');

    // Apply sensible defaults for optional steps if missing

    BudgetEntity budget =
        _registrationData.budget ?? BudgetEntity(limitBudget: false);

    final updatedRegistration = _registrationData.copyWith(budget: budget);

    if (!_validateRegistrationData(updatedRegistration)) {
      print('❌ Registration validation failed');
      return false;
    }

    isSubmitting = true;
    submitError = null;
    notifyListeners();

    try {
      final success = await submitServiceRegistration(updatedRegistration);
      if (success) {
        print('✅ Professional service registered successfully!');
        _clearRegistrationData();
      }
      isSubmitting = false;
      notifyListeners();
      return success;
    } catch (e) {
      submitError = e.toString();
      print('❌ Registration failed: $e');
      isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  // Validation
  bool _validateRegistrationData(ServiceRegistrationEntity registration) {
    if (registration.selectedService == null) {
      print('❌ Service validation failed: No service selected');
      return false;
    }

    if (registration.budget == null) {
      print('❌ Budget validation failed: No budget set');
      return false;
    }

    print('✅ All registration data validated successfully');
    return true;
  }

  void _clearRegistrationData() {
    _selectedService = null;
    _selectedSubCategory = null;
    _answers.clear();
    _questions.clear();
    notifyListeners();
  }

  void updateBudgetData(BudgetEntity budget) {
    _registrationData = _registrationData.copyWith(budget: budget);
    notifyListeners();
  }

  // Helper method to get current registration progress
  double get registrationProgress {
    int completedSteps = 0;
    const int totalSteps =
        5; // service, availability, questions, location, budget

    if (_registrationData.selectedService != null) completedSteps++;

    if (_registrationData.questionAnswers != null &&
        _registrationData.questionAnswers!.isNotEmpty)
      completedSteps++;

    if (_registrationData.budget != null) completedSteps++;

    return completedSteps / totalSteps;
  }
}

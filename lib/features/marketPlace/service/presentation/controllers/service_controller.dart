import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/location_data_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/mile_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/minute_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/vehicle_type_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/add_location.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/get_all_Minute_use_case.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/get_all_miles.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/get_all_vehicle_type_use_case.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/get_services_location_of_authenticated_user.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/update_location.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/screens/service_location_screens/add_location.dart';
import 'package:yelpax_pro/shared/widgets/custom_flutter_toast.dart';
import '../../domain/entities/budget_entity.dart';

import '../../domain/entities/question_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/service_registration_entity.dart';
import '../../domain/entities/subcategory_entity.dart';
import '../../domain/usecases/delete_service_location_use_case.dart';
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
  final GetServicesLocationOfAuthenticatedUser
  getServicesLocationOfAuthenticatedUser;
  final UpdateLocationUseCase updateLocationUseCase;
  final GetAllMilesUseCase getAllMilesUseCase;
  final DeleteServiceLocationUseCase deleteServiceLocationUseCase;
  final GetAllMinuteUseCase getAllMinuteUseCase;
  final GetAllVehicleTypeUseCase getAllVehicleTypesUseCase;
  ServiceController({
    required this.getAllSubCategories,
    required this.getAllServices,
    required this.getServicesBySubCategory,
    required this.getQuestionsForService,
    required this.submitServiceRegistration,
    required this.addLocation,
    required this.getServicesLocationOfAuthenticatedUser,
    required this.updateLocationUseCase,
    required this.getAllMilesUseCase,
    required this.deleteServiceLocationUseCase,
    required this.getAllMinuteUseCase,
    required this.getAllVehicleTypesUseCase,
  });
  bool _isLoading = false;
  bool get isLoading => _isLoading;
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
    notifyListeners();
  }

  ///////////-Location-////////////

  List<MileEntity> _miles = [];
  List<MileEntity> get miles => _miles;

  Future<void> fetchAllMiles() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await getAllMilesUseCase();
      Logger().d('fetch Miles === $response');
      _miles = response;
    } catch (e) {
      print('Error fetching miles: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<MinuteEntity> _minute = [];
  List<MinuteEntity> get minute => _minute;

  Future<void> fetchAllMinute() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await getAllMinuteUseCase();
      Logger().d('fetch minutes === $response');
      _minute = response;
    } catch (e) {
      print('Error fetching miles: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<VehicleTypeEntity> _vehicleType = [];
  List<VehicleTypeEntity> get vehicleType => _vehicleType;

  Future<void> fetchAllVehicleTypes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await getAllVehicleTypesUseCase();
      Logger().d('fetch Vehicle Types === $response');
      _vehicleType = response;
    } catch (e) {
      print('Error fetching vehicle types: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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

  final List<LocationDataEntity> _serviceLocations = [];

  List<LocationDataEntity> get serviceLocations =>
      List.unmodifiable(_serviceLocations);

  Future<void> getServiceLocationsOfAuthenticatedUser(
    String professionalId,
  ) async {
    try {
      final response = await getServicesLocationOfAuthenticatedUser(
        professionalId,
        selectedService!.id.toString(),
      );
      Logger().d('response === $response');
      if (response.isEmpty) {
        Logger().d('No service locations found.');
      } else {
        _serviceLocations.clear();
        _serviceLocations.addAll(response);
        notifyListeners(); // notify UI about changes
      }
    } catch (e) {
      CustomFlutterToast.showErrorToast('Failed to fetch service locations.');
    }
  }

  // Add this method to your ServiceController
  Future<void> updateLocationData(LocationDataEntity locationEntity) async {
    try {
      _isLoading = true;

      // ✅ CORRECT: Call the usecase instance that was injected in the constructor
      final response = await updateLocationUseCase(locationEntity);
      if (response.isEmpty) {
        CustomFlutterToast.showErrorToast('Error updating location.');
      }
      Logger().d("-------------------$response");
      notifyListeners();
    } catch (e) {
      Logger().e('Error updating location: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  Future<void> deleteServiceLocation(String? id) async {
    try {
      _isLoading = true;
      notifyListeners();

      await deleteServiceLocationUseCase(id);

      // Remove the deleted location from the local list
      _serviceLocations.removeWhere((location) => location.id == id);

      _isLoading = false;
      notifyListeners();

      CustomFlutterToast.showSuccessToast('Location deleted successfully');
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      CustomFlutterToast.showErrorToast('Error deleting service location.');
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
    // Apply sensible defaults for optional steps if missing

    BudgetEntity budget =
        _registrationData.budget ?? BudgetEntity(limitBudget: false);

    final updatedRegistration = _registrationData.copyWith(budget: budget);

    if (!_validateRegistrationData(updatedRegistration)) {
      return false;
    }

    isSubmitting = true;
    submitError = null;
    notifyListeners();

    try {
      final success = await submitServiceRegistration(updatedRegistration);
      if (success) {
        _clearRegistrationData();
      }
      isSubmitting = false;
      notifyListeners();
      return success;
    } catch (e) {
      submitError = e.toString();

      isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  // Validation
  bool _validateRegistrationData(ServiceRegistrationEntity registration) {
    if (registration.selectedService == null) {
      return false;
    }

    if (registration.budget == null) {
      return false;
    }

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

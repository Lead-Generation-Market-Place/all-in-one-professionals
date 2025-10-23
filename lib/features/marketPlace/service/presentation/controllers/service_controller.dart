import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/features/authentication/presentation/controllers/auth_user_controller.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/location_data_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/professional_services_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/answer_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/mile_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/minute_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/professional_services_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/vehicle_type_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/add_answers_usecase.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/add_location.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/add_service_pricing_usecase.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/delete_pro_service_usecase.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/get_all_Minute_use_case.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/get_all_miles.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/get_all_vehicle_type_use_case.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/get_services_location_of_authenticated_user.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/professional_services_usecase.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/update_location.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/update_pricing_usecase.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/update_service_usecase.dart';

import 'package:yelpax_pro/shared/widgets/custom_flutter_toast.dart';


import '../../domain/entities/question_entity.dart';
import '../../domain/entities/service_entity.dart';

import '../../domain/entities/subcategory_entity.dart';
import '../../domain/usecases/delete_service_location_use_case.dart';
import '../../domain/usecases/get_all_services.dart';
import '../../domain/usecases/get_all_subcategories.dart';
import '../../domain/usecases/get_questions_for_service.dart';
import '../../domain/usecases/get_services_by_subcategory.dart';
import '../../domain/usecases/add_service_usecase.dart';

class ServiceController extends ChangeNotifier {
  final GetAllSubCategories getAllSubCategories;
  final GetAllServices getAllServices;
  final GetServicesBySubCategory getServicesBySubCategory;
  final GetQuestionsForService getQuestionsForService;

  final AddLocationUseCase addLocation;
  final GetServicesLocationOfAuthenticatedUser
  getServicesLocationOfAuthenticatedUser;
  final UpdateLocationUseCase updateLocationUseCase;
  final GetAllMilesUseCase getAllMilesUseCase;
  final DeleteServiceLocationUseCase deleteServiceLocationUseCase;
  final GetAllMinuteUseCase getAllMinuteUseCase;
  final GetAllVehicleTypeUseCase getAllVehicleTypesUseCase;
  final AuthUserController authController;
  final AddServiceUsecase addServiceUsecase;
  final AddAnswersUsecase addAnswersUsecase;
  final ProfessionalServicesUsecase professionalServicesUsecase;
  final UpdateServiceUsecase updateServiceUsecase;
  final AddServicePricingUsecase addServicePricingUsecase;
  final DeleteProServiceUsecase deleteProServiceUsecase;
  final UpdatePricingUsecase updateServicePricingUsecase;
  ServiceController({
    required this.getAllSubCategories,
    required this.getAllServices,
    required this.getServicesBySubCategory,
    required this.getQuestionsForService,

    required this.addLocation,
    required this.getServicesLocationOfAuthenticatedUser,
    required this.updateLocationUseCase,
    required this.getAllMilesUseCase,
    required this.deleteServiceLocationUseCase,
    required this.getAllMinuteUseCase,
    required this.getAllVehicleTypesUseCase,
    required this.authController,
    required this.addServiceUsecase,
    required this.addAnswersUsecase,
    required this.professionalServicesUsecase,
    required this.updateServiceUsecase,
    required this.deleteProServiceUsecase,
    required this.addServicePricingUsecase,
    required this.updateServicePricingUsecase
  });
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  // Registration data

  void initializeRegistrationData(String professionalId) {}

  void updateProfessionalId(String professionalId) {}

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
    _selectedSubCategory == null;
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

  Future<void> addService(BuildContext context, String? professionalId) async {
    if (selectedService == null || professionalId == null) {
      CustomFlutterToast.showErrorToast(
        'Service or Professional ID is missing.',
      );
      return;
    }

    try {
      final response = await addServiceUsecase(
        selectedService!.id,
        professionalId,
      );

      Logger().d('Add Service Response: $response');

      // Case 1: response has 'success' key
      if (response.isNotEmpty) {
        final String message =
            response['message'] ?? 'Service added successfully.';
        CustomFlutterToast.showSuccessToast(message);
        Navigator.pushNamed(context, AppRouter.add_location);
        return;
      }

      // Case 2: response contains 'assignedService' key
      if (response.containsKey('assignedService')) {
        CustomFlutterToast.showSuccessToast('Service assigned successfully.');
        Navigator.pushReplacementNamed(context, AppRouter.add_location);
        return;
      }

      // Case 3: fallback for unknown error
      final String message = response['message'] ?? 'Unknown error occurred.';
      CustomFlutterToast.showErrorToast(message);
    } catch (e, stackTrace) {
      Logger().e('Error adding service');
      CustomFlutterToast.showErrorToast('Failed to add service.');
      return Future.error('Failed to add service: $e');
    }
  }


  ///////////-Location-////////////

  List<MileEntity> _miles = [];
  List<MileEntity> get miles => _miles;

  Future<void> fetchAllMiles() async {
    _isLoading = true;
    // notifyListeners();

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
      Logger().d('fetch Questions === $_questions');
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

    notifyListeners();
  }

  Future<void> submitAnswers(BuildContext context) async {
    final authUserController = Provider.of<AuthUserController>(
      context,
      listen: false,
    );

    if (isSubmitting) return;

    isSubmitting = true;
    submitError = null;
    notifyListeners();

    try {
      // ✅ Validate required questions
      for (final question in _questions) {
        final answer = _answers[question.id];
        if (question.required) {
          if (answer == null ||
              (answer is String && answer.trim().isEmpty) ||
              (answer is List && answer.isEmpty)) {
            throw Exception('Please answer all required questions');
          }
        }
      }

      final String serviceId = selectedService!.id;

      // ✅ Extract location IDs from serviceLocations
      final List<String> locationIds = serviceLocations
          .where((location) => location.id != null)
          .map((location) => location.id!)
          .toList();

      // ✅ Prepare answer entities with service location IDs
      final List<AnswerEntity> answerEntities = _answers.entries.map((entry) {
        final questionId = entry.key;
        final answerValue = entry.value;

        return AnswerEntity(
          userId: null,
          questionId: questionId,
          professionalId: authUserController.professionalId.value,
          serviceId: serviceId,
          serviceLocationIds: locationIds,
          answers: answerValue,
          createdAt: DateTime.now(),
        );
      }).toList();

      // ✅ Submit answers
      final response = await addAnswersUsecase(answerEntities);

      if (response['success'] == true) {
        CustomFlutterToast.showSuccessToast('Answers submitted successfully!');
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouter.homeServicesServices,
          (route) => false,
        );
      } else {
        CustomFlutterToast.showErrorToast('Error submitting answers.');
      }
    } catch (e) {
      submitError = e.toString();
      CustomFlutterToast.showErrorToast('Failed to submit answers: $e');
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  List<ProfessionalServicesEntity> _professionalServices = [];
  List<ProfessionalServicesEntity> get professionalServices =>
      _professionalServices;

  Future<void> professionalServicesList(String professionalId) async {
    if (professionalId.isEmpty) {
      Logger().w('Professional ID is null or empty. Cannot fetch services.');
      return;
    }

    try {
      final response = await professionalServicesUsecase(professionalId);
      _professionalServices = response;
      Logger().i('Loaded professional services: $_professionalServices');
      notifyListeners();
    } catch (e) {
      Logger().e('Error loading professional services: $e');
    }
  }

  Future<void> previousSubcategoryAndService(
    ServiceEntity service,
    SubCategoryEntity subcategoryEntity,
  ) async {
    try {
      // Set the selected subcategory
      _selectedSubCategory = subcategoryEntity;
      notifyListeners();

      // Ensure services are loaded
      if (_services.isEmpty) {
        await fetchAllServices();
      }

      // Find the matching service by ID
      final matchingService = _services.firstWhere(
        (s) => s.id == service.id,
        orElse: () => service,
      );

      _selectedService = matchingService;
      notifyListeners();
    } catch (e) {
      Logger().e('Error setting previous subcategory and service: $e');
      // Fallback: set the provided values directly
      _selectedSubCategory = subcategoryEntity;
      _selectedService = service;
      notifyListeners();
    }
  }

  Future<void> updateService(
    BuildContext context,
    String proServicesId,
    String professionalId,
    ProfessionalServicesModel service,
  ) async {
    try {
      final response = await updateServiceUsecase(
        proServicesId,
        selectedService!.id,
      );
      Logger().d('asdfasdfasdfasdfa $response');

      final bool success = response['success'] == true;
      if (success) {
        final String message =
            response['message'] ?? 'Service update successfully.';
        CustomFlutterToast.showSuccessToast(message);
        professionalServicesList(professionalId);
        Navigator.pushNamed(
          context,
          AppRouter.add_location,
          arguments: service,
        );
      } else if (response.containsKey('assignedService')) {
        CustomFlutterToast.showSuccessToast('Service update successfully.');
        Navigator.pushNamed(
          context,
          AppRouter.add_location,
          arguments: service,
        );
      } else {
        final String message = response['message'] ?? 'Unknown error occurred.';
        CustomFlutterToast.showErrorToast(message);
      }
    } catch (e) {
      print('Error adding service: $e');
      CustomFlutterToast.showErrorToast('Failed to add service.');
      return Future.error('Failed to add service: $e');
    }
  }

  Future<void> deleteService(
    String proServicesId,
    String professionalId,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      await deleteProServiceUsecase(proServicesId);
      Logger().d('Delete service executed for id: $proServicesId');

      await professionalServicesList(professionalId);
      CustomFlutterToast.showSuccessToast('Service deleted successfully');
    } catch (e) {
      Logger().e('Error deleting service: $e');
      CustomFlutterToast.showErrorToast('Error deleting service.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  final TextEditingController maxPriceController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController completedTasksController =
      TextEditingController();

  String? selectedPricingType;

  final List<String> pricingTypes = [
    "fixed",
    "hourly",
    "per_project",
    "custom",
  ];

  Future<bool> savePricing(String? professionalId, String serviceId) async {
    try {
      await addServicePricingUsecase(
        professionalId: professionalId!,
        serviceId: serviceId,
        maxPrice: double.tryParse(maxPriceController.text) ?? 0.0,
        minPrice: double.tryParse(minPriceController.text) ?? 0.0,
        description: descriptionController.text.trim(),
        pricingType: selectedPricingType ?? 'fixed',
        completedTasks: int.tryParse(completedTasksController.text) ?? 0,
      );
      CustomFlutterToast.showSuccessToast('Pricing saved successfully');
      clearPricingFields();
      return true;
    } catch (e) {
      Logger().e('Error saving pricing: $e');
      CustomFlutterToast.showErrorToast('Failed to save pricing');
      return false;
    }
  }

  void clearPricingFields() {
    maxPriceController.clear();
    minPriceController.clear();
    descriptionController.clear();
    completedTasksController.clear();
    selectedPricingType = null;
    notifyListeners();
  }

  Future<void> updateServicePricing(
    String? professionalId,
    String serviceId,
  ) async {
    try {
      await updateServicePricingUsecase(
        professionalId: professionalId!,
        serviceId: serviceId,
        maxPrice: double.tryParse(maxPriceController.text) ?? 0.0,
        minPrice: double.tryParse(minPriceController.text) ?? 0.0,
        description: descriptionController.text.trim(),
        pricingType: selectedPricingType ?? 'fixed',
        completedTasks: int.tryParse(completedTasksController.text) ?? 0,
      );
      CustomFlutterToast.showSuccessToast('Pricing updated successfully');
      clearPricingFields();
    } catch (e) {
      Logger().e('Error updating pricing: $e');
      CustomFlutterToast.showErrorToast('Failed to update pricing');
    }
  }
}

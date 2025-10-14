import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/add_location.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/delete_service_location_use_case.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/get_all_miles.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/get_services_location_of_authenticated_user.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/update_location.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/screens/service_location_screens/add_location.dart';

import '../../../../../shared/services/api_service.dart';
import '../datasources/service_remote_datasource_impl.dart';
import '../repositories/service_repository_impl.dart';
import '../../domain/repositories/service_repository.dart';
import '../../domain/usecases/get_all_services.dart';
import '../../domain/usecases/get_all_subcategories.dart';
import '../../domain/usecases/get_questions_for_service.dart';
import '../../domain/usecases/get_services_by_subcategory.dart';
import '../../domain/usecases/submit_service_registration.dart';
import '../../presentation/controllers/service_controller.dart';

// Simple dependency injection without external packages
class ServiceDIContainer {
  static final ServiceDIContainer _instance = ServiceDIContainer._internal();
  factory ServiceDIContainer() => _instance;
  ServiceDIContainer._internal();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  late final ServiceRemoteDataSourceImpl _remoteDataSource;
  late final ServiceRepository _repository;
  late final GetAllSubCategories _getAllSubCategories;
  late final GetAllServices _getAllServices;
  late final GetServicesBySubCategory _getServicesBySubCategory;
  late final GetQuestionsForService _getQuestionsForService;
  late final SubmitServiceRegistration _submitServiceRegistration;
  late final AddLocationUseCase _addLocation;
  late final GetServicesLocationOfAuthenticatedUser
  _getServicesLocationOfAuthenticatedUser;
  late final UpdateLocationUseCase _updateLocationUseCase;
  late final GetAllMilesUseCase _allMilesUseCase;
  late final DeleteServiceLocationUseCase _deleteServiceLocationUseCase;

  void initialize() {
    if (_initialized) return;

    _remoteDataSource = ServiceRemoteDataSourceImpl(apiService: ApiService());
    _repository = ServiceRepositoryImpl(remoteDataSource: _remoteDataSource);

    _getAllSubCategories = GetAllSubCategories(_repository);
    _getAllServices = GetAllServices(_repository);
    _getServicesBySubCategory = GetServicesBySubCategory(_repository);
    _getQuestionsForService = GetQuestionsForService(_repository);
    _submitServiceRegistration = SubmitServiceRegistration(_repository);
    _addLocation = AddLocationUseCase(_repository);
    _getServicesLocationOfAuthenticatedUser =
        GetServicesLocationOfAuthenticatedUser(_repository);
    _updateLocationUseCase = UpdateLocationUseCase(_repository);
    _allMilesUseCase = GetAllMilesUseCase(_repository);
    _deleteServiceLocationUseCase = DeleteServiceLocationUseCase(_repository);
    _initialized = true;
  }

  ServiceController createServiceController() {
    return ServiceController(
      getAllSubCategories: _getAllSubCategories,
      getAllServices: _getAllServices,
      getServicesBySubCategory: _getServicesBySubCategory,
      getQuestionsForService: _getQuestionsForService,
      submitServiceRegistration: _submitServiceRegistration,
      addLocation: _addLocation,
      getServicesLocationOfAuthenticatedUser:
          _getServicesLocationOfAuthenticatedUser,
      updateLocationUseCase: _updateLocationUseCase,
      getAllMilesUseCase: _allMilesUseCase,
      deleteServiceLocationUseCase: _deleteServiceLocationUseCase
    );
  }
}

final ServiceDIContainer serviceDI = ServiceDIContainer();

void setupServiceDI() {
  serviceDI.initialize();
}

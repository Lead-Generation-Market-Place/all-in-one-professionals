import 'package:get_it/get_it.dart';
import 'package:yelpax_pro/features/authentication/presentation/controllers/auth_user_controller.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/datasources/service_remote_datasource_impl.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/repositories/service_repository_impl.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/service_repository.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/add_answers_usecase.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/add_location.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/add_service_pricing_usecase.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/add_service_usecase.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/delete_pro_service_usecase.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/delete_service_location_use_case.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/get_all_Minute_use_case.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/get_all_miles.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/get_all_services.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/get_all_subcategories.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/get_all_vehicle_type_use_case.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/get_questions_for_service.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/get_services_by_subcategory.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/get_services_location_of_authenticated_user.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/professional_services_usecase.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/update_location.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/update_pricing_usecase.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/update_service_usecase.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/controllers/service_controller.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';

final getIt = GetIt.instance;

void setupServiceDI() {
  // Check if already registered to avoid re-registration
  if (getIt.isRegistered<ServiceRemoteDataSourceImpl>()) {
    return;
  }

  // Register ApiService if not already registered
  if (!getIt.isRegistered<ApiService>()) {
    getIt.registerLazySingleton<ApiService>(() => ApiService());
  }

  // Register Data Sources
  getIt.registerLazySingleton<ServiceRemoteDataSourceImpl>(
    () => ServiceRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );

  // Register Repositories
  getIt.registerLazySingleton<ServiceRepository>(
    () => ServiceRepositoryImpl(
      remoteDataSource: getIt<ServiceRemoteDataSourceImpl>(),
    ),
  );

  // Register Use Cases
  getIt.registerLazySingleton<GetAllSubCategories>(
    () => GetAllSubCategories(getIt<ServiceRepository>()),
  );

  getIt.registerLazySingleton<GetAllServices>(
    () => GetAllServices(getIt<ServiceRepository>()),
  );

  getIt.registerLazySingleton<GetServicesBySubCategory>(
    () => GetServicesBySubCategory(getIt<ServiceRepository>()),
  );

  getIt.registerLazySingleton<GetQuestionsForService>(
    () => GetQuestionsForService(getIt<ServiceRepository>()),
  );

  getIt.registerLazySingleton<AddLocationUseCase>(
    () => AddLocationUseCase(getIt<ServiceRepository>()),
  );

  getIt.registerLazySingleton<GetServicesLocationOfAuthenticatedUser>(
    () => GetServicesLocationOfAuthenticatedUser(getIt<ServiceRepository>()),
  );

  getIt.registerLazySingleton<UpdateLocationUseCase>(
    () => UpdateLocationUseCase(getIt<ServiceRepository>()),
  );

  getIt.registerLazySingleton<GetAllMilesUseCase>(
    () => GetAllMilesUseCase(getIt<ServiceRepository>()),
  );

  getIt.registerLazySingleton<DeleteServiceLocationUseCase>(
    () => DeleteServiceLocationUseCase(getIt<ServiceRepository>()),
  );

  getIt.registerLazySingleton<GetAllMinuteUseCase>(
    () => GetAllMinuteUseCase(getIt<ServiceRepository>()),
  );

  getIt.registerLazySingleton<GetAllVehicleTypeUseCase>(
    () => GetAllVehicleTypeUseCase(getIt<ServiceRepository>()),
  );

  getIt.registerLazySingleton<AddServiceUsecase>(
    () => AddServiceUsecase(getIt<ServiceRepository>()),
  );

  getIt.registerLazySingleton<AddAnswersUsecase>(
    () => AddAnswersUsecase(getIt<ServiceRepository>()),
  );

  getIt.registerLazySingleton<ProfessionalServicesUsecase>(
    () => ProfessionalServicesUsecase(getIt<ServiceRepository>()),
  );

  getIt.registerLazySingleton<UpdateServiceUsecase>(
    () => UpdateServiceUsecase(getIt<ServiceRepository>()),
  );

  getIt.registerLazySingleton<DeleteProServiceUsecase>(
    () => DeleteProServiceUsecase(getIt<ServiceRepository>()),
  );

  getIt.registerLazySingleton<AddServicePricingUsecase>(
    () => AddServicePricingUsecase(getIt<ServiceRepository>()),
  );

  getIt.registerLazySingleton<UpdatePricingUsecase>(
    () => UpdatePricingUsecase(getIt<ServiceRepository>()),
  );
}

/// Create ServiceController using GetIt
ServiceController createServiceControllerWithGetIt(
  AuthUserController authController,
) {
  return ServiceController(
    getAllSubCategories: getIt<GetAllSubCategories>(),
    getAllServices: getIt<GetAllServices>(),
    getServicesBySubCategory: getIt<GetServicesBySubCategory>(),
    getQuestionsForService: getIt<GetQuestionsForService>(),
    addLocation: getIt<AddLocationUseCase>(),
    getServicesLocationOfAuthenticatedUser:
        getIt<GetServicesLocationOfAuthenticatedUser>(),
    updateLocationUseCase: getIt<UpdateLocationUseCase>(),
    getAllMilesUseCase: getIt<GetAllMilesUseCase>(),
    deleteServiceLocationUseCase: getIt<DeleteServiceLocationUseCase>(),
    getAllMinuteUseCase: getIt<GetAllMinuteUseCase>(),
    getAllVehicleTypesUseCase: getIt<GetAllVehicleTypeUseCase>(),
    authController: authController,
    addServiceUsecase: getIt<AddServiceUsecase>(),
    addAnswersUsecase: getIt<AddAnswersUsecase>(),
    professionalServicesUsecase: getIt<ProfessionalServicesUsecase>(),
    updateServiceUsecase: getIt<UpdateServiceUsecase>(),
    deleteProServiceUsecase: getIt<DeleteProServiceUsecase>(),
    addServicePricingUsecase: getIt<AddServicePricingUsecase>(),
    updateServicePricingUsecase: getIt<UpdatePricingUsecase>(),
  );
}

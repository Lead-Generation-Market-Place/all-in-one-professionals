import 'package:yelpax_pro/features/marketPlace/service/data/datasource/category_data_source.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/datasource/question_data_source.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/datasource/service_data_source.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/datasource/subcategory_data_source.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/repositoryImpl/category_repository_impl.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/repositoryImpl/services_repository_impl.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/repositoryImpl/sub_category_repository_impl.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/category_use_case.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/services_usecase.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/usecases/sub_category_usecase.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/controllers/service_controller.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';

ServiceController createServiceController() {
  final apiService = ApiService();

  // Data sources
  final subcategoryDataSource = SubcategoryRemoteDataSourceImpl(apiService);
  final categoryDataSource = CategoryDataSourceImpl(apiService);

  // Repositories
  final subcategoryRepository = SubCategoryRepositoryImpl(
    subcategoryDataSource,
  );
  final categoryRepository = CategoryRepositoryImpl(categoryDataSource);

  // Usecases
  final subCategoryUsecase = SubCategoryUsecase(subcategoryRepository);
  final categoryUsecase = CategoryUsecase(categoryRepository);

  // Instantiate your ServicesUsecase similarly, assuming you have datasource, repo, etc.
  // This part depends on your existing architecture.
  final servicesDataSource = ServiceRemoteDataSourceImpl(apiService);
  final servicesRepository = ServicesRepositoryImpl(servicesDataSource);
  final serviceUsecase = ServicesUsecase(servicesRepository);
  final questionDataSource = QuestionDataSourceImpl(apiService: apiService);
  return ServiceController(
    subCategoryUsecase: subCategoryUsecase,
    categoryUsecase: categoryUsecase,
    serviceUsecase: serviceUsecase,
    questionDataSource: questionDataSource,
  );
}

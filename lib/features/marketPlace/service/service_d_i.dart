import 'package:yelpax_pro/features/marketPlace/service/presentation/controllers/service_controller.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';

ServiceController createServiceController() {
  final ApiService apiService = ApiService();
  return ServiceController(apiService: apiService);
}

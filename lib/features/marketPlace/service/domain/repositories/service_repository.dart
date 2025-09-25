import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/service_entity.dart';

abstract class ServiceRepository {
  Future<List<ServiceEntity>> fetchServices(); 
}
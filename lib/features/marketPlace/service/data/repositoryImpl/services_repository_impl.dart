import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/datasource/service_data_source.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/model/service_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/service_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/service_repository.dart';

class ServicesRepositoryImpl implements ServiceRepository {
  final  ServiceDataSource servicesDatasource;

  ServicesRepositoryImpl(this.servicesDatasource);
  
  @override
  Future<List<ServiceEntity>> fetchServices() {
    return servicesDatasource.fetchServices();
  }

  

}
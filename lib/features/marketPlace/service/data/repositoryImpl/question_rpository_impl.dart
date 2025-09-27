import 'package:yelpax_pro/features/marketPlace/service/data/datasource/question_data_source.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/question_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/question_repository.dart';

class QuestionRepositoryImpl extends QuestionRepository {
  final QuestionDataSource dataSource;

  QuestionRepositoryImpl(this.dataSource);

  @override
  Future<List<QuestionEntity>> getQuestions(String serviceId) {
    return dataSource.getQuestions(serviceId);
  }
}
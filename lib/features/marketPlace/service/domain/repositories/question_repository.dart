import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/question_entity.dart';

abstract class QuestionRepository {
  Future<List<QuestionEntity>> getQuestions(String serviceId);
}
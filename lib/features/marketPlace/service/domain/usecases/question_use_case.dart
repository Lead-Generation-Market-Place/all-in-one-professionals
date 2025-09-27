import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/question_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/question_repository.dart';

class QuestionUseCase {
  final QuestionRepository repository;

  QuestionUseCase(this.repository);

  Future<List<QuestionEntity>> call(String serviceId) {
    return repository.getQuestions(serviceId);
  }
}
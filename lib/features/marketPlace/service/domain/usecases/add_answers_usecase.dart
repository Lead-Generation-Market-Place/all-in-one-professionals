import 'package:yelpax_pro/features/marketPlace/service/domain/entities/answer_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/service_repository.dart';

class AddAnswersUsecase {
  final ServiceRepository repository;
  AddAnswersUsecase(this.repository);

  Future<Map<String, dynamic>> call(List<AnswerEntity> answerEntities) async {
    return await repository.sendAnswers(answerEntities);
  }
}


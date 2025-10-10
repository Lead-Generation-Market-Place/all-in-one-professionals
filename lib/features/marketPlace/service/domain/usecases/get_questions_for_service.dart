import '../entities/question_entity.dart';
import '../repositories/service_repository.dart';

class GetQuestionsForService {
  final ServiceRepository repository;

  GetQuestionsForService(this.repository);

  Future<List<QuestionEntity>> call(String serviceId) async {
    return await repository.getQuestionsForService(serviceId);
  }
}

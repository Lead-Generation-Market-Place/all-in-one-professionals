import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/model/question_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/question_entity.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';

abstract class QuestionDataSource {
  Future<List<QuestionEntity>> getQuestions(String serviceId);
}

class QuestionDataSourceImpl implements QuestionDataSource {
  final ApiService apiService;

  QuestionDataSourceImpl({required this.apiService});

  @override
  Future<List<QuestionEntity>> getQuestions(String serviceId) async {
    try {
      // Use query parameter instead of path parameter
      Logger().d('Fetching questions for service ID: $serviceId');
      final response = await apiService.get(
        'questions/service/$serviceId',
      );

      Logger().d('Questions API Response: ${response.statusCode}');
      Logger().d('Questions API Data: ${response.data}');

      // Check if the response was successful
      if (response.statusCode != 200) {
        // Handle 404 specifically - no questions found
        if (response.statusCode == 404) {
          Logger().d('No questions found for service $serviceId');
          return [];
        }
        throw Exception(
          'Server returned ${response.statusCode}: ${response.data}',
        );
      }

      // Check if response is HTML (error page) instead of JSON
      if (response.data is String &&
          (response.data as String).contains('<!DOCTYPE html>')) {
        throw Exception('Server returned HTML error page instead of JSON');
      }

      // Handle the response structure with 'data' wrapper
      if (response.data is Map<String, dynamic>) {
        if (response.data['error'] == true) {
          throw Exception('API Error: ${response.data['message']}');
        }

        if (response.data['data'] != null) {
          final List<dynamic> questionsData = response.data['data'];
          return questionsData
              .map((questionJson) => QuestionModel.fromJson(questionJson))
              .map((questionModel) => questionModel.toEntity())
              .toList();
        }
      }

      // If we get here, the response format is unexpected
      throw Exception('Invalid response format: ${response.data}');
    } on DioException catch (e) {
      Logger().e('DioError in getQuestions: ${e.message}');
      Logger().e('DioError Response: ${e.response?.data}');

      // More specific error handling
      if (e.response != null) {
        if (e.response!.statusCode == 404) {
          Logger().d('No questions found for service $serviceId (404)');
          return []; // No questions found is not an error
        }
      }

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      Logger().e('Unexpected error in getQuestions: $e');
      throw Exception('Failed to load questions: $e');
    }
  }
}

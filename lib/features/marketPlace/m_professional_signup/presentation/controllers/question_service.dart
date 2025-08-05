  // lib/services/service_question_service.dart

  class ServiceQuestions {
    Future<List<Map<String, dynamic>>> fetchQuestions() async {
      // Simulating local JSON for now.
      await Future.delayed(Duration(milliseconds: 500));
      return [
        {
          "form_id": 1,
          "service_id": 1,
          "step": 1,
          "form_type": "radio",
          "question": "What type of service do you provide?",
          "options": ["Plumbing", "Electrical", "Cleaning"],
          "form_group": "category"
        },
        {
          "form_id": 2,
          "service_id": 1,
          "step": 2,
          "form_type": "checkbox",
          "question": "What days do you work?",
          "options": ["Mon", "Tue", "Wed", "Thu", "Fri"],
          "form_group": "availability"
        },
      ];
    }

    Future<bool> submitAnswers(List<Map<String, dynamic>> answers) async {
      await Future.delayed(Duration(seconds: 1)); // Simulate API call
      print("Submitted Answers: $answers");
      return true;
    }
  }

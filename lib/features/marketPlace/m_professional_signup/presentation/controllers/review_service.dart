import 'package:http/http.dart' as http;

class ReviewService {
  final String baseUrl;

  ReviewService({required this.baseUrl});

  Future<void> sendReviewRequest({
    required String recipientEmail,
    required String userName,
    required String reviewLink,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/send-review-request'),
      headers: {'Content-Type': 'application/json'},
      body: '''{
        "recipientEmail": "$recipientEmail",
        "userName": "$userName",
        "reviewLink": "$reviewLink"
      }''',
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to send email.');
    }
  }
}

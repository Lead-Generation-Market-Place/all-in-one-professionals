import 'dart:convert';

void main() {
  // Sample API response
  const jsonResponse = '''
  {
    "message": "Service pricing updated successfully",
    "data": {
        "_id": "68fa431909296f42d82ad3e4",
        "professional_id": "68e69e207e4abae95a8fc502",
        "service_id": "68eaaf1973f142e5115639f9",
        "location_ids": [],
        "service_status": true,
        "pricing_type": "fixed",
        "completed_tasks": 0,
        "question_ids": [],
        "createdAt": "2025-10-23T15:00:41.338Z",
        "updatedAt": "2025-10-23T15:00:41.338Z"
    }
  }
  ''';

  // Parse JSON
  final Map<String, dynamic> parsed = jsonDecode(jsonResponse);

  // Test method
  void testServicePricingResponse(Map<String, dynamic> response) {
    assert(response.containsKey('message'), 'Message field is missing');
    assert(response.containsKey('data'), 'Data field is missing');

    final data = response['data'];
    assert(data['_id'] != null, '_id is missing');
    assert(data['professional_id'] != null, 'professional_id is missing');
    assert(data['service_id'] != null, 'service_id is missing');
    assert(data['location_ids'] is List, 'location_ids should be a List');
    assert(data['service_status'] is bool, 'service_status should be a bool');
    assert(data['pricing_type'] is String, 'pricing_type should be a String');
    assert(data['completed_tasks'] is int, 'completed_tasks should be an int');
    assert(data['question_ids'] is List, 'question_ids should be a List');
    assert(
      DateTime.tryParse(data['createdAt']) != null,
      'createdAt is invalid',
    );
    assert(
      DateTime.tryParse(data['updatedAt']) != null,
      'updatedAt is invalid',
    );

    print('✅ Service pricing response is valid!');
  }

  // Run test
  testServicePricingResponse(parsed);
}

import 'package:flutter_test/flutter_test.dart';

import 'package:yelpax_pro/features/marketPlace/service/data/models/professional_services_model.dart';

void main() {
  test("testing model", () {
    final sampleData = {
      "professionalServiceId": "68f25ac0e85ad5915b81a376",
      "service": {
        "_id": "68eaad6c73f142e5115639ed",
        "name": "Handyman",
        "slug": "hadyman",
        "description": "Handyman services",
        "image_url": "service_1760023594437.png",
        "is_active": true,
        "is_featured": true,
        "createdAt": "2025-10-11T19:18:04.632Z",
        "updatedAt": "2025-10-11T19:18:04.632Z",
      },
    };
    var res = ProfessionalServicesModel.fromJson(sampleData);

  print("Parsed service name: ${res.serviceEntity}");

    expect("Handyman", res.serviceEntity.name);
  });
}

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
      "subcategory": {
        "_id": "68ee643df632958fbcbdfcaa",
        "name": "General Home Repair",
        "slug": "general_home_repair",
        "category_id": "68e7ca35f162244284796406",
      },
      "professionalServiceDetails": {
        "locations": [
          {
            "_id": "68f24211630cb313b179a126",
            "type": "service",
            "professional_id": "68e69e207e4abae95a8fc502",
            "service_id": "68eaad6c73f142e5115639ed",
            "country": "Germany",
            "state": "",
            "city": "Geseke",
            "zipcode": "59590",
            "address_line": "59590 Geseke, Germany",
            "mile_id": "68ed5aa3037f5c15f5118bbf",
            "mile": 1,
            "minute_id": "68efa0b3fab3455995dce7fc",
            "minute": 25,
            "vehicle_type_id": "68efa120fab3455995dce805",
            "vehicle_type": "Driving",
            "coordinates": {
              "type": "Point",
              "coordinates": [8.5067607, 51.6393693],
            },
          },
          {
            "_id": "68f2574ae2dbc9cf45db79db",
            "type": "service",
            "professional_id": "68e69e207e4abae95a8fc502",
            "service_id": "68eaad6c73f142e5115639ed",
            "country": "Germany",
            "state": "",
            "city": "Freiburg im Breisgau",
            "zipcode": "79",
            "address_line": "79 Freiburg im Breisgau, Germany",
            "mile_id": "68ed5abc037f5c15f5118bc3",
            "mile": 3,
            "minute_id": "68efa0c6fab3455995dce7ff",
            "minute": 40,
            "vehicle_type_id": "68efa12cfab3455995dce807",
            "vehicle_type": "Public Transport",
            "coordinates": {
              "type": "Point",
              "coordinates": [7.842104299999999, 47.9990077],
            },
          },
        ],
        "maximum_price": null,
        "minimum_price": null,
        "pricing_type": "fixed",
        "service_status": true,
        "description": "",
        "completed_tasks": 0,
      },
      "questions": [
        {
          "_id": "68efad801ed0471bc3761170",
          "question_name": "Re-Structuring the objects in the room",
          "form_type": "checkbox",
          "options": ["1 Room", "2 Room", "5 Rooms"],
          "required": true,
          "order": 1,
          "answer": ["1 Room"],
        },
        {
          "_id": "68efb5581ed0471bc3761182",
          "question_name": "Cooking Egg How Much Time Needed",
          "form_type": "date",
          "options": [],
          "required": false,
          "order": 1,
          "answer": "sbd",
        },
      ],
      "createdAt": "2025-10-17T15:03:28.497Z",
      "updatedAt": "2025-10-17T15:03:43.065Z",
    };
    var res = ProfessionalServicesModel.fromJson(sampleData);
  
    print("Parsed service name: ${res.subCategoryEntity.categoryId}");

    expect("Handyman", res.serviceEntity.name);
  });
}

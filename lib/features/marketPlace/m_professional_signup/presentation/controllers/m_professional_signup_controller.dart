import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/controllers/question_service.dart';
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/controllers/review_service.dart';
import '../../data/service_questions.dart';
import 'm_professional_service.dart';

enum AvailabilityType { businessHours, anyTime }

class ProfessionalSignUpProvider extends ChangeNotifier {
  final ProfessionalService? professionalService;
  final ReviewService? reviewService;

  final ServiceQuestions? serviceQuestions;

  ProfessionalSignUpProvider({
    this.professionalService,
    this.serviceQuestions,
    this.reviewService,
  }) {
    _loadQuestions();
  }
void setBusinessImage(String path) {
    businessImageUrl = path;
    notifyListeners();
  }

  // Controllers
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController employeesCountController =
      TextEditingController();
  final TextEditingController businessDetailsInformation =
      TextEditingController();

  // Service (business logic)

  // Image
  final ImagePicker _picker = ImagePicker();
  String businessImageUrl = '';

  // Business type (delegated to service)
  void setBusinessType(String type) {
    professionalService?.setBusinessType(type);
    notifyListeners();
  }

  String? get selectedBusinessType => professionalService?.selectedBusinessType;

  // Image Picker
  Future<void> showImagePickerBottomSheet(BuildContext context) async {
    final permissionStatus = await _checkPermissions();
    if (!permissionStatus) return;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 180,
        maxHeight: 180,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        businessImageUrl = pickedFile.path;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
    }
  }

  Future<bool> _checkPermissions() async {
    try {
      if (Platform.isAndroid) {
        if (await Permission.camera.request().isGranted &&
            (await Permission.photos.request().isGranted ||
                await Permission.storage.request().isGranted)) {
          return true;
        }
      } else if (Platform.isIOS) {
        final photosStatus = await Permission.photos.request();
        final cameraStatus = await Permission.camera.request();
        return photosStatus.isGranted && cameraStatus.isGranted;
      }
      return false;
    } catch (e) {
      debugPrint('Permission error: $e');
      return false;
    }
  }

  // Availability logic
  AvailabilityType selectedType = AvailabilityType.anyTime;
  bool isLoading = false;
  bool isEditing = false;

  Map<String, bool> selectedDays = {
    'Sun': true,
    'Mon': true,
    'Tues': true,
    'Wed': true,
    'Thurs': true,
    'Fri': true,
    'Sat': true,
  };

  Map<String, bool> editingDays = {
    'Sun': false,
    'Mon': false,
    'Tues': false,
    'Wed': false,
    'Thurs': false,
    'Fri': false,
    'Sat': false,
  };

  Map<String, String> availability = {
    'Sun': '4 am - midnight',
    'Mon': '4 am - midnight',
    'Tues': '4 am - midnight',
    'Wed': '4 am - midnight',
    'Thurs': '4 am - midnight',
    'Fri': '4 am - midnight',
    'Sat': '4 am - midnight',
  };

  Map<String, Map<String, String>> tempTimes = {
    'Sun': {'start': '4 am', 'end': 'midnight'},
    'Mon': {'start': '4 am', 'end': 'midnight'},
    'Tues': {'start': '4 am', 'end': 'midnight'},
    'Wed': {'start': '4 am', 'end': 'midnight'},
    'Thurs': {'start': '4 am', 'end': 'midnight'},
    'Fri': {'start': '4 am', 'end': 'midnight'},
    'Sat': {'start': '4 am', 'end': 'midnight'},
  };

  // Settings
  String leadTimeNotice = '1 day';
  String leadTimeAdvance = '24 months';
  String timeZone = 'Pacific Time Zone';
  String jobsPerSlot = '1 job';
  String travelTime = '30 minutes';

  // Time options
  final List<String> startTimeOptions = [
    '12 am',
    '1 am',
    '2 am',
    '3 am',
    '4 am',
    '5 am',
    '6 am',
    '7 am',
    '8 am',
    '9 am',
    '10 am',
    '11 am',
    '12 pm',
    '1 pm',
    '2 pm',
    '3 pm',
    '4 pm',
    '5 pm',
    '6 pm',
    '7 pm',
    '8 pm',
    '9 pm',
    '10 pm',
    '11 pm',
  ];

  final List<String> endTimeOptions = [
    '12 am',
    '1 am',
    '2 am',
    '3 am',
    '4 am',
    '5 am',
    '6 am',
    '7 am',
    '8 am',
    '9 am',
    '10 am',
    '11 am',
    '12 pm',
    '1 pm',
    '2 pm',
    '3 pm',
    '4 pm',
    '5 pm',
    '6 pm',
    '7 pm',
    '8 pm',
    '9 pm',
    '10 pm',
    '11 pm',
    'midnight',
  ];

  void toggleDayEditing(String day) {
    if (!editingDays[day]!) {
      editingDays.updateAll((key, value) => false);
    }
    editingDays[day] = !editingDays[day]!;
    if (editingDays[day]!) {
      final times = availability[day]!.split(' - ');
      tempTimes[day] = {'start': times[0], 'end': times[1]};
    }
    notifyListeners();
  }

  void updateDayTime(String day) {
    availability[day] =
        '${tempTimes[day]!['start']} - ${tempTimes[day]!['end']}';
    editingDays[day] = false;
    notifyListeners();
  }

  void applyToSelectedDays(String fromDay) {
    selectedDays.forEach((day, isSelected) {
      if (isSelected && day != fromDay) {
        tempTimes[day] = Map.from(tempTimes[fromDay]!);
        availability[day] =
            '${tempTimes[fromDay]!['start']} - ${tempTimes[fromDay]!['end']}';
      }
    });
    notifyListeners();
  }

  void updateDaySelection(String day, bool? value) {
    selectedDays[day] = value ?? false;
    notifyListeners();
  }

  void setAvailabilityType(AvailabilityType type) {
    selectedType = type;
    isEditing = type == AvailabilityType.businessHours;
    notifyListeners();
  }

  void onBusinessNameChanged(String value) {}

  List<String> emails = [''];
  int? sendingIndex;
  String? username = '';
  String? userId = '2222';
  String businessName = 'Servicyee';
  bool copied = false;
  String userImageUrl = '';
  void addEmailField() {
    emails.add('');
    notifyListeners();
  }

  void updateEmail(int index, String value) {
    emails[index] = value;
    notifyListeners();
  }

  Future<void> sendEmail(int index) async {
    final email = emails[index];
    if (!email.contains('@')) {
      throw Exception('Invalid email address');
    }

    sendingIndex = index;
    notifyListeners();

    try {
      final reviewLink =
          'https://yourdomain.com/ask-reviews/services/$userId/reviews';

      await reviewService?.sendReviewRequest(
        recipientEmail: email,
        userName: businessName,
        reviewLink: reviewLink,
      );
    } finally {
      sendingIndex = null;
      notifyListeners();
    }
  }

  void copyLink() {
    copied = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 2), () {
      copied = false;
      notifyListeners();
    });
  }

  String get reviewLink =>
      'https://yourdomain.com/home-services/services/step-6/$userId';

  List<ServiceQuestion> _questions = [];
  Map<String, dynamic> _answers = {};
  bool _isLoading = true;
  bool _isSubmitting = false;

  List<ServiceQuestion> get questions => _questions;
  Map<String, dynamic> get answers => _answers;

  bool get isSubmitting => _isSubmitting;

  Future<void> _loadQuestions() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate loading from local JSON
      await Future.delayed(Duration(milliseconds: 500));

      final jsonData = [
        {
          "form_id": 101,
          "service_id": 5,
          "step": 5,
          "form_type": "radio",
          "question": "How much help do you need?",
          "options": [
            "Less than 2 hours (Simple tasks)",
            "2 -5 hours (A few different projects)",
            "A full day (Complex or long-term projects)",
          ],
          "form_group": "help_duration",
        },
        {
          "form_id": 102,
          "service_id": 5,
          "step": 5,
          "form_type": "checkbox",
          "question": "What needs work?",
          "options": [
            "Doors",
            "Windows",
            "Walls (inside)",
            "Walls (outside)",
            "Gutters",
            "Cabinets",
            "Shelving",
            "Molding or baseboards",
            "Flooring",
            "Tiling",
            "Appliances",
            "Plumbing",
            "Electrical",
            "Lighting",
            "Wall hangings",
            "Furniture",
            "Other",
          ],
          "form_group": "work_needs",
        },
        {
          "form_id": 103,
          "service_id": 5,
          "step": 5,
          "form_type": "checkbox",
          "question": "Which areas of the home need work?",
          "options": [
            "Bathroom",
            "Kitchen",
            "Living room",
            "Bedroom",
            "Basement",
            "Attic",
            "Garage",
            "Deck or porch",
            "Closet",
            "Other",
          ],
          "form_group": "home_areas",
        },
        {
          "form_id": 104,
          "service_id": 5,
          "step": 5,
          "form_type": "radio",
          "question": "Is this a home or a business?",
          "options": ["Home", "Business"],
          "form_group": "property_type",
        },
        {
          "form_id": 105,
          "service_id": 5,
          "step": 5,
          "form_type": "radio",
          "question": "What's your timeline?",
          "options": [
            "Need a pro right away** (Within 48 hours)",
            "Ready to hire (not urgent)* (Within a week)",
            "Researching options* (Flexible on timeline)",
          ],
          "form_group": "timeline",
        },
        {
          "form_id": 106,
          "service_id": 5,
          "step": 5,
          "form_type": "checkbox",
          "question": "What do you need help with?",
          "options": [
            "Repairs",
            "Installation",
            "Maintenance",
            "Assembly",
            "Painting",
            "Cleaning",
            "Other",
          ],
          "form_group": "help_type",
        },
      ];

      _questions = jsonData.map((q) => ServiceQuestion.fromMap(q)).toList();

      // Initialize answers
      _answers = {};
      for (var question in _questions) {
        _answers[question.formId.toString()] = question.formType == 'checkbox'
            ? []
            : question.options.isNotEmpty
            ? question.options[0]
            : '';
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void updateAnswer(String formId, dynamic value) {
    _answers[formId] = value;
    notifyListeners();
  }

  Future<bool> submitAnswers() async {
    try {
      _isSubmitting = true;
      notifyListeners();

      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      // Prepare payload similar to React version
      final payload = _questions
          .map(
            (q) => {
              'form_id': q.formId,
              'service_id': q.serviceId,
              'answer': _answers[q.formId.toString()],
            },
          )
          .toList();

      print("Submitted Answers: $payload");

      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  // void setBusinessImage(String path) {
  //   businessImageUrl = path;
  //   notifyListeners();
  // }

}

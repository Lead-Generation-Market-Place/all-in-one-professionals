import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
enum AvailabilityType { businessHours, anyTime }
class ProfessionalSignUpProvider extends ChangeNotifier {
  String businessImageUrl = '';
  TextEditingController businessNameController = TextEditingController();
  TextEditingController employeesCountController = TextEditingController();
  TextEditingController businessDetailsInformation = TextEditingController();


  final ImagePicker _picker = ImagePicker();

  void onBusinessNameChanged(String value) {
    notifyListeners();
  }

  Future<void> showImagePickerBottomSheet(BuildContext context) async {
    // Check and request permissions first
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
      // You might want to show an error to the user here
    }
  }

  Future<bool> _checkPermissions() async {
    try {
      if (Platform.isAndroid) {
        // For Android 13+ we need different permissions
        if (await Permission.camera.request().isGranted) {
          if (await Permission.photos.request().isGranted ||
              await Permission.storage.request().isGranted) {
            return true;
          }
        }
        return false;
      } else if (Platform.isIOS) {
        // For iOS
        final photosStatus = await Permission.photos.request();
        final cameraStatus = await Permission.camera.request();
        return photosStatus.isGranted && cameraStatus.isGranted;
      }
      return true;
    } catch (e) {
      debugPrint('Permission error: $e');
      return false;
    }
  }

  String? selectedBusinessType;

  void setBusinessType(String type) {
    selectedBusinessType = type;
    notifyListeners();
  }















  AvailabilityType selectedType = AvailabilityType.anyTime;
  bool isLoading = false;
  bool isEditing = false;

  // Days and availability
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
  '12 am', '1 am', '2 am', '3 am', '4 am', '5 am', '6 am', '7 am', '8 am',
  '9 am', '10 am', '11 am', '12 pm', '1 pm', '2 pm', '3 pm', '4 pm', '5 pm',
  '6 pm', '7 pm', '8 pm', '9 pm', '10 pm', '11 pm',
  ];

  final List<String> endTimeOptions = [
  '12 am', '1 am', '2 am', '3 am', '4 am', '5 am', '6 am', '7 am', '8 am',
  '9 am', '10 am', '11 am', '12 pm', '1 pm', '2 pm', '3 pm', '4 pm', '5 pm',
  '6 pm', '7 pm', '8 pm', '9 pm', '10 pm', '11 pm', 'midnight',
  ];

  void toggleDayEditing(String day) {
  // Close any other open day editors
  if (!editingDays[day]!) {
  editingDays.forEach((key, value) {
  editingDays[key] = false;
  });
  }
  editingDays[day] = !editingDays[day]!;

  // Initialize temp times with current values
  if (editingDays[day]!) {
  final times = availability[day]!.split(' - ');
  tempTimes[day] = {'start': times[0], 'end': times[1]};
  }
  notifyListeners();
  }

  void updateDayTime(String day) {
  availability[day] = '${tempTimes[day]!['start']} - ${tempTimes[day]!['end']}';
  editingDays[day] = false;
  notifyListeners();
  }

  void applyToSelectedDays(String fromDay) {
  selectedDays.forEach((day, isSelected) {
  if (isSelected && day != fromDay) {
  tempTimes[day] = Map.from(tempTimes[fromDay]!);
  availability[day] = '${tempTimes[fromDay]!['start']} - ${tempTimes[fromDay]!['end']}';
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

  // Add other methods for updating settings...














}

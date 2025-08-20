import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/entities/basic_info_entity.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/entities/business_information_entity.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/usecases/basic_info/get_basic_info_use_case.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/usecases/basic_info/update_basic_info_use_case.dart';

import 'package:yelpax_pro/features/marketPlace/profiles/domain/usecases/business_information/get_business_information_use_case.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/usecases/business_information/update_business_information_use_case.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/usecases/professional_license/get_business_information_use_case.dart';

class ProfileProvider extends ChangeNotifier {
  final GetBasicInfo getBasicInfo;
  final UpdateBasicInfo updateBasicInfo;
  final GetBusinessInfo getBusinessInfo;
  final UpdateBusinessInformation updateBusinessInformation;
  ProfileProvider(
    this.getBasicInfo,
    this.updateBasicInfo,
    this.getBusinessInfo,
    this.updateBusinessInformation,
  );

  String businessImageUrl = '';

  final ImagePicker _picker = ImagePicker();
  final TextEditingController businessNameController = TextEditingController();

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

  void onBusinessNameChanged(String value) {
    businessNameController.text = value;
    notifyListeners();
  }

  Future<void> loadProfile(int id) async {
    final basicInfo = await getBasicInfo(id);

    businessNameController.text = basicInfo.businessName;
    businessImageUrl = basicInfo.businessProfileUrl;
    notifyListeners();
  }

  Future<void> saveProfile(int id) async {
    final basicInfo = BasicInfoEntity(
      id: id,
      businessName: businessNameController.text,
      businessProfileUrl: businessImageUrl,
    );
    await updateBasicInfo(basicInfo);
    notifyListeners();
  }

  final TextEditingController yearFoundedController = TextEditingController();
  final TextEditingController employeesController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController suiteController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();

  List<String> selectedPaymentMethods = [];
  final List<String> availablePaymentMethods = [
    'Credit card',
    'Cash',
    'Venmo',
    'Paypal',
    'Square cash app',
    'Check',
    'Apple Pay',
    'Google Pay',
    'Zelle',
    'Samsung Pay',
    'Stripe',
  ];
  String _name = 'John';
  String _companyName = 'Brand Construction Company';

  int _stepNumber = 1;

  int get stepNumber => _stepNumber;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String get name => _name;

  String get companyName => _companyName;

  void updateStepNumber(int updatedStepNumber) {
    _stepNumber = updatedStepNumber;
  }

  void updateLoader(bool updatedLoader) {
    _isLoading = updatedLoader;
  }

  void updateCompanyName(String newCompanyName) {
    _companyName = newCompanyName;
    notifyListeners();
  }

  void updateName(String newName) {
    _name = newName;
    notifyListeners();
  }

  void togglePaymentMethod(String method) {
    if (selectedPaymentMethods.contains(method)) {
      selectedPaymentMethods.remove(method);
    } else {
      selectedPaymentMethods.add(method);
    }
  }

  Future<void> loadBusinessInformation(int id) async {
    final businessInfo = await getBusinessInfo(id);

    yearFoundedController.text = businessInfo.yearFounded.toString();
    employeesController.text = businessInfo.numberOfEmployees?.toString() ?? '';
    phoneController.text = businessInfo.phoneNumber;
    addressController.text = businessInfo.address;
    suiteController.text = businessInfo.suit;
    zipCodeController.text = businessInfo.zipCode;
    websiteController.text = businessInfo.website;

    // ✅ Fix here
    selectedPaymentMethods
      ..clear()
      ..addAll(businessInfo.paymentMethods);

    facebookController.text = businessInfo.facebook;
    twitterController.text = businessInfo.twitter;
    instagramController.text = businessInfo.instagram;

    notifyListeners();
  }

  Future<void> saveBusinessInformation(int id) async {
    final businessInfo = BusinessInformationEntity(
      id: id,
      yearFounded: int.parse(yearFoundedController.text),
      numberOfEmployees: int.parse(employeesController.text),
      phoneNumber: phoneController.text,
      address: addressController.text,
      suit: suiteController.text,
      zipCode: zipCodeController.text,
      website: websiteController.text,
      paymentMethods: selectedPaymentMethods,
      facebook: facebookController.text,
      twitter: twitterController.text,
      instagram: instagramController.text,
    );
    await updateBusinessInformation(businessInfo);
    notifyListeners();
  }

  Future<void> saveBusinessInfo() async {}

  bool hasLoadedFaqs = false;

  void hasLoadedFaqsUpdate(bool updatedHasLoadedFaqs) {
    hasLoadedFaqs = updatedHasLoadedFaqs;
    notifyListeners();
  }

  Future<void> fetchAnsweredBusinessFaqs() async {}

  Future<void> answeredBusinessFaqsQuestion() async {}

  // TextEditingControllers for each question
  final TextEditingController firstBusinessQuestion = TextEditingController();
  final TextEditingController secondBusinessQuestion = TextEditingController();
  final TextEditingController thirdBusinessQuestion = TextEditingController();
  final TextEditingController fourthBusinessQuestion = TextEditingController();
  final TextEditingController fifthBusinessQuestion = TextEditingController();
  final TextEditingController sixthBusinessQuestion = TextEditingController();
  final TextEditingController seventhBusinessQuestion = TextEditingController();
  final TextEditingController eighthBusinessQuestion = TextEditingController();
  final TextEditingController ninthBusinessQuestion = TextEditingController();

  // Tracking typed status and character count for each question
  bool _hasTypedFirstBusiness = false;
  int _firstBusinessCharCount = 0;

  bool _hasTypedSecondBusiness = false;
  int _secondBusinessCharCount = 0;

  bool _hasTypedThirdBusiness = false;
  int _thirdBusinessCharCount = 0;

  bool _hasTypedFourthBusiness = false;
  int _fourthBusinessCharCount = 0;

  bool _hasTypedFifthBusiness = false;
  int _fifthBusinessCharCount = 0;

  bool _hasTypedSixthBusiness = false;
  int _sixthBusinessCharCount = 0;

  bool _hasTypedSeventhBusiness = false;
  int _seventhBusinessCharCount = 0;

  bool _hasTypedEighthBusiness = false;
  int _eighthBusinessCharCount = 0;

  bool _hasTypedNinthBusiness = false;
  int _ninthBusinessCharCount = 0;

  // Getters
  bool get hasTypedFirstBusiness => _hasTypedFirstBusiness;
  int get firstBusinessCharCount => _firstBusinessCharCount;

  bool get hasTypedSecondBusiness => _hasTypedSecondBusiness;
  int get secondBusinessCharCount => _secondBusinessCharCount;

  bool get hasTypedThirdBusiness => _hasTypedThirdBusiness;
  int get thirdBusinessCharCount => _thirdBusinessCharCount;

  bool get hasTypedFourthBusiness => _hasTypedFourthBusiness;
  int get fourthBusinessCharCount => _fourthBusinessCharCount;

  bool get hasTypedFifthBusiness => _hasTypedFifthBusiness;
  int get fifthBusinessCharCount => _fifthBusinessCharCount;

  bool get hasTypedSixthBusiness => _hasTypedSixthBusiness;
  int get sixthBusinessCharCount => _sixthBusinessCharCount;

  bool get hasTypedSeventhBusiness => _hasTypedSeventhBusiness;
  int get seventhBusinessCharCount => _seventhBusinessCharCount;

  bool get hasTypedEighthBusiness => _hasTypedEighthBusiness;
  int get eighthBusinessCharCount => _eighthBusinessCharCount;

  bool get hasTypedNinthBusiness => _hasTypedNinthBusiness;
  int get ninthBusinessCharCount => _ninthBusinessCharCount;

  // Listener setup
  void _setupControllerListeners() {
    firstBusinessQuestion.addListener(() {
      _hasTypedFirstBusiness = firstBusinessQuestion.text.isNotEmpty;
      _firstBusinessCharCount = firstBusinessQuestion.text.length;
      notifyListeners();
    });

    secondBusinessQuestion.addListener(() {
      _hasTypedSecondBusiness = secondBusinessQuestion.text.isNotEmpty;
      _secondBusinessCharCount = secondBusinessQuestion.text.length;
      notifyListeners();
    });

    thirdBusinessQuestion.addListener(() {
      _hasTypedThirdBusiness = thirdBusinessQuestion.text.isNotEmpty;
      _thirdBusinessCharCount = thirdBusinessQuestion.text.length;
      notifyListeners();
    });

    fourthBusinessQuestion.addListener(() {
      _hasTypedFourthBusiness = fourthBusinessQuestion.text.isNotEmpty;
      _fourthBusinessCharCount = fourthBusinessQuestion.text.length;
      notifyListeners();
    });

    fifthBusinessQuestion.addListener(() {
      _hasTypedFifthBusiness = fifthBusinessQuestion.text.isNotEmpty;
      _fifthBusinessCharCount = fifthBusinessQuestion.text.length;
      notifyListeners();
    });

    sixthBusinessQuestion.addListener(() {
      _hasTypedSixthBusiness = sixthBusinessQuestion.text.isNotEmpty;
      _sixthBusinessCharCount = sixthBusinessQuestion.text.length;
      notifyListeners();
    });

    seventhBusinessQuestion.addListener(() {
      _hasTypedSeventhBusiness = seventhBusinessQuestion.text.isNotEmpty;
      _seventhBusinessCharCount = seventhBusinessQuestion.text.length;
      notifyListeners();
    });

    eighthBusinessQuestion.addListener(() {
      _hasTypedEighthBusiness = eighthBusinessQuestion.text.isNotEmpty;
      _eighthBusinessCharCount = eighthBusinessQuestion.text.length;
      notifyListeners();
    });

    ninthBusinessQuestion.addListener(() {
      _hasTypedNinthBusiness = ninthBusinessQuestion.text.isNotEmpty;
      _ninthBusinessCharCount = ninthBusinessQuestion.text.length;
      notifyListeners();
    });
  }

  // Dispose controllers
  @override
  void dispose() {
    firstBusinessQuestion.dispose();
    secondBusinessQuestion.dispose();
    thirdBusinessQuestion.dispose();
    fourthBusinessQuestion.dispose();
    fifthBusinessQuestion.dispose();
    sixthBusinessQuestion.dispose();
    seventhBusinessQuestion.dispose();
    eighthBusinessQuestion.dispose();
    ninthBusinessQuestion.dispose();
    licenseNumberController.dispose();
    super.dispose();
  }

  final TextEditingController introductionController = TextEditingController();

  Future<void> saveBusinessIntroduction() async {
    // Your logic to save the introduction
  }

  /// Dropdown lists
  List<String> _states = [];
  List<String> _licenseTypes = [];

  /// Selected values
  String _selectedState = '';
  String _selectedLicenseType = '';

  /// Controller
  final TextEditingController licenseNumberController = TextEditingController();

  // Getters
  List<String> get states => _states;
  List<String> get licenseTypes => _licenseTypes;
  String get selectedState => _selectedState;
  String get selectedLicenseType => _selectedLicenseType;

  /// Simulated API fetch for states
  Future<void> fetchStates() async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulate loading
    _states = ['California', 'New York', 'Texas', 'Florida', 'Nevada'];
    notifyListeners();
  }

  /// Simulated API fetch for license types
  Future<void> fetchLicenses() async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulate loading
    _licenseTypes = [
      'General Contractor',
      'Electrician',
      'Plumber',
      'HVAC Technician',
    ];
    notifyListeners();
  }

  /// Setters
  void setSelectedState(String value) {
    _selectedState = value;
    notifyListeners();
  }

  void setSelectedLicenseType(String value) {
    _selectedLicenseType = value;
    notifyListeners();
  }

  /// Save function
  Future<void> saveProfessionalLicense() async {
    final licenseData = {
      'state': _selectedState,
      'license_type': _selectedLicenseType,
      'license_number': licenseNumberController.text.trim(),
    };

    // Simulate saving
    print("Saving license data: $licenseData");
    await Future.delayed(const Duration(seconds: 1));

    // Optionally reset form or show success message
  }

  List<String> userImageUrls = [];

  Future<void> fetchUserImages() async {
    // Fetch and assign images
    // userImageUrls = await imageService.getUserImages();
    notifyListeners();
  }

  Future<void> pickMedia({
    required ImageSource source,
    required bool isVideo,
  }) async {
    final picker = ImagePicker();
    final pickedFile = await (isVideo
        ? picker.pickVideo(source: source)
        : picker.pickImage(source: source));

    if (pickedFile != null) {
      // Upload or handle the file, then update the list
      // final uploadedUrl = await uploadService.uploadFile(pickedFile);
      // userImageUrls.add(uploadedUrl);
      notifyListeners();
    }
  }

  final TextEditingController locationController = TextEditingController();
  final TextEditingController projectTitleController = TextEditingController();
  final List<XFile> selectedFiles = [];

  List<Map<String, dynamic>> services = [];
  List<Map<String, dynamic>> citySearchResults = [];
  List<String> featureProjectImageUrls = [];

  String selectedServiceId = '';
  int selectedCityId = 0;
  bool isCitySearching = false;

  Future<void> fetchServices() async {
    /* your logic */
  }

  Future<void> fetchFeaturedProjects() async {
    /* your logic */
  }

  Future<void> searchCities(String query) async {
    /* your logic */
  }

  Future<void> saveFeaturedProjectAndFiles() async {
    /* your logic */
  }

  void setServiceId(String id) {
    selectedServiceId = id;
    notifyListeners();
  }

  void setCityId(int id) {
    selectedCityId = id;
    notifyListeners();
  }

  void setCitySearching(bool val) {
    isCitySearching = val;
    notifyListeners();
  }

  File? _profileImage;
  File? get profileImage => _profileImage;

  void setProfileImage(File file) {
    _profileImage = file;
    notifyListeners();
  }
}

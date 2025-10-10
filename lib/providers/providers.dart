import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:yelpax_pro/features/authentication/di_auth_user.dart';
import 'package:yelpax_pro/features/authentication/presentation/controllers/auth_user_controller.dart';

import 'package:yelpax_pro/features/inbox/di_controller.dart';
import 'package:yelpax_pro/features/mainHome/presentation/controllers/business_context_controller.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/d_i_m_profiles.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/di/service_di.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/controllers/service_controller.dart';

import 'package:yelpax_pro/shared/services/api_service.dart';
import 'package:yelpax_pro/shared/services/bottom_navbar_notifier.dart';

import '../config/localization/locale_provider.dart';
import '../config/themes/theme_provider.dart';
import '../features/marketPlace/m_professional_signup/d_i_m_professional_sign_up.dart';

List<SingleChildWidget> appProviders = [
  /// ✅ Register ApiService globally
  Provider<ApiService>(create: (_) => ApiService()),

  ChangeNotifierProvider(create: (_) => ThemeProvider()),
  ChangeNotifierProvider(create: (_) => createProfessionalSignUpProvider()),
  ChangeNotifierProvider(create: (_) => BusinessContextProvider()),
  ChangeNotifierProvider(create: (_) => createProfileProvider()),
  ChangeNotifierProvider(create: (_) => LocaleProvider()),
  ChangeNotifierProvider(create: (_) => createController()),
  ChangeNotifierProvider(create: (_) => createAuthUserController()),

  /// ✅ ServiceController using clean architecture with AuthUserController dependency
  ChangeNotifierProxyProvider<AuthUserController, ServiceController>(
    create: (context) {
      // Initialize the service DI if not already done
      if (!serviceDI.isInitialized) {
        serviceDI.initialize();
      }
      final controller = serviceDI.createServiceController();
      final authController = context.read<AuthUserController>();
      final professionalId = authController.professionalId.value ?? '';
      if (professionalId.isNotEmpty) {
        controller.initializeRegistrationData(professionalId);
      }
      return controller;
    },
    update: (context, authController, controller) {
      final professionalId = authController.professionalId.value ?? '';
      if (professionalId.isNotEmpty) {
        controller?.updateProfessionalId(professionalId);
      }
      return controller!;
    },
  ),

  ChangeNotifierProvider(create: (_) => BottomNavProvider()),
];

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:yelpax_pro/features/authentication/di_auth_user.dart';
import 'package:yelpax_pro/features/authentication/presentation/controllers/auth_user_controller.dart';

import 'package:yelpax_pro/features/inbox/di_controller.dart';
import 'package:yelpax_pro/features/mainHome/presentation/controllers/business_context_controller.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/d_i_m_profiles.dart';
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

  /// ✅ Wire ServiceController to react to AuthUserController professionalId updates
  ChangeNotifierProxyProvider2<
    ApiService,
    AuthUserController,
    ServiceController
  >(
    create: (context) => ServiceController(
      apiService: context.read<ApiService>(),
      professionalId:
          context.read<AuthUserController>().professionalId.value ?? '',
    ),
    update: (context, api, auth, controller) {
      final proId = auth.professionalId.value;
      if (proId != null && proId.isNotEmpty) {
        controller!.setProfessionalId(proId);
      }
      return controller!;
    },
  ),

  ChangeNotifierProvider(create: (_) => BottomNavProvider()),
];

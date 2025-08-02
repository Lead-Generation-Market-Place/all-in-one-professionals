import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:yelpax_pro/features/authentication/di_auth_user.dart';

import 'package:yelpax_pro/features/inbox/di_controller.dart';
import 'package:yelpax_pro/features/mainHome/presentation/controllers/business_context_controller.dart';
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/controllers/m_professional_signup.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/controllers/profile_provider.dart';
import 'package:yelpax_pro/shared/services/bottom_navbar_notifier.dart';

import '../config/localization/locale_provider.dart';
import '../config/themes/theme_provider.dart';

List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(create: (_) => ThemeProvider()),
  ChangeNotifierProvider(create: (_)=> ProfessionalSignUpProvider()),
  ChangeNotifierProvider(create: (_) => BusinessContextProvider()),
  ChangeNotifierProvider(create: (_) => ProfileProvider()),
  ChangeNotifierProvider(create: (_) => LocaleProvider()),
  ChangeNotifierProvider(create: (_) => createController()),
  ChangeNotifierProvider(create: (_) => createAuthUserController()),
  ChangeNotifierProvider(create: (_) => BottomNavProvider()),
];

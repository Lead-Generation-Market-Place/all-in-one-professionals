import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yelpax_pro/config/localization/l10n/l10n.dart';
import 'package:yelpax_pro/config/localization/locale_provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/config/themes/theme_provider.dart';
import 'package:yelpax_pro/core/utils/app_restart.dart';
import 'package:yelpax_pro/features/authentication/presentation/controllers/auth_user_controller.dart';
import 'package:yelpax_pro/features/authentication/presentation/screens/login_screen.dart';
import 'package:yelpax_pro/generated/app_localizations.dart';
import 'package:yelpax_pro/features/mainHome/presentation/screens/home.dart';
import 'package:yelpax_pro/providers/providers.dart';
import 'package:yelpax_pro/shared/onboarding_screen/onboarding_screen.dart';
import 'package:yelpax_pro/shared/screens/unexpected_error_screen.dart';
import 'package:yelpax_pro/shared/screens/unexpected_release_mode_error.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      ErrorWidget.builder = (FlutterErrorDetails details) {
        if (kReleaseMode) {
          return UnexpectedReleaseModeError(message: details.toString());
        }
        return MaterialApp(
          navigatorKey: navigatorKey,
          home: UnexpectedErrorScreen(message: details.toString()),
        );
      };
      runApp(
        RestartWidget(
          child: MultiProvider(providers: appProviders, child: const MyApp()),
        ),
      );
    },
    (error, stack) {
      Logger().log(
        Level.error,
        "Dart Server Error occured on $error on Stack \n $stack",
      );

      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => UnexpectedErrorScreen(message: 'message'),
        ),
      );
      // navigatorKey.currentState!.pushNamed(AppRouter.unknownRouteScreen);
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? _startScreen;
  final _storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('onboarding_seen') ?? false;

    final auth = Provider.of<AuthUserController>(context, listen: false);
    await auth.checkAuthStatus();

    Widget targetScreen;
    if (!seen) {
      targetScreen = const OnboardingScreen();
    } else if (auth.isAuthenticated.value == true) {
      targetScreen = const Home();
    } else {
      targetScreen = const LoginScreen();
    }

    setState(() {
      _startScreen = targetScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(

          navigatorKey: navigatorKey,
          onGenerateRoute: AppRouter.generateRoute,
          onUnknownRoute: (settings) => AppRouter.unknownRoute(settings),
          locale: localeProvider.locale ?? const Locale('en'),
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          title: 'Yelpax Pro',
          theme: themeProvider.themeData,
          debugShowCheckedModeBanner: false,
          home:
              _startScreen ??
              const Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      },
    );
  }
}

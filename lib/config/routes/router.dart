import 'package:flutter/material.dart';
import 'package:yelpax_pro/core/error/widgets/unknown_route_screen.dart';
import 'package:yelpax_pro/features/authentication/presentation/screens/login_screen.dart';
import 'package:yelpax_pro/home.dart';
import 'package:yelpax_pro/shared/onboarding_screen/onboarding_screen.dart';


class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String unknownRouteScreen = '/unknownRouteScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const Home());
      case unknownRouteScreen:
        return MaterialPageRoute(
          builder: (_) =>
              const UnknowRouteScreen(message: 'Unknown Route Screen'),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const UnknowRouteScreen(message: "Unknown Route!"),
        );
    }
  }

  //when going to unknown routes
  static Route<dynamic> unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) =>
          UnknowRouteScreen(message: 'Screen not found: ${settings.name}'),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:yelpax_pro/core/error/widgets/unknown_route_screen.dart';
import 'package:yelpax_pro/features/authentication/presentation/screens/login_screen.dart';
import 'package:yelpax_pro/features/authentication/presentation/screens/signup_as_professional.dart';
import 'package:yelpax_pro/features/mainHome/presentation/screens/business_category_selection_screen.dart';
import 'package:yelpax_pro/features/mainHome/presentation/screens/home.dart';

import 'package:yelpax_pro/features/marketPlace/jobs/presentation/screens/jobs_screen.dart';
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/screens/availability.dart';
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/screens/business_name_logo.dart';
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/screens/m_services_categories.dart';
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/screens/rating.dart';
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/screens/service_question_form.dart';
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/screens/signup_process_scree.dart';
import 'package:yelpax_pro/features/marketPlace/notifications/presentation/screens/notifications_screen.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/screens/profile_screen.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/widgets/business_faqs.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/widgets/business_info.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/widgets/featured_projects.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/widgets/photos_videos.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/widgets/professional_license.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/widgets/profile_picture_edit.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/widgets/your_introduction.dart';
import 'package:yelpax_pro/features/marketPlace/search/presentation/screens/search_screen.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/screens/service_screen.dart';
import 'package:yelpax_pro/features/marketPlace/settings/presentation/widgets/theme_selection.dart';

import 'package:yelpax_pro/shared/onboarding_screen/onboarding_screen.dart';

import '../../features/marketPlace/settings/presentation/screens/settings_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String unknownRouteScreen = '/unknownRouteScreen';
  static const String marketplaceJobs = '/marketplace/jobs';
  static const String marketplaceSearch = '/marketplace/search';
  static const String marketplaceServices = '/marketplace/services';
  static const String marketplaceNotifications = '/marketplace/notifications';
  static const String marketplaceProfile = '/marketplace/profile';
  static const String editProfilePicture = '/marketplace/editProfilePicture';
  static const String editBusinessInfo = '/marketplace/editBusinessInfo';
  static const String editBusinessFAQS = '/marketplace/editBusinessFAQS';
  static const String editYourIntroduction =
      '/marketplace/editYourIntroduction';
  static const String addBusinessLicense = '/marketplace/addBusinessLicense';
  static const String addPhotosAndVideoes = '/marketplace/addPhotosAndVideoes';
  static const String addFeatureProject = '/marketplace/addFeatureProject';

  static const String signUpAsProfessional =
      '/marketplace/signUpAsProfessional';

  static const String mServicesAndCategories =
      '/marketplace/mServicesAndCategories';

  static const String signUpProcessScreen = '/marketplace/signUpProcessScreen';

  static const String signUpProcessBusinessNameLogo =
      '/marketplace/signUpProcessBusinessNameLogo';

  static const String professionalRating =
      '/marketplace/professionalRating';


  static const String professionalAvailability =
      '/marketplace/professionalAvailability';
  static const String professionalServiceQuestionForm =
      '/marketplace/professionalServiceQuestionForm';

  static const String businessCategorySelectionScreen =
      '/marketplace/businessCategorySelectionScreen';

  static const String settingsScreen =
      '/marketplace/settingsScreen';

  static const String themeSelection =
      '/marketplace/themeSelection';
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const Home());
      case marketplaceJobs:
        return MaterialPageRoute(builder: (_) => const JobsScreen());
      case marketplaceSearch:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case marketplaceServices:
        return MaterialPageRoute(builder: (_) => const ServiceScreen());
      case marketplaceNotifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case marketplaceProfile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case editProfilePicture:
        return MaterialPageRoute(builder: (_) => ProfilePictureEdit());
      case editBusinessInfo:
        return MaterialPageRoute(builder: (_) => BusinessInfo());
      case editBusinessFAQS:
        return MaterialPageRoute(builder: (_) => BusinessFaqs());
      case editYourIntroduction:
        return MaterialPageRoute(builder: (_) => YourIntroduction());
      case addBusinessLicense:
        return MaterialPageRoute(builder: (_) => ProfessionalLicense());
      case addPhotosAndVideoes:
        return MaterialPageRoute(builder: (_) => PhotosVideos());
      case addFeatureProject:
        return MaterialPageRoute(builder: (_) => FeaturedProjects());
      case signUpAsProfessional:
        return MaterialPageRoute(builder: (_) => SignupAsProfessional());
      case mServicesAndCategories:
        return MaterialPageRoute(builder: (_) => MServicesCategories());
      case signUpProcessScreen:
        return MaterialPageRoute(builder: (_) => SignupProcessScreem());
      case signUpProcessBusinessNameLogo:
        return MaterialPageRoute(builder: (_) => BusinessNameLogo());
      case professionalRating:
        return MaterialPageRoute(builder: (_) => Rating());

      case professionalAvailability:
        return MaterialPageRoute(builder: (_) => AvailabilityScreen());

      case professionalServiceQuestionForm:
        return MaterialPageRoute(builder: (_) => ServiceQuestionForm());
      case businessCategorySelectionScreen:
        return MaterialPageRoute(builder: (_) => BusinessCategorySelectionScreen());
      case settingsScreen:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case themeSelection:
        return MaterialPageRoute(builder: (_) => ThemeSelection());
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

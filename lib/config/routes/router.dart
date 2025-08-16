import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:yelpax_pro/core/error/widgets/unknown_route_screen.dart';
import 'package:yelpax_pro/features/authentication/presentation/screens/login_screen.dart';
import 'package:yelpax_pro/features/authentication/presentation/screens/signup_as_professional.dart';
import 'package:yelpax_pro/features/mainHome/presentation/screens/business_category_selection_screen.dart';
import 'package:yelpax_pro/features/mainHome/presentation/screens/home.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/subs/filter/presentation/screens/filter_screen.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/subs/google_map_leads/presentation/screens/google_map_leads.dart';

import 'package:yelpax_pro/features/marketPlace/jobs/presentation/screens/jobs_screen.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/subs/leads_setting/presentation/screens/lead_setting.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/subs/leads_setting/presentation/screens/leads_details_page.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/subs/reponses/presentation/screens/response_credits.dart';

import 'package:yelpax_pro/features/marketPlace/jobs/subs/reponses/presentation/screens/responses.dart' hide GoogleMapLeads;
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/screens/availability.dart';
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/screens/business_name_logo.dart';
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/screens/card_details.dart';
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/screens/location.dart';
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/screens/m_services_categories.dart';
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/screens/rating.dart';
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/screens/service_question_form.dart';
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/screens/signup_process_scree.dart';
import 'package:yelpax_pro/features/marketPlace/notifications/presentation/screens/notifications_screen.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/screens/profile_screen.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/screens/business_faqs.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/screens/business_info.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/screens/featured_projects.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/screens/photos_videos.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/screens/professional_license.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/screens/profile_picture_edit.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/screens/your_introduction.dart';
import 'package:yelpax_pro/features/marketPlace/search/presentation/screens/search_screen.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/screens/business_availability.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/screens/service_screen.dart';
import 'package:yelpax_pro/features/marketPlace/settings/presentation/widgets/theme_selection.dart';

import 'package:yelpax_pro/shared/onboarding_screen/onboarding_screen.dart';

import '../../features/marketPlace/settings/presentation/screens/settings_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String unknownRouteScreen = '/unknownRouteScreen';
  static const String homeServicesJobs = '/homeServices/jobs';
  static const String homeServicesSearch = '/homeServices/search';
  static const String homeServicesServices = '/homeServices/services';
  static const String homeServicesNotifications = '/homeServices/notifications';
  static const String homeServicesProfile = '/homeServices/profile';
  static const String editProfilePicture = '/homeServices/editProfilePicture';
  static const String editBusinessInfo = '/homeServices/editBusinessInfo';
  static const String editBusinessFAQS = '/homeServices/editBusinessFAQS';
  static const String editYourIntroduction =
      '/homeServices/editYourIntroduction';
  static const String addBusinessLicense = '/homeServices/addBusinessLicense';
  static const String addPhotosAndVideoes = '/homeServices/addPhotosAndVideoes';
  static const String addFeatureProject = '/homeServices/addFeatureProject';

  static const String signUpAsProfessional =
      '/homeServices/signUpAsProfessional';

  static const String mServicesAndCategories =
      '/homeServices/mServicesAndCategories';

  static const String signUpProcessScreen = '/homeServices/signUpProcessScreen';

  static const String signUpProcessBusinessNameLogo =
      '/homeServices/signUpProcessBusinessNameLogo';

  static const String professionalRating =
      '/homeServices/professionalRating';


  static const String professionalAvailability =
      '/homeServices/professionalAvailability';
  static const String professionalServiceQuestionForm =
      '/homeServices/professionalServiceQuestionForm';

  static const String businessCategorySelectionScreen =
      '/homeServices/businessCategorySelectionScreen';

  static const String settingsScreen =
      '/homeServices/settingsScreen';

  static const String themeSelection =
      '/homeServices/themeSelection';
  static const String location =
      '/homeServices/location';

  static const String cardDetails =
      '/homeServices/cardDetails';

  static const String businessAvailability =
      '/homeServices/businessAvailability';

  static const String filterScreen =
      '/homeServices/filterScreen';

  static const String leadDetailsPage =
      '/homeServices/leadDetailsPage';
  static const String response_credits =
      '/homeServices/response_credits';
  static const String google_map_leads =
      '/homeServices/google_map_leads';
  static const String responses =
      '/homeServices/responses';
  static const String leadSetting =
      '/homeServices/leadSetting';
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const Home());
      case homeServicesJobs:
        return MaterialPageRoute(builder: (_) => const JobsScreen());
      case homeServicesSearch:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case homeServicesServices:
        return MaterialPageRoute(builder: (_) => const ServiceScreen());
      case homeServicesNotifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case homeServicesProfile:
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
      case location:
        return MaterialPageRoute(builder: (_) => LocationScreen());
      case cardDetails:
        return MaterialPageRoute(builder: (_) => CardDetails());
      case businessAvailability:
        return MaterialPageRoute(builder: (_) => BusinessAvailability());
      case filterScreen:
        return MaterialPageRoute(builder: (_) => FilterScreen());
      case leadDetailsPage:
        return MaterialPageRoute(builder: (_) => LeadsDetailsPage());
      case response_credits:
        return MaterialPageRoute(builder: (_) => ResponseCredits());
      case google_map_leads:
        return MaterialPageRoute(builder: (_) => GoogleMapLeads());
      case leadSetting:
        return MaterialPageRoute(builder: (_) => LeadSetting());

      case responses:
        return MaterialPageRoute(builder: (_) => Responses());
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

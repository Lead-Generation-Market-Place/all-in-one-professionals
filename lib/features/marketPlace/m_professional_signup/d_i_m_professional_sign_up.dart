import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/controllers/m_professional_signup_controller.dart';
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/controllers/question_service.dart';

ProfessionalSignUpProvider createProfessionalSignUpProvider() {
  return ProfessionalSignUpProvider(
    serviceQuestions: ServiceQuestions(),
    // other services if needed
  );
}
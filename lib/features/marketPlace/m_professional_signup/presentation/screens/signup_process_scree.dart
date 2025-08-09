import 'package:flutter/material.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

class SignupProcessScreem extends StatefulWidget {
  const SignupProcessScreem({super.key});

  @override
  State<SignupProcessScreem> createState() => _SignupProcessScreemState();
}

class _SignupProcessScreemState extends State<SignupProcessScreem> {
  bool businessInfoCompleted = false;
  bool availabilityInfoCompleted = false;
  bool verificationCompleted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Complete Your Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Complete these steps to start getting leads',
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 12),
              _buildProgressIndicator(theme),
              const SizedBox(height: 32),

              // Steps
              _buildStep(
                completed: businessInfoCompleted,
                enabled: true,
                // Always enabled
                icon: Icons.business_outlined,
                title: "Business Information",
                description: "Basic details about your business",
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRouter.signUpProcessBusinessNameLogo,
                  );
                  if (result == true) {
                    setState(() => businessInfoCompleted = true);
                  }
                },
              ),
              const SizedBox(height: 24),

              _buildStep(
                completed: availabilityInfoCompleted,
                enabled: businessInfoCompleted,
                icon: Icons.calendar_today_outlined,
                title: "Availability Information",
                description: "Tell us about your availability",
                onTap: businessInfoCompleted
                    ? () async {
                        final result = await Navigator.pushNamed(
                          context,
                          AppRouter.professionalAvailability,
                        );
                        if (result == true) {
                          setState(() => availabilityInfoCompleted = true);
                        }
                      }
                    : null,
              ),
              const SizedBox(height: 24),

              _buildStep(
                completed: verificationCompleted,
                enabled: availabilityInfoCompleted,
                icon: Icons.help_outline_rounded,
                title: "Questions",
                description: "Respond to the questions",
                onTap: availabilityInfoCompleted
                    ? () async {
                        final result = await Navigator.pushNamed(
                          context,
                          AppRouter.professionalServiceQuestionForm,
                        );
                        if (result == true) {
                          setState(() => verificationCompleted = true);
                        }
                      }
                    : null,
              ),
              const SizedBox(height: 24),

              _buildStep(
                completed: verificationCompleted,
                enabled: verificationCompleted,
                icon: Icons.location_on_outlined,
                title: "Location",
                description: "Set your location",
                onTap: verificationCompleted
                    ? () {
                        Navigator.pushNamed(context, AppRouter.location);
                      }
                    : null,
              ),
              const SizedBox(height: 24),

              _buildStep(
                completed: verificationCompleted,
                enabled: verificationCompleted,
                icon: Icons.payment_outlined,
                title: "Payment",
                description: "Set your details",
                onTap: verificationCompleted
                    ? () {
                        Navigator.pushNamed(context, AppRouter.cardDetails);
                      }
                    : null,
              ),
              const SizedBox(height: 24),

              _buildStep(
                completed: verificationCompleted,
                enabled: verificationCompleted,
                icon: Icons.verified_outlined,
                title: "Verification",
                description: "Verify your identity",
                onTap: verificationCompleted
                    ? () => _navigateToVerification(context)
                    : null,
              ),
              const SizedBox(height: 24),

              _buildStep(
                completed: false,
                enabled: verificationCompleted,
                icon: Icons.star_outline_rounded,
                title: "Professional Rating",
                description: "Get ratings from your customers",
                onTap: verificationCompleted
                    ? () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.professionalRating,
                        );
                      }
                    : null,
              ),
              const SizedBox(height: 40),

              // Continue button
              CustomButton(
                text: 'Continue to Dashboard',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.homeServicesJobs,
                    (route) => false,
                  );
                },
                enabled: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _allStepsCompleted() {
    return businessInfoCompleted &&
        availabilityInfoCompleted &&
        verificationCompleted;
  }

  Future<void> _navigateToVerification(BuildContext context) async {
    // final result = await Navigator.pushNamed(
    //   context,
    //   AppRouter.signUpProcessVerification,
    // );
    //
    // if (result == true) {
    //   setState(() => verificationCompleted = true);
    // }
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    final completedSteps = [
      businessInfoCompleted,
      availabilityInfoCompleted,
      verificationCompleted,
    ].where((completed) => completed).length;
    const totalSteps = 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: completedSteps / totalSteps,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
          minHeight: 10,
          semanticsLabel: 'Progress indicator',
          semanticsValue: '$completedSteps of $totalSteps steps completed',
        ),
        const SizedBox(height: 8),
        Text(
          "$completedSteps of $totalSteps steps completed",
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildStep({
    required bool completed,
    required bool enabled,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: enabled ? Colors.white : Colors.grey.shade100,
          border: Border.all(
            color: completed
                ? Colors.green.shade400
                : enabled
                ? AppColors.primaryBlue.withOpacity(0.5)
                : Colors.grey.shade300,
            width: 1.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Opacity(
          opacity: enabled ? 1.0 : 0.5,
          child: Row(
            children: [
              // Status icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: completed
                      ? Colors.green.shade50
                      : enabled
                      ? AppColors.primaryBlue.withOpacity(0.1)
                      : Colors.grey.shade200,
                ),
                child: Icon(
                  icon,
                  size: 26,
                  color: completed
                      ? Colors.green.shade700
                      : enabled
                      ? AppColors.primaryBlue
                      : Colors.grey.shade500,
                ),
              ),
              const SizedBox(width: 18),

              // Step details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: enabled ? Colors.black87 : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: enabled
                            ? Colors.grey.shade800
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              // Action indicator
              if (enabled && !completed)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20,
                  color: AppColors.primaryBlue,
                ),
              if (!enabled && !completed)
                Icon(
                  Icons.lock_outline_rounded,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
              if (completed)
                Icon(
                  Icons.check_circle_rounded,
                  size: 22,
                  color: Colors.green.shade600,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

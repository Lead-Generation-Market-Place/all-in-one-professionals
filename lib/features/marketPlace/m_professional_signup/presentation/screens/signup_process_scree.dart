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
                enabled: false,
                icon: Icons.calendar_today_outlined,
                title: "Availability Information",
                description: "Tell us about your availability",
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRouter.businessAvailability,
                  );
                  if (result == true) {
                    setState(() => businessInfoCompleted = true);
                  }
                },
              ),
              const SizedBox(height: 24),

              _buildStep(
                completed: verificationCompleted,
                enabled: true,
                icon: Icons.help_outline_rounded,
                title: "Questions",
                description: "Respond to the questions",
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRouter.professionalServiceQuestionForm,
                  );
                  if (result == true) {
                    setState(() => businessInfoCompleted = true);
                  }
                },
              ),
              const SizedBox(height: 24),

              _buildStep(
                completed: verificationCompleted,
                enabled: true,
                icon: Icons.location_on_outlined,
                title: "Location",
                description: "Set your location",
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRouter.location,
                  );
                  if (result == true) {
                    setState(() => businessInfoCompleted = true);
                  }
                },
              ),
              const SizedBox(height: 24),

              _buildStep(
                completed: verificationCompleted,
                enabled: true,
                icon: Icons.payment_outlined,
                title: "Payment",
                description: "Set your details",
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRouter.cardDetails,
                  );
                  if (result == true) {
                    setState(() => businessInfoCompleted = true);
                  }
                },
              ),
              const SizedBox(height: 24),

              _buildStep(
                completed: verificationCompleted,
                enabled: true,
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
                enabled: true,
                icon: Icons.star_outline_rounded,
                title: "Professional Rating",
                description: "Get ratings from your customers",
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRouter.professionalRating,
                  );
                  if (result == true) {
                    setState(() => businessInfoCompleted = true);
                  }
                },
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
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          minHeight: 10,
          semanticsLabel: 'Progress indicator',
          semanticsValue: '$completedSteps of $totalSteps steps completed',
        ),
        const SizedBox(height: 8),
        Text(
          "$completedSteps of $totalSteps steps completed",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final Color borderColor = completed
        ? scheme.tertiary
        : enabled
        ? scheme.primary.withOpacity(0.5)
        : scheme.outlineVariant;
    final Color cardColor = enabled
        ? scheme.surface
        : scheme.surfaceContainerHighest;
    final Color iconBg = completed
        ? scheme.tertiaryContainer
        : enabled
        ? scheme.primary.withOpacity(0.12)
        : scheme.surfaceContainerHighest;
    final Color iconColor = completed
        ? scheme.tertiary
        : enabled
        ? scheme.primary
        : scheme.onSurfaceVariant;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: cardColor,
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.04),
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
                  color: iconBg,
                ),
                child: Icon(icon, size: 26, color: iconColor),
              ),
              const SizedBox(width: 18),

              // Step details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: enabled
                            ? scheme.onSurface
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
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
                  color: scheme.primary,
                ),
              if (!enabled && !completed)
                Icon(
                  Icons.lock_outline_rounded,
                  size: 20,
                  color: scheme.onSurfaceVariant,
                ),
              if (completed)
                Icon(
                  Icons.check_circle_rounded,
                  size: 22,
                  color: scheme.tertiary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

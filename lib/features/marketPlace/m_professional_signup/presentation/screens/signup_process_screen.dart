import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

class SignupProcessScreen extends StatefulWidget {
  const SignupProcessScreen({super.key});

  @override
  State<SignupProcessScreen> createState() => _SignupProcessScreenState();
}

class _SignupProcessScreenState extends State<SignupProcessScreen> {
  bool businessInfoCompleted = false;
  bool availabilityInfoCompleted = false;
  bool verificationCompleted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Complete Your Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Complete these steps to start getting leads',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 16),
              _buildProgressIndicator(theme),
              const SizedBox(height: 32),

              // Steps in a clean card layout
              _buildStepCard(
                completed: businessInfoCompleted,
                enabled: true,
                icon: CupertinoIcons.building_2_fill,
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
              const SizedBox(height: 12),

              _buildStepCard(
                completed: availabilityInfoCompleted,
                enabled: false,
                icon: CupertinoIcons.calendar,
                title: "Availability",
                description: "Tell us about your availability",
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRouter.businessAvailability,
                  );
                  if (result == true) {
                    setState(() => availabilityInfoCompleted = true);
                  }
                },
              ),
              const SizedBox(height: 12),

              _buildStepCard(
                completed: verificationCompleted,
                enabled: true,
                icon: CupertinoIcons.question_circle,
                title: "Questions",
                description: "Respond to the questions",
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRouter.professionalServiceQuestionForm,
                  );
                  if (result == true) {
                    setState(() => verificationCompleted = true);
                  }
                },
              ),
              const SizedBox(height: 12),

              _buildStepCard(
                completed: false,
                enabled: true,
                icon: CupertinoIcons.location_fill,
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
              const SizedBox(height: 12),

              _buildStepCard(
                completed: false,
                enabled: true,
                icon: CupertinoIcons.creditcard_fill,
                title: "Payment",
                description: "Set your payment details",
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
              const SizedBox(height: 12),

              _buildStepCard(
                completed: verificationCompleted,
                enabled: true,
                icon: CupertinoIcons.checkmark_seal_fill,
                title: "Verification",
                description: "Verify your identity",
                onTap: verificationCompleted
                    ? () => _navigateToVerification(context)
                    : null,
              ),
              const SizedBox(height: 12),

              _buildStepCard(
                completed: false,
                enabled: true,
                icon: CupertinoIcons.star_fill,
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
              const SizedBox(height: 32),

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

  Widget _buildProgressIndicator(ThemeData theme) {
    final completedSteps = [
      businessInfoCompleted,
      availabilityInfoCompleted,
      verificationCompleted,
    ].where((completed) => completed).length;
    const totalSteps = 3;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Profile Completion",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "${((completedSteps / totalSteps) * 100).toInt()}%",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: completedSteps / totalSteps,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            "$completedSteps of $totalSteps steps completed",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required bool completed,
    required bool enabled,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: completed
                ? scheme.primary.withOpacity(0.3)
                : scheme.outline.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon with status indicator
            Stack(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: completed
                        ? scheme.primary.withOpacity(0.1)
                        : scheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: completed
                        ? scheme.primary
                        : enabled
                            ? scheme.onSurface
                            : scheme.onSurfaceVariant,
                  ),
                ),
                if (completed)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: scheme.surface,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        CupertinoIcons.checkmark,
                        size: 10,
                        color: scheme.onPrimary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: enabled
                          ? scheme.onSurface
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Action indicator
            if (enabled && !completed)
              Icon(
                CupertinoIcons.chevron_forward,
                size: 18,
                color: scheme.onSurfaceVariant,
              ),
            if (!enabled)
              Icon(
                CupertinoIcons.lock,
                size: 18,
                color: scheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
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

  // Widget _buildProgressIndicator(ThemeData theme) {
  //   final completedSteps = [
  //     businessInfoCompleted,
  //     availabilityInfoCompleted,
  //     verificationCompleted,
  //   ].where((completed) => completed).length;
  //   const totalSteps = 3;

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       LinearProgressIndicator(
  //         value: completedSteps / totalSteps,
  //         backgroundColor: theme.colorScheme.surfaceContainerHighest,
  //         valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
  //         minHeight: 10,
  //         semanticsLabel: 'Progress indicator',
  //         semanticsValue: '$completedSteps of $totalSteps steps completed',
  //       ),
  //       const SizedBox(height: 8),
  //       Text(
  //         "$completedSteps of $totalSteps steps completed",
  //         style: theme.textTheme.bodySmall?.copyWith(
  //           color: theme.colorScheme.onSurfaceVariant,
  //         ),
  //       ),
  //     ],
  //   );
  // }

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

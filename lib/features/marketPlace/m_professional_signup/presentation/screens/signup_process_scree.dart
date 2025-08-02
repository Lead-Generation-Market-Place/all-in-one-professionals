import 'package:flutter/material.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Complete Your Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complete these steps to start getting leads',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 32),
            const SizedBox(height: 16),

            // Progress indicator
            _buildProgressIndicator(),
            const SizedBox(height: 32),

            // Steps
            _buildStep(
              completed: businessInfoCompleted,
              enabled: true, // First step always enabled
              icon: Icons.business_outlined,
              title: "Business Information",
              description: "Basic details about your business",
              onTap: () => {
                Navigator.pushNamed(context, AppRouter.signUpProcessBusinessNameLogo)
              },
            ),
            const SizedBox(height: 24),

            _buildStep(
              completed: availabilityInfoCompleted,
              enabled:
                  true, // Only enabled if business info complete
              icon: Icons.calendar_today_outlined,
              title: "Availability Information",
              description: "Tell us about your availability",
              onTap: () =>
                  {
                    Navigator.pushNamed(context, AppRouter.professionalRating)
                  }

            ),
            const SizedBox(height: 24),

            _buildStep(
              completed: verificationCompleted,
              enabled:
                  availabilityInfoCompleted, // Only enabled if availability complete
              icon: Icons.verified_outlined,
              title: "Verification",
              description: "Verify your identity",
              onTap: () => _navigateToVerification(context),
            ),
            const SizedBox(height: 40),

            // Continue button
            if (_allStepsCompleted())
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/dashboard'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: AppColors.black,
                  ),
                  child: const Text(
                    'Continue to Dashboard',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _allStepsCompleted() {
    return businessInfoCompleted &&
        availabilityInfoCompleted &&
        verificationCompleted;
  }

  Future<void> _navigateToBusinessInfo(BuildContext context) async {
    final result = await Navigator.pushNamed(
      context,
      AppRouter.signUpProcessBusinessNameLogo,
    );

    if (result == true) {
      setState(() => businessInfoCompleted = true);
    }
  }

  Future<void> _navigateToAvailabilityInfo(BuildContext context) async {
    // final result = await Navigator.pushNamed(
    //   context,
    //   AppRouter.signUpProcessAvailability,
    // );

    // if (result == true) {
    //   setState(() => availabilityInfoCompleted = true);
    // }
  }

  Future<void> _navigateToVerification(BuildContext context) async {
    // final result = await Navigator.pushNamed(
    //   context,
    //   AppRouter.signUpProcessVerification,
    // );

    // if (result == true) {
    //   setState(() => verificationCompleted = true);
    // }
  }

  Widget _buildProgressIndicator() {
    final completedSteps = [
      businessInfoCompleted,
      availabilityInfoCompleted,
      verificationCompleted,
    ].where((completed) => completed).length;
    final totalSteps = 3;

    return Column(
      children: [
        LinearProgressIndicator(
          value: completedSteps / totalSteps,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.black),
          minHeight: 8,
          borderRadius: BorderRadius.circular(10),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "$completedSteps of $totalSteps completed",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
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
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: completed
                ? Colors.green.shade100
                : enabled
                ? Colors.blue.shade100
                : Colors.grey.shade200,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Opacity(
          opacity: enabled ? 1.0 : 0.6,
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
                      ? Colors.blue.shade50
                      : Colors.grey.shade100,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: completed
                      ? Colors.green
                      : enabled
                      ? AppColors.primaryBlue
                      : Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 16),

              // Step details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Action indicator
              if (enabled && !completed)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20,
                  color: Colors.grey,
                ),
              if (!enabled && !completed)
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 20,
                  color: Colors.grey,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

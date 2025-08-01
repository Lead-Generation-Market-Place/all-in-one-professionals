import 'package:flutter/material.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

class ProfileCompletionBanner extends StatelessWidget {
  final int stepNumber;
  final VoidCallback onFinishSetupPressed;

  const ProfileCompletionBanner({
    Key? key,
    required this.stepNumber,
    required this.onFinishSetupPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.secondaryBlue,
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        margin: const EdgeInsets.all(12), // Optional spacing around banner
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                'Only $stepNumber setup tasks left before you can start getting leads.',
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            CustomButton(
              text: 'Finish Setup',
              enabled: true,
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.signUpProcessScreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}

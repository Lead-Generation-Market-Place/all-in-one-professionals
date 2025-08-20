import 'package:flutter/material.dart';
import 'package:yelpax_pro/config/routes/router.dart';

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
        decoration: BoxDecoration(color: Colors.black87),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Finish ',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$stepNumber',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const TextSpan(
                      text: ' setup tasks and start getting leads.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Finish Setup Button
            FilledButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.signUpProcessScreen);
              },
              label: Text('Finish Setup', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

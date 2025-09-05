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
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).unselectedWidgetColor,
        border: Border.all(width: 1, color: Colors.white30),
        borderRadius: BorderRadius.circular(16), // Rounded rectangle
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  const TextSpan(text: 'Finish '),
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
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        '$stepNumber',
                        style: const TextStyle(
                       
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: ' setup tasks and start getting leads.'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.signUpProcessScreen);
              onFinishSetupPressed(); // Optional: if you still want to trigger a callback
            },
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Finish Setup', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

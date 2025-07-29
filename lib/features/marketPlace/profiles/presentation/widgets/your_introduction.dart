import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/controllers/profile_provider.dart';
import 'package:yelpax_pro/shared/widgets/custom_input.dart';


class YourIntroduction extends StatelessWidget {
  const YourIntroduction({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your introduction', ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Save Introduction'),
                    content: const Text('Do you want to save your business introduction?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Yes'),
                      ),
                    ],
                  );
                },
              );

              if (result == true) {
                await controller.saveBusinessIntroduction();
              }
            },
            label: const Text('Save',),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomInputField(
              hintText: 'Introduce yourself',
              controller: controller.introductionController,
    
              label: 'Tell customers about your business',
            ),
            const SizedBox(height: 30),
            const Text(
              "Explain what makes your business stand out and why you'll do a great job.",
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

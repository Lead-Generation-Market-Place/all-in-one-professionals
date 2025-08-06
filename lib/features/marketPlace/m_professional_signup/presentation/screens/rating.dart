import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_input.dart';
import '../controllers/m_professional_signup_controller.dart';

class Rating extends StatelessWidget {
  const Rating({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfessionalSignUpProvider(),
      child: SafeArea(
        bottom: true,
        top: false,
        left: false,
        right: false,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Request Reviews'),
            centerTitle: true,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HeaderSection(),
                const SizedBox(height: 24),
                const _EmailInputSection(),
                const SizedBox(height: 24),
                const _PreviewCard(),
                const SizedBox(height: 24),
                const _TrustCard(),
                const SizedBox(height: 32),
                const _NavigationButtons(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Request Customer Reviews',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Collect reviews from your customers to build trust and credibility',
        ),
      ],
    );
  }
}

class _EmailInputSection extends StatelessWidget {
  const _EmailInputSection();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfessionalSignUpProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Customer Emails'),
        const SizedBox(height: 12),
        ...List.generate(provider.emails.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  // Add this Expanded widget
                  child: CustomInputField(
                    hintText: 'customer@example.com',
                    label: 'Email',
                    onChanged: (val) => provider.updateEmail(index, val),
                  ),

                ),
                const SizedBox(width: 8),
                CustomButton(
                  text: 'Send to',
                  onPressed: provider.sendingIndex == index
                      ? null
                      : () async {
                          try {
                            await provider.sendEmail(index);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Sent to ${provider.emails[index]}',
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed: ${e.toString()}'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                ),
              ],
            ),
          );
        }),
        TextButton(
          onPressed: provider.addEmailField,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.add, size: 18),
              SizedBox(width: 4),
              Text('Add another email'),
            ],
          ),
        ),
        const SizedBox(height: 16),

        CustomButton(text: 'Import from Google',onPressed: (){},enabled: true,)

      ],
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfessionalSignUpProvider>(context);

    return Card(
        color: Theme.of(context).colorScheme.surface,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'EMAIL PREVIEW',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(

                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              provider.businessName,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text('Review Request',),
            const SizedBox(height: 16),
            provider.userImageUrl != null
                ? CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80',
                    ),
                  )
                : const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
            const SizedBox(height: 16),
            const Text(
              'How was your experience with us?',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'We\'d love your feedback to help us improve',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 24),
                Icon(Icons.star, color: Colors.amber, size: 24),
                Icon(Icons.star, color: Colors.amber, size: 24),
                Icon(Icons.star, color: Colors.amber, size: 24),
                Icon(Icons.star, color: Colors.amber, size: 24),
              ],
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Leave a Review',
              enabled: true,
              onPressed: () {},
            ),
            const SizedBox(height: 8),
            Text(
              'Requested by: ${provider.username ?? 'Your Business'}',
              style: const TextStyle(fontSize: 12,),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrustCard extends StatelessWidget {
  const _TrustCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),

      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.thumb_up, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Build Trust with Reviews',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Positive reviews help attract more customers and grow your business',

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationButtons extends StatelessWidget {
  const _NavigationButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Back'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomButton(
            text: 'Continue',
            enabled: true,
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.professionalAvailability);
            },
          ),
        ),
      ],
    );
  }
}

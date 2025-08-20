import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/controllers/profile_provider.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';
import 'package:yelpax_pro/shared/widgets/custom_input.dart';

class BusinessFaqs extends StatefulWidget {
  const BusinessFaqs({super.key});

  @override
  State<BusinessFaqs> createState() => _BusinessFaqsState();
}

class _BusinessFaqsState extends State<BusinessFaqs> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    if (!profileProvider.hasLoadedFaqs) {
      profileProvider.fetchAnsweredBusinessFaqs();
      profileProvider.hasLoadedFaqs = true;
    }
  }

  String? validateMin50IfTyped(String? value) {
    if (value != null && value.trim().isNotEmpty && value.trim().length < 50) {
      return 'Please enter at least 50 characters';
    }
    return null;
  }

  Widget buildQuestion({
    required BuildContext context,
    required String title,
    required TextEditingController controllerText,
    required bool hasTyped,
    required int charCount,
  }) {
    final theme = Theme.of(context);
    final remaining = 50 - charCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 8),
        CustomInputField(
          controller: controllerText,
          hintText: 'Enter your answer',
          label: 'Your answer',
          validator: validateMin50IfTyped,
        ),
        if (!hasTyped)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Minimum 50 characters needed',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          )
        else if (remaining > 0)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$remaining more characters needed',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Business FAQs'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CustomButton(
              text: 'Save',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: theme.cardTheme.color,
                      title: Text('Confirm Save'),
                      content: Text(
                        'Are you sure you want to save your answers?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await profileProvider
                                .answeredBusinessFaqsQuestion();
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Selector<ProfileProvider, bool>(
                selector: (_, provider) => provider.hasTypedFirstBusiness,
                builder: (context, hasTyped, child) {
                  return Selector<ProfileProvider, int>(
                    selector: (_, provider) => provider.firstBusinessCharCount,
                    builder: (context, charCount, child) {
                      return buildQuestion(
                        context: context,
                        title:
                            'What should the customer know about your pricing (e.g., discounts, fees)?',
                        controllerText: profileProvider.firstBusinessQuestion,
                        hasTyped: hasTyped,
                        charCount: charCount,
                      );
                    },
                  );
                },
              ),
              Selector<ProfileProvider, bool>(
                selector: (_, provider) => provider.hasTypedSecondBusiness,
                builder: (context, hasTyped, child) {
                  return Selector<ProfileProvider, int>(
                    selector: (_, provider) => provider.secondBusinessCharCount,
                    builder: (context, charCount, child) {
                      return buildQuestion(
                        context: context,
                        title:
                            'What is your typical process for working with a new customer?',
                        controllerText: profileProvider.secondBusinessQuestion,
                        hasTyped: hasTyped,
                        charCount: charCount,
                      );
                    },
                  );
                },
              ),
              Selector<ProfileProvider, bool>(
                selector: (_, provider) => provider.hasTypedThirdBusiness,
                builder: (context, hasTyped, child) {
                  return Selector<ProfileProvider, int>(
                    selector: (_, provider) => provider.thirdBusinessCharCount,
                    builder: (context, charCount, child) {
                      return buildQuestion(
                        context: context,
                        title:
                            'What education and/or training do you have that relates to your work?',
                        controllerText: profileProvider.thirdBusinessQuestion,
                        hasTyped: hasTyped,
                        charCount: charCount,
                      );
                    },
                  );
                },
              ),
              Selector<ProfileProvider, bool>(
                selector: (_, provider) => provider.hasTypedFourthBusiness,
                builder: (context, hasTyped, child) {
                  return Selector<ProfileProvider, int>(
                    selector: (_, provider) => provider.fourthBusinessCharCount,
                    builder: (context, charCount, child) {
                      return buildQuestion(
                        context: context,
                        title:
                            'How did you get started doing this type of work?',
                        controllerText: profileProvider.fourthBusinessQuestion,
                        hasTyped: hasTyped,
                        charCount: charCount,
                      );
                    },
                  );
                },
              ),
              Selector<ProfileProvider, bool>(
                selector: (_, provider) => provider.hasTypedFifthBusiness,
                builder: (context, hasTyped, child) {
                  return Selector<ProfileProvider, int>(
                    selector: (_, provider) => provider.fifthBusinessCharCount,
                    builder: (context, charCount, child) {
                      return buildQuestion(
                        context: context,
                        title: 'What type of customer have you worked with?',
                        controllerText: profileProvider.fifthBusinessQuestion,
                        hasTyped: hasTyped,
                        charCount: charCount,
                      );
                    },
                  );
                },
              ),
              Selector<ProfileProvider, bool>(
                selector: (_, provider) => provider.hasTypedSixthBusiness,
                builder: (context, hasTyped, child) {
                  return Selector<ProfileProvider, int>(
                    selector: (_, provider) => provider.sixthBusinessCharCount,
                    builder: (context, charCount, child) {
                      return buildQuestion(
                        context: context,
                        title:
                            'Describe a recent project you are fond of. How long did it take?',
                        controllerText: profileProvider.sixthBusinessQuestion,
                        hasTyped: hasTyped,
                        charCount: charCount,
                      );
                    },
                  );
                },
              ),
              Selector<ProfileProvider, bool>(
                selector: (_, provider) => provider.hasTypedSeventhBusiness,
                builder: (context, hasTyped, child) {
                  return Selector<ProfileProvider, int>(
                    selector: (_, provider) =>
                        provider.seventhBusinessCharCount,
                    builder: (context, charCount, child) {
                      return buildQuestion(
                        context: context,
                        title:
                            'What advice you would give a customer looking to hire a provider in your area of work?',
                        controllerText: profileProvider.seventhBusinessQuestion,
                        hasTyped: hasTyped,
                        charCount: charCount,
                      );
                    },
                  );
                },
              ),
              Selector<ProfileProvider, bool>(
                selector: (_, provider) => provider.hasTypedEighthBusiness,
                builder: (context, hasTyped, child) {
                  return Selector<ProfileProvider, int>(
                    selector: (_, provider) => provider.eighthBusinessCharCount,
                    builder: (context, charCount, child) {
                      return buildQuestion(
                        context: context,
                        title:
                            'What questions should customers think through before talking to professionals about their project?',
                        controllerText: profileProvider.eighthBusinessQuestion,
                        hasTyped: hasTyped,
                        charCount: charCount,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

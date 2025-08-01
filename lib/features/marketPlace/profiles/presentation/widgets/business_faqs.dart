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
    required String title,
    required TextEditingController controllerText,
    required bool hasTyped,
    required int charCount,
  }) {
    final remaining = 50 - charCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        CustomInputField(
          controller: controllerText,
          hintText: 'text',
          label: 'text',
          validator: validateMin50IfTyped,
        ),
        if (!hasTyped)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Minimum 50 characters needed',
              style: const TextStyle(color: Colors.green, fontSize: 12),
            ),
          )
        else if (remaining > 0)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$remaining more characters needed',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business FAQs'),
        actions: [
          CustomButton(
            text: 'Save',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Save'),
                    content: const Text(
                      'Are you sure you want to save your answers?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context); // Close dialog
                          await profileProvider.answeredBusinessFaqsQuestion();
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
              }
            },
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

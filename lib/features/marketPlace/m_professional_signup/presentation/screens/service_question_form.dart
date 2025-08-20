import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

import '../../data/service_questions.dart';
import '../controllers/m_professional_signup_controller.dart';

class ServiceQuestionForm extends StatefulWidget {
  const ServiceQuestionForm({super.key});

  @override
  State<ServiceQuestionForm> createState() => _ServiceQuestionFormState();
}

class _ServiceQuestionFormState extends State<ServiceQuestionForm> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProfessionalSignUpProvider>(context);

    if (controller.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Service Questions"), elevation: 0),
      body: SafeArea(
        child: Column(
          children: [
            /// --- Progress Bar ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: LinearProgressIndicator(
                // value: controller.serviceQuestions, // add double value in controller (0–1)
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation(Color(0xFF0077B6)),
                minHeight: 6,
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            /// --- Questions ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Please review and confirm your selections",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (controller.questions.isEmpty)
                      const Center(child: Text("No questions available."))
                    else
                      ...controller.questions.map((question) {
                        return _buildQuestionCard(controller, question);
                      }).toList(),
                  ],
                ),
              ),
            ),

            /// --- Bottom Sticky Buttons ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey[400]!),
                      ),
                      child: const Text("Back"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: 'Next',
                      onPressed: controller.isSubmitting
                          ? null
                          : () async {
                              final success = await controller.submitAnswers();
                              if (success && mounted) {
                                Navigator.pushNamed(
                                  context,
                                  AppRouter.location,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Submitted successfully'),
                                  ),
                                );
                              }
                            },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// --- Question Card ---
  Widget _buildQuestionCard(
    ProfessionalSignUpProvider controller,
    ServiceQuestion question,
  ) {
    final formId = question.formId.toString();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Step Badge + Question Text
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: const Color(0xFF0077B6),
                  child: Text(
                    question.step.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.question,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Input Field
            _buildQuestionInput(controller, question, formId),
          ],
        ),
      ),
    );
  }

  /// --- Input Types ---
  Widget _buildQuestionInput(
    ProfessionalSignUpProvider controller,
    ServiceQuestion question,
    String formId,
  ) {
    final currentAnswer = controller.answers[formId];

    switch (question.formType) {
      case 'checkbox':
        return Column(
          children: question.options.map((option) {
            final isSelected = (currentAnswer as List).contains(option);
            return CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFF0077B6),
              title: Text(option),
              value: isSelected,
              onChanged: (bool? value) {
                final newValue = List.from(currentAnswer);
                if (value == true) {
                  newValue.add(option);
                } else {
                  newValue.remove(option);
                }
                controller.updateAnswer(formId, newValue);
              },
            );
          }).toList(),
        );

      case 'radio':
        return Column(
          children: question.options.map((option) {
            return RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              activeColor: const Color(0xFF0077B6),
              title: Text(option),
              value: option,
              groupValue: currentAnswer as String?,
              onChanged: (value) {
                controller.updateAnswer(formId, value);
              },
            );
          }).toList(),
        );

      case 'select':
        return DropdownButtonFormField<String>(
          initialValue: currentAnswer as String?,
          items: question.options.map((option) {
            return DropdownMenuItem(value: option, child: Text(option));
          }).toList(),
          onChanged: (value) {
            controller.updateAnswer(formId, value);
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        );

      default:
        return TextFormField(
          initialValue: currentAnswer as String?,
          onChanged: (value) {
            controller.updateAnswer(formId, value);
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: "Enter your answer...",
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        );
    }
  }
}

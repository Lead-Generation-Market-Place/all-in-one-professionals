import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    return SafeArea(
      top: false,
      bottom: true,
      left: false,
      right: false,

      child: Scaffold(
        appBar: AppBar(title: const Text("Service Questions"), elevation: 0),
        body: Column(
          children: [
            // Progress bar would go here (you'll need to implement this widget)
            // const ProgressBar(currentStep: 5, totalSteps: 4),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Please review and confirm your selections",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

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

            // Bottom buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: const Text("Back"),
                  ),
                  const SizedBox(width: 16),

                  CustomButton(
                    text: 'Next',
                    onPressed: controller.isSubmitting
                        ? null
                        : () async {
                            final success = await controller.submitAnswers();
                            if (success && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Submitted successfully'),
                                ),
                              );
                              // Navigate to next screen
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
                            }
                          },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(
    ProfessionalSignUpProvider controller,
    ServiceQuestion question,
  ) {
    final formId = question.formId.toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0077B6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    question.step.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.question,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildQuestionInput(controller, question, formId),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
          value: currentAnswer as String?,
          items: question.options.map((option) {
            return DropdownMenuItem(value: option, child: Text(option));
          }).toList(),
          onChanged: (value) {
            controller.updateAnswer(formId, value);
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        );

      default:
        return TextFormField(
          initialValue: currentAnswer as String?,
          onChanged: (value) {
            controller.updateAnswer(formId, value);
          },
          decoration: const InputDecoration(border: OutlineInputBorder()),
        );
    }
  }
}

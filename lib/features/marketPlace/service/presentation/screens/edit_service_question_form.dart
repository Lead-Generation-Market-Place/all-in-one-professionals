import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/professional_services_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/answer_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/question_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/controllers/service_controller.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

class EditServiceQuestionForm extends StatefulWidget {
  const EditServiceQuestionForm({
    super.key,
    required this.service,
    this.existingAnswers = const [],
  });

  final ProfessionalServicesModel service;
  final List<AnswerEntity> existingAnswers;

  @override
  State<EditServiceQuestionForm> createState() =>
      _EditServiceQuestionFormState();
}

class _EditServiceQuestionFormState extends State<EditServiceQuestionForm> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;

    final controller = context.read<ServiceController>();

    // Defer controller calls until after the first frame so notifyListeners
    // doesn't run while the widgets are building (avoids setState-during-build).
    WidgetsBinding.instance.addPostFrameCallback((_) {
        // Select current subcategory and service if controller exposes them.
        // Note: selectSubCategory resets the selected service to null, so
        // select the subcategory first, then re-select the service.
      try {
        controller.selectSubCategory(widget.service.subCategoryEntity);
        controller.selectService(widget.service.serviceEntity);
      } catch (_) {
        // ignore if controller doesn't need selection
      }

  Logger().d('EditServiceQuestionForm: incoming service id=${widget.service.professionalServiceId}');
  Logger().d('EditServiceQuestionForm: incoming questions count=${widget.service.questionEntities.length}');

  // Load questions into controller
  controller.setQuestions(widget.service.questionEntities);

  Logger().d('After controller.setQuestions: controller.questions.length=${controller.questions.length}');

      // Load previous answers passed into the widget (if any) OR
      // attempt to read answers embedded inside each question in
      // `widget.service.questionEntities` (without modifying models).
      Logger().d('EditServiceQuestionForm init: existingAnswers length=${widget.existingAnswers.length}');

      // If explicit existingAnswers were provided, prefer them.
      Logger().d('EditServiceQuestionForm: existingAnswers.length=${widget.existingAnswers.length}');
      if (widget.existingAnswers.isNotEmpty) {
        Logger().d('Existing answers passed to widget: ${widget.existingAnswers.map((a) => a.toJson())}');
        final Map<String, dynamic> normalized = {};
        for (final ans in widget.existingAnswers) {
          normalized[ans.questionId] = ans.answers;
        }
        controller.setAnswers(normalized);
        Logger().d('Controller answers after load(existingAnswers): ${controller.answers}');
      } else {
        // Try to extract answers from questionEntities if the backend included
        // them inside each question as an `answer` key at runtime. We use
        // dynamic casts to avoid changing model/entity classes.
        final Map<String, dynamic> normalized = {};
        for (final q in widget.service.questionEntities) {
          try {
            final dynamic runtimeQ = q as dynamic;
            final dynamic raw = runtimeQ.answer; // may be null
            if (raw == null) continue;

            switch (q.formType) {
              case 'checkbox':
                if (raw is List) {
                  normalized[q.id] = raw.map((e) => e.toString()).toList();
                } else if (raw is String) {
                  normalized[q.id] = raw.split(',').map((e) => e.trim()).where((s) => s.isNotEmpty).toList();
                } else {
                  normalized[q.id] = <String>[];
                }
                break;
              case 'radio':
              case 'select':
                if (raw is List && raw.isNotEmpty) {
                  normalized[q.id] = raw.first.toString();
                } else {
                  normalized[q.id] = raw.toString();
                }
                break;
              default:
                normalized[q.id] = raw.toString();
            }
          } catch (e) {
            // if dynamic access fails, skip that question
            Logger().d('No runtime answer found for question ${q.id}: $e');
          }
        }

        if (normalized.isNotEmpty) {
          controller.setAnswers(normalized);
          Logger().d('Controller answers after extracting from questions: ${controller.answers}');
        } else {
          Logger().d('No runtime answers found inside questionEntities');
        }
      }

      // Ensure every question has a value in the controller.answers map.
      for (final question in widget.service.questionEntities) {
        if (!controller.answers.containsKey(question.id)) {
          controller.updateAnswer(question.id, _getDefaultAnswer(question));
        }
      }
    });

    _isInitialized = true;
  }

  // Helper method to get default answer based on question type
  dynamic _getDefaultAnswer(QuestionEntity question) {
    switch (question.formType) {
      case 'checkbox':
        return <String>[];
      case 'radio':
      case 'select':
        return null;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ServiceController>();
    Logger().d(
      'Building EditServiceQuestionForm with ${controller.questions.length} questions and ${controller.answers.length} answers.',
    );

    // Debug: Print all answers to see what's loaded
    controller.answers.forEach((questionId, answer) {
      Logger().d('Question: $questionId, Answer: $answer');
    });

    if (controller.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Questions')),
        body: const Center(child: Text('No questions available.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.selectedService?.name ?? 'Edit Questions'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: controller.questions.map((q) {
                  final currentAnswer = controller.answers[q.id];
                  Logger().d(
                    'Rendering question: ${q.id}, answer: $currentAnswer',
                  );
                  return _buildQuestionCard(
                    context,
                    controller,
                    q,
                    currentAnswer,
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Back"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    text: controller.isSubmitting
                        ? 'Submitting...'
                        : 'Save Changes',
                    onPressed: controller.isSubmitting
                        ? null
                        : () async {
                            await controller.submitAnswers(context);
                          },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context,
    ServiceController controller,
    QuestionEntity question,
    dynamic currentAnswer,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.questionName,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildQuestionInput(controller, question, currentAnswer),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionInput(
    ServiceController controller,
    QuestionEntity question,
    dynamic currentAnswer,
  ) {
    Logger().d(
      'Building input for question: ${question.id}, type: ${question.formType}, current answer: $currentAnswer',
    );

    switch (question.formType) {
      case 'checkbox':
        final selectedOptions = List<String>.from(currentAnswer ?? []);
        Logger().d(
          'Checkbox options: ${question.options}, selected: $selectedOptions',
        );
        return Column(
          children: question.options.map((option) {
            final selected = selectedOptions.contains(option);
            return CheckboxListTile(
              value: selected,
              title: Text(option),
              onChanged: (value) {
                final updated = List<String>.from(selectedOptions);
                if (value == true) {
                  updated.add(option);
                } else {
                  updated.remove(option);
                }
                controller.updateAnswer(question.id, updated);
              },
            );
          }).toList(),
        );

      case 'radio':
        Logger().d(
          'Radio options: ${question.options}, current: $currentAnswer',
        );
        return Column(
          children: question.options.map((option) {
            return RadioListTile<String>(
              value: option,
              groupValue: (currentAnswer is List)
                  ? (currentAnswer.isNotEmpty ? currentAnswer.first as String : null)
                  : currentAnswer as String?,
              title: Text(option),
              onChanged: (value) {
                controller.updateAnswer(question.id, value);
              },
            );
          }).toList(),
        );

      case 'select':
        Logger().d(
          'Select options: ${question.options}, current: $currentAnswer',
        );
        return DropdownButtonFormField<String>(
          initialValue: (currentAnswer is List && currentAnswer.isNotEmpty)
              ? currentAnswer.first as String
              : currentAnswer as String?, // bind to current controller value so rebuilds show selection
          hint: const Text("Select an option"),
          items: question.options.map((option) {
            return DropdownMenuItem<String>(value: option, child: Text(option));
          }).toList(),
          onChanged: (value) {
            controller.updateAnswer(question.id, value);
          },
        );

      default:
        Logger().d('Text input, current: $currentAnswer');
        final controllerText = TextEditingController(text: currentAnswer?.toString() ?? '');
        controllerText.selection = TextSelection.fromPosition(
          TextPosition(offset: controllerText.text.length),
        );
        return TextField(
          controller: controllerText,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: "Enter your answer...",
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            controller.updateAnswer(question.id, value);
          },
        );
    }
  }
}



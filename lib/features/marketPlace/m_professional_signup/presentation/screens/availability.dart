import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/features/marketPlace/m_professional_signup/presentation/controllers/m_professional_signup_controller.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';

class AvailabilityScreen extends StatelessWidget {
  const AvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfessionalSignUpProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Availability',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.black,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const _AvailabilityBody(),
      ),
    );
  }
}

class _AvailabilityBody extends StatelessWidget {
  const _AvailabilityBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(),
          const SizedBox(height: 24),
          _buildAvailabilityTypeSelector(),
          const SizedBox(height: 24),
          const _BusinessHoursSection(),
          const SizedBox(height: 24),
          const _SaveButton(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set your availability',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Customers will only request jobs during the times you set. You need at least 12 hours of availability per week.',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildAvailabilityTypeSelector() {
    return Consumer<ProfessionalSignUpProvider>(
      builder: (context, provider, _) {
        return Column(
          children: [
            _buildRadioOption(
              context,
              title: 'Use any open day or time',
              description:
                  'Customers can request jobs during any time your calendar is not blocked.',
              value: AvailabilityType.anyTime,
              groupValue: provider.selectedType,
              onChanged: (value) {
                provider.setAvailabilityType(value!);
              },
            ),
            const SizedBox(height: 16),
            _buildRadioOption(
              context,
              title: 'Use specific hours',
              description:
                  'Note: You\'ll still get messages from customers outside these times.',
              value: AvailabilityType.businessHours,
              groupValue: provider.selectedType,
              onChanged: (value) {
                provider.setAvailabilityType(value!);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildRadioOption(
    BuildContext context, {
    required String title,
    required String description,
    required AvailabilityType value,
    required AvailabilityType groupValue,
    required ValueChanged<AvailabilityType?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: groupValue == value
                ? AppColors.primaryBlue
                : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Radio<AvailabilityType>(
                  value: value,
                  groupValue: groupValue,
                  onChanged: onChanged,
                  activeColor: AppColors.primaryBlue,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 48.0),
              child: Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BusinessHoursSection extends StatelessWidget {
  const _BusinessHoursSection();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfessionalSignUpProvider>(context);

    if (provider.selectedType != AvailabilityType.businessHours) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...provider.availability.keys.map((day) => _DayRow(day: day)).toList(),
        const SizedBox(height: 24),
        const _SettingsSection(),
      ],
    );
  }
}

class _DayRow extends StatelessWidget {
  final String day;

  const _DayRow({required this.day});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfessionalSignUpProvider>(context);
    final isEditing = provider.editingDays[day]!;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: provider.selectedDays[day],
                    onChanged: (value) =>
                        provider.updateDaySelection(day, value),
                    activeColor: AppColors.primaryBlue,
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(day, style: const TextStyle(fontSize: 16)),
                  ),
                  Expanded(
                    child: Text(
                      provider.availability[day]!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () => provider.toggleDayEditing(day),
                    child: Text(
                      isEditing ? 'Done' : 'Edit',
                      style: const TextStyle(color: AppColors.primaryBlue),
                    ),
                  ),
                ],
              ),
              if (isEditing) _DayTimeEditor(day: day),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _DayTimeEditor extends StatelessWidget {
  final String day;

  const _DayTimeEditor({required this.day});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfessionalSignUpProvider>(context);
    final tempTime = provider.tempTimes[day]!;

    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: tempTime['start'],
                decoration: InputDecoration(
                  labelText: 'Start Time',
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                items: provider.startTimeOptions.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  provider.tempTimes[day]!['start'] = value!;
                  provider.notifyListeners();
                },
              ),
            ),
            const SizedBox(width: 16),
            const Text('to'),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: tempTime['end'],
                decoration: InputDecoration(
                  labelText: 'End Time',
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                items: provider.endTimeOptions.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  provider.tempTimes[day]!['end'] = value!;
                  provider.notifyListeners();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => provider.applyToSelectedDays(day),
          child: const Text(
            'Apply to selected days',
            style: TextStyle(color: AppColors.primaryBlue),
          ),
        ),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildSettingItem(
          context,
          title: 'Lead Time',
          description:
              'Set how much notice you need and how far in advance customers can book',
          children: const [
            _LeadTimeNoticeDropdown(),
            SizedBox(width: 16),
            _LeadTimeAdvanceDropdown(),
          ],
        ),
        const SizedBox(height: 16),
        _buildSettingItem(
          context,
          title: 'Time Zone',
          description: 'Select your time zone',
          children: const [Expanded(child: _TimeZoneDropdown())],
        ),
        const SizedBox(height: 16),
        _buildSettingItem(
          context,
          title: 'Team Capacity',
          description:
              'Set the number of jobs your team can take per time slot',
          children: const [Expanded(child: _JobsPerSlotDropdown())],
        ),
        const SizedBox(height: 16),
        _buildSettingItem(
          context,
          title: 'Travel Time',
          description: 'Set the time you need between jobs for travel',
          children: const [Expanded(child: _TravelTimeDropdown())],
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String title,
    required String description,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 8),
        Row(children: children),
      ],
    );
  }
}

// Settings dropdown widgets would be similar to your existing ones
// but implemented as separate widgets that consume the provider

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfessionalSignUpProvider>(context);

    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: 'Save Business Hours',
        onPressed: provider.isLoading
            ? null
            : () => _saveBusinessHours(context),
        enabled: true,
      ),
    );
  }

  Future<void> _saveBusinessHours(BuildContext context) async {
    final provider = Provider.of<ProfessionalSignUpProvider>(
      context,
      listen: false,
    );

    try {
      provider.isLoading = true;
      provider.notifyListeners();

      // Your save logic here...

      // Show success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Business hours saved successfully')),
      );


      Navigator.pushNamed(context, AppRouter.professionalServiceQuestionForm);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving business hours: $e')),
      );
    } finally {
      provider.isLoading = false;
      provider.notifyListeners();
    }
  }
}

class _LeadTimeNoticeDropdown extends StatelessWidget {
  const _LeadTimeNoticeDropdown();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfessionalSignUpProvider>(context);

    return Expanded(
      child: DropdownButtonFormField<String>(
        value: provider.leadTimeNotice,
        decoration: InputDecoration(
          labelText: 'Notice needed',
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        items: ['1 day', '2 days', '3 days'].map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (value) {
          provider.leadTimeNotice = value!;
          provider.notifyListeners();
        },
      ),
    );
  }
}

class _LeadTimeAdvanceDropdown extends StatelessWidget {
  const _LeadTimeAdvanceDropdown();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfessionalSignUpProvider>(context);

    return Expanded(
      child: DropdownButtonFormField<String>(
        value: provider.leadTimeAdvance,
        decoration: InputDecoration(
          labelText: 'Book in advance',
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        items: ['24 months', '18 months', '12 months'].map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (value) {
          provider.leadTimeAdvance = value!;
          provider.notifyListeners();
        },
      ),
    );
  }
}

class _TimeZoneDropdown extends StatelessWidget {
  const _TimeZoneDropdown();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfessionalSignUpProvider>(context);

    return DropdownButtonFormField<String>(
      value: provider.timeZone,
      decoration: InputDecoration(
        labelText: 'Select time zone',
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      items:
          [
            'Pacific Time Zone',
            'Eastern Time Zone',
            'Central Time Zone',
            'Mountain Time Zone',
            'Alaska Time Zone',
            'Hawaii-Aleutian Time Zone',
          ].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
      onChanged: (value) {
        provider.timeZone = value!;
        provider.notifyListeners();
      },
    );
  }
}

class _JobsPerSlotDropdown extends StatelessWidget {
  const _JobsPerSlotDropdown();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfessionalSignUpProvider>(context);

    return DropdownButtonFormField<String>(
      value: provider.jobsPerSlot,
      decoration: InputDecoration(
        labelText: 'Jobs per slot',
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      items: ['1 job', '2 jobs', '3 jobs', '4 jobs', '5 jobs'].map((
        String value,
      ) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: (value) {
        provider.jobsPerSlot = value!;
        provider.notifyListeners();
      },
    );
  }
}

class _TravelTimeDropdown extends StatelessWidget {
  const _TravelTimeDropdown();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfessionalSignUpProvider>(context);

    return DropdownButtonFormField<String>(
      value: provider.travelTime,
      decoration: InputDecoration(
        labelText: 'Travel time needed',
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      items:
          [
            '15 minutes',
            '30 minutes',
            '45 minutes',
            '1 hour',
            '1.5 hours',
            '2 hours',
          ].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
      onChanged: (value) {
        provider.travelTime = value!;
        provider.notifyListeners();
      },
    );
  }
}

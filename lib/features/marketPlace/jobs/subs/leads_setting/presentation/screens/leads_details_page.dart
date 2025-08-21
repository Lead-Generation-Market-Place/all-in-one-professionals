import 'package:flutter/material.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

class LeadsDetailsPage extends StatefulWidget {
  const LeadsDetailsPage({super.key});

  @override
  State<LeadsDetailsPage> createState() => _LeadsDetailsPageState();
}

class _LeadsDetailsPageState extends State<LeadsDetailsPage> {
  String? _selectedReminder;

  void _showReminderBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Set a reminder',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildReminderOption('In 30 minutes'),
              _buildReminderOption('In 1 hour'),
              _buildReminderOption('In 3 hours'),
              _buildReminderOption('Tomorrow at 09:00'),
              _buildReminderOption('Monday at 09:00'),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Create reminder',
                isFullWidth: true,
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reminder set for $_selectedReminder'),
                      backgroundColor: colorScheme.surface,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showResponsesBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Icon(
                Icons.info_outline,
                size: 40,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Response Limit Notice',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'A maximum number of 5 professionals can respond to each request.\n\n'
                'Being the first to reply will increase your chances of getting a response from the customer.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReminderOption(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Radio<String>(
            value: text,
            groupValue: _selectedReminder,
            onChanged: (value) {
              setState(() {
                _selectedReminder = value;
              });
            },
          ),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lead Details'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: theme.dividerColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CustomButton(
              text: 'Pass',
              type: CustomButtonType.outline,
              size: CustomButtonSize.small,
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Muna',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Staines-Upon-Thames, TW18',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'House Cleaning',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Be the first to respond banner
            Card(
              elevation: 0,
              color: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Be the 1st to respond',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: _showResponsesBottomSheet,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Details'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.tonal(
                      onPressed: _showReminderBottomSheet,
                      child: const Text('Set reminder'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Highlights section
            Text(
              'Highlights',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildHighlightChip('Urgent', colorScheme.error),
                _buildHighlightChip('High hiring intent', colorScheme.tertiary),
                _buildHighlightChip('Verified phone', colorScheme.primary),
                _buildHighlightChip('Frequent user', colorScheme.secondary),
              ],
            ),

            const SizedBox(height: 24),

            // Contact details
            Text(
              'Contact Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildContactOption('079**************', false),
            _buildContactOption('m**************9@g****l.com', true),

            const SizedBox(height: 24),

            // Credits
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.credit_card),
                  SizedBox(width: 8),
                  Text(
                    '8 Credits',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Details section
            Text(
              'Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('What type of property needs cleaning?', 'House'),
            _buildDetailRow('How often do you need cleaning?', 'Weekly'),
            _buildDetailRow('How many bedroom(s) need cleaning?', '3 bedrooms'),
            _buildDetailRow(
              'How many bathroom(s) need cleaning?',
              '1 bathroom + 1 additional toilet',
            ),
            _buildDetailRow('How many reception room(s) need cleaning?', '1'),
            _buildDetailRow(
              'What type of cleaning would you like?',
              'Standard cleaning',
            ),
            _buildDetailRow(
              'Do you currently have a cleaner?',
              'Yes, replacing a current cleaner',
            ),
            _buildDetailRow('When are the best days for cleaning?', 'Any'),
            _buildDetailRow(
              'Will you be supplying cleaning materials/equipment?',
              'Yes - Cleaning materials and equipment',
            ),
            _buildDetailRow(
              'How likely are you to make a hiring decision?',
              'I\'m ready to hire now',
            ),

            const SizedBox(height: 16),

            // Additional details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Additional Details',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('I need 4 to 5 hours once a week'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Location
            Text(
              'Location',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              color: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              child: ListTile(
                leading: Icon(Icons.location_on, color: colorScheme.error),
                title: const Text('Staines-Upon-Thames, TW18'),
                trailing: OutlinedButton(
                  onPressed: () {
                    // Open Google Maps
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.colorScheme.outlineVariant),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Google'),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Contact button
            CustomButton(
              text: 'Contact Muna',
              isFullWidth: true,
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.response_credits);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightChip(String text, Color color) {
    final theme = Theme.of(context);
    return Chip(
      label: Text(text, style: theme.textTheme.labelSmall),
      backgroundColor: color.withOpacity(0.12),
      labelStyle: theme.textTheme.labelSmall?.copyWith(color: color),
      side: BorderSide(color: theme.colorScheme.outlineVariant),
    );
  }

  Widget _buildContactOption(String text, bool isSelected) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Checkbox(value: isSelected, onChanged: (value) {}),
          Text(text, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String question, String answer) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

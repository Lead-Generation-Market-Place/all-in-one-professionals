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
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Set a reminder',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildReminderOption('In 30 minutes'),
              _buildReminderOption('In 1 hour'),
              _buildReminderOption('In 3 hours'),
              _buildReminderOption('Tomorrow at 09:00'),
              _buildReminderOption('Monday at 09:00'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Reminder set for $_selectedReminder'),
                      ),
                    );
                  },
                  child: const Text(
                    'Create reminder',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),

              // Icon
              Icon(
                Icons.info_outline,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),

              const SizedBox(height: 16),

              // Title
              Text(
                'Response Limit Notice',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Description
              Text(
                'A maximum number of 5 professionals can respond to each request.\n\n'
                'Being the first to reply will increase your chances of getting a response from the customer.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Close Button
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lead Details'),
        actions: [CustomButton(text: 'Pass', enabled: true, onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 30),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Muna',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Staines-Upon-Thames, TW18',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'House Cleaning',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Be the first to respond banner
            GestureDetector(
              onTap: _showReminderBottomSheet,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.blue),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: _showResponsesBottomSheet,
                      child: const Text(
                        'Be the 1st to respond',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),

                    const Spacer(),
                    TextButton(
                      onPressed: _showReminderBottomSheet,
                      child: const Text(
                        'Set reminder',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Highlights section
            const Text(
              'Highlights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildHighlightChip('Urgent', Colors.red),
                const SizedBox(width: 8),
                _buildHighlightChip('High hiring intent', Colors.green),
                const SizedBox(width: 8),
                _buildHighlightChip('Verified phone', Colors.blue),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [_buildHighlightChip('Frequent user', Colors.orange)],
            ),

            const SizedBox(height: 24),

            // Contact details
            const Text(
              'Contact Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildContactOption('079**************', false),
            _buildContactOption('m**************9@g****l.com', true),

            const SizedBox(height: 24),

            // Credits
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.credit_card, color: Colors.blue),
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
            const Text(
              'Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                color: Colors.grey[100],
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
            const Text(
              'Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),
                const SizedBox(width: 8),
                const Text('Staines-Upon-Thames, TW18'),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // Open Google Maps
                  },
                  child: const Text('Google'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Contact button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.response_credits);
                },
                child: const Text(
                  'Contact Muna',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightChip(String text, Color color) {
    return Chip(
      label: Text(text, style: const TextStyle(fontSize: 12)),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }

  Widget _buildContactOption(String text, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              // Handle checkbox change
            },
          ),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(answer, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

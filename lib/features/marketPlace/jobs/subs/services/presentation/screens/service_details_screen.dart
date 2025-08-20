import 'package:flutter/material.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String serviceName;

  const ServiceDetailsScreen({super.key, required this.serviceName});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  bool _windsorChecked = false;
  final List<String> _questions = [
    "How likely are you to make a hiring decision?",
    "What type of property needs cleaning?",
    "How often do you need cleaning?",
    "How many bedroom(s) need cleaning?",
    "How many bathroom(s) need cleaning?",
    "How many reception room(s) need cleaning?",
    "What type of cleaning would you like?",
    "Do you currently have a cleaner?",
    "When are the best days for cleaning?",
    "Will you be supplying cleaning materials/equipment?",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.serviceName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose the specific details you want to see in your leads',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Customer Questions Section
            const Text(
              'Customer questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Every customer answers this series of questions, allowing you to define exactly which type of leads you see.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Dynamic list of questions
            ..._questions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;
              return _buildQuestionItem(index + 1, question);
            }).toList(),

            const SizedBox(height: 16),
            const Text(
              'Something missing?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // Handle suggest a question
              },
              child: const Text('Suggest a question'),
            ),

            const Divider(height: 32),

            // Your Locations Section
            const Text(
              'Your locations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            TextButton(
              onPressed: () {
                // Handle add location
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 18),
                  SizedBox(width: 4),
                  Text('Add a location'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Checkbox(
                  value: _windsorChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _windsorChecked = value!;
                    });
                  },
                ),
                const Expanded(child: Text('Within 20 miles of Windsor')),
              ],
            ),

            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Handle remove service
              },
              child: const Text('Remove this service'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionItem(int number, String question) {
    return GestureDetector(
      onTap: () {
        // Navigate to question details screen
        Navigator.pushNamed(
          context,
          '/question-details',
          arguments: {
            'questionNumber': number,
            'questionText': question,
            'serviceName': widget.serviceName,
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$number. $question', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }
}

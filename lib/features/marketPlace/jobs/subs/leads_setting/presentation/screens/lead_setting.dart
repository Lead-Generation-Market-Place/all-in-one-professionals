import 'package:flutter/material.dart';

class LeadSetting extends StatefulWidget {
  const LeadSetting({super.key});

  @override
  State<LeadSetting> createState() => _LeadSettingState();
}

class _LeadSettingState extends State<LeadSetting> {
  bool _windsorChecked = false;

  // Dynamic list of services
  final List<Service> _services = [
    Service(name: 'House Cleaning', description: 'All leads * 1 locations'),
    Service(
      name: 'End of Tenancy Cleaning',
      description: 'All leads * 1 locations',
    ),
    Service(
      name: 'Deep Cleaning Services',
      description: 'All leads * 1 locations',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lead settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Leads you can choose to contact.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Your Services Section
            const Text(
              'Your services',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fine tune the leads you want to be alerted about.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Dynamic list of services
            ..._services
                .map(
                  (service) =>
                      _buildServiceItem(service.name, service.description),
                )
                .toList(),

            const Divider(height: 32),

            _buildAddButton(
              'Add a service',
              onPressed: () {
                // Handle add service logic
              },
            ),
            const SizedBox(height: 32),

            // Your Locations Section
            const Text(
              'Your locations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose where you want to find new customers.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
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
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Within 20 miles of Windsor'),
                      SizedBox(height: 4),
                      Text(
                        '3 services',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 32),

            _buildAddButton(
              'Add a location',
              onPressed: () {
                // Handle add location logic
              },
            ),
            const SizedBox(height: 32),

            // Online/Remote Leads Section
            const Text(
              'Online/remote leads',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Customers tell us if they\'re happy to receive services online or remotely.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            TextButton(
              onPressed: () {
                // Navigator.pushNamed(context, AppRouter.onlineLeadsScreen);
              },
              child: const Text('See online/remote leads'),
            ),
            const SizedBox(height: 32),

            // View Leads Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.pushNamed(context, AppRouter.viewLeadsScreen);
                },
                child: const Text('View leads'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(
        //     context,
        //     // AppRouter.serviceDetailsScreen,
        //     arguments: {'serviceName': title}
        // );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(String text, {VoidCallback? onPressed}) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add, size: 18),
          const SizedBox(width: 4),
          Text(text),
        ],
      ),
    );
  }
}

// Service model class
class Service {
  final String name;
  final String description;

  Service({required this.name, required this.description});
}

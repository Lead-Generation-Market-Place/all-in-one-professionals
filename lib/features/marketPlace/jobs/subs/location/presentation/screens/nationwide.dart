import 'package:flutter/material.dart';

class Nationwide extends StatefulWidget {
  const Nationwide({super.key});

  @override
  State<Nationwide> createState() => _NationwideState();
}

class _NationwideState extends State<Nationwide> {
  final List<String> allServices = [
    'Plumbing',
    'Electrical',
    'Carpentry',
    'Cleaning',
    'Landscaping',
    'Painting',
    'Roofing',
    'HVAC',
    'Pest Control',
    'Moving Services',
    'Appliance Repair',
  ];

  // Store selected services
  final Set<String> selectedServices = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nationwide'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Select the services you offer at this location',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: allServices.length,
                itemBuilder: (context, index) {
                  final service = allServices[index];
                  final isSelected = selectedServices.contains(service);

                  return CheckboxListTile(
                    title: Text(service),
                    value: isSelected,
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          selectedServices.add(service);
                        } else {
                          selectedServices.remove(service);
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print('Selected services: $selectedServices');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Services updated")),
                  );
                },
                child: const Text('Save Services'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

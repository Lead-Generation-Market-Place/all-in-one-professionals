import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:yelpax_pro/shared/widgets/custom_advanced_dropdown.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';
import 'package:yelpax_pro/shared/widgets/custom_input.dart';

class Job {
  final int id;
  final String name;

  Job({required this.id, required this.name});
}

class Service {
  final int id;
  final String name;

  Service({required this.id, required this.name});
}

class FeaturedProjects extends StatefulWidget {
  const FeaturedProjects({super.key});

  @override
  State<FeaturedProjects> createState() => _FeaturedProjectsState();
}

class _FeaturedProjectsState extends State<FeaturedProjects> {
  final List<Job> _jobs = [
    Job(id: 1, name: 'Developer'),
    Job(id: 2, name: 'Designer'),
    Job(id: 3, name: 'Consultant'),
    Job(id: 4, name: 'Student'),
  ];

  final List<Service> _services = [
    Service(id: 10, name: 'Home Cleaning'),
    Service(id: 11, name: 'Home Designing'),
    Service(id: 12, name: 'Plumber'),
    Service(id: 13, name: 'Modeling'),
  ];

  final List<String> imageUrls = [
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150/0000FF',
    'https://via.placeholder.com/150/FF0000',
    'https://via.placeholder.com/150/00FF00',
  ];

  int? selectedJobId;
  int? selectedServiceId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final jobNames = _jobs.map((job) => job.name).toList();
    final serviceNames = _services.map((service) => service.name).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Featured Projects', style: theme.textTheme.titleLarge),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(text: 'Save', enabled: true, onPressed: () {}),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: theme.inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AdvancedDropdown<Service>(
                  items: _services,
                  selectedItem: selectedServiceId != null
                      ? _services.firstWhere((s) => s.id == selectedServiceId)
                      : null,
                  hintText: 'Select service...',
                  itemToString: (service) => service.name,
                  onChanged: (selected) {
                    if (selected != null) {
                      setState(() {
                        selectedServiceId = selected.id;
                      });
                      Logger().i(
                        'Selected Service ID: ${selected.id}, Name: ${selected.name}',
                      );
                    }
                  },
                ),

              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: theme.inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AdvancedDropdown<Job>(
                  items: _jobs,
                  selectedItem: selectedJobId != null
                      ? _jobs.firstWhere((j) => j.id == selectedJobId)
                      : null,
                  hintText: 'Select job...',
                  itemToString: (job) => job.name,
                  onChanged: (selected) {
                    if (selected != null) {
                      setState(() {
                        selectedJobId = selected.id;
                      });
                      Logger().i(
                        'Selected Job ID: ${selected.id}, Name: ${selected.name}',
                      );
                    }
                  },
                ),

              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomInputField(
                    label: 'Project Title',
                    hintText: 'Project title',
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Example: Outdoor beach wedding',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Photo',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: imageUrls.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrls[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.broken_image,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add photo functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Add Photo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

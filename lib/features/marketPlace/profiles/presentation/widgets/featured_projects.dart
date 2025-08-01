import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
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
  // List of objects
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
  // Temporary dummy image list — you can use File objects, assets, or network images
  final List<String> imageUrls = [
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150/0000FF',
    'https://via.placeholder.com/150/FF0000',
    'https://via.placeholder.com/150/00FF00',
  ];

  // For selected item IDs
  int? selectedJobId;
  int? selectedServiceId;

  @override
  Widget build(BuildContext context) {
    // Extract names only for dropdown display
    final jobNames = _jobs.map((job) => job.name).toList();
    final serviceNames = _services.map((service) => service.name).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Featured Projects'),
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
              CustomDropdown.search(
                hintText: 'Select service...',
                items: serviceNames,
                initialItem: selectedServiceId != null
                    ? _services
                          .firstWhere((s) => s.id == selectedServiceId)
                          .name
                    : null,
                onChanged: (selectedName) {
                  final selectedService = _services.firstWhere(
                    (service) => service.name == selectedName,
                  );
                  setState(() {
                    selectedServiceId = selectedService.id;
                  });
                  Logger().i(
                    'Selected Service ID: ${selectedService.id}, Name: ${selectedService.name}',
                  );
                },
              ),
              const SizedBox(height: 20),
              CustomDropdown.search(
                hintText: 'Select job...',
                items: jobNames,
                initialItem: selectedJobId != null
                    ? _jobs.firstWhere((j) => j.id == selectedJobId).name
                    : null,
                onChanged: (selectedName) {
                  final selectedJob = _jobs.firstWhere(
                    (job) => job.name == selectedName,
                  );
                  setState(() {
                    selectedJobId = selectedJob.id;
                  });
                  Logger().i(
                    'Selected Job ID: ${selectedJob.id}, Name: ${selectedJob.name}',
                  );
                },
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 20),

              // Wrap in a Column instead of Row
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomInputField(
                    label: 'Project Title',
                    hintText: 'Project title',
                  ),
                  const SizedBox(height: 4), // spacing between input and text
                  const Text(
                    'Example: Outdoor beach wedding',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Replace this inside your build method, instead of:
              // Container(
              // )
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: imageUrls.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
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
                          color: Colors.grey[300],
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

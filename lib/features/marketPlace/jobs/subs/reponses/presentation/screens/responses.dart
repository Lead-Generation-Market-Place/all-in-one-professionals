import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:yelpax_pro/config/routes/router.dart';

import '../../../../presentation/widgets/bottom_navbar_leads.dart';

class Status {
  final int id;
  final String name;
  Status({required this.id, required this.name});
}

class Responses extends StatefulWidget {
  const Responses({super.key});

  @override
  State<Responses> createState() => _ResponsesState();
}

class _ResponsesState extends State<Responses> {
  int _currentNavIndex = 1; // Responses is index 1
  Status? selectedStatus;

  void _onNavItemTapped(int index, BuildContext context) {
    if (index == _currentNavIndex) return;

    setState(() {
      _currentNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRouter.google_map_leads);
        break;
      case 1:
        // Already on Responses screen
        break;
      case 2:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/reminders',
          (route) => false,
        );
        break;
    }
  }

  List<Status> statusList = [
    Status(id: 1, name: 'Pending'),
    Status(id: 2, name: 'Hired'),
    Status(id: 3, name: 'Archived'),
  ];

  @override
  Widget build(BuildContext context) {
    final statusItems = statusList.map((e) => e.name).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responses'),
        centerTitle: true,
        leading: CircleAvatar(
          child: IconButton(onPressed: () {}, icon: const Icon(Icons.av_timer)),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomDropdown<String>(
              items: statusItems,
              initialItem: selectedStatus?.name,
              hintText: 'Select Status',
              onChanged: (name) {
                setState(() {
                  selectedStatus = statusList.firstWhere(
                    (status) => status.name == name,
                  );
                });
                debugPrint(
                  'Selected status: ${selectedStatus!.name} (ID: ${selectedStatus!.id})',
                );
              },
            ),
            const SizedBox(height: 40),

            Padding(
              padding: EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  Text('No Responses'),
                  Text(
                    "You haven't responded to any customers yet.  When you do, you'll be able to contact and access their details here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRouter.homeServicesJobs,
                  (route) => false,
                );
              },
              child: Text('View Leads', style: TextStyle(inherit: true)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => _onNavItemTapped(index, context),
      ),
    );
  }
}

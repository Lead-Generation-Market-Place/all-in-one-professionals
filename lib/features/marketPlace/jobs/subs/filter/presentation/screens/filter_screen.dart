import 'package:flutter/material.dart';

import '../../../../../../../shared/widgets/custom_search_input.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // Filter states
  int selectedCredit = 6;
  bool showAllLocations = true;
  bool show20MilesFromWindsor = false;
  List<String> selectedServices = [];
  String leadSubmittedTime = 'Any time';
  String sortBy = 'Recommended';
  bool showUnread = false;
  List<String> selectedLeadSpotlights = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filter'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            bottom: 50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter results header
              _buildFilterResultsHeader(),
              const SizedBox(height: 16),

              // Sort by section
              _buildSortBySection(),
              const SizedBox(height: 16),

              // Keyword search
              DynamicSearchInput(hintText: 'Search ....'),
              const SizedBox(height: 16),

              // View section
              _buildViewSection(),
              const SizedBox(height: 16),

              // Lead spotlights
              _buildLeadSpotlights(),
              const SizedBox(height: 16),

              // Credits section
              _buildCreditsSection(),
              const SizedBox(height: 16),

              // Contact preferences
              _buildContactPreferences(),
              const SizedBox(height: 16),

              // Buyer actions
              _buildBuyerActions(),
              const SizedBox(height: 16),

              // When lead was submitted
              _buildLeadSubmittedTime(),
              const SizedBox(height: 16),

              // Services
              _buildServicesSection(),
              const SizedBox(height: 16),

              // Locations
              _buildLocationsSection(),
              const SizedBox(height: 16),

              // Apply filter button at bottom
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Apply filter logic
                  },
                  child: const Text('Apply filter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterResultsHeader() {
    return const Wrap(
      spacing: 2,
      runSpacing: 2,
      children: [
        Text(
          'Filtered results: 136',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          '733 leads matching your Lead Settings',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSortBySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sort by', style: TextStyle(fontWeight: FontWeight.bold)),
        RadioListTile<String>(
          title: const Text('Recommended'),
          value: 'Recommended',
          groupValue: sortBy,
          onChanged: (value) {
            setState(() {
              sortBy = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Newest first'),
          value: 'Newest first',
          groupValue: sortBy,
          onChanged: (value) {
            setState(() {
              sortBy = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildKeywordSearch() {
    return const TextField(
      decoration: InputDecoration(
        labelText: 'Keyword search',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildViewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('View', style: TextStyle(fontWeight: FontWeight.bold)),
        CheckboxListTile(
          title: const Text('Unread (729)'),
          value: showUnread,
          onChanged: (value) {
            setState(() {
              showUnread = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildLeadSpotlights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lead spotlights',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        CheckboxListTile(
          title: const Text('All lead spotlights (653)'),
          value: selectedLeadSpotlights.contains('All'),
          onChanged: (value) {
            setState(() {
              if (value!) {
                selectedLeadSpotlights.add('All');
              } else {
                selectedLeadSpotlights.remove('All');
              }
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Free leads (277)'),
          value: selectedLeadSpotlights.contains('Free'),
          onChanged: (value) {
            setState(() {
              if (value!) {
                selectedLeadSpotlights.add('Free');
              } else {
                selectedLeadSpotlights.remove('Free');
              }
            });
          },
        ),
        CheckboxListTile(
          title: const Text('1st to respond (352)'),
          value: selectedLeadSpotlights.contains('1st'),
          onChanged: (value) {
            setState(() {
              if (value!) {
                selectedLeadSpotlights.add('1st');
              } else {
                selectedLeadSpotlights.remove('1st');
              }
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Urgent (178)'),
          value: selectedLeadSpotlights.contains('Urgent'),
          onChanged: (value) {
            setState(() {
              if (value!) {
                selectedLeadSpotlights.add('Urgent');
              } else {
                selectedLeadSpotlights.remove('Urgent');
              }
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Updated requests (12)'),
          value: selectedLeadSpotlights.contains('Updated'),
          onChanged: (value) {
            setState(() {
              if (value!) {
                selectedLeadSpotlights.add('Updated');
              } else {
                selectedLeadSpotlights.remove('Updated');
              }
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Has additional details (502)'),
          value: selectedLeadSpotlights.contains('Details'),
          onChanged: (value) {
            setState(() {
              if (value!) {
                selectedLeadSpotlights.add('Details');
              } else {
                selectedLeadSpotlights.remove('Details');
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildCreditsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Credits', style: TextStyle(fontWeight: FontWeight.bold)),
        _buildCreditCheckbox(2, 12),
        _buildCreditCheckbox(3, 52),
        _buildCreditCheckbox(4, 100),
        _buildCreditCheckbox(5, 160),
        _buildCreditCheckbox(6, 136),
        _buildCreditCheckbox(7, 157),
        _buildCreditCheckbox(8, 87),
        _buildCreditCheckbox(9, 14),
        _buildCreditCheckbox(10, 10),
        _buildCreditCheckbox(11, 2),
        _buildCreditCheckbox(12, 2),
        _buildCreditCheckbox(14, 1),
      ],
    );
  }

  Widget _buildCreditCheckbox(int credits, int count) {
    return CheckboxListTile(
      title: Text('$credits Credits ($count)'),
      value: selectedCredit == credits,
      onChanged: (value) {
        setState(() {
          if (value!) {
            selectedCredit = credits;
          } else {
            selectedCredit = 0;
          }
        });
      },
    );
  }

  Widget _buildContactPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact preferences',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        CheckboxListTile(
          title: const Text('Phone (0)'),
          value: false,
          onChanged: (value) {},
        ),
        CheckboxListTile(
          title: const Text('Email (0)'),
          value: false,
          onChanged: (value) {},
        ),
        CheckboxListTile(
          title: const Text('SMS (0)'),
          value: false,
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildBuyerActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Actions buyer has taken',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        RadioListTile(
          title: const Text('Buyer has taken an action (0)'),
          value: 'action',
          groupValue: '',
          onChanged: (value) {},
        ),
        RadioListTile(
          title: const Text('Buyer has requested a quote (0)'),
          value: 'quote',
          groupValue: '',
          onChanged: (value) {},
        ),
        RadioListTile(
          title: const Text('Buyer has expressed an interest (0)'),
          value: 'interest',
          groupValue: '',
          onChanged: (value) {},
        ),
        RadioListTile(
          title: const Text('Buyer has sent a message (0)'),
          value: 'message',
          groupValue: '',
          onChanged: (value) {},
        ),
        RadioListTile(
          title: const Text('Buyer has requested a callback (0)'),
          value: 'callback',
          groupValue: '',
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildLeadSubmittedTime() {
    final options = [
      'Any time',
      'Last hour (1)',
      'Today (27)',
      'Yesterday (12)',
      'Less than 3 days ago (57)',
      'Less than 7 days ago (105)',
      'Within the last 2 weeks (136)',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'When the lead was submitted',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...options.map(
          (option) => RadioListTile(
            title: Text(option),
            value: option,
            groupValue: leadSubmittedTime,
            onChanged: (value) {
              setState(() {
                leadSubmittedTime = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServicesSection() {
    final services = [
      {'name': 'House Cleaning', 'count': 103},
      {'name': 'End of Tenancy Cleaning', 'count': 29},
      {'name': 'Deep Cleaning Services', 'count': 4},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Services', style: TextStyle(fontWeight: FontWeight.bold)),
        ...services.map(
          (service) => CheckboxListTile(
            title: Text('${service['name']} (${service['count']})'),
            value: selectedServices.contains(service['name']),
            onChanged: (value) {
              setState(() {
                if (value!) {
                  // selectedServices.add(service['name']);
                } else {
                  selectedServices.remove(service['name']);
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLocationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Locations', style: TextStyle(fontWeight: FontWeight.bold)),
        CheckboxListTile(
          title: const Text('All'),
          value: showAllLocations,
          onChanged: (value) {
            setState(() {
              showAllLocations = value!;
              if (showAllLocations) {
                show20MilesFromWindsor = false;
              }
            });
          },
        ),
        CheckboxListTile(
          title: const Text('20 miles from Windsor'),
          value: show20MilesFromWindsor,
          onChanged: (value) {
            setState(() {
              show20MilesFromWindsor = value!;
              if (show20MilesFromWindsor) {
                showAllLocations = false;
              }
            });
          },
        ),
      ],
    );
  }
}

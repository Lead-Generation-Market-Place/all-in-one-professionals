import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/presentation/widgets/finish_setup.dart';
import 'package:yelpax_pro/shared/widgets/custom_appbar.dart';

import '../../../../../shared/widgets/custom_search_input.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isSetupFinished = false;
  int _currentTabIndex = 0;

  List<Map<String, dynamic>> leads = [
    {
      'name': 'Samantha',
      'location': 'London, NW6',
      'timeAgo': '19m ago',
      'isUrgent': false,
      'hasHighHiringIntent': true,
      'isVerifiedPhone': false,
      'hasAdditionalDetails': true,
      'isFrequentUser': true,
      'serviceType': 'Cleaning',
      'serviceDetails':
          'Apartment / 1 bedroom / 1 bathroom / one time clean service',
      'notes':
          'Need the cleaning to be done tomorrow for a one bedroom flat that is currently empty. Keys to the property would need to be picked...',
      'credits': 7,
      'responseStatus': '1st to respond',
    },
    {
      'name': 'A. Annie',
      'location': 'Rickmansworth, WD3',
      'timeAgo': '2h ago',
      'isUrgent': true,
      'hasHighHiringIntent': true,
      'isVerifiedPhone': true,
      'hasAdditionalDetails': true,
      'isFrequentUser': true,
      'serviceType': 'House Cleaning',
      'serviceDetails':
          'House / 4 bedrooms / 2 bathrooms + 1 additional toilet / Every other week service',
      'notes': 'Husband and wife with friendly dogs',
      'credits': 7,
      'responseStatus': '1/5',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (!isSetupFinished)
            ProfileCompletionBanner(
              stepNumber: 3,
              onFinishSetupPressed: () {
                Navigator.pushNamed(context, AppRouter.signUpProcessScreen);
              },
            ),
          CustomAppBar(
            title: 'Jobs',
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.homeServicesNotifications,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.settingsScreen);
                },
              ),
            ],
          ),
          // AppBar

          // Header section matching the image exactly
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First row with "Leads" title and input + map button
                Row(
                  children: [
                    // Search input
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRouter.filterScreen);
                        },
                        child: AbsorbPointer(
                          // prevents direct typing
                          child: DynamicSearchInput(
                            hintText: 'Search Leads...',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8), // Map button
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.map_outlined,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRouter.google_map_leads,
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 8), // Map button
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, AppRouter.leadSetting);
                        },
                      ),
                    ),
                  ],
                ),

                // Second row with leads count and services

                // Third row with filter tabs
                const SizedBox(height: 10),
              ],
            ),
          ),

          Divider(
            height: 24,
            thickness: 1,
            color: Theme.of(context).dividerColor,
          ),
          // Tab Content
          Expanded(child: _buildLeadsList()),
        ],
      ),
    );
  }

  Widget _buildLeadsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      itemCount: leads.length,
      itemBuilder: (context, index) {
        final lead = leads[index];
        return Slidable(
          key: Key(lead['name']),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  setState(() {
                    leads.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Passed on ${lead['name']}')),
                  );
                },
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
                icon: Icons.close,
                label: 'Pass',
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.leadDetailsPage);
                },
                child: Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lead['name'],
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  lead['timeAgo'],
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                            Text(
                              lead['location'],
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Tags Row
                        Wrap(
                          spacing: 12,
                          children: [
                            // Urgent Tag
                            if (lead['isUrgent'])
                              _buildSimpleTag(
                                label: 'Urgent',
                                color: Theme.of(context).colorScheme.error,
                              ),
                            // High Hiring Intent Tag
                            if (lead['hasHighHiringIntent'])
                              _buildSimpleTag(
                                label: 'High hiring intent',
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Verification Tags
                        Wrap(
                          spacing: 12,
                          children: [
                            // Verified Phone Tag
                            if (lead['isVerifiedPhone'])
                              _buildSimpleTag(
                                label: 'Verified phone',
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            // Additional Details Tag
                            if (lead['hasAdditionalDetails'])
                              _buildSimpleTag(
                                label: 'Additional details',
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Frequent User Tag
                        if (lead['isFrequentUser'])
                          _buildSimpleTag(
                            label: 'Frequent user',
                            color: Theme.of(context).colorScheme.secondary,
                          ),

                        const SizedBox(height: 16),
                        const Divider(height: 1),

                        const SizedBox(height: 16),

                        // Service Type
                        Text(
                          lead['serviceType'],
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 8),

                        // Service Details
                        Text(
                          lead['serviceDetails'],
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),

                        const SizedBox(height: 12),

                        // Notes (if any)
                        if (lead['notes'] != null && lead['notes'].isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                lead['notes'],
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 16),
                        const Divider(height: 1),

                        const SizedBox(height: 16),

                        // Credits and Response Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '💬 ${lead['credits']} Credits',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              lead['responseStatus'],
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSimpleTag({required String label, required Color color}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(color: color),
      ),
    );
  }

  Widget _buildFilterTab(String text, {bool isActive = false}) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isActive ? scheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isActive ? scheme.primary : scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

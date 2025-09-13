import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/presentation/widgets/finish_setup.dart';
import 'package:yelpax_pro/shared/widgets/custom_appbar.dart';
import 'package:yelpax_pro/shared/widgets/custom_search_input.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isSetupFinished = true;
  int _currentTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();

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
      'profileImage': 'assets/images/avatar1.jpg', // Added profile image
      'rating': 4.8, // Added rating
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
      'profileImage': 'assets/images/avatar2.jpg', // Added profile image
      'rating': 4.5, // Added rating
    },
    // Add more sample leads to demonstrate scrolling
    {
      'name': 'John Smith',
      'location': 'Manchester, M1',
      'timeAgo': '3h ago',
      'isUrgent': false,
      'hasHighHiringIntent': false,
      'isVerifiedPhone': true,
      'hasAdditionalDetails': false,
      'isFrequentUser': false,
      'serviceType': 'Gardening',
      'serviceDetails': 'Backyard / Lawn mowing / Hedge trimming',
      'notes': 'Need regular maintenance for my garden',
      'credits': 5,
      'responseStatus': '3/5',
      'profileImage': 'assets/images/avatar3.jpg',
      'rating': 4.2,
    },
    {
      'name': 'Emma Wilson',
      'location': 'Birmingham, B2',
      'timeAgo': '5h ago',
      'isUrgent': true,
      'hasHighHiringIntent': true,
      'isVerifiedPhone': true,
      'hasAdditionalDetails': true,
      'isFrequentUser': false,
      'serviceType': 'Plumbing',
      'serviceDetails': 'Kitchen sink / Leaking pipe / Emergency repair',
      'notes': 'Water is leaking all over the kitchen floor',
      'credits': 10,
      'responseStatus': '1st to respond',
      'profileImage': 'assets/images/avatar4.jpg',
      'rating': 4.9,
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leads'),
       
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.homeServicesNotifications);
            },
          ),
          IconButton(
            icon: const Icon(Icons.campaign),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.marketing_dashboard);
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
    
      body: Column(
        children: [
            
          if (!isSetupFinished)
            ProfileCompletionBanner(
              stepNumber: 3,
              onFinishSetupPressed: () {
                Navigator.pushNamed(context, AppRouter.signUpProcessScreen);
              },
            ),

          // Search and filter section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                // Search input
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.filterScreen);
                    },
                    child: AbsorbPointer(
                      child: DynamicSearchInput(hintText: 'Search Leads...'),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Map button
                Card(
                
                  child: IconButton(
                    icon: Icon(
                      Icons.map_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.google_map_leads);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Settings button
                Card(
               
             
                  child: IconButton(
                    icon: Icon(
                      Icons.filter_list_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.leadSetting);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3.0,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant,
              tabs: const [
                Tab(text: 'All Leads'),
                Tab(text: 'My Leads'),
              ],
            ),
          ),

          // Tab Content - Only this part is scrollable
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildLeadsList(), _buildMyLeadsList()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadsList() {
    if (leads.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No leads available',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new job opportunities',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
   
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: leads.length,
      itemBuilder: (context, index) {
        final lead = leads[index];
        return _buildLeadCard(lead, index);
      },
    );
  }

  Widget _buildLeadCard(Map<String, dynamic> lead, int index) {
    return Container(
      child: Slidable(
        key: Key(lead['name']),
        endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const ScrollMotion(),
          children: [
            // Pass button - full height of the container
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 8, bottom: 16),
                child: SlidableAction(
                  onPressed: (context) {
                    setState(() {
                      leads.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Passed on ${lead['name']}'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  icon: Icons.close,
                  label: 'Pass',
                  borderRadius: BorderRadius.circular(16),
                  autoClose: true,
                ),
              ),
            ),
          ],
        ),
        child: Card(
          margin: const EdgeInsets.only(bottom: 16),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(16),
          //   border: Border.all(color: Theme.of(context).colorScheme.outline),
          // ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.pushNamed(context, AppRouter.leadDetailsPage);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with profile and basic info
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile avatar
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                          child: lead['profileImage'] != null
                              ? ClipOval(
                                  child: Image.asset(
                                    lead['profileImage'],
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Text(
                                        lead['name'][0],
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimaryContainer,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Text(
                                  lead['name'][0],
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 12),
                        // Name and location
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lead['name'],
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lead['location'],
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        // Time and urgent indicator
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              lead['timeAgo'],
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            if (lead['isUrgent'])
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.errorContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Urgent',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onErrorContainer,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Tags Row
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        // High Hiring Intent Tag
                        if (lead['hasHighHiringIntent'])
                          _buildSimpleTag(
                            label: 'High hiring intent',

                            icon: Icons.trending_up,
                          ),
                        // Verified Phone Tag
                        if (lead['isVerifiedPhone'])
                          _buildSimpleTag(
                            label: 'Verified phone',

                            icon: Icons.verified,
                          ),
                        // Additional Details Tag
                        if (lead['hasAdditionalDetails'])
                          _buildSimpleTag(
                            label: 'Additional details',

                            icon: Icons.info_outline,
                          ),
                        // Frequent User Tag
                        if (lead['isFrequentUser'])
                          _buildSimpleTag(
                            label: 'Frequent user',

                            icon: Icons.star,
                          ),
                        // Rating if available
                        if (lead['rating'] != null)
                          _buildSimpleTag(
                            label: '${lead['rating']} ★',

                            icon: Icons.star_rate,
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),

                    // Service Information
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lead['serviceType'],
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          lead['serviceDetails'],
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),

                    // Notes (if any)
                    if (lead['notes'] != null && lead['notes'].isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                lead['notes'],
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),

                    // Footer with credits and response status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.bolt,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text('${lead['credits']} Credits'),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                         
                          child: Text(lead['responseStatus']),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMyLeadsList() {
    // Implement your "My Leads" tab content here
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No saved leads',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Save leads to view them here',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleTag({
    required String label,
    IconData? icon,
   
    bool isInteractive = false,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    

    return GestureDetector(
      onTap: isInteractive ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          
          borderRadius: BorderRadius.circular(16),
          border: Border.all( 
            width: 0.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
              
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

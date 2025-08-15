import 'package:flutter/material.dart';
import 'package:yelpax_pro/config/routes/router.dart';

import '../../../jobs/presentation/widgets/finish_setup.dart';
import '../../data/service_model.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceDashboardState();
}

class _ServiceDashboardState extends State<ServiceScreen> {
  bool isSetupFinished = false;
  int? expandedServiceId;

  late List<Service> services = [
    Service(
      id: 1,
      name: "Basement Finishing or Remodeling",
      active: true,
      completed: false,
      description:
          "Transform your basement into a functional living space with our remodeling services.",
      metrics: ServiceMetrics(spent: "\$0", leads: 0, views: 0),
      setupProgress: SetupProgress(
        questions: true,
        pricing: false,
        availability: false,
        serviceArea: true,
      ),
    ),
    Service(
      id: 2,
      name: "Kitchen Remodeling",
      active: true,
      completed: true,
      description:
          "Modern kitchen remodeling services to upgrade your cooking space.",
      metrics: ServiceMetrics(spent: "\$120", leads: 3, views: 24),
    ),
  ];

  void toggleService(int id) {
    setState(() {
      services = services.map((service) {
        if (service.id == id) {
          // return service.copyWith(active: !service.active);
        }
        return service;
      }).toList();
    });
  }

  void toggleExpand(int id) {
    setState(() {
      expandedServiceId = expandedServiceId == id ? null : id;
    });
  }

  double calculateCompletion(Service service) {
    if (service.completed) return 100;
    if (service.setupProgress == null) return 0;

    final totalSteps = service.setupProgress!.toJson().length;
    final completedSteps = service.setupProgress!
        .toJson()
        .values
        .where((v) => v)
        .length;
    return (completedSteps / totalSteps) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top:  30.0),
        child: Column(
          children: [
            if (!isSetupFinished)
              ProfileCompletionBanner(
                stepNumber: 3,
                onFinishSetupPressed: () {
                  Navigator.pushNamed(context, AppRouter.signUpProcessScreen);
                },
              ),

            // App Bar
            Material(
              elevation: 4,
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: SizedBox(
                height: kToolbarHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRouter.homeServicesNotifications,
                              );
                              debugPrint("Settings tapped");
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRouter.settingsScreen,
                              );
                              debugPrint("Settings tapped");
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Stats Cards
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  StatCard(title: "Active Services", value: "4"),
                  StatCard(title: "Avg. Rating", value: "3.7"),
                  StatCard(title: "Total Reviews", value: "134"),
                  StatCard(title: "Incomplete Setups", value: "2"),
                ],
              ),
            ),

            // Header with business info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BCC Brand",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "Falls Church",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.businessAvailability,
                      );
                    },
                    child: const Text("Business Availability"),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Services section
                    Card(
                      margin: const EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Services",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Set your job preferences, activate or deactivate services, and choose where you want to work.",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.info_outline),
                              label: const Text(
                                "View our guide to job preferences",
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Service list
                            ...services.map(
                              (service) => ServiceCard(
                                service: service,
                                isExpanded: expandedServiceId == service.id,
                                completion: calculateCompletion(service),
                                onToggle: () => toggleService(service.id),
                                onExpand: () => toggleExpand(service.id),
                              ),
                            ),

                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.add),
                              label: const Text("Add a Service"),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Sidebar cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const ActivityCard(),
                          const SizedBox(height: 16),
                          const SpendingCard(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final Service service;
  final bool isExpanded;
  final double completion;
  final VoidCallback onToggle;
  final VoidCallback onExpand;

  const ServiceCard({
    required this.service,
    required this.isExpanded,
    required this.completion,
    required this.onToggle,
    required this.onExpand,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasSetupProgress = service.setupProgress != null;
    final bool isCompleted = service.completed;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: service.active
              ? Theme.of(context).primaryColor.withOpacity(0.2)
              : Colors.grey.shade300,
        ),
      ),
      child: InkWell(
        onTap: onExpand,
        child: Column(
          children: [
            // Service header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          service.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Switch(
                        value: service.active,
                        onChanged: (_) => onToggle(),
                      ),
                      IconButton(
                        icon: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                        ),
                        onPressed: onExpand,
                      ),
                    ],
                  ),
                  if (service.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        service.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  if (hasSetupProgress && !isCompleted)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Setup progress: ${completion.toStringAsFixed(0)}%",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              "${service.setupProgress!.toJson().values.where((v) => v).length}/"
                              "${service.setupProgress!.toJson().length} steps",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: completion / 100,
                          backgroundColor: Colors.grey.shade200,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Expanded content
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Setup incomplete section
                    if (hasSetupProgress && !isCompleted)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border(
                            left: BorderSide(color: Colors.red, width: 4),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.warning, color: Colors.red),
                                const SizedBox(width: 8),
                                Text(
                                  "Setup incomplete",
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(color: Colors.red),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Complete your service setup to start receiving leads.",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            ...service.setupProgress!.toJson().entries.map(
                              (e) => ListTile(
                                leading: Icon(
                                  e.value ? Icons.check : Icons.close,
                                  color: e.value ? Colors.green : Colors.red,
                                ),
                                title: Text(e.key),
                                trailing: TextButton(
                                  onPressed: () {},
                                  child: const Text("Set up"),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text("Complete Setup"),
                            ),
                          ],
                        ),
                      ),

                    // Metrics section
                    const SizedBox(height: 16),
                    Text(
                      "Activity this week",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        MetricCard(
                          icon: Icons.attach_money,
                          title: "Spent",
                          value: service.metrics.spent,
                          color: Colors.blue,
                        ),
                        MetricCard(
                          icon: Icons.abc_outlined,
                          title: "Leads",
                          value: service.metrics.leads.toString(),
                          color: Colors.green,
                        ),
                        MetricCard(
                          icon: Icons.remove_red_eye,
                          title: "Views",
                          value: service.metrics.views.toString(),
                          color: Colors.purple,
                        ),
                      ],
                    ),

                    // Divider
                    const Divider(height: 32),

                    // Pricing section
                    SectionHeader(
                      title: "Pricing",
                      description:
                          "Configure your pricing structure for this service.",
                      onEdit: () {},
                    ),

                    Row(
                      children: [
                        PricingCard(
                          icon: Icons.attach_money,
                          title: "What you pay",
                          description: "Choose how much you pay per lead",
                          value: "\$15 - \$25 per lead",
                          color: Colors.blue.shade50,
                        ),
                        PricingCard(
                          icon: Icons.attach_money,
                          title: "customers pay",
                          description: "Your service pricing",
                          value: "\$2,500 - \$5,000",
                          color: Colors.green.shade50,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}



class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF0077B6),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const MetricCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
          color: color.withOpacity(0.1),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.bodySmall),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onEdit;

  const SectionHeader({
    required this.title,
    required this.description,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 2,
      runSpacing: 2,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Text(description, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        TextButton(
          onPressed: onEdit,
          child: const Row(
            children: [
              Icon(Icons.edit, size: 16),
              SizedBox(width: 4),
              Text("Edit"),
            ],
          ),
        ),
      ],
    );
  }
}

class PricingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String value;
  final Color color;

  const PricingCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
          color: color,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Changed from baseline to start
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 16),
                ),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.trending_up, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  "Activity this week",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF005F91),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "\$0",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF0077B6),
                      ),
                    ),
                    Text("spent", style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "0",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF0077B6),
                      ),
                    ),
                    Text("leads", style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "0",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF0077B6),
                      ),
                    ),
                    Text("views", style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SpendingCard extends StatelessWidget {
  const SpendingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.wallet, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  "Spending this week",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF005F91),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\$0",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF0077B6),
                      ),
                    ),
                    Text(
                      "\$85 budget spent",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "\$0",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF0077B6),
                      ),
                    ),
                    Text(
                      "additional spent",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

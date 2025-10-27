import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';
import 'package:yelpax_pro/features/authentication/presentation/controllers/auth_user_controller.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/presentation/widgets/finish_setup.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/controllers/service_controller.dart';
// Import your entity class
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/professional_services_entity.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceDashboardState();
}

class _ServiceDashboardState extends State<ServiceScreen> {
  bool isSetupFinished = false;
  late ServiceController serviceController;
  late AuthUserController authController;

  @override
  void initState() {
    super.initState();
    serviceController = Provider.of<ServiceController>(context, listen: false);
    authController = Provider.of<AuthUserController>(context, listen: false);
    init(context);
  }

  Future<void> init(BuildContext context) async {
    try {
      final professionalId = authController.professionalId.value;
      await serviceController.professionalServicesList(professionalId);
    } catch (e) {
      Logger().d(e);
    }
  }

  void _handleEditService(ProfessionalServicesEntity service) {
    print('Edit service with data: ${service.serviceEntity.name}');
    Navigator.pushNamed(context, AppRouter.edit_service, arguments: service);
  }

  void _handleDeleteService(String serviceId, BuildContext context) {
    print('Delete service with ID: $serviceId');
    _showDeleteConfirmationDialog(serviceId, context);
  }
  Future<void> _refreshServices() async {
    try {
      final professionalId = authController.professionalId.value;
      await serviceController.professionalServicesList(professionalId);
    } catch (e) {
      Logger().d(e);
      // Optional: Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh services: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _showDeleteConfirmationDialog(String serviceId, BuildContext context) {
    final professionalId = authController.professionalId.value;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ServiceController>(
          builder: (context, valueController, child) {
            return AlertDialog(
              title: Text(
                'Delete Service',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              content: Text(
                'Are you sure you want to delete this service? This action cannot be undone.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await valueController.deleteService(
                      serviceId,
                      professionalId,
                    );
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Services',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.homeServicesNotifications);
            },
          ),
          IconButton(
            icon: const Icon(Icons.campaign_outlined),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.marketing_dashboard);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: const [
                _StatCard(title: "Active Services", value: "4"),
                _StatCard(title: "Avg. Rating", value: "3.7"),
                _StatCard(title: "Total Reviews", value: "134"),
                _StatCard(title: "Incomplete Setups", value: "2"),
              ],
            ),
          ),
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
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Falls Church",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Service'),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.add_service);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Services",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                      child: Consumer<ServiceController>(
                        builder: (context, controller, child) {
                          if (controller.professionalServices.isEmpty) {
                            return _buildEmptyStateWithRefresh();
                          }

                          return _buildRefreshableServiceList(controller);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateWithRefresh() {
    return RefreshIndicator(
      onRefresh: _refreshServices,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.work_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'No services added yet',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pull down to refresh',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshableServiceList(ServiceController controller) {
    // Use CupertinoSliverRefreshControl for iOS-style refresh
    // and RefreshIndicator for Android-style refresh
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: _refreshServices),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final service = controller.professionalServices[index];
              return Column(
                children: [
                  if (index == 0) const SizedBox(height: 1),
                  _ServiceListItem(
                    service: service,
                    onEdit: _handleEditService,
                    onDelete: (serviceId) =>
                        _handleDeleteService(serviceId, context),
                  ),
                  if (index < controller.professionalServices.length - 1)
                    const Divider(height: 1),
                ],
              );
            }, childCount: controller.professionalServices.length),
          ),
        ],
      );
    } else {
      // Android-style refresh indicator
      return RefreshIndicator(
        onRefresh: _refreshServices,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: controller.professionalServices.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final service = controller.professionalServices[index];
            return _ServiceListItem(
              service: service,
              onEdit: _handleEditService,
              onDelete: (serviceId) => _handleDeleteService(serviceId, context),
            );
          },
        ),
      );
    }
  }
}

class _ServiceListItem extends StatelessWidget {
  final ProfessionalServicesEntity service;
  final Function(ProfessionalServicesEntity) onEdit;
  final Function(String) onDelete;

  const _ServiceListItem({
    required this.service,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.work_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          service.serviceEntity.name,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          service.subCategoryEntity.name,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: _ServicePopupMenu(
          service: service,
          onEdit: onEdit,
          onDelete: onDelete,
        ),
      ),
    );
  }
}

class _ServicePopupMenu extends StatelessWidget {
  final ProfessionalServicesEntity service;
  final Function(ProfessionalServicesEntity) onEdit;
  final Function(String) onDelete;

  const _ServicePopupMenu({
    required this.service,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit(service);
            break;
          case 'delete':
            // Make sure to pass the correct ID here:
            onDelete(service.professionalServiceId);
            break;
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                size: 18,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              Text('Edit', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline,
                size: 18,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 8),
              Text(
                'Delete',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

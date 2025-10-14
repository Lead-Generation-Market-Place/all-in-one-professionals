import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/features/authentication/presentation/controllers/auth_user_controller.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/subs/location/presentation/widgets/build_location_card.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/di/service_di.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/controllers/service_controller.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';
import 'package:yelpax_pro/shared/widgets/custom_flutter_toast.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  late final AuthUserController authUserController;
  late final ServiceController serviceController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    authUserController = Provider.of<AuthUserController>(
      context,
      listen: false,
    );
    serviceController = Provider.of<ServiceController>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await init();
    });
  }

  Future<void> init() async {
    try {
      final professionalId = authUserController.professionalId.value;
      final serviceController = Provider.of<ServiceController>(
        context,
        listen: false,
      );

      await serviceController.getServiceLocationsOfAuthenticatedUser(
        professionalId!,
      );
    } catch (e) {
      Logger().d('Error initializing location data.');
    }
  }

  Future<void> _refreshData() async {
    try {
      final professionalId = authUserController.professionalId.value;
      await serviceController.getServiceLocationsOfAuthenticatedUser(
        professionalId!,
      );
    } catch (e) {
      Logger().d('Error refreshing location data: $e');
      CustomFlutterToast.showErrorToast('Error refreshing locations');
    }
  }

  Future<void> _handleDeleteLocation(String? id) async {
    try {
      await serviceController.deleteServiceLocation(id);
      await _refreshData();
    } catch (e) {
      CustomFlutterToast.showErrorToast('Error deleting service location.');
    }
  }

  Future<void> _showDeleteConfirmationDialog(
    String? locationId,
    String locationName,
  ) async {
    final theme = Theme.of(context);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: theme.colorScheme.error,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Delete Location',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete this service location?',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                locationName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'This action cannot be undone.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(
                'Cancel',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog first
                await _handleDeleteLocation(locationId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<ServiceController>(
      builder: (context, provider, _) {
        final locations = provider.serviceLocations;
        final isLoading = provider.isLoading;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Service Locations',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRouter.distance),
                  icon: const Icon(Icons.add_location_alt, size: 18),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ],
            backgroundColor: theme.scaffoldBackgroundColor,
            foregroundColor: theme.colorScheme.onSurface,
          ),

          body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refreshData,
            color: colorScheme.primary,
            backgroundColor: theme.scaffoldBackgroundColor,
            child: isLoading && locations.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Loading locations...',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : locations.isEmpty
                ? _buildEmptyState(theme)
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: locations.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final location = locations[index];
                      return _buildLocationCard(location, theme, colorScheme);
                    },
                  ),
          ),

          // ✅ Only show this button when locations are not empty
          bottomNavigationBar: locations.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Save',
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.homeServicesServices,
                        );
                      },
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 80,
                  color: theme.colorScheme.outline.withOpacity(0.5),
                ),
                const SizedBox(height: 24),
                Text(
                  'No Service Locations',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Add your first service location to start offering your services in new areas',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard(
    dynamic location,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final locationName = _formatLocationText(location);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorScheme.surface, colorScheme.surface.withOpacity(0.8)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Service Location',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      _handleLocationAction(value, location, locationName);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow(Icons.place, locationName, theme),
              if (location.addressLine?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                _buildDetailRow(
                  Icons.home_work_outlined,
                  location.addressLine!,
                  theme,
                ),
              ],
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  String _formatLocationText(dynamic location) {
    final parts = [
      location.city?.toString(),
      location.state?.toString(),
      location.country?.toString(),
    ].where((part) => part != null && part.isNotEmpty).toList();

    return parts.join(', ');
  }

  void _handleLocationAction(
    String action,
    LocationDataEntity location,
    String locationName,
  ) {
    switch (action) {
      case 'edit':
        Navigator.pushNamed(
          context,
          AppRouter.edit_distance,
          arguments: location,
        );
        break;
      case 'delete':
        _showDeleteConfirmationDialog(location.id, locationName);
        break;
    }
  }
}

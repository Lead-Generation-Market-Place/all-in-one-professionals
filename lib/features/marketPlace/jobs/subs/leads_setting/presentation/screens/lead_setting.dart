import 'package:flutter/material.dart';
import 'package:yelpax_pro/config/routes/router.dart';

class LeadSetting extends StatefulWidget {
  const LeadSetting({super.key});

  @override
  State<LeadSetting> createState() => _LeadSettingState();
}

class _LeadSettingState extends State<LeadSetting> {
  bool _windsorChecked = true;
  bool _onlineLeadsEnabled = true;

  // Dynamic list of services
  final List<Service> _services = [
    Service(
      name: 'House Cleaning',
      description: 'All leads • 1 location',
      isActive: true,
    ),
    Service(
      name: 'End of Tenancy Cleaning',
      description: 'All leads • 1 location',
      isActive: true,
    ),
    Service(
      name: 'Deep Cleaning Services',
      description: 'All leads • 1 location',
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lead Settings'),
        centerTitle: true,
    


        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeaderSection(theme, colorScheme),
            const SizedBox(height: 32),

            // Your Services Section
            _buildServicesSection(theme, colorScheme),
            const SizedBox(height: 24),

            // Your Locations Section
            _buildLocationsSection(theme, colorScheme),
            const SizedBox(height: 24),

            _buildOnlineLeadsSection(theme, colorScheme),
            const SizedBox(height: 32),

            _buildViewLeadsButton(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lead Preferences',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Customize which leads you want to be alerted about based on your services and locations',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildServicesSection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.work_outline,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Your Services',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Fine-tune the leads you want to be alerted about',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ..._services
              .map((service) => _buildServiceItem(service, theme, colorScheme))
              .toList(),
          const Divider(height: 1),
          _buildAddButton(
            'Add a service',
            Icons.add,
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.add_service);
            },
            theme: theme,
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(
    Service service,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return SwitchListTile(
      value: service.isActive,
      onChanged: (value) {
        setState(() {
          // Update service status
          final index = _services.indexWhere((s) => s.name == service.name);
          if (index != -1) {
            _services[index] = Service(
              name: service.name,
              description: service.description,
              isActive: value,
            );
          }
        });
      },
      title: Text(
        service.name,
        style: theme.textTheme.bodyMedium
      ),
      subtitle: Text(
        service.description,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      secondary: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.cleaning_services,
          color: colorScheme.primary,
          size: 20,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }

  Widget _buildLocationsSection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Your Locations',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose where you want to find new customers',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          SwitchListTile(
            value: _windsorChecked,
            onChanged: (value) {
              setState(() {
                _windsorChecked = value;
              });
            },
            title: Text(
              'Within 20 miles of Windsor',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              '3 services available',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            secondary: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_pin,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
          ),
          const Divider(height: 1),
          _buildAddButton(
            'Add a location',
            Icons.add_location_alt,
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.add_location);
            },
            theme: theme,
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineLeadsSection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.laptop_outlined,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Online/Remote Leads',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Customers tell us if they\'re happy to receive services online or remotely',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          SwitchListTile(
            value: _onlineLeadsEnabled,
            onChanged: (value) {
              setState(() {
                _onlineLeadsEnabled = value;
              });
            },
            title: Text(
              'Enable Online Leads',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'Receive leads from customers open to remote services',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            secondary: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.video_call,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.visibility_outlined,
              color: colorScheme.primary,
            ),
            title: Text('View Online Leads', style: theme.textTheme.bodyLarge),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            onTap: () {
              // Navigator.pushNamed(context, AppRouter.onlineLeadsScreen);
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(
    String text,
    IconData icon, {
    required VoidCallback? onPressed,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewLeadsButton(ThemeData theme, ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Navigator.pushNamed(context, AppRouter.viewLeadsScreen);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          'View Matching Leads',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// Service model class
class Service {
  final String name;
  final String description;
  final bool isActive;

  Service({
    required this.name,
    required this.description,
    required this.isActive,
  });
}

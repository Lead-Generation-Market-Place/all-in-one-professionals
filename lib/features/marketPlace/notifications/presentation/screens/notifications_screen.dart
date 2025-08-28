import 'package:flutter/material.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      key: _scaffoldKey,
      drawer: _buildProfessionalDrawer(),
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          // Professional drawer toggle button
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 16),
                const Text(
                  'Notification Center',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.primary),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: AppColors.warning,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No notifications yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'ll notify you when something important happens',
                    style: TextStyle(fontSize: 14, color: AppColors.warning),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(color: AppColors.background),
        child: Column(
          children: [
            // Simple notification header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              decoration: const BoxDecoration(
            
                color: AppColors.primary,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.background.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.notifications,
                      color: AppColors.background,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Notification Settings',
                      style: TextStyle(
                        color: AppColors.background,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildDrawerContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      children: [
        _buildSectionHeader('NOTIFICATION TYPES'),
        const SizedBox(height: 8),
        _buildDrawerItem(
          icon: Icons.notifications_active,
          title: 'All Notifications',
          subtitle: 'Manage all notification types',
          onTap: () {
            Navigator.pushNamed(context, AppRouter.homeServicesNotifications);
          },
        ),
        _buildDrawerItem(
          icon: Icons.work,
          title: 'Job Alerts',
          subtitle: 'New job opportunities',
          badge: '3',
          onTap: () {
            // Handle job alerts
          },
        ),
        _buildDrawerItem(
          icon: Icons.message,
          title: 'Messages',
          subtitle: 'Client communications',
          badge: '1',
          onTap: () {
            // Handle messages
          },
        ),
        _buildDrawerItem(
          icon: Icons.payment,
          title: 'Payment Updates',
          subtitle: 'Transaction notifications',
          onTap: () {
            // Handle payment updates
          },
        ),
        _buildDrawerItem(
          icon: Icons.event,
          title: 'Appointment Reminders',
          subtitle: 'Schedule notifications',
          onTap: () {
            // Handle appointment reminders
          },
        ),
        const SizedBox(height: 24),
        _buildSectionHeader('NOTIFICATION PREFERENCES'),
        const SizedBox(height: 8),
        _buildDrawerItem(
          icon: Icons.schedule,
          title: 'Quiet Hours',
          subtitle: 'Set do not disturb times',
          onTap: () {
            // Handle quiet hours
          },
        ),
        _buildDrawerItem(
          icon: Icons.volume_up,
          title: 'Sound & Vibration',
          subtitle: 'Notification alerts',
          onTap: () {
            // Handle sound settings
          },
        ),
        _buildDrawerItem(
          icon: Icons.visibility,
          title: 'Show on Lock Screen',
          subtitle: 'Display when locked',
          onTap: () {
            // Handle lock screen settings
          },
        ),
        _buildDrawerItem(
          icon: Icons.settings,
          title: 'Advanced Settings',
          subtitle: 'Detailed notification options',
          onTap: () {
            Navigator.pushNamed(context, AppRouter.settingsScreen);
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required String subtitle,
    String? badge,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
        ),
        trailing: badge != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: AppColors.background,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : const Icon(
                Icons.chevron_right,
                color: AppColors.primaryDark,
                size: 20,
              ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:yelpax_pro/config/routes/router.dart';

import '../../../../../shared/widgets/bottom_sheet.dart';
import '../widgets/account_bottom_sheet.dart';
import '../widgets/setting_item.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void navigateTo(String routeName) {
    Navigator.pushNamed(context, routeName); // Or use Navigator.push(...)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [

          SettingsItem(
            icon: Icons.palette_outlined,
            title: 'Theme',
            subtitle: 'Dark mode, light mode, system',
            onTap: () => navigateTo('/marketplace/themeSelection'),
          ),
          Divider(),
          SettingsItem(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'Select your preferred language',
            onTap: () {
              Navigator.pushNamed(context, AppRouter.themeSelection);
            }

          ),
          Divider(),

          SettingsItem(
            icon: Icons.account_circle_outlined,
            title: 'Accounts',
            subtitle: 'Login & security options',
            // In your SettingsItem where you call the bottom sheet:
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                isScrollControlled: true,
                builder: (context) => const AccountBottomSheet(),
              );
            },
          ),

          Divider(),
          const Divider(),
          SettingsItem(
            icon: Icons.info_outline,
            title: 'Version',
            subtitle: 'App version 1.0.0',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Your App Name',
                applicationVersion: '1.0.0',
              );
            },
          ),
        ],
      ),
    );
  }



}



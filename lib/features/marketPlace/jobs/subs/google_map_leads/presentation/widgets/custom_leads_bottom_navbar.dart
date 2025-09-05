import 'package:flutter/material.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/subs/google_map_leads/presentation/screens/google_map_leads.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/subs/reminders/presentation/reminders_screen.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/subs/reponses/presentation/screens/responses.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.map), text: 'Leads'),
            Tab(icon: Icon(Icons.email), text: 'Responses'),
            Tab(icon: Icon(Icons.notifications), text: 'Reminders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [GoogleMapLeads(), Responses(), RemindersScreen()],
      ),
    );
  }
}

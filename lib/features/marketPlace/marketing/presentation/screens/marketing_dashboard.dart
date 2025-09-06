import 'package:flutter/material.dart';

class MarketingDashboard extends StatefulWidget {
  const MarketingDashboard({super.key});

  @override
  State<MarketingDashboard> createState() => _MarketingDashboardState();
}

class _MarketingDashboardState extends State<MarketingDashboard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Dashboard'),
    );
  }
}
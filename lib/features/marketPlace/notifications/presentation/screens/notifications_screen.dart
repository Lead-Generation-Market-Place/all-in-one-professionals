import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yelpax_pro/shared/widgets/bottom_navbar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(title: Text('Notification'), automaticallyImplyLeading: false,),
    bottomNavigationBar: BottomNavbar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(child: Text('Notifications',style: TextStyle(fontSize: 20),)),
      ),
    );
  }
}
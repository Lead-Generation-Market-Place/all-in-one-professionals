import 'package:flutter/material.dart';
import 'package:yelpax_pro/config/routes/router.dart';

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
      key: _scaffoldKey,

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Notification Settings',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Setting One'),
              onTap: () {
                Navigator.pushNamed(
                    context, AppRouter.homeServicesNotifications);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Setting Two'),
              onTap: () {
                Navigator.pushNamed(context, AppRouter.settingsScreen);
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        

      ),

      body: Column(
        children: [
          // ✅ Drawer button below the AppBar
          Container(
            color: Colors.grey[200],
            height: 50,
            alignment: Alignment.centerRight, // 👈 right side
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),

          // ✅ Main content
          Expanded(
            child: Center(
              child: const Text(
                'Notifications',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

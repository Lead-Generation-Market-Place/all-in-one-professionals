import 'package:flutter/material.dart';
import 'package:yelpax_pro/shared/widgets/bottom_navbar.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Services'),automaticallyImplyLeading: false,),
      bottomNavigationBar: BottomNavbar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(child: Text('Services',style: TextStyle(fontSize: 20),)),
      ),
    );
  }
}
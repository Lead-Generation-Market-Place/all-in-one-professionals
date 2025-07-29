import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/shared/widgets/bottom_navbar.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override 
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  @override
  Widget build(BuildContext context) {
       return Scaffold(
        appBar: AppBar(title: Text('Jobs'),leading: IconButton(onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context,AppRouter.home,(route) => false,);
        }, icon: Icon(Icons.arrow_back)),),
        bottomNavigationBar: BottomNavbar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(child: Text('Jobs',style: TextStyle(fontSize: 20),)),
      ),
    );
  }
}
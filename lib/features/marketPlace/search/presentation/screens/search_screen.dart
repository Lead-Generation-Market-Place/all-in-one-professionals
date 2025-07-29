import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yelpax_pro/shared/widgets/bottom_navbar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar( title: Text('Search'),automaticallyImplyLeading: false,
        
      ),bottomNavigationBar: BottomNavbar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(child: Text('Search',style: TextStyle(fontSize: 20),)),
      ),
    );
  }
}
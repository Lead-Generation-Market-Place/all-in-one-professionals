import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yelpax_pro/shared/widgets/custom_advanced_dropdown.dart';
class DistanceInMiles{
  final int id;     
  final String name;
  DistanceInMiles(this.name, this.id);
}
class Distance extends StatefulWidget {
  const Distance({super.key});

  @override
  State<Distance> createState() => _DistanceState();
}

class _DistanceState extends State<Distance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Distance'),centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },  
        ),
      ),
      body: Padding(padding: EdgeInsets.all(20),
      child: Column(
        children: [

          SearchBar(autoFocus: true,hintText: 'search by name',enabled: true,leading: Icon(Icons.search,color: Colors.black,),),
          const SizedBox(height: 20,),
          Container(
            child: Center(
              child: Text("Map"),
            ),
          ),

          const SizedBox(height: 20,),
          // AdvancedDropdown(items: , itemToString: itemToString)
        ],
      ),),
    );
  }
}
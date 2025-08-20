import 'package:flutter/material.dart';

class ResponseCredits extends StatefulWidget {
  const ResponseCredits({super.key});

  @override
  State<ResponseCredits> createState() => _ResponseCreditsState();
}

class _ResponseCreditsState extends State<ResponseCredits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Response Credits'), centerTitle: true),
      body: Padding(
        padding: EdgeInsetsGeometry.all(15),
        child: Container(child: Column(children: [Text('You have 0 credits')])),
      ),
    );
  }
}

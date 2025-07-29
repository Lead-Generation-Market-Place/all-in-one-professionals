import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => Card(
        margin: const EdgeInsets.all(10),
        child: ListTile(
          title: Text('Home Post $index'),
        ),
      ),
    );
  }
}

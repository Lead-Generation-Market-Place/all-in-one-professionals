import 'package:flutter/material.dart';

import '../../core/utils/app_restart.dart';

class UnexpectedErrorScreen extends StatelessWidget {
  String message;
  UnexpectedErrorScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 12),

              Text(message),

              const SizedBox(height: 12),
              const Text("Please restart the app or contact support."),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  RestartWidget.restartApp(context);
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Restart App"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

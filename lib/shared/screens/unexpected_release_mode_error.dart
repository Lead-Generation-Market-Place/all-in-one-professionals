import 'package:flutter/material.dart';

import '../../core/utils/app_restart.dart';

class UnexpectedReleaseModeError extends StatelessWidget {
  String message;
  UnexpectedReleaseModeError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                const Text("Unexpected Error Occured Please contact support."),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    RestartWidget.restartApp(context);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text("Close App"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

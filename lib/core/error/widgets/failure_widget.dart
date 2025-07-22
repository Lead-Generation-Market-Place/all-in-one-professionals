import 'package:flutter/material.dart';

import '../../../generated/app_localizations.dart';
import '../failures/failure.dart';

class FailureWidget extends StatelessWidget {
  final Failure failure;
  final VoidCallback onRetry;
  const FailureWidget({Key? key, required this.failure, required this.onRetry})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final label = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade400, size: 48),
            const SizedBox(height: 12),
            Text(
              failure.message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(label.retry ?? 'Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

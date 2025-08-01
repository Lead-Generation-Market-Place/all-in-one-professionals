import 'package:flutter/material.dart';
import 'package:yelpax_pro/core/error/failures/failure.dart';

void showFailureSnackbar(BuildContext context, Failure failure) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(failure.message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/features/inbox/presentation/controllers/signup_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupController>(listen: false, context);
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            provider.addUser(
              'NOor Hmad',
              'Bashery',
              'email',
              'password',
              'confirmPassword',
            );
          },
          child: Text('Press'),
        ),
      ),
    );
  }
}

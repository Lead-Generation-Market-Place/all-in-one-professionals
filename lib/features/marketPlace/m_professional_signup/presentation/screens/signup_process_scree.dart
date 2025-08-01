import 'package:flutter/material.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

class SignupProcessScreem extends StatefulWidget {
  const SignupProcessScreem({super.key});

  @override
  State<SignupProcessScreem> createState() => _SignupProcessScreemState();
}

class _SignupProcessScreemState extends State<SignupProcessScreem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Signup Process',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Complete your steps to get leads.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(offset: Offset(1.0, 1.0), color: Colors.black87),
                    ],
                  ),
                  softWrap: true,
                ),
              ),
              Divider(),
              const SizedBox(height: 40),
              FirstStep(true),
              const SizedBox(height: 20),
              SecondStep(true),
              const SizedBox(height: 20),
              ThirdStep(false),
            ],
          ),
        ),
      ),
    );
  }

  Widget FirstStep(bool isCompleted) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              isCompleted ? Icons.check_circle : Icons.cancel,
              color: isCompleted ? Colors.green : Colors.red,
              size: 40,
            ),
          ),
          const SizedBox(width: 15),
          Container(
        

            child: isCompleted
                ? Text(
                    'Personal Information completed',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 3
                  
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      // Handle action
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Complete personal information',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.arrow_forward_ios), // <-- icon on the right
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget SecondStep(bool isCompleted) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              isCompleted ? Icons.check_circle : Icons.cancel,
              color: isCompleted ? Colors.green : Colors.red,
              size: 40,
            ),
          ),
          const SizedBox(width: 15),
          Container(
      

            child: isCompleted
                ? Text(
                    'Personal Information completed',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      // Handle action
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Complete personal information',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.arrow_forward_ios), // <-- icon on the right
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget ThirdStep(bool isCompleted) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              isCompleted ? Icons.check_circle : Icons.cancel,
              color: isCompleted ? Colors.green : Colors.red,
              size: 40,
            ),
          ),
          const SizedBox(width: 15),
          Container(
       
            child: isCompleted
                ? Text(
                    'Personal Information completed',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      // Handle action
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Complete personal information',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.arrow_forward_ios, size: 20,), // <-- icon on the right
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

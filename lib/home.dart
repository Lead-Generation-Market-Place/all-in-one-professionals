import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';
import 'package:yelpax_pro/shared/widgets/custom_input.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  int counter = 0;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> _simulateCount() async {
    setState(() => isLoading = true);

    // Simulate a delay (e.g., API call or task)
    await Future.delayed(const Duration(seconds: 5));

    setState(() {
      isLoading = false;
      counter += 1;
    });
  }

  TextEditingController nameController = TextEditingController();

  List<String> _list = ['Developer', 'Designer', 'Consultant', 'Student'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          CustomButton(
            text: 'Tap',
            onPressed: () {
              _simulateCount();
            },
            isLoading: isLoading,
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20),

        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomButton(
                text: 'Submit',
                icon: Icons.send,
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () {
                        if (formKey.currentState!.validate()) {
                          _simulateCount();
                        } else {
                          print("Validation failed");
                        }
                      },
                type: CustomButtonType.primary,
                size: CustomButtonSize.large,
              ),

              SizedBox(height: 40),
              CustomDropdown<String>(
                hintText: 'Select job role',
                items: _list,
                initialItem: _list[0],
                onChanged: (value) {
                  print('changing value to: $value');
                },
              ),

              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomInputField(
                  label: 'Name',
                  hintText: 'Please Enter you name',
                  prefixIcon: Icons.person,
                  suffixIcon: Icons.add,
                  inputType: TextInputType.name,
                  isEnabled: true,
                  isPassword: false,
                  controller: nameController,
                  onChanged: (p0) {
                    nameController = nameController;
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

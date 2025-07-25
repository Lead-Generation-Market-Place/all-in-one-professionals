import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/themes/theme_mode_type.dart';
import 'package:yelpax_pro/config/themes/theme_provider.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';
import 'package:yelpax_pro/features/authentication/presentation/controllers/auth_user_controller.dart';
import 'package:yelpax_pro/features/authentication/presentation/screens/login_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 100.0,
            centerTitle: false,
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.message)),
              IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),

              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'settings') {
                  } else if (value == 'logout') {
                    final authController = context.read<AuthUserController>();
                    authController.logout();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'settings',
                    child: Text('Settings'),
                  ),
                  PopupMenuItem<String>(value: 'logout', child: Text('Logout')),
                ],
              ),
            ],

            flexibleSpace: const FlexibleSpaceBar(
              title: Text('Hi,Noor Ahmad'),
              titlePadding: EdgeInsets.only(left: 10),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Onboarding Checklist 🌟',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Text(
                        'Take the first steps to sell on Groupon',
                        style: TextStyle(fontSize: 12),
                      ),

                      buildStepLine(3, 4),

                      buildExpandableList(),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                DropdownButton<ThemeModeType>(
                  value: provider.currentTheme,
                  isExpanded: true,
                  items: ThemeModeType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (type) {
                    if (type != null) {
                      provider.setTheme(type);
                    }
                  },
                ),
              ],
            ),
          ),
          // You can add more Slivers here, like lists or grids
        ],
      ),
    );
  }

  Widget buildStepLine(int completedSteps, int totalSteps) {
    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isEven) {
          int stepIndex = index ~/ 2;
          bool isCompleted = stepIndex < completedSteps;
          return CircleAvatar(
            radius: 12,
            backgroundColor: isCompleted
                ? AppColors.primaryBlue
                : AppColors.neutral400,
            child: Icon(Icons.check, size: 16, color: Colors.white),
          );
        } else {
          bool isLineCompleted = index ~/ 2 < completedSteps - 1;
          return Expanded(
            child: Container(
              height: 4,
              color: isLineCompleted
                  ? AppColors.primaryBlue
                  : AppColors.neutral400,
            ),
          );
        }
      }),
    );
  }

  Widget buildExpandableList() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            color: Colors.grey[300],
            padding: EdgeInsets.all(16),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Layer Title',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Layer Title (Header)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('This is the introduction text for the expandable layer.'),
                SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Button 1 action
                      },
                      child: Text('Button 1'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Button 2 action
                      },
                      child: Text('Button 2'),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text('Duration: 2 hours', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
      ],
    );
  }
}

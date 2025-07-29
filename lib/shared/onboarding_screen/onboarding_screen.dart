import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/features/authentication/presentation/controllers/auth_user_controller.dart';
import 'package:yelpax_pro/features/authentication/presentation/screens/login_screen.dart';
import 'package:yelpax_pro/features/mainHome/presentation/screens/home.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRouter.login, (route) => false);
  }

  void _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          _buildWelcomePage(context),
          _buildGuidesPage(context),
          _buildRemindersPage(context),
          _buildProsPage(context),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildWelcomePage(BuildContext context) {
    return _buildPage(
      context,
      lottiePath: 'assets/lottie/splash1.json',
      text: 'Caring for your home, made easy.',
    );
  }

  Widget _buildGuidesPage(BuildContext context) {
    return _buildPage(
      context,
      lottiePath: 'assets/lottie/splash2.json',
      text: 'Generate custom guides, made for your home.',
    );
  }

  Widget _buildRemindersPage(BuildContext context) {
    return _buildPage(
      context,
      lottiePath: 'assets/lottie/splash3.json',
      text: 'We\'ll help you stay on track with reminders.',
    );
  }

  Widget _buildProsPage(BuildContext context) {
    return _buildPage(
      context,
      lottiePath: 'assets/lottie/splash4.json',
      text: 'Find nearby pros who can help get things done.',
    );
  }

  Widget _buildPage(
    BuildContext context, {
    required String lottiePath,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Lottie.asset(
              lottiePath,
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(onPressed: _skipOnboarding, child: const Text('Skip')),
          Row(children: List.generate(4, (index) => _buildDot(index, context))),
          _currentPage == 3
              ? ElevatedButton(
                  onPressed: _finishOnboarding,
                  child: const Text('Get Started'),
                )
              : TextButton(
                  onPressed: _nextPage,
                  child: Text(
                    'Next',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildDot(int index, BuildContext context) {
    final isActive = _currentPage == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Theme.of(context).primaryColor : Colors.grey[400],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

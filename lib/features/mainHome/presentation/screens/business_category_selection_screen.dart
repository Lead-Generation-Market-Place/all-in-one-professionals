import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/shared/services/bottom_navbar_notifier.dart';
import '../controllers/business_context_controller.dart';

class BusinessCategorySelectionScreen extends StatefulWidget {
  const BusinessCategorySelectionScreen({super.key});

  @override
  State<BusinessCategorySelectionScreen> createState() =>
      _BusinessCategorySelectionScreenState();
}

class _BusinessCategorySelectionScreenState
    extends State<BusinessCategorySelectionScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);

    // Add listener to track current page
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });

    // Animation setup for selection feedback
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onCategorySelected(BuildContext context, BusinessContext ctx) {
    final contextProvider = Provider.of<BusinessContextProvider>(
      context,
      listen: false,
    );

    // Play selection animation
    _scaleController.forward().then((_) {
      _scaleController.reverse();

      // Update context and navigate
      contextProvider.switchContext(ctx);
      Provider.of<BottomNavProvider>(context, listen: false).resetIndex();

      // Add a slight delay for better UX
      Future.delayed(const Duration(milliseconds: 150), () {
        Navigator.pushReplacementNamed(context, AppRouter.home);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final contextProvider = Provider.of<BusinessContextProvider>(
      context,
      listen: false,
    );
    final availableContexts = contextProvider.availableContexts;
    final currentContext = contextProvider.currentContext;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section with improved spacing
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Your Business Category",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Swipe left or right to browse categories. Tap to select and continue.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Page Indicator
              Center(
                child: Container(
                  height: 6,
                  margin: const EdgeInsets.only(bottom: 24),
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: availableContexts.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _currentPage == index ? 24 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? colorScheme.primary
                              : colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Animated PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: availableContexts.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final ctx = availableContexts[index];
                    final isSelected = ctx.name == currentContext.name;

                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        if (_pageController.position.haveDimensions) {
                          value = _pageController.page! - index;
                          value = (1 - (value.abs() * 0.3)).clamp(0.85, 1.0);
                        }
                        return Transform.scale(scale: value, child: child);
                      },
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? colorScheme.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          color: isSelected
                              ? colorScheme.primary.withOpacity(0.05)
                              : colorScheme.surface,
                          shadowColor: Colors.black.withOpacity(0.1),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => _onCategorySelected(context, ctx),
                            onTapDown: (_) => _scaleController.forward(),
                            onTapCancel: () => _scaleController.reverse(),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Icon with gradient background
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: isSelected
                                            ? [
                                                colorScheme.primary.withOpacity(
                                                  0.2,
                                                ),
                                                colorScheme.primary.withOpacity(
                                                  0.1,
                                                ),
                                              ]
                                            : [
                                                colorScheme.surfaceVariant,
                                                colorScheme.surfaceVariant
                                                    .withOpacity(0.7),
                                              ],
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.business_center_rounded,
                                      size: 28,
                                      color: isSelected
                                          ? colorScheme.primary
                                          : colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    ctx.name,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Tap to switch to this business context and access relevant features",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      height: 1.4,
                                    ),
                                  ),
                                  const Spacer(),
                                  // Animated selection indicator
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height: 4,
                                    width: isSelected ? 40 : 0,
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Animated button
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        isSelected ? "SELECTED" : "SELECT",
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: isSelected
                                                  ? colorScheme.primary
                                                  : colorScheme
                                                        .onSurfaceVariant,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 16,
                                        color: isSelected
                                            ? colorScheme.primary
                                            : colorScheme.onSurfaceVariant,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
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

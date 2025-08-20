import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/shared/services/bottom_navbar_notifier.dart';
import '../controllers/business_context_controller.dart';

class BusinessCategorySelectionScreen extends StatelessWidget {
  const BusinessCategorySelectionScreen({super.key});

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Text
                Text(
                  "Select Your Business Category",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Choose one of the categories below to continue",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

                // Category List
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: availableContexts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final ctx = availableContexts[index];
                    final isSelected = ctx.name == currentContext.name;

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        contextProvider.switchContext(ctx);
                        Provider.of<BottomNavProvider>(
                          context,
                          listen: false,
                        ).resetIndex();
                        Navigator.pushReplacementNamed(context, AppRouter.home);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: isSelected
                              ? colorScheme.primary.withOpacity(0.1)
                              : colorScheme.surface,
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.outlineVariant,
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: colorScheme.primary.withOpacity(
                              0.15,
                            ),
                            child: Text(
                              ctx.name[0].toUpperCase(),
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            ctx.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            "Tap to switch to this context",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

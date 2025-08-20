import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

import '../../../../../shared/services/bottom_navbar_notifier.dart';
import '../../../../mainHome/presentation/controllers/business_context_controller.dart';

class AccountBottomSheet extends StatelessWidget {
  const AccountBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final contextProvider = Provider.of<BusinessContextProvider>(context);
    final navProvider = Provider.of<BottomNavProvider>(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.bottomSheetTheme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sheet Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Switch Account',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
                color: theme.colorScheme.onSurface,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Description
          Text(
            'Select a business context to switch to. Your selection will affect the navigation and features available.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 20),

          // Dropdown container - Updated to use theme colors
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(10),
              color: theme
                  .colorScheme
                  .surfaceContainerHighest, // Using theme color
            ),
            child: DropdownButton<BusinessContext>(
              value: contextProvider.currentContext,
              isExpanded: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: theme.colorScheme.onSurface,
              ),
              dropdownColor: theme.colorScheme.surface,
              // Using theme color
              underline: const SizedBox(),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              items: contextProvider.availableContexts.map((contextItem) {
                return DropdownMenuItem<BusinessContext>(
                  value: contextItem,
                  child: Text(
                    contextItem.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newContext) {
                if (newContext != null) {
                  contextProvider.switchContext(newContext);
                  navProvider.resetIndex();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.home,
                    (route) => false,
                  );
                }
              },
            ),
          ),

          const SizedBox(height: 20),

          // Add New Account Button
          CustomButton(
            text: 'Add New Account',
            enabled: true,
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.signUpAsProfessional);
            },
          ),
        ],
      ),
    );
  }

  // In your DynamicBottomSheet class (or wherever you define it), ensure it uses theme:
}

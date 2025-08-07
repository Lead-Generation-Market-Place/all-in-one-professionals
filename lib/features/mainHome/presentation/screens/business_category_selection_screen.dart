import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yelpax_pro/shared/services/bottom_navbar_notifier.dart';
import 'package:yelpax_pro/config/routes/router.dart';

import '../controllers/business_context_controller.dart';

class BusinessCategorySelectionScreen extends StatelessWidget {
  const BusinessCategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contextProvider = Provider.of<BusinessContextProvider>(context, listen: false);
    final availableContexts = contextProvider.availableContexts;
    final currentContext = contextProvider.currentContext;

    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(

        appBar: AppBar(
          title: const Text("Select Your Business Category"),
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 1,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.separated(
            itemCount: availableContexts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final ctx = availableContexts[index];
              final isSelected = ctx.name == currentContext.name;

              return Material(
                elevation: isSelected ? 3 : 1,
                borderRadius: BorderRadius.circular(12),
                color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.08) : Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    child: Text(
                      ctx.name[0].toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    ctx.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    "Tap to switch to this context",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    contextProvider.switchContext(ctx);
                    Provider.of<BottomNavProvider>(context, listen: false).resetIndex();
                    Navigator.pushReplacementNamed(context, AppRouter.home);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final double elevation;

  const CustomAppBar({
    Key? key,
    this.title,
    this.leading,
    this.actions,
    this.bottom,
    this.backgroundColor,
    this.elevation = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor =
        backgroundColor ??
        theme.appBarTheme.backgroundColor ??
        theme.scaffoldBackgroundColor;

    return Material(
      elevation: elevation,
      color: bgColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: kToolbarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Leading + Title together
                  Row(
                    children: [
                      if (leading != null) leading!,
                      if (title != null) ...[
                        if (leading != null) const SizedBox(width: 8),
                        Text(
                          title!,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Actions
                  Row(mainAxisSize: MainAxisSize.min, children: actions ?? []),
                ],
              ),
            ),
          ),

          // Optional bottom widget
          if (bottom != null) bottom!,
        ],
      ),
    );
  }

  @override
  Size get preferredSize {
    double height = kToolbarHeight;
    if (bottom != null) {
      height += bottom!.preferredSize.height;
    }
    return Size.fromHeight(height);
  }
}

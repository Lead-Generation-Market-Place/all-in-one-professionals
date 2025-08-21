import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final double elevation;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBack;
  final double toolbarHeight;
  final Gradient? backgroundGradient;
  final double bottomRadius;
  final bool showBottomDivider;

  const CustomAppBar({
    Key? key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.bottom,
    this.backgroundColor,
    this.elevation = 4,
    this.centerTitle = false,
    this.showBackButton = true,
    this.onBack,
    this.toolbarHeight = kToolbarHeight,
    this.backgroundGradient,
    this.bottomRadius = 0,
    this.showBottomDivider = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor =
        backgroundColor ??
        theme.appBarTheme.backgroundColor ??
        theme.scaffoldBackgroundColor;

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(bottomRadius),
      ),
    );

    Widget barContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: toolbarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Leading + Title together
                Expanded(
                  child: Row(
                    mainAxisAlignment: centerTitle
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      if (leading != null)
                        leading!
                      else if (showBackButton && Navigator.canPop(context))
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed:
                              onBack ?? () => Navigator.of(context).maybePop(),
                        ),
                      if (!centerTitle &&
                          (leading != null ||
                              (showBackButton && Navigator.canPop(context))))
                        const SizedBox(width: 8),
                      if (title != null)
                        Flexible(
                          child: Column(
                            crossAxisAlignment: centerTitle
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                title!,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (subtitle != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    subtitle!,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                // Actions
                Row(mainAxisSize: MainAxisSize.min, children: actions ?? []),
              ],
            ),
          ),
        ),

        // Optional bottom widget
        if (bottom != null) bottom!,
        if (showBottomDivider && bottom == null)
          Divider(height: 1, thickness: 1, color: theme.dividerColor),
      ],
    );

    // Background paint: gradient takes precedence
    return Material(
      elevation: elevation,
      color: backgroundGradient == null ? bgColor : Colors.transparent,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: backgroundGradient == null
          ? barContent
          : Container(
              decoration: BoxDecoration(gradient: backgroundGradient),
              child: barContent,
            ),
    );
  }

  @override
  Size get preferredSize {
    double height = toolbarHeight;
    if (bottom != null) {
      height += bottom!.preferredSize.height;
    }
    return Size.fromHeight(height);
  }
}

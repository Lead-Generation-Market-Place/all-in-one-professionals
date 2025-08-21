import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

enum CustomButtonType { primary, secondary, outline, text }

enum CustomButtonSize { small, medium, large }

enum CustomButtonIconPosition { leading, trailing }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonType type;
  final CustomButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final bool enabled;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Gradient? gradient; // takes precedence over background color
  final Color? backgroundColor; // force background color
  final Color? foregroundColor; // force text/icon color
  final Duration animationDuration;
  final bool enableHaptics;
  final CustomButtonIconPosition iconPosition;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = CustomButtonType.primary,
    this.size = CustomButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.enabled = true,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.gradient,
    this.backgroundColor,
    this.foregroundColor,
    this.animationDuration = const Duration(milliseconds: 160),
    this.enableHaptics = true,
    this.iconPosition = CustomButtonIconPosition.leading,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled =
        !widget.enabled || widget.isLoading || widget.onPressed == null;

    final bgColor =
        widget.backgroundColor ?? _getBackgroundColor(context, isDisabled);
    final fgColor =
        widget.foregroundColor ?? _getForegroundColor(context, isDisabled);
    final radius = widget.borderRadius ?? BorderRadius.circular(12);

    final decoration = BoxDecoration(
      color: widget.gradient == null ? bgColor : null,
      gradient: widget.gradient,
      borderRadius: radius,
      border: _getBorder(context, isDisabled),
      boxShadow: _getBoxShadow(context, isDisabled),
    );

    final scale = _isPressed ? 0.98 : (_isHovered ? 1.01 : 1.0);

    return Semantics(
      button: true,
      enabled: !isDisabled,
      label: widget.text,
      child: AnimatedScale(
        duration: widget.animationDuration,
        scale: scale,
        child: Container(
          margin: widget.margin,
          width: widget.isFullWidth ? double.infinity : widget.width,
          height: widget.height ?? _getHeight(),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isDisabled
                  ? null
                  : () {
                      if (widget.enableHaptics) HapticFeedback.lightImpact();
                      widget.onPressed?.call();
                    },
              onHighlightChanged: (v) => setState(() => _isPressed = v),
              onHover: (v) => setState(() => _isHovered = v),
              borderRadius: radius,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Ink(
                decoration: decoration,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildContent(context, isDisabled, fgColor),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDisabled, Color fgColor) {
    if (widget.isLoading) {
      return SizedBox(
        height: _getLoaderSize(),
        width: _getLoaderSize(),
        child: Lottie.asset(
          'assets/lottie/loader_button3dots.json',
          fit: BoxFit.contain,
        ),
      );
    }

    final textStyle = _getTextStyle(
      context,
      isDisabled,
    ).copyWith(color: fgColor);
    final iconSize = _getIconSize();

    if (widget.icon != null) {
      final iconWidget = Icon(
        widget.icon!,
        size: iconSize,
        color: textStyle.color,
      );
      final textWidget = Text(widget.text, style: textStyle);
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.iconPosition == CustomButtonIconPosition.leading
            ? [
                iconWidget,
                if (widget.text.isNotEmpty) const SizedBox(width: 8),
                textWidget,
              ]
            : [
                textWidget,
                if (widget.text.isNotEmpty) const SizedBox(width: 8),
                iconWidget,
              ],
      );
    }

    return Text(widget.text, style: textStyle);
  }

  // Resolve ButtonStyle from ThemeData
  ButtonStyle? _resolveStyle(BuildContext context) {
    final theme = Theme.of(context);
    switch (widget.type) {
      case CustomButtonType.primary:
      case CustomButtonType.secondary:
        return theme.elevatedButtonTheme.style;
      case CustomButtonType.outline:
        return theme.outlinedButtonTheme.style;
      case CustomButtonType.text:
        return theme.textButtonTheme.style;
    }
  }

  Color _getBackgroundColor(BuildContext context, bool isDisabled) {
    final theme = Theme.of(context);
    final style = _resolveStyle(context);
    final resolvedColor = style?.backgroundColor?.resolve(_states(isDisabled));
    if (resolvedColor != null) return resolvedColor;

    if (isDisabled) {
      return theme.colorScheme.surfaceContainerHighest;
    }

    switch (widget.type) {
      case CustomButtonType.primary:
        return theme.colorScheme.primary;
      case CustomButtonType.secondary:
        return theme.colorScheme.secondaryContainer;
      case CustomButtonType.outline:
        return theme.colorScheme.surface;
      case CustomButtonType.text:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor(BuildContext context, bool isDisabled) {
    final theme = Theme.of(context);
    if (isDisabled) return theme.colorScheme.onSurface.withOpacity(0.38);
    switch (widget.type) {
      case CustomButtonType.primary:
        return theme.colorScheme.onPrimary;
      case CustomButtonType.secondary:
        return theme.colorScheme.onSecondaryContainer;
      case CustomButtonType.outline:
        return theme.colorScheme.primary;
      case CustomButtonType.text:
        return theme.colorScheme.primary;
    }
  }

  TextStyle _getTextStyle(BuildContext context, bool isDisabled) {
    final style = _resolveStyle(context);
    final textStyle =
        style?.textStyle?.resolve(_states(isDisabled)) ??
        Theme.of(context).textTheme.labelLarge;
    return textStyle?.copyWith(fontSize: _getFontSize()) ??
        TextStyle(fontSize: _getFontSize());
  }

  Border? _getBorder(BuildContext context, bool isDisabled) {
    final style = _resolveStyle(context);
    final side = style?.side?.resolve(_states(isDisabled));

    if (side != null) {
      return Border.all(color: side.color, width: side.width);
    }

    final theme = Theme.of(context);
    if (widget.type == CustomButtonType.outline) {
      return Border.all(
        color: isDisabled
            ? theme.colorScheme.outlineVariant
            : theme.colorScheme.outline,
        width: 1.2,
      );
    }
    return null;
  }

  // List<BoxShadow>? _getBoxShadow(BuildContext context, bool isDisabled) {
  //   final theme = Theme.of(context);
  //   if (type == CustomButtonType.text || isDisabled) return null;
  //
  //   return [
  //     BoxShadow(
  //
  //       blurRadius: 8,
  //       offset: const Offset(0, 4),
  //     ),
  //   ];
  // }

  Set<WidgetState> _states(bool isDisabled) {
    return isDisabled ? {WidgetState.disabled} : {};
  }

  List<BoxShadow>? _getBoxShadow(BuildContext context, bool isDisabled) {
    if (isDisabled || widget.type == CustomButtonType.text) return null;
    final theme = Theme.of(context);
    if (_isPressed) {
      return [
        BoxShadow(
          color: theme.shadowColor.withOpacity(0.12),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];
    }
    if (_isHovered) {
      return [
        BoxShadow(
          color: theme.shadowColor.withOpacity(0.14),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ];
    }
    return [
      BoxShadow(
        color: theme.shadowColor.withOpacity(0.08),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ];
  }

  double _getHeight() {
    switch (widget.size) {
      case CustomButtonSize.small:
        return 32;
      case CustomButtonSize.medium:
        return 44;
      case CustomButtonSize.large:
        return 56;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case CustomButtonSize.small:
        return 12;
      case CustomButtonSize.medium:
        return 14;
      case CustomButtonSize.large:
        return 16;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case CustomButtonSize.small:
        return 16;
      case CustomButtonSize.medium:
        return 20;
      case CustomButtonSize.large:
        return 24;
    }
  }

  double _getLoaderSize() {
    switch (widget.size) {
      case CustomButtonSize.small:
        return 24;
      case CustomButtonSize.medium:
        return 36;
      case CustomButtonSize.large:
        return 48;
    }
  }
}

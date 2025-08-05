import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum CustomButtonType { primary, secondary, outline, text }
enum CustomButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = !enabled || isLoading || onPressed == null;

    return Container(
      margin: margin,
      width: isFullWidth ? double.infinity : width,
      height: height ?? _getHeight(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          splashColor: isDisabled ? Colors.transparent : theme.splashColor,
          highlightColor: isDisabled ? Colors.transparent : theme.highlightColor,
          child: Ink(
            decoration: BoxDecoration(
              color: _getBackgroundColor(context, isDisabled),
              borderRadius: BorderRadius.circular(12),
              border: _getBorder(context, isDisabled),
              boxShadow: _getBoxShadow(context, isDisabled),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildContent(context, isDisabled),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDisabled) {
    if (isLoading) {
      return SizedBox(
        height: _getLoaderSize(),
        width: _getLoaderSize(),
        child: Lottie.asset(
          'assets/lottie/loader_button3dots.json',
          fit: BoxFit.contain,
        ),
      );
    }

    final textStyle = _getTextStyle(context, isDisabled);
    final iconSize = _getIconSize();

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon!, size: iconSize, color: textStyle.color),
          if (text.isNotEmpty) const SizedBox(width: 8),
          Text(text, style: textStyle),
        ],
      );
    }

    return Text(text, style: textStyle);
  }

  Color _getBackgroundColor(BuildContext context, bool isDisabled) {
    final theme = Theme.of(context);

    if (isLoading) return theme.colorScheme.primary;
    if (isDisabled) {
      return type == CustomButtonType.text
          ? Colors.transparent
          : theme.disabledColor;
    }

    switch (type) {
      case CustomButtonType.primary:
        return theme.colorScheme.primary;
      case CustomButtonType.secondary:
        return theme.colorScheme.secondary;
      case CustomButtonType.outline:
      case CustomButtonType.text:
        return Colors.transparent;
    }
  }

  TextStyle _getTextStyle(BuildContext context, bool isDisabled) {
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: _getFontSize(),
    ) ?? TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: _getFontSize(),
    );

    if (isDisabled) {
      return baseStyle.copyWith(
        color: type == CustomButtonType.text
            ? theme.disabledColor
            : theme.disabledColor,
      );
    }

    switch (type) {
      case CustomButtonType.primary:
        return baseStyle.copyWith(color: theme.colorScheme.onPrimary);
      case CustomButtonType.secondary:
        return baseStyle.copyWith(color: theme.colorScheme.onSecondary);
      case CustomButtonType.outline:
      case CustomButtonType.text:
        return baseStyle.copyWith(color: theme.colorScheme.primary);
    }
  }

  Border? _getBorder(BuildContext context, bool isDisabled) {
    final theme = Theme.of(context);

    if (type == CustomButtonType.outline) {
      return Border.all(
        color: isDisabled
            ? theme.disabledColor
            : theme.colorScheme.primary,
      );
    }
    return null;
  }

  List<BoxShadow>? _getBoxShadow(BuildContext context, bool isDisabled) {
    final theme = Theme.of(context);

    if (type == CustomButtonType.text || isDisabled) return null;

    return [
      BoxShadow(
        color: theme.shadowColor.withOpacity(0.2),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ];
  }

  double _getHeight() {
    switch (size) {
      case CustomButtonSize.small: return 32;
      case CustomButtonSize.medium: return 44;
      case CustomButtonSize.large: return 56;
    }
  }

  double _getFontSize() {
    switch (size) {
      case CustomButtonSize.small: return 12;
      case CustomButtonSize.medium: return 14;
      case CustomButtonSize.large: return 16;
    }
  }

  double _getIconSize() {
    switch (size) {
      case CustomButtonSize.small: return 16;
      case CustomButtonSize.medium: return 20;
      case CustomButtonSize.large: return 24;
    }
  }

  double _getLoaderSize() {
    switch (size) {
      case CustomButtonSize.small: return 24;
      case CustomButtonSize.medium: return 36;
      case CustomButtonSize.large: return 48;
    }
  }
}
import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String? label; // now this is used as labelText for floating label
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;
  final bool isEnabled;
  final TextInputType inputType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final int? minLines;

  const CustomInputField({
    super.key,
    this.label,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.isEnabled = true,
    this.inputType = TextInputType.text,
    this.validator,
    this.controller,
    this.onChanged,
    this.onTap,
    this.autofocus = false,
    this.focusNode,
    this.textInputAction,
    this.fillColor,
    this.contentPadding,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool _obscureText;
  bool _isFocused = false;

  @override
  void initState() {
    _obscureText = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Focus(
      onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
      child: TextFormField(
        enabled: widget.isEnabled,
        keyboardType: widget.inputType,
        obscureText: _obscureText,
        controller: widget.controller,
        validator: widget.validator,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        autofocus: widget.autofocus,
        focusNode: widget.focusNode,
        textInputAction: widget.textInputAction,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: widget.isEnabled
              ? colorScheme.onSurface
              : colorScheme.onSurface.withOpacity(0.5),
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintText: widget.hintText,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant.withOpacity(0.6),
          ),
          prefixIcon: widget.prefixIcon != null
              ? Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: Icon(
              widget.prefixIcon,
              color: _isFocused
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              size: 22,
            ),
          )
              : null,
          suffixIcon: _buildSuffixIcon(colorScheme),
          contentPadding: widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

          // Borders from theme
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: colorScheme.outline, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: colorScheme.error, width: 1.2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: colorScheme.error, width: 1.5),
          ),

          errorStyle: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.error,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon(ColorScheme colorScheme) {
    if (widget.isPassword) {
      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: colorScheme.onSurfaceVariant,
            size: 22,
          ),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
      );
    } else if (widget.suffixIcon != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Icon(
          widget.suffixIcon,
          color: _isFocused
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
          size: 22,
        ),
      );
    }
    return null;
  }
}

import 'package:flutter/material.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;
  final bool isEnabled;
  final TextInputType inputType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.isEnabled = true,
    this.inputType = TextInputType.text,
    this.validator,
    this.controller,
    this.onChanged,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool _obscureText;

  @override
  void initState() {
    _obscureText = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      enabled: widget.isEnabled,
      keyboardType: widget.inputType,
      obscureText: _obscureText,
      controller: widget.controller,
      validator: widget.validator,
      onChanged: widget.onChanged,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: theme.inputDecorationTheme.labelStyle,
        hintText: widget.hintText,
        hintStyle: theme.inputDecorationTheme.hintStyle,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: theme.inputDecorationTheme.iconColor)
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: theme.inputDecorationTheme.iconColor,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : (widget.suffixIcon != null
            ? Icon(widget.suffixIcon, color: theme.inputDecorationTheme.iconColor)
            : null),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: theme.inputDecorationTheme.border,
        enabledBorder: theme.inputDecorationTheme.enabledBorder,
        focusedBorder: theme.inputDecorationTheme.focusedBorder,
        errorBorder: theme.inputDecorationTheme.errorBorder,
        filled: theme.inputDecorationTheme.filled,
        fillColor: theme.inputDecorationTheme.fillColor,
        errorStyle: theme.inputDecorationTheme.errorStyle,
      ),
    );
  }
}

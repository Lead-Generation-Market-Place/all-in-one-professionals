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
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final String? helperText;
  final bool showClearButton;

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
    this.onSubmitted,
    this.onTap,
    this.autofocus = false,
    this.focusNode,
    this.textInputAction,
    this.fillColor,
    this.contentPadding,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.helperText,
    this.showClearButton = true,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool _obscureText;
  bool _isFocused = false;
  bool _hasText = false;
  late TextEditingController _internalController;
  VoidCallback? _textListener;
  bool _ownsController = false;
  FocusNode? _internalFocusNode;
  bool _ownsFocusNode = false;

  @override
  void initState() {
    _obscureText = widget.isPassword;
    _ownsController = widget.controller == null;
    _internalController = widget.controller ?? TextEditingController();
    _hasText = _internalController.text.isNotEmpty;
    _textListener = () {
      final hasTextNow = _internalController.text.isNotEmpty;
      if (hasTextNow != _hasText) {
        if (!mounted) return;
        setState(() {
          _hasText = hasTextNow;
        });
      }
    };
    _internalController.addListener(_textListener!);

    // Focus handling
    _ownsFocusNode = widget.focusNode == null;
    _internalFocusNode = widget.focusNode ?? FocusNode();
    _isFocused = _internalFocusNode!.hasFocus;
    _internalFocusNode!.addListener(_handleFocusChange);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      // Detach from previous controller
      if (_textListener != null) {
        _internalController.removeListener(_textListener!);
      }

      // Dispose previously owned controller if we owned it
      if (_ownsController && oldWidget.controller == null) {
        _internalController.dispose();
      }

      // Attach to new controller, creating if now we need to own it
      _ownsController = widget.controller == null;
      if (_ownsController) {
        _internalController = TextEditingController(
          text: oldWidget.controller?.text ?? '',
        );
      } else {
        _internalController = widget.controller!;
      }

      _hasText = _internalController.text.isNotEmpty;
      if (_textListener != null) {
        _internalController.addListener(_textListener!);
      }
    }

    if (oldWidget.focusNode != widget.focusNode) {
      // Detach old focus node
      _internalFocusNode?.removeListener(_handleFocusChange);
      if (_ownsFocusNode && oldWidget.focusNode == null) {
        _internalFocusNode?.dispose();
      }

      _ownsFocusNode = widget.focusNode == null;
      _internalFocusNode = widget.focusNode ?? FocusNode();
      _isFocused = _internalFocusNode!.hasFocus;
      _internalFocusNode!.addListener(_handleFocusChange);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      child: TextFormField(
        enabled: widget.isEnabled,
        keyboardType: widget.inputType,
        obscureText: _obscureText,
        controller: _internalController,
        validator: widget.validator,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        autofocus: widget.autofocus,
        focusNode: _internalFocusNode,
        textInputAction: widget.textInputAction,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        cursorColor: colorScheme.primary,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: widget.isEnabled
              ? colorScheme.onSurface
              : colorScheme.onSurface.withOpacity(0.5),
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: (widget.fillColor ?? colorScheme.surfaceVariant)
              .withOpacity(_isFocused ? 0.28 : 0.18),
          labelText: widget.label,
          labelStyle: theme.textTheme.bodyMedium?.copyWith(
            color: _isFocused
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintText: widget.hintText,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant.withOpacity(0.6),
          ),
          helperText: widget.helperText,
          helperStyle: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          counterText: widget.maxLength != null ? null : '',
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
          prefixIconConstraints: const BoxConstraints(minWidth: 0),
          suffixIcon: _buildSuffixIcon(colorScheme),
          contentPadding:
              widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

          // Borders from theme
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: colorScheme.outline, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: colorScheme.outline, width: 1.5),
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
            height: 1.3,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
          errorMaxLines: 2,
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
    } else if (widget.showClearButton && _hasText && widget.isEnabled) {
      return Padding(
        padding: const EdgeInsets.only(right: 6),
        child: IconButton(
          icon: Icon(
            Icons.clear_rounded,
            color: colorScheme.onSurfaceVariant,
            size: 20,
          ),
          onPressed: () {
            _internalController.clear();
            widget.onChanged?.call('');
          },
          tooltip: 'Clear',
        ),
      );
    }
    return null;
  }

  @override
  void dispose() {
    if (_textListener != null) {
      _internalController.removeListener(_textListener!);
    }
    if (_ownsController) {
      _internalController.dispose();
    }
    _internalFocusNode?.removeListener(_handleFocusChange);
    if (_ownsFocusNode) {
      _internalFocusNode?.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    if (!mounted) return;
    final hasFocus = _internalFocusNode?.hasFocus ?? false;
    if (hasFocus != _isFocused) {
      setState(() => _isFocused = hasFocus);
    }
  }
}

import 'dart:async';
import 'package:flutter/material.dart';

class DynamicSearchInput extends StatefulWidget {
  final List<String>? items; // Static list of items
  final Future<List<String>> Function(String)?
  asyncSearch; // Async search function
  final bool showDropdown; // Show suggestions in dropdown
  final bool highlightMatch; // Highlight matched text
  final void Function(String)? onItemSelected; // Callback when item is selected
  final String hintText;
  final Color fillColor;
  final Duration debounceDuration; // Debounce for async search

  const DynamicSearchInput({
    Key? key,
    this.items,
    this.asyncSearch,
    this.showDropdown = true,
    this.highlightMatch = false,
    this.onItemSelected,
    this.hintText = 'Search...',
    this.fillColor = Colors.white,
    this.debounceDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  _DynamicSearchInputState createState() => _DynamicSearchInputState();
}

class _DynamicSearchInputState extends State<DynamicSearchInput> {
  final TextEditingController _controller = TextEditingController();
  List<String> _filteredItems = [];
  bool _isLoading = false;
  Timer? _debounce;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  void _onSearchChanged() {
    final query = _controller.text.trim().toLowerCase();

    // Trigger rebuild to update clear icon
    if (!mounted) return;
    setState(() {});

    // Cancel previous debounce
    _debounce?.cancel();

    // Debounce async search
    _debounce = Timer(widget.debounceDuration, () async {
      if (widget.asyncSearch != null) {
        if (query.isEmpty) {
          if (!mounted) return;
          setState(() => _filteredItems = []);
          return;
        }
        if (!mounted) return;
        setState(() => _isLoading = true);
        try {
          final results = await widget.asyncSearch!(query);
          if (!mounted) return;
          setState(() => _filteredItems = results);
        } catch (_) {
          if (!mounted) return;
          setState(() => _filteredItems = []);
        }
        if (!mounted) return;
        setState(() => _isLoading = false);
      } else if (widget.items != null) {
        if (!mounted) return;
        setState(() {
          _filteredItems = query.isEmpty
              ? widget.items!
              : widget.items!
                    .where((item) => item.toLowerCase().contains(query))
                    .toList();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
    if (widget.items != null) {
      _filteredItems = widget.items!;
    }
    _focusNode.addListener(() {
      if (!mounted) return;
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _debounce?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  Widget _buildItem(String item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    if (!widget.highlightMatch || _controller.text.isEmpty) {
      return Text(item, style: theme.textTheme.bodyMedium);
    }
    final query = _controller.text.toLowerCase();
    final index = item.toLowerCase().indexOf(query);
    if (index == -1) return Text(item, style: theme.textTheme.bodyMedium);

    final baseStyle = theme.textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurface,
    );
    final highlightStyle = baseStyle?.copyWith(
      color: colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: item.substring(0, index)),
          TextSpan(
            text: item.substring(index, index + query.length),
            style: highlightStyle,
          ),
          TextSpan(text: item.substring(index + query.length)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: _isFocused
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            suffixIcon: _isLoading
                ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                    ),
                  )
                : (_controller.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          onPressed: () {
                            _debounce?.cancel();
                            _controller.clear();
                            if (widget.onItemSelected != null) {
                              widget.onItemSelected!('');
                            }
                            if (!mounted) return;
                            setState(
                              () => _filteredItems = widget.items == null
                                  ? []
                                  : [],
                            );
                          },
                          tooltip: 'Clear',
                        )
                      : null),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.6),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: colorScheme.outline, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: colorScheme.outline, width: 1.5),
            ),
            filled: true,
            fillColor: Color.alphaBlend(
              colorScheme.primary.withOpacity(_isFocused ? 0.05 : 0.03),
              isDark ? colorScheme.surface : widget.fillColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (widget.showDropdown && (_isLoading || _filteredItems.isNotEmpty))
          _isLoading ? _buildLoading(theme) : _buildDropdown(theme),
        if (widget.showDropdown &&
            !_isLoading &&
            _controller.text.isNotEmpty &&
            _filteredItems.isEmpty)
          _buildNoResults(theme),
      ],
    );
  }

  Widget _buildLoading(ThemeData theme) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      color: theme.colorScheme.surface,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: _dropdownDecoration(theme),
        child: const Center(
          child: SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(ThemeData theme) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      color: theme.colorScheme.surface,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 240),
        decoration: _dropdownDecoration(theme),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: _filteredItems.length,
          separatorBuilder: (_, __) =>
              Divider(height: 1, color: theme.dividerColor),
          itemBuilder: (context, index) {
            final item = _filteredItems[index];
            return ListTile(
              title: _buildItem(item),
              onTap: () {
                _controller.text = item;
                if (widget.onItemSelected != null) {
                  widget.onItemSelected!(item);
                }
                if (!mounted) return;
                setState(() => _filteredItems = []);
                FocusScope.of(context).unfocus();
              },
              hoverColor: theme.colorScheme.primary.withOpacity(0.06),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNoResults(ThemeData theme) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      color: theme.colorScheme.surface,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: _dropdownDecoration(theme),
        child: Row(
          children: [
            Icon(Icons.search_off, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text('No results', style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  BoxDecoration _dropdownDecoration(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
    );
  }
}

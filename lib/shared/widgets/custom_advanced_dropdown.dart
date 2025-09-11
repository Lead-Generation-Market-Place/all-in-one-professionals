import 'package:flutter/material.dart';

typedef DropdownItemBuilder<T> = Widget Function(BuildContext context, T item);

class AdvancedDropdown<T> extends StatefulWidget {
  final List<T> items;
  final ValueChanged<T?>? onChanged;
  final T? selectedItem;
  final String searchHintText;
  final bool enableSearch;
  final String Function(T item) itemToString;
  final DropdownItemBuilder<T>? itemBuilder;
  final BoxDecoration? decoration;
  final String hintText;
  final TextStyle? textStyle;

  const AdvancedDropdown({
    Key? key,
    required this.items,
    this.onChanged,
    this.selectedItem,
    this.searchHintText = 'Search...',
    this.enableSearch = true,
    required this.itemToString,
    this.itemBuilder,
    this.decoration,
    this.hintText = 'Select an item',
    this.textStyle,
  }) : super(key: key);

  @override
  _AdvancedDropdownState<T> createState() => _AdvancedDropdownState<T>();
}

class _AdvancedDropdownState<T> extends State<AdvancedDropdown<T>> {
  late List<T> _filteredItems;
  T? _selectedItem;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  bool _isDropdownOpen = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;
    _filteredItems = List<T>.from(widget.items);
    _searchController.addListener(_filterItems);
  }

  @override
  void didUpdateWidget(covariant AdvancedDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _filteredItems = List<T>.from(widget.items);
    }
    if (widget.selectedItem != oldWidget.selectedItem) {
      _selectedItem = widget.selectedItem;
    }
  }

  void _filterItems() {
    if (_isDisposed) return;

    final query = _searchController.text.toLowerCase();
    final newFilteredItems = query.isEmpty
        ? List<T>.from(widget.items)
        : widget.items
              .where(
                (item) =>
                    widget.itemToString(item).toLowerCase().contains(query),
              )
              .toList();

    if (mounted) {
      setState(() {
        _filteredItems = newFilteredItems;
      });
    } else {
      _filteredItems = newFilteredItems;
    }
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (_isDisposed || !mounted) return;

    try {
      final overlay = Overlay.of(context);

      _overlayEntry = _createOverlayEntry();
      overlay.insert(_overlayEntry!);

      if (mounted) {
        setState(() {
          _isDropdownOpen = true;
        });
      } else {
        _isDropdownOpen = true;
      }
    } catch (e) {
      _isDropdownOpen = false;
    }
  }

  void _closeDropdown({bool fromDispose = false}) {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }

    // _searchController.clear();

    if (!fromDispose && mounted) {
      setState(() {
        _isDropdownOpen = false;
        _filteredItems = List<T>.from(widget.items);
      });
    } else {
      _isDropdownOpen = false;
      _filteredItems = List<T>.from(widget.items);
    }
  }

  OverlayEntry _createOverlayEntry() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return OverlayEntry(
      builder: (context) {
        final currentTheme = Theme.of(context);
        final currentColorScheme = currentTheme.colorScheme;
        final currentTextTheme = currentTheme.textTheme;

        return Positioned(
          width: MediaQuery.of(context).size.width - 32,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 5),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 300),
                decoration: BoxDecoration(
                  color: currentColorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: currentColorScheme.outline.withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: currentColorScheme.shadow.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.enableSearch)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          style: currentTextTheme.bodyMedium?.copyWith(
                            color: currentColorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: widget.searchHintText,
                            hintStyle: currentTextTheme.bodyMedium?.copyWith(
                              color: currentColorScheme.onSurfaceVariant,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: currentColorScheme.onSurfaceVariant,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: currentColorScheme.outline.withOpacity(
                                  0.5,
                                ),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: currentColorScheme.outline.withOpacity(
                                  0.3,
                                ),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: currentColorScheme.primary,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            fillColor: currentColorScheme
                                .surfaceContainerHighest
                                .withOpacity(0.3),
                            filled: true,
                          ),
                        ),
                      ),
                    Expanded(
                      child: _filteredItems.isNotEmpty
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: _filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = _filteredItems[index];
                                final isSelected = item == _selectedItem;
                                return InkWell(
                                  onTap: () {
                                    if (_isDisposed) return;

                                    setState(() {
                                      _selectedItem = item;
                                    });
                                    widget.onChanged?.call(item);
                                    _closeDropdown();
                                  },
                                  child: Container(
                                    color: isSelected
                                        ? currentColorScheme.primary
                                              .withOpacity(0.1)
                                        : Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                    child: widget.itemBuilder != null
                                        ? widget.itemBuilder!(context, item)
                                        : Text(
                                            widget.itemToString(item),
                                            style: currentTextTheme.bodyMedium
                                                ?.copyWith(
                                                  color: isSelected
                                                      ? currentColorScheme
                                                            .primary
                                                      : currentColorScheme
                                                            .onSurface,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w600
                                                      : FontWeight.normal,
                                                ),
                                          ),
                                  ),
                                );
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'No items found',
                                style: currentTextTheme.bodyMedium?.copyWith(
                                  color: currentColorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _searchController.dispose();
    _focusNode.dispose();
    _closeDropdown(fromDispose: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          decoration:
              widget.decoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isDropdownOpen
                      ? colorScheme.primary
                      : colorScheme.outline.withOpacity(0.4),
                ),
                color: colorScheme.surface,
                boxShadow: [
                  if (_isDropdownOpen)
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _selectedItem != null
                      ? widget.itemToString(_selectedItem!)
                      : widget.hintText,
                  style:
                      widget.textStyle ??
                      textTheme.bodyMedium?.copyWith(
                        color: _selectedItem != null
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

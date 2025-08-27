import 'package:flutter/material.dart';

typedef DropdownItemBuilder<T> = Widget Function(BuildContext context, T item);
typedef DropdownSearchFilter<T> = bool Function(T item, String query);

class AdvancedDropdown<T> extends StatefulWidget {
  /// List of all items to display in dropdown
  final List<T> items;

  /// Called when selected item changes
  final ValueChanged<T?>? onChanged;

  /// The currently selected item
  final T? selectedItem;

  /// Optional search placeholder
  final String searchHintText;

  /// Whether search is enabled
  final bool enableSearch;

  /// How to display items as string in dropdown (fallback if no builder given)
  final String Function(T item) itemToString;

  /// Optional custom widget builder for dropdown items
  final DropdownItemBuilder<T>? itemBuilder;

  /// Decoration for the dropdown container
  final BoxDecoration? decoration;

  /// Hint text for dropdown
  final String hintText;

  /// TextStyle for hint and selected item display
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

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;
    _filteredItems = widget.items;
    _searchController.addListener(_filterItems);
  }

  @override
  void didUpdateWidget(covariant AdvancedDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _filteredItems = widget.items;
      _filterItems();
    }
    if (widget.selectedItem != oldWidget.selectedItem) {
      setState(() {
        _selectedItem = widget.selectedItem;
      });
    }
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where(
              (item) => widget.itemToString(item).toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)!.insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _searchController.clear();
    setState(() {
      _filteredItems = widget.items;
      _isDropdownOpen = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx,
          top: offset.dy + size.height + 5,
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 5),
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 300),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.enableSearch)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: widget.searchHintText,
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: _filteredItems.isNotEmpty
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: _filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = _filteredItems[index];
                                final isSelected = item == _selectedItem;
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedItem = item;
                                    });
                                    widget.onChanged?.call(item);
                                    _closeDropdown();
                                  },
                                  child: Container(
                                    color: isSelected
                                        ? Colors.blue.shade100
                                        : null,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                    child: widget.itemBuilder != null
                                        ? widget.itemBuilder!(context, item)
                                        : Text(
                                            widget.itemToString(item),
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.blue
                                                  : Colors.black87,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
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
                                style: TextStyle(color: Colors.grey.shade600),
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
    _searchController.dispose();
    _focusNode.dispose();
    _closeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          decoration:
              widget.decoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
                color: Colors.white,
              ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  _selectedItem != null
                      ? widget.itemToString(_selectedItem!)
                      : widget.hintText,
                  style:
                      widget.textStyle ??
                      TextStyle(
                        color: _selectedItem != null
                            ? Colors.black87
                            : Colors.grey.shade600,
                        fontSize: 16,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Colors.grey.shade700,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

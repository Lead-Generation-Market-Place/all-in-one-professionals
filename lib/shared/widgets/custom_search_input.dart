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
    this.fillColor = const Color(0xFFE0E0E0),
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

  void _onSearchChanged() {
    final query = _controller.text.trim().toLowerCase();

    // Trigger rebuild to update clear icon
    setState(() {});

    // Cancel previous debounce
    _debounce?.cancel();

    // Debounce async search
    _debounce = Timer(widget.debounceDuration, () async {
      if (widget.asyncSearch != null) {
        if (query.isEmpty) {
          setState(() => _filteredItems = []);
          return;
        }
        setState(() => _isLoading = true);
        try {
          final results = await widget.asyncSearch!(query);
          setState(() => _filteredItems = results);
        } catch (_) {
          setState(() => _filteredItems = []);
        }
        setState(() => _isLoading = false);
      } else if (widget.items != null) {
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
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Widget _buildItem(String item) {
    if (!widget.highlightMatch || _controller.text.isEmpty) {
      return Text(item);
    }
    final query = _controller.text.toLowerCase();
    final index = item.toLowerCase().indexOf(query);
    if (index == -1) return Text(item);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: item.substring(0, index),
            style: const TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: item.substring(index, index + query.length),
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: item.substring(index + query.length),
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _controller.clear();
                      if (widget.onItemSelected != null) {
                        widget.onItemSelected!('');
                      }
                      setState(() => _filteredItems = widget.items ?? []);
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: widget.fillColor,
          ),
        ),
        const SizedBox(height: 8),
        if (widget.showDropdown && (_isLoading || _filteredItems.isNotEmpty))
          _isLoading ? _buildLoading() : _buildDropdown(),
      ],
    );
  }

  Widget _buildLoading() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _dropdownDecoration(),
      child: const Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: _dropdownDecoration(),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: _filteredItems.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = _filteredItems[index];
          return ListTile(
            title: _buildItem(item),
            onTap: () {
              _controller.text = item;
              if (widget.onItemSelected != null) {
                widget.onItemSelected!(item);
              }
              FocusScope.of(context).unfocus();
            },
            hoverColor: Colors.blue.withOpacity(0.1),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          );
        },
      ),
    );
  }

  BoxDecoration _dropdownDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
    );
  }
}

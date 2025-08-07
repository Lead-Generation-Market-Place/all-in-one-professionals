import 'package:flutter/material.dart';

class SettingsItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  State<SettingsItem> createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final hoverColor = Theme.of(context).hoverColor;

    return MouseRegion(

        child: ListTile(
          leading: Icon(widget.icon, color: Theme.of(context).colorScheme.primary),
          title: Text(widget.title, style: const TextStyle(fontSize: 16)),
          subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
          trailing: const Icon(Icons.chevron_right),
          onTap: widget.onTap,
        ),

    );
  }
}

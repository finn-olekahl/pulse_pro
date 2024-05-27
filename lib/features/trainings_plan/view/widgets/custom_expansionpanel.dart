import 'package:flutter/material.dart';

class CustomExpansionPanel extends StatefulWidget {
  const CustomExpansionPanel({super.key, required this.title, required this.body, required this.isFinished});

  final Widget title;
  final Widget body;
  final bool isFinished;

  @override
  State<CustomExpansionPanel> createState() => _CustomExpansionPanelState();
}

class _CustomExpansionPanelState extends State<CustomExpansionPanel> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      title: widget.title,
      leading: widget.isFinished
          ? null
          : _isExpanded
              ? const Icon(Icons.arrow_drop_down)
              : const Icon(Icons.arrow_right),
      trailing: widget.isFinished ? const Icon(Icons.done) : null,
      subtitle: _isExpanded && !widget.isFinished ? widget.body : null,
    );
  }
}

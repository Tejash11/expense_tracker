import 'package:flutter/material.dart';

class ExpandableFab extends StatefulWidget {
  final Icon mainFab;
  final List<Widget> children;

  const ExpandableFab({
    Key? key,
    required this.mainFab,
    required this.children,
  }) : super(key: key);

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {
  bool _isExpanded = false;

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = [];
    for (int i = 0; i < widget.children.length; i++) {
      buttons.add(
        AnimatedPositioned(
          bottom: 80.0 + i * 60.0,
          right: 16.0,
          duration: Duration(milliseconds: 300),
          child: AnimatedOpacity(
            opacity: _isExpanded ? 1.0 : 0.0,
            duration: Duration(milliseconds: 300),
            child: widget.children[i],
          ),
        ),
      );
    }

    return Stack(
      children: [
        ...buttons,
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: _toggle,
            child: Icon(_isExpanded ? Icons.cancel : Icons.add),
            backgroundColor: Colors.blue,
          ),
        ),
      ],
    );
  }
}

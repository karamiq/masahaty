import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';

class CustomExpansionTile extends StatefulWidget {
  final String initialTitle;
  final List<String> options;
  final ValueChanged<String> onOptionSelected;

  const CustomExpansionTile({
    super.key,
    required this.initialTitle,
    required this.options,
    required this.onOptionSelected,
  });

  @override
  createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  late String _currentTitle;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _currentTitle = widget.initialTitle;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CoustomBorderTheme.normalBorderRaduis),
        border: Border.all(
          width: CoustomBorderTheme.borderWidth,
          color: CustomColorsTheme.dividerColor,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(_currentTitle),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: CustomColorsTheme.headLineColor,
            ),
          ),
          if (_isExpanded)
            Column(
              children: widget.options.map((option) {
                return ListTile(
                  title: Text(option),
                  onTap: () {
                    setState(() {
                      _currentTitle = option;
                      _isExpanded = false;
                    });
                    widget.onOptionSelected(option);
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

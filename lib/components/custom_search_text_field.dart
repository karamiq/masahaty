import 'package:flutter/material.dart';

import '../core/constants/constants.dart';

class CoustomSearchTextField extends StatelessWidget {
  const CoustomSearchTextField({
    super.key,
    this.prefixIcon,
    required this.labelText,
    required this.controller, 
    required this.onChange,
  });

  final IconData? prefixIcon;
  final String labelText;
  final TextEditingController controller;
  final Function(String) onChange;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChange,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIcon:
            Icon(prefixIcon, size: 24, color: CustomColorsTheme.headLineColor),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF5F5F5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromRGBO(245, 245, 245, 1)),
        ),
      ),
    );
  }
}

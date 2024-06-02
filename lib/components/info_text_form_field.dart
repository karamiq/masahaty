
import 'package:flutter/material.dart';

import '../core/constants/constants.dart';

class InfoTextField extends StatelessWidget {
  const InfoTextField(
      {super.key,
      required this.controller,
      this.maxLines = 1,
      required this.formKey,
      required this.validator,
      this.keyboardType = TextInputType.text});

  final TextEditingController? controller;
  final int maxLines;
  final GlobalKey formKey;
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Center(
          child: TextFormField(
            maxLines: maxLines,
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              helperText: '',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.red, width: 2)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: CustomColorsTheme.dividerColor, width: 2)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: CustomColorsTheme.dividerColor, width: 1)),
            ),
            validator: validator,
          ),
        ));
  }
}
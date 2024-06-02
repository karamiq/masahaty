import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masahaty/provider/change_language.dart';
import '../core/constants/constants.dart';

class CustomTextFormField extends ConsumerWidget {
  const CustomTextFormField({
    super.key,
    required this.formKey,
    required this.controller,
    required this.validator,
    required this.prefixIcon,
    required this.labelText, 
    this.keyBoardType = TextInputType.name,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final Icon prefixIcon;
  final String labelText;
  final TextInputType keyBoardType;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(currentLanguageProvider);
    return Form(
      key: formKey,
      child: TextFormField(
        textDirection: currentLanguage == const Locale('ar') ? TextDirection.rtl : TextDirection.ltr,
        keyboardType: keyBoardType,
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          labelText: labelText,
          helperText: '',
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: CustomColorsTheme.headLineColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: CustomColorsTheme.headLineColor, width: 1),
          ),
        ),
      ),
    );
  }
}

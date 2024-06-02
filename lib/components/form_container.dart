import 'package:flutter/material.dart';

import '../core/constants/constants.dart';

class FormContainer extends StatelessWidget {
  const FormContainer({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.background = Colors.white,
    this.padding = const  EdgeInsets.symmetric(horizontal: CustomPageTheme.normalPadding), 
     this.contentPadding = const EdgeInsets.all(0)
  });

  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Color background;
  final EdgeInsets padding;
  final EdgeInsets contentPadding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  padding,
      child: Container(
          decoration: BoxDecoration(
            color: background,
            border: Border.all(
                width: CoustomBorderTheme.borderWidth,
                color: CustomColorsTheme.dividerColor),
            borderRadius:
                BorderRadius.circular(CoustomBorderTheme.normalBorderRaduis),
          ),
          child: Padding(
            padding: contentPadding,
            child: Column(
              children: children,
            ),
          )),
    );
  }
}

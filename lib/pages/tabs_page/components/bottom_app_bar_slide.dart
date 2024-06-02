
import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';

class BottomAppBarSlide extends StatelessWidget {
  const BottomAppBarSlide({
    super.key,
    required this.selectedPageIndex,
    required this.size,
  });

  final int selectedPageIndex;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4,
        (index) => Container(
          color: index == selectedPageIndex ? CustomColorsTheme.headLineColor : Colors.white,
          height: 3,
          width: size.width/4,
        ) 
      ),
    );
  }
  
}


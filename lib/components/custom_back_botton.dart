
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/constants.dart';

class customBackButton extends StatelessWidget {
  const customBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
     onPressed: ()=> context.pop(), 
     icon: const Icon( Icons.chevron_left, ),
     style: ButtonStyle(
       shape: WidgetStateProperty.all(
         RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(CoustomBorderTheme.normalBorderRaduis),
           side: const BorderSide(width: 1,color: CustomColorsTheme.dividerColor),
         )
         ),
       backgroundColor: WidgetStateProperty.all(Colors.white.withOpacity(0.9))
     ),
            );
  }
}
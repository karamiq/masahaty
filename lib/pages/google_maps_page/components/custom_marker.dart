import 'package:flutter/material.dart';
import 'package:masahaty/core/constants/constants.dart';

class CustomMarker extends StatelessWidget {
  final String title;
  final Color color;

  const CustomMarker({Key? key, required this.title, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            height: 10, width: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(CoustomBorderTheme.normalBorderRaduis), topRight: Radius.circular(CoustomBorderTheme.normalBorderRaduis), bottomLeft: Radius.circular(CoustomBorderTheme.normalBorderRaduis))
            ),
            child: Text(title,
              style: const TextStyle(
                //fontSize: 50
              ),),
          ),
        ),
        const Align(
          alignment: Alignment.bottomRight,
          child: Icon(Icons.location_on_outlined,color: CustomColorsTheme.headLineColor,),
        )
      ],
    );
  }
}

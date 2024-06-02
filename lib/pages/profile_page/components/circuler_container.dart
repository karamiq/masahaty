
import 'package:flutter/material.dart';

class CirculerContainer extends StatelessWidget {
  const CirculerContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, width: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF3D8BA1),width: 2)
      ),
    );
  }
}
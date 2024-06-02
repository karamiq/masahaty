
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
class AddImages extends StatelessWidget {
  final int imagesLimit;
  final List<File> selectedImages;
  final Function() selectImages;

  const AddImages({
    required this.imagesLimit,
    required this.selectedImages,
    required this.selectImages,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: imagesLimit > 1 ? selectImages : null,
      child: SizedBox(
        height: 100,
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
            width: 20,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: selectedImages.isEmpty ? imagesLimit : selectedImages.length,
          itemBuilder: (context, index) {
            return DottedBorder(
              color: CustomColorsTheme.headLineColor,
              strokeWidth: 2,
              borderType: BorderType.RRect,
              radius:
                  const Radius.circular(CoustomBorderTheme.normalBorderRaduis),
              dashPattern: const [9, 6],
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: index == 0
                      ? CustomColorsTheme.lightHeadLineColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(
                      CoustomBorderTheme.normalBorderRaduis),
                ),
                child: selectedImages.isEmpty
                    ? Center(
                        child: index == 0
                            ? const Icon(
                                Icons.camera_enhance_outlined,
                                color: CustomColorsTheme.headLineColor,
                              )
                            : null)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(
                            CoustomBorderTheme.normalBorderRaduis),
                        child: Image.file(
                          selectedImages[index],
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}

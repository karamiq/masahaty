
import 'package:flutter/material.dart';

import '../core/constants/constants.dart';
import 'shimmer_container.dart';

class WarehouseCardSkeleton extends StatelessWidget {
  const WarehouseCardSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(vertical: CustomPageTheme.smallPadding),
      padding:
          const EdgeInsets.symmetric(horizontal: CustomPageTheme.normalPadding),
      width: 347,
      height: 337,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.1),
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(CoustomBorderTheme.normalBorderRaduis),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: CustomPageTheme.bigPadding,
          ),
          ShimmerContainer(
            width: double.infinity,
            height: 160,
          ),
          ShimmerContainer(
            width: double.infinity,
          ),
          ShimmerContainer(
            width: double.infinity,
          ),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerContainer(
                width: 150,
              ),
              ShimmerContainer(
                width: 150,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerContainer(
                width: 80,
              ),
              ShimmerContainer(
                width: 80,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
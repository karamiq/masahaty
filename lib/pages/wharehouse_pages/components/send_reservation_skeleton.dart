import 'package:flutter/material.dart';
import 'package:masahaty/components/shimmer_container.dart';

import '../../../core/constants/constants.dart';

class SendReserveSkeleton extends StatelessWidget {
  const SendReserveSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: CustomPageTheme.veryBigpadding * 2),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: CustomPageTheme.normalPadding,
            vertical: CustomPageTheme.bigPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ShimmerContainer(
                    width: 120,
                    height: 90,
                  ),
                  SizedBox(width: CustomPageTheme.smallPadding),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerContainer(width: 120, height: 10),
                      Row(
                        children: [
                          ShimmerContainer(width: 60, height: 10),
                          SizedBox(width: CustomPageTheme.smallPadding),
                          ShimmerContainer(width: 50, height: 10),
                        ],
                      ),
                      ShimmerContainer(width: 100, height: 10),
                    ],
                  )
                ],
              ),
              SizedBox(height: CustomPageTheme.normalPadding),
              ShimmerContainer(width: 100),
              SizedBox(height: CustomPageTheme.normalPadding),
              ShimmerContainer(width: double.infinity, height: 120),
              SizedBox(height: CustomPageTheme.normalPadding),
              ShimmerContainer(width: 100),
              SizedBox(height: CustomPageTheme.normalPadding),
              ShimmerContainer(width: double.infinity, height: 180),
              SizedBox(height: CustomPageTheme.normalPadding),
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: CustomPageTheme.normalPadding),
          child: ShimmerContainer(width: double.infinity,height: 50,),
        ),
         SizedBox(
            height: CustomPageTheme.normalPadding,
          ),
      ],
    );
  }
}

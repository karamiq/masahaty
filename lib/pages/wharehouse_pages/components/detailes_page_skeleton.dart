import 'package:flutter/material.dart';
import 'package:masahaty/components/shimmer_container.dart';
import 'package:masahaty/core/constants/constants.dart';

class DetailsPageSkeleton extends StatelessWidget {
  const DetailsPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerContainer(
            width: double.infinity,
            height: 286,
          ),
          SizedBox(
            height: CustomPageTheme.normalPadding,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: CustomPageTheme.normalPadding,
                vertical: CustomPageTheme.bigPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerContainer(
                      width: 150,
                    ),
                    ShimmerContainer(
                      width: 100,
                    ),

                  ],
                ),
                ShimmerContainer(
                  width: 100, height: 10,
                ),
                SizedBox(
                  height: CustomPageTheme.normalPadding,
                ),
                ShimmerContainer(
                  width: 100,
                ),
                ShimmerContainer(
                  width: 250,height: 10,
                ),
                ShimmerContainer(
                  width: 200,height: 10,
                ),ShimmerContainer(
                  width: 300,height: 10,
                ),
                SizedBox(
                  height: CustomPageTheme.normalPadding,
                ),
                ShimmerContainer(
                  width: 100,
                ),
                SizedBox(height: CustomPageTheme.smallPadding,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShimmerContainer(
                      width: 90,height: 40,
                    ),
                    SizedBox(width: CustomPageTheme.normalPadding,),
                     ShimmerContainer(
                      width: 90,height: 40,
                    ),
                    SizedBox(width: CustomPageTheme.normalPadding,),
                     ShimmerContainer(
                      width: 90,height: 40,
                    ),
                  ],
                ),
      
                SizedBox(
                  height: CustomPageTheme.normalPadding,
                ),
                ShimmerContainer(
                  width: 100,
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ShimmerContainer(
                        width: double.infinity,height: 35,
                      ),
                       ShimmerContainer(
                        width: double.infinity,height: 35,
                      ),
                       ShimmerContainer(
                        width: double.infinity,height: 35,
                      ),
                       ShimmerContainer(
                        width: double.infinity,height: 35,
                      ),
                       ShimmerContainer(
                        width: double.infinity,height: 35,
                      ),
                       ShimmerContainer(
                        width: double.infinity,height: 35,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: CustomPageTheme.bigPadding,),
          ShimmerContainer(
                  width: 100,
                ),
                ShimmerContainer(
                  width: double.infinity, height: 200,
                ),
                SizedBox(height: CustomPageTheme.smallPadding,),
                ShimmerContainer(
                  width: double.infinity, height: 60,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

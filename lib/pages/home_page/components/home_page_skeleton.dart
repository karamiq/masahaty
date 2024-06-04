
import 'package:flutter/material.dart';

import '../../../components/shimmer_container.dart';
import '../../../components/warehouse_card_skeleton.dart';
import '../../../core/constants/constants.dart';

class HomPageSkeleton extends StatelessWidget {
  const HomPageSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: CustomPageTheme.veryBigpadding + CustomPageTheme.smallPadding,),
          SizedBox(
            height: 347,
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(width: CustomPageTheme.normalPadding,),
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return const WarehouseCardSkeleton();
              },
            ),
          ),
          const SizedBox(
            height: CustomPageTheme.normalPadding,
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(
                      CustomPageTheme.smallPadding),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          CoustomBorderTheme
                              .normalBorderRaduis),
                      border: Border.all(
                          color: Colors.grey, width: 0.1),
                    ),
                    height: 97,
                    width: 102,
                    child: Column(children: [
                      Container(
                        padding: const EdgeInsets.only(
                            bottom:
                                CustomPageTheme.smallPadding),
                        height: 97,
                        width: 102,
                        color: Colors.white,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ShimmerContainer(
                            height: 20,
                            width: 20,
                          ),
                        ),
                      )
                    ]),
                  ),
                );
              },
            ),
          ),
          const WarehouseCardSkeleton(),
          const WarehouseCardSkeleton(),
        ],
      );
  }
}
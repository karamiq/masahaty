import 'package:flutter/material.dart';
import 'package:masahaty/components/shimmer_container.dart';
import 'package:masahaty/core/constants/constants.dart';

class NotificationsSkeleton extends StatelessWidget {
  const NotificationsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: CustomPageTheme.normalPadding * 4,
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 10,
          separatorBuilder: (context, index) => const SizedBox(height: CustomPageTheme.normalPadding,),
          itemBuilder: (context, index) => const ShimmerContainer(
            width: double.infinity,
            height: 60,
          ),
        )
      ],
    );
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:masahaty/components/shimmer_container.dart';
import 'package:masahaty/core/constants/constants.dart';

class MarkedInfoSkeleton extends StatelessWidget {
  const MarkedInfoSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment:CrossAxisAlignment.start ,
      children: [
        const SizedBox(height: CustomPageTheme.smallPadding,),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: CustomPageTheme.normalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerContainer(width: 100,),
                  Row(
                    children: [
                      ShimmerContainer(width: 50,height: 10,),
                      SizedBox(width: CustomPageTheme.smallPadding,),
                      ShimmerContainer(width: 70,height: 10,),
                      SizedBox(width: CustomPageTheme.smallPadding,),
                      ShimmerContainer(width: 30,height: 10,),
                    ],
                  ),
                  ShimmerContainer(width: 200,height: 10,),
                  
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: CustomPageTheme.smallPadding),
                child: Row(
                  children: [
                    ShimmerContainer(width: 35,height: 35,),
                    SizedBox(width: CustomPageTheme.smallPadding,),
                    ShimmerContainer(width: 35,height: 35,),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: CustomPageTheme.normalPadding,),
        Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(
                          CoustomBorderTheme.normalBorderRaduis)),
                ),
                child: CarouselSlider.builder(
                  itemCount: 4,
                  itemBuilder: (context, index, realIndex) {
                    return const ShimmerContainer(width: 300);
                  },
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    enableInfiniteScroll: true,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(CustomPageTheme.normalPadding),
                child: SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ShimmerContainer(height: 40, width:double.infinity,)
                ),
              )
      ],
    );
  }
}
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../components/custom_back_botton.dart';
import '../../../components/custom_comments_button.dart';
import '../../../components/custom_favorites_button.dart';
import '../../../components/rating_button.dart';
import '../../../core/constants/constants.dart';

class WarehouseCarousel extends ConsumerWidget {
  final List<String> images;
  final double rating;
  final String id;
  const WarehouseCarousel(
      {super.key,
      required this.images,
      required this.rating,
      required this.id});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int activeIndex = 0;
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(CoustomBorderTheme.normalBorderRaduis)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 0, 158, 204),
                Color.fromARGB(255, 0, 101, 132),
              ],
            ),
          ),
          child: CarouselSlider.builder(
            itemCount: images.length,
            itemBuilder: (context, index, realIndex) {
              final urlImage = images[index];
              return buildImage(urlImage, index);
            },
            options: CarouselOptions(
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                activeIndex = index;
              },
              height: 286,
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: MediaQuery.of(context).size.width / 2.5,
          child: buildIndicator(activeIndex),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: CustomPageTheme.normalPadding,
            vertical: CustomPageTheme.meduimPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const customBackButton(),
              Row(
                children: [
                  CustomCommentsButton(id: id),
                  CustomFavoritesButton(id: id),
                  RatingButton(warehouseRating: rating, id: id),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildIndicator(int index) => AnimatedSmoothIndicator(
        effect: const ExpandingDotsEffect(
          expansionFactor: 3,
          spacing: 5,
          dotWidth: 10,
          dotHeight: 8,
          activeDotColor: CustomColorsTheme.headLineColor,
        ),
        activeIndex: index,
        count: images.length,
      );

  Widget buildImage(String urlImage, int index) => ClipRRect(
        borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(CoustomBorderTheme.normalBorderRaduis)),
        child: Image.network(
          urlImage,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../components/custom_back_botton.dart';
import '../../../components/custom_comments_button.dart';
import '../../../components/custom_favorites_button.dart';
import '../../../components/custom_rating_button.dart';
import '../../../core/constants/constants.dart';

class WarehouseCarousel extends StatefulWidget {
  final List<String> images;
  final double rating;
  final String id;
  final bool showTop;
  const WarehouseCarousel(
      {super.key,
      this.showTop = true,
      required this.images,
      required this.rating,
      required this.id});

  @override
  State<WarehouseCarousel> createState() => _WarehouseCarouselState();
}

class _WarehouseCarouselState extends State<WarehouseCarousel> {
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    
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
            itemCount: widget.images.length,
            itemBuilder: (context, index, realIndex) {
              final urlImage = widget.images[index];
              return buildImage(urlImage, index);
            },
            options: CarouselOptions(
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  activeIndex = index;
                });
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
        if (widget.showTop == true)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: CustomPageTheme.normalPadding,
              vertical: CustomPageTheme.meduimPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomBackButton(),
                Row(
                  children: [
                    CustomCommentsButton(id: widget.id),
                    CustomFavoritesButton(id: widget.id),
                    CustomRatingButton(warehouseRating: widget.rating, id: widget.id),
                  ],
                )
              ],
            ),
          ),
      ],
    );
  }

  Widget buildIndicator(int index) {
   return AnimatedSmoothIndicator(
      effect: const ExpandingDotsEffect(
        expansionFactor: 3,
        spacing: 5,
        dotWidth: 10,
        dotHeight: 8,
        activeDotColor: CustomColorsTheme.headLineColor,
      ),
      activeIndex: index,
      count: widget.images.length,
    );
  }

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

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/constants.dart';
import '../../../models/storage&features_model.dart';
import '../../../services/dio_storage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../wharehouse_pages/warehouse_details_page.dart';
import 'marked_info_head.dart';
import 'marked_info_skeleton.dart';
import 'dart:ui' as ui;

class MarkedWarehouseInfo extends StatefulWidget {
  const MarkedWarehouseInfo({super.key, required this.id});
  final String id;

  @override
  State<MarkedWarehouseInfo> createState() => _MarkedWarehouseInfoState();
}

class _MarkedWarehouseInfoState extends State<MarkedWarehouseInfo> {
  StorageService storageService = StorageService();
  Storage? markedWarehouse;

  void getMarkedWarehouse() async {
    markedWarehouse = await storageService.storageGetById(id: widget.id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getMarkedWarehouse();
  }

  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return markedWarehouse != null
        ? Column(
            children: [
              MarkedInfoHead(markedWarehouse: markedWarehouse),
              const SizedBox(height: CustomPageTheme.normalPadding),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(
                          CoustomBorderTheme.normalBorderRaduis)),
                ),
                child: CarouselSlider.builder(
                  itemCount: markedWarehouse!.images.length,
                  itemBuilder: (context, index, realIndex) {
                    final urlImage = markedWarehouse!.images[index];
                    return buildGridImage(urlImage);
                  },
                  options: CarouselOptions(
                    onPageChanged: (index, reason) =>
                        setState(() => activeIndex = index),
                    height: 200,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    enableInfiniteScroll: true,
                  ),
                ),
              ),
              const SizedBox(height: CustomPageTheme.smallPadding),
              buildIndicator(
                  index: activeIndex, markedWarehouse: markedWarehouse!),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(CustomPageTheme.normalPadding),
                child: SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              CoustomBorderTheme.normalBorderRaduis)),
                    ),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (c) => WarehouseDetailesPage(
                                id: markedWarehouse!.id))),
                    label: Text(AppLocalizations.of(context)!.moreInfo),
                    icon: const Icon(Icons.chevron_left_outlined),
                  ),
                ),
              )
            ],
          )
        : const MarkedInfoSkeleton();
  }
}

Widget buildIndicator({required Storage markedWarehouse, required int index}) =>
    AnimatedSmoothIndicator(
      effect: const ExpandingDotsEffect(
        expansionFactor: 3,
        spacing: 5,
        dotWidth: 10,
        dotHeight: 8,
        activeDotColor: CustomColorsTheme.headLineColor,
      ),
      activeIndex: index,
      count: markedWarehouse.images.length,
    );

Widget buildGridImage(String urlImage) => Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: CustomPageTheme.smallPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(CustomPageTheme.smallPadding),
        child: Image.network(
          urlImage,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );

dynamic getMarkedInfo(
    {required BuildContext context,
   // required LatLng location,
    required String id}) async {
  
  showModalBottomSheet(
    isScrollControlled: true,
    showDragHandle: true,
    enableDrag: true,
    barrierColor: const ui.Color.fromARGB(90, 0, 0, 0),
    context: context,
    builder: (context) => SizedBox(
      width: double.infinity,
      height: 400,
      child: MarkedWarehouseInfo(
        id: id,
      ),
    ),
  );
}

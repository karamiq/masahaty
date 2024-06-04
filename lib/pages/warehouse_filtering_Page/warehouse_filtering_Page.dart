import 'package:flutter/material.dart';
import 'package:masahaty/components/custom_back_botton.dart';
import 'package:masahaty/components/warehouse_card.dart';
import 'package:masahaty/components/warehouse_card_skeleton.dart';
import 'package:masahaty/models/order_model.dart';
import 'package:masahaty/services/dio_features.dart';
import 'package:masahaty/services/dio_storage.dart';

import '../../core/constants/constants.dart';
import '../../models/storage&features_model.dart';

class WarehouseFilteringPage extends StatefulWidget {
  const WarehouseFilteringPage({super.key, required this.filtringType});
  final String filtringType;

  @override
  State<WarehouseFilteringPage> createState() => _WarehouseFilteringPageState();
}

class _WarehouseFilteringPageState extends State<WarehouseFilteringPage> {
  FeaturesService featuresService = FeaturesService();
  StorageService storageService = StorageService();
  List<Storage> filteredList = [];

  Future<void> fetchData() async {
    setState(() {});
    List<Storage> temp = [];
    final featureId = await featuresService.featuresGet(widget.filtringType);
    final data = await storageService.storageGet();
    for (var warehouse in data) {
      for (var feature in warehouse.storageFeatures) {
        if (feature.id == featureId) {
          temp.add(warehouse);
          break;
        }
      }
    }
    setState(() {
      filteredList = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  @override
  Widget build(BuildContext context) {
    Widget content;
    if (filteredList.isEmpty) {
      content =const _WarehouseFilteringPageSkeleton();
    } else {
      content = ListView.separated(
        padding: const EdgeInsets.all(CustomPageTheme.normalPadding),
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: filteredList.length,
        itemBuilder: (context, index) => WarehouseCard(
          governorate: filteredList[index].city!.govName,
          district: filteredList[index].city!.name,
          title: filteredList[index].name,
          discription: filteredList[index].description,
          imagePath: filteredList[index].images[0],
          price: filteredList[index].price,
          id: filteredList[index].id,
          rating: filteredList[index].rating,
        ),
        separatorBuilder: (context, index) => const SizedBox(
          height: CustomPageTheme.normalPadding,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filtringType),
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.all(CustomPageTheme.smallPadding),
          child: CustomBackButton(),
        ),
      ),
      body: Center(child: content),
    );
  }
}
class _WarehouseFilteringPageSkeleton extends StatelessWidget {
  const _WarehouseFilteringPageSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(CustomPageTheme.normalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WarehouseCardSkeleton(),
          WarehouseCardSkeleton(),
          WarehouseCardSkeleton(),
          WarehouseCardSkeleton(),
          WarehouseCardSkeleton(),
        ],
      ),
    );
  }
}
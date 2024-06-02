import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masahaty/components/custom_back_botton.dart';
import 'package:masahaty/core/constants/constants.dart';
import 'package:masahaty/models/warehouse_model.dart';
import '../../components/warehouse_card.dart';

class MorePage extends ConsumerWidget {
  final List<Warehouse> colsestToYou;
  const MorePage(this.colsestToYou, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColorsTheme.scaffoldBackGroundColor,
          leading: const Padding(
            padding: EdgeInsets.all(CustomPageTheme.smallPadding),
            child: customBackButton(),
          ),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.symmetric(
              horizontal: CustomPageTheme.normalPadding),
          itemCount: colsestToYou.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: CustomPageTheme.normalPadding,
          ),
          itemBuilder: (context, index) {
            if (colsestToYou.isEmpty) {
              return const Center(child: Text('em'));
            } else {
              return WarehouseCard(
                  rating: colsestToYou[index].rating,
                  id: colsestToYou[index].id,
                  governorate: colsestToYou[index].city['govName'],
                  district: colsestToYou[index].city['name'],
                  title: colsestToYou[index].name,
                  discription: colsestToYou[index].description,
                  imagePath: colsestToYou[index].images[0],
                  price: colsestToYou[index].price);
            }
          },
        ));
  }
}

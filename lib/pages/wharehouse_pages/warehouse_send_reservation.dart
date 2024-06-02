// ignore_for_file: unnecessary_null_comparison

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:masahaty/components/form_container.dart'; 
import 'package:masahaty/provider/current_user.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../components/custom_back_botton.dart';
import '../../components/viewed_item_title.dart';
import '../../core/constants/constants.dart';
import '../../models/warehouse_model.dart';
import '../../services/dio_order.dart';
import '../../services/dio_storage.dart';
import 'components/order_info.dart';
import 'components/send_reservation_head.dart';

class WarehouseSendReservation extends ConsumerStatefulWidget {
  const WarehouseSendReservation(
      {super.key,
      this.id = '',
      this.type = '',
      this.startDate,
      this.endDate,
      this.count = ''});
  final String id;
  final String type;
  final String count;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  ConsumerState<WarehouseSendReservation> createState() =>
      _WarehouseSendReservationState();
}

class _WarehouseSendReservationState
    extends ConsumerState<WarehouseSendReservation> {
  get currentUserToken => ref.read(currentUserProvider)?.token;
  Warehouse? currentWarehouse;
  final orderService = OrderService();
  Future<void> getDetails() async {
    try {
      StorageService storageService = StorageService();
      Warehouse temp = await storageService.storageGetById(id: widget.id);
      setState(() {
        currentWarehouse = temp;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  bool isLoading = false;
  void sendOrder() async {
    setState(() => isLoading = true);
    await orderService.orderPost(
      token: currentUserToken,
      storageId: currentWarehouse!.id,
      name: widget.type,
      startDate: widget.startDate!.toIso8601String(),
      endDate: widget.endDate!.toIso8601String(),
      count: int.parse(widget.count),
      images: currentWarehouse!.images,
    );
    context.pop();
    context.pop();
    context.pop();
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    double tempTotal;
    dynamic formattedPrice;
    dynamic formattedTotalPrice;
    Widget content;
    if (currentWarehouse == null) {
      content = const Center(child: CircularProgressIndicator());
    } else {
      formattedPrice =
          NumberFormat.decimalPattern().format(currentWarehouse!.price);
      tempTotal = widget.endDate!.difference(widget.startDate!).inDays *
          currentWarehouse!.price;
      formattedTotalPrice = NumberFormat.decimalPattern().format(tempTotal);
      content = Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: CustomPageTheme.normalPadding),
        child: Column(children: [
          const SizedBox(
            height: CustomPageTheme.normalPadding,
          ),
          Row(
            children: [
              const customBackButton(),
              const SizedBox(
                width: CustomPageTheme.smallPadding,
              ),
              Text(
                AppLocalizations.of(context)!.bookWharehouse,
              )
            ],
          ),
          const SizedBox(
            height: CustomPageTheme.bigPadding,
          ),
          SendReservationHead(currentWarehouse: currentWarehouse),
          ViewedItemsTitle(
            padding: const EdgeInsets.symmetric(
                vertical: CustomPageTheme.normalPadding),
            mainText: AppLocalizations.of(context)!.orderDetails,
          ),
          OrderInfo(
            startDate: DateFormat('d.m.yyy').format(widget.startDate!),
            endDate: DateFormat('d.m.yyy').format(widget.endDate!),
            start: widget.count,
            type: widget.type,
          ),
          ViewedItemsTitle(
            padding: const EdgeInsets.symmetric(
                vertical: CustomPageTheme.bigPadding),
            mainText: AppLocalizations.of(context)!.orderDetails,
          ),
          FormContainer(
              contentPadding: const EdgeInsets.symmetric(
                  vertical: CustomPageTheme.smallPadding,
                  horizontal: CustomPageTheme.normalPadding),
              padding: const EdgeInsets.all(0),
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.night,
                      ),
                      Text(
                          '$formattedPrice ${AppLocalizations.of(context)!.iqd}'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.orderRentingDays,
                      ),
                      Text(
                          '${widget.endDate!.difference(widget.startDate!).inDays}'),
                    ],
                  ),
                ),
                const Divider(
                  color: CustomColorsTheme.dividerColor,
                  indent: 0,
                  endIndent: 0,
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ViewedItemsTitle(
                        mainText: AppLocalizations.of(context)!.total,
                        padding: const EdgeInsets.all(0),
                      ),
                      Text(
                        formattedTotalPrice,
                        style: const TextStyle(
                            fontWeight: CustomFontsTheme.bigWeight,
                            color: CustomColorsTheme.headLineColor,
                            fontSize: CustomFontsTheme.bigSize),
                      ),
                    ],
                  ),
                ),
              ]),
          const Spacer(),
          ElevatedButton(
            style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        CoustomBorderTheme.normalBorderRaduis))),
            onPressed: sendOrder,
            child: Text(AppLocalizations.of(context)!.sendReservation),
          ),
          const SizedBox(
            height: CustomPageTheme.bigPadding,
          ),
        ]),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(inAsyncCall: isLoading, child: content),
      ),
    );
  }
}
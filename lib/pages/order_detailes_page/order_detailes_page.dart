import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:masahaty/components/custom_back_botton.dart';
import 'package:masahaty/core/constants/constants.dart';
import 'package:masahaty/pages/wharehouse_pages/components/detailes_page_skeleton.dart';
import 'package:masahaty/pages/wharehouse_pages/components/images_slides.dart';
import 'package:masahaty/provider/change_language.dart';
import 'package:masahaty/provider/current_user.dart';
import 'package:masahaty/services/dio_order.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../components/viewed_item_title.dart';
import '../../models/order_model.dart';
import '../../models/storage&features_model.dart';
import '../wharehouse_pages/components/info_table.dart';
import '../wharehouse_pages/components/order_info.dart';
import '../wharehouse_pages/components/wharehouse_title_and_price.dart';

class OrderDetailesPage extends ConsumerStatefulWidget {
  const OrderDetailesPage({super.key, required this.id});
  final String id;

  @override
  ConsumerState<OrderDetailesPage> createState() => _OrderDetailesPageState();
}

class _OrderDetailesPageState extends ConsumerState<OrderDetailesPage> {
  get currentLanguage => ref.read(currentLanguageProvider);
  get token => ref.read(currentUserProvider)?.token;
  OrderService orderService = OrderService();

  late List<StorageFeature> features = [];
  Order? currentOrder;
  Future<void> getOrder() async {
    currentOrder = await orderService.orderGetById(id: widget.id);
  }

  @override
  void initState() {
    super.initState();
    getOrder();
  }

  void finishOrder() async {
    OrderService orderService = OrderService();
    setState(() {
      isLoading = true;
    });
    await orderService.orderFinish(token: token, id: widget.id);
    setState(() {
      isLoading = false;
    });
    context.pop();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Widget content;
    if (currentOrder != null) {
      dynamic features = currentOrder!.storage.storageFeatures;
      String formattedPrice =
          NumberFormat.decimalPattern().format(currentOrder!.storage.price);
      content = SingleChildScrollView(
        child: Column(
          children: [
            WarehouseCarousel(
                showTop: false,
                images: currentOrder!.images,
                rating: currentOrder!.storage.rating,
                id: currentOrder!.storage.id),
            Container(
              padding: const EdgeInsets.all(CustomPageTheme.normalPadding),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(
                          CoustomBorderTheme.normalBorderRaduis))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WarehouseTitleAndPrice(
                      currentWarehouse: currentOrder!.storage,
                      formattedPrice: formattedPrice),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: CustomColorsTheme.headLineColor,
                          size: CoustomIconTheme.smallize),
                      Text(
                        '${currentOrder!.storage.city?.govName}, ${currentOrder!.storage.address}',
                        style: const TextStyle(
                            color: CustomColorsTheme.descriptionColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: CustomPageTheme.normalPadding,
                  ),
                  ViewedItemsTitle(
                    padding: const EdgeInsets.all(0),
                    mainText: AppLocalizations.of(context)!.description,
                  ),
                  const SizedBox(
                    height: CustomPageTheme.normalPadding,
                  ),
                  Text(
                    currentOrder!.storage.description,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: CustomPageTheme.bigPadding,
                  ),
                  OrderInfo(
                    startDate:
                        DateFormat('d.m.yyy').format(currentOrder!.startDate),
                    endDate:
                        DateFormat('d.m.yyy').format(currentOrder!.endDate),
                    start: currentOrder!.count.toString(),
                    type: currentOrder!.name,
                  ),
                  const SizedBox(
                    height: CustomPageTheme.bigPadding,
                  ),
                  ViewedItemsTitle(
                    padding: const EdgeInsets.all(0),
                    mainText: AppLocalizations.of(context)!.details,
                  ),
                  const SizedBox(
                    height: CustomPageTheme.normalPadding,
                  ),
                  InfoTable(
                      currentLanguage: currentLanguage,
                      currentWarehouse: currentOrder!.storage,
                      features: features),
                  const SizedBox(
                    height: CustomPageTheme.bigPadding,
                  ),
                  ViewedItemsTitle(
                    padding: const EdgeInsets.all(0),
                    mainText: AppLocalizations.of(context)!.location,
                  ),
                  const SizedBox(
                    height: CustomPageTheme.normalPadding,
                  ),
                  SizedBox(
                    height: 200,
                    width: 400,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          CoustomBorderTheme.normalBorderRaduis),
                      child: Image.network(
                          fit: BoxFit.fill,
                          "https://img.freepik.com/free-photo/red-light-round-podium-black-background-mock-up_43614-950.jpg?t=st=1716295750~exp=1716299350~hmac=050643ede7569f05a16820f520ee7b52f3ddc7e104fd09fc5393b7a0dfbe388e&w=826"),
                    ),
                  ),
                  const SizedBox(
                    height: CustomPageTheme.bigPadding,
                  ),
                  const SizedBox(
                    height: CustomPageTheme.bigPadding,
                  ),
                  ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.orange.shade900,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                CoustomBorderTheme.normalBorderRaduis))),
                    onPressed: finishOrder,
                    child: isLoading != true
                        ? Text(AppLocalizations.of(context)!.finishOrder)
                        : const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      content = const DetailsPageSkeleton();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.orderDetails),
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.all(CustomPageTheme.smallPadding),
          child: customBackButton(),
        ),
      ),
      body: content,
    );
  }
}

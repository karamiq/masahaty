import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:masahaty/core/constants/constants.dart';
import 'package:masahaty/models/order_model.dart';
import 'package:masahaty/models/storage&features_model.dart';
import 'package:masahaty/pages/wharehouse_pages/components/info_table.dart';
import 'package:masahaty/pages/wharehouse_pages/wharehouse_reserve_form.dart';
import 'package:masahaty/provider/change_language.dart';
import 'package:masahaty/provider/current_user.dart';
import 'package:masahaty/services/dio_storage.dart';
import '../../components/custom_chips.dart';
import '../../components/viewed_item_title.dart';
import '../../routes/routes.dart';
import 'components/detailes_page_skeleton.dart';
import 'components/images_slides.dart';
import 'components/wharehouse_title_and_price.dart';

class WarehouseDetailesPage extends ConsumerStatefulWidget {
  const WarehouseDetailesPage({super.key, this.id = ''});
  final String id;

  @override
  createState() => _WarehouseDetailesState();
}

class _WarehouseDetailesState extends ConsumerState<WarehouseDetailesPage> {
  get currentUserToken => ref.read(currentUserProvider)?.token;
  Storage? currentWarehouse;
  List<StorageFeature> features = [];
  StorageService storageService = StorageService();
  @override
  void initState() {
    super.initState();
    getDetails();
  }

  Future<void> getDetails() async {
    try {
      Storage temp = await storageService.storageGetById(id: widget.id);
      print(widget.id);
      setState(() {
        currentWarehouse = temp;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  bool isLoading = false;
  void signIn() => context.pushNamed(Routes.logIn);
  void route() => Navigator.of(context).push(MaterialPageRoute(
      builder: (c) => WharehouseReserveForm(id: currentWarehouse!.id)));
  Future<void> delete() async {
    setState(() {
      isLoading = true;
    });

    await storageService.storageDelete(token: currentUserToken, id: widget.id);
    setState(() {
      isLoading = false;
    });
    context.pop();

    setState(() {
      isLoading = false;
    });
    // Handle error, show error message, etc.
  }

  late dynamic formattedPrice;
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    final currentLanguage = ref.read(currentLanguageProvider);
    final currentUser = ref.read(currentUserProvider);
    Widget content;
    Widget currentButton() {
      if (currentUser == null) {
        return OutlinedButton.icon(
            style: ButtonStyle(
                minimumSize:
                    WidgetStateProperty.all(const Size(double.infinity, 50)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        CoustomBorderTheme.normalBorderRaduis), // Ad
                  ),
                ),
                side: WidgetStateProperty.all(const BorderSide(
                    width: 1.5, color: CustomColorsTheme.headLineColor))),
            onPressed: signIn,
            label: Text(AppLocalizations.of(context)!.signIn),
            icon: const Icon(
              Icons.account_box_outlined,
            ));
      } else if (currentUser.id == currentWarehouse?.owner.id) {
        return OutlinedButton.icon(
          style: ButtonStyle(
              minimumSize:
                  WidgetStateProperty.all(const Size(double.infinity, 50)),
              foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
              backgroundColor: WidgetStateProperty.all<Color>(
                  CustomColorsTheme.unAvailableRadioColor),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      CoustomBorderTheme.normalBorderRaduis),
                ),
              ),
              side: WidgetStateProperty.all(const BorderSide(
                  width: 1.5, color: CustomColorsTheme.unAvailableRadioColor))),
          onPressed: delete,
          label: Text(AppLocalizations.of(context)!.delete),
          icon: const Icon(Icons.delete_forever_outlined),
        );
      } else {
        return ElevatedButton.icon(
            style: ButtonStyle(
                minimumSize:
                    WidgetStateProperty.all(const Size(double.infinity, 50)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        CoustomBorderTheme.normalBorderRaduis), // Ad
                  ),
                ),
                side: WidgetStateProperty.all(const BorderSide(
                    width: 1.5, color: CustomColorsTheme.headLineColor))),
            onPressed: route,
            label: Text(AppLocalizations.of(context)!.bookWharehouse),
            icon: const Icon(
              Icons.edit_calendar_outlined,
            ));
      }
    }

    if (currentWarehouse == null) {
      content = const DetailsPageSkeleton();
    } else {
      features = currentWarehouse!.storageFeatures;
      formattedPrice =
          NumberFormat.decimalPattern().format(currentWarehouse!.price);
      content = SingleChildScrollView(
        child: Column(
          children: [
            WarehouseCarousel(
              id: currentWarehouse!.id,
              images: currentWarehouse!.images,
              rating: currentWarehouse!.rating,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: CustomPageTheme.normalPadding),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(
                          CoustomBorderTheme.normalBorderRaduis))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: CustomPageTheme.normalPadding,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 3),
                    width: 150,
                    height: 4,
                    decoration: const BoxDecoration(
                        color: CustomColorsTheme.handColor,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                                CoustomBorderTheme.normalBorderRaduis))),
                  ),
                  const SizedBox(
                    height: CustomPageTheme.normalPadding,
                  ),
                  WarehouseTitleAndPrice(
                      currentWarehouse: currentWarehouse!,
                      formattedPrice: formattedPrice),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: CustomColorsTheme.headLineColor,
                          size: CoustomIconTheme.smallize),
                      Text(
                        '${currentWarehouse!.city!.govName}, ${currentWarehouse!.address}',
                        style: const TextStyle(
                            color: CustomColorsTheme.descriptionColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: CustomPageTheme.bigPadding,
                  ),
                  ViewedItemsTitle(
                    padding: const EdgeInsets.all(0),
                    mainText: AppLocalizations.of(context)!.description,
                  ),
                  const SizedBox(
                    height: CustomPageTheme.normalPadding,
                  ),
                  Text(
                    currentWarehouse!.description,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: CustomPageTheme.bigPadding,
                  ),
                  ViewedItemsTitle(
                    padding: const EdgeInsets.all(0),
                    mainText: AppLocalizations.of(context)!.features,
                  ),
                  const SizedBox(
                    height: CustomPageTheme.normalPadding,
                  ),
                  CustomChips(
                      featuresChipsPics:
                          CustomChipsData(context).featuresChipsPics,
                      featuresChipText:
                          CustomChipsData(context).featuresChipText),
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
                      currentWarehouse: currentWarehouse!,
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
                  currentButton(),
                  const SizedBox(
                    height: CustomPageTheme.bigPadding,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: content,
      ),
    );
  }
}
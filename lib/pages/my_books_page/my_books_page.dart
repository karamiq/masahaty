import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:masahaty/models/order_model.dart';
import 'package:masahaty/pages/order_detailes_page/order_detailes_page.dart';
import 'package:masahaty/provider/current_user.dart';
import 'package:masahaty/services/api/dio_order.dart';
import '../../components/custom_back_botton.dart';
import '../../core/constants/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class MyBooksPage extends ConsumerStatefulWidget {
  const MyBooksPage({super.key});

  @override
  ConsumerState<MyBooksPage> createState() => _MyBooksPageState();
}

class _MyBooksPageState extends ConsumerState<MyBooksPage> {
  get currentUserId => ref.read(currentUserProvider)?.id;
  List<Order> currentBooks = [];
  bool isLoading = false;
  OrderService orderService = OrderService();
  void getOrders() async {
     setState(()=> isLoading = true);
    final orders = await orderService.orderGet();
    for (Order order in orders) {
      if (order.renter.id == currentUserId) {
        currentBooks.add(order);
      }
    }
    setState(()=> isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (currentBooks.isEmpty) {
      content = Center(
        child: Text(
            "${AppLocalizations.of(context)!.myBooking} ${AppLocalizations.of(context)!.empty}"),
      );
    } else {
      content = ListView.separated(
        padding: const EdgeInsets.symmetric(
            horizontal: CustomPageTheme.normalPadding),
        itemCount: currentBooks.length,
        separatorBuilder: (context, index) => const SizedBox(
          height: CustomPageTheme.normalPadding,
        ),
        itemBuilder: (context, index) {
          final formattedPrice = NumberFormat.decimalPattern()
              .format(currentBooks[index].storage.price);
          if (currentBooks.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.myBooking));
          } else {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                      CoustomBorderTheme.normalBorderRaduis)),
              child: ListTile(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (c) =>
                        OrderDetailesPage(id: currentBooks[index].id))),
                title: Text(currentBooks[index].storage.name),
                subtitle: Text(
                    "${AppLocalizations.of(context)!.owner}: ${currentBooks[index].owner.fullName}"),
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(currentBooks[index].storage.images[0]),
                  radius: CoustomIconTheme.normalSize,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$formattedPrice ${AppLocalizations.of(context)!.iqd}',
                      style: const TextStyle(
                        color: CustomColorsTheme.headLineColor,
                        fontWeight: CustomFontsTheme.bigWeight,
                      ),
                    ),
                    Text(
                      '/${AppLocalizations.of(context)!.night}',
                      style: const TextStyle(
                        color: CustomColorsTheme.descriptionColor,
                        fontWeight: CustomFontsTheme.bigWeight,
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      );
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColorsTheme.scaffoldBackGroundColor,
          leading: const Padding(
            padding: EdgeInsets.all(CustomPageTheme.smallPadding),
            child: CustomBackButton(),
          ),
          title: Text(AppLocalizations.of(context)!.myBooking),
          centerTitle: true,
        ),
        body: content);
  }
}

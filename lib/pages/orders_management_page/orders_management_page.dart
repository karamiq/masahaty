import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:intl/intl.dart';
import 'package:masahaty/models/order_model.dart';
import 'package:masahaty/services/api/dio_order.dart';
import '../../components/custom_back_botton.dart';
import '../../core/constants/constants.dart';
import '../../provider/current_user.dart';

class OrdersManagementPage extends ConsumerStatefulWidget {
  const OrdersManagementPage({super.key});

  @override
  ConsumerState<OrdersManagementPage> createState() =>
      _OrdersManagementPageState();
}

class _OrdersManagementPageState extends ConsumerState<OrdersManagementPage> {
  get currentUser => ref.read(currentUserProvider);
  List<Order> currentOrders = [];

  OrderService orderService = OrderService();

  void getOrders() async {
    dynamic orders = await orderService.orderGet();
    for (Order order in orders) {
      if (order.owner.id == currentUser.id) {
        currentOrders.add(order);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (currentOrders.isEmpty) {
      content = Center(
        child: Text(
            "${AppLocalizations.of(context)!.orderManagement} ${AppLocalizations.of(context)!.empty}"),
      );
    } else {
      content = ListView.separated(
        padding: const EdgeInsets.symmetric(
            horizontal: CustomPageTheme.normalPadding),
        itemCount: currentOrders.length,
        separatorBuilder: (context, index) => const SizedBox(
          height: CustomPageTheme.normalPadding,
        ),
        itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: CoustomBorderTheme.borderWidth,
                        color: CustomColorsTheme.dividerColor),
                    borderRadius: BorderRadius.circular(
                        CoustomBorderTheme.normalBorderRaduis),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: CoustomIconTheme.normalSize,
                      backgroundImage:
                          NetworkImage(currentOrders[index].images[0]),
                    ),
                    title: Text(currentOrders[index].storage.name),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(currentOrders[index].renter.fullName),
                        Text(
                          DateFormat('d.M.yyyy')
                              .format(currentOrders[index].creationDate)
                              .toString(),
                        ),
                        Text(
                          DateFormat('d.M.yyyy')
                              .format(currentOrders[index].endDate)
                              .toString(),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding:
                          const EdgeInsets.all(CustomPageTheme.smallPadding),
                      child: ElevatedButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      CoustomBorderTheme.normalBorderRaduis)),
                              backgroundColor:
                                  CustomColorsTheme.availableRadioColor),
                          onPressed: () async {
                            await orderService.orderAccept(
                                token: currentUser.token,
                                id: currentOrders[index].id);
                                print(currentOrders[index].id);
                          },
                          child: Text(AppLocalizations.of(context)!.accept)),
                    )),
                    Expanded(
                        child: Padding(
                      padding:
                          const EdgeInsets.all(CustomPageTheme.smallPadding),
                      child: ElevatedButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      CoustomBorderTheme.normalBorderRaduis)),
                              backgroundColor:
                                  CustomColorsTheme.unAvailableRadioColor),
                          onPressed: () async {
                            await orderService.orderReject(
                                token: currentUser.token,
                                id: currentOrders[index].id);
                            print(currentOrders[index].id);
                          },
                          child: Text(AppLocalizations.of(context)!.reject)),
                    )),
                  ],
                )
              ],
            );
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
          title: Text(AppLocalizations.of(context)!.orderManagement),
          centerTitle: true,
        ),
        body: content);
  }
}

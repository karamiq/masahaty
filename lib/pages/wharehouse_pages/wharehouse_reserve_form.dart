import 'package:flutter/material.dart';
import 'package:masahaty/components/custom_back_botton.dart';
import 'package:masahaty/components/info_text_form_field.dart';
import 'package:masahaty/components/subtitle.dart';
import 'package:masahaty/components/viewed_item_title.dart';
import 'package:masahaty/core/constants/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:table_calendar/table_calendar.dart';
import 'components/custom_expantion_tile.dart';
import 'warehouse_send_reservation.dart';

class WharehouseReserveForm extends StatefulWidget {
  const WharehouseReserveForm({super.key, this.id = ''});
  final String id;
  @override
  State<WharehouseReserveForm> createState() => _WharehouseReserveFormState();
}

class _WharehouseReserveFormState extends State<WharehouseReserveForm> {
  String? storagingType;
  DateTime? _rangeStart = DateTime.now();
  DateTime? _rangeEnd = DateTime.now();
  final countController = TextEditingController();
  final countFormKey = GlobalKey<FormState>();
  bool totalDaysValid = true;
  List<String> get storagingTypeOptions => [
        AppLocalizations.of(context)!.storagingTypeGoods,
        AppLocalizations.of(context)!.storagingTypeFurniture,
        AppLocalizations.of(context)!.storagingTypeElectronics,
      ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    storagingType = AppLocalizations.of(context)!.storagingTypeFurniture;
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _rangeStart = start;
      _rangeEnd = end;
    });
  }

  String? checkValidation(String? query) {
    if (query == '' || query == null) {
      return AppLocalizations.of(context)!.phoneNumberErrorEmpty;
    } else {
      return null;
    }
  }

  bool validateForm() {
    bool isValid = true;
    final tempTotal = _rangeEnd!.difference(_rangeStart!).inDays;
    if (tempTotal <= 2) {
      isValid = false;
      setState(() {
        totalDaysValid = false;
      });
    }
    if (!countFormKey.currentState!.validate()) isValid = false;
    if (storagingType == null) isValid = false;
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    void route() {
      if (validateForm()) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (c) => WarehouseSendReservation(
                  id: widget.id,
                  type: storagingType!,
                  startDate: _rangeStart,
                  endDate: _rangeEnd,
                  count: countController.text,
                )));
      }
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: CustomPageTheme.normalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: CustomPageTheme.normalPadding),
              Row(
                children: [
                  const customBackButton(),
                  const SizedBox(width: CustomPageTheme.smallPadding),
                  Text(AppLocalizations.of(context)!.bookWharehouse),
                ],
              ),
              const SizedBox(height: CustomPageTheme.bigPadding),
              ViewedItemsTitle(
                mainText: AppLocalizations.of(context)!.chooseTimeOfReserve,
                padding: const EdgeInsets.all(0),
              ),
              TableCalendar(
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                      color: Color.fromARGB(255, 80, 145, 180),
                      shape: BoxShape.circle),
                  rangeEndDecoration: BoxDecoration(
                      color: CustomColorsTheme.headLineColor,
                      shape: BoxShape.circle),
                  rangeStartDecoration: BoxDecoration(
                      color: CustomColorsTheme.headLineColor,
                      shape: BoxShape.circle),
                  rangeHighlightColor: CustomColorsTheme.rangeHighlightColor,
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle:
                        TextStyle(color: CustomColorsTheme.calenderTextColor),
                    weekendStyle:
                        TextStyle(color: CustomColorsTheme.calenderTextColor)),
                headerStyle: const HeaderStyle(
                    titleCentered: true, formatButtonVisible: false),
                availableGestures: AvailableGestures.all,
                pageJumpingEnabled: true,
                rangeSelectionMode: RangeSelectionMode.toggledOn,
                focusedDay: DateTime.now(),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                onRangeSelected: _onRangeSelected,
                firstDay: DateTime.now(),
                lastDay: DateTime(2070, 1, 1),
              ),
              if (totalDaysValid != true)
                Text(
                  AppLocalizations.of(context)!.rentDaysMinimum,
                  style:
                      const TextStyle(color: CustomColorsTheme.unAvailableRadioColor),
                ),
              const SizedBox(height: CustomPageTheme.normalPadding),
              ViewedItemsTitle(
                mainText: AppLocalizations.of(context)!.orderDetails,
                padding: const EdgeInsets.all(0),
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.storagingType),
              CustomExpansionTile(
                initialTitle: storagingType ?? '',
                options: storagingTypeOptions,
                onOptionSelected: (s) {
                  setState(() {
                    storagingType = s;
                  });
                },
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.storagingCount),
              InfoTextField(
                keyboardType: TextInputType.number,
                controller: countController,
                formKey: countFormKey,
                validator: checkValidation,
              ),
              const SizedBox(height: CustomPageTheme.smallPadding),
              ElevatedButton(
                style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            CoustomBorderTheme.normalBorderRaduis))),
                onPressed: route,
                child: Text(AppLocalizations.of(context)!.bookWharehouse),
              ),
              const SizedBox(height: CustomPageTheme.bigPadding),
            ],
          ),
        ),
      ),
    );
  }
}

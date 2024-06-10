
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.5,
            ),
            Center(
              child: Text(
                  "${AppLocalizations.of(context)!.notifications} ${AppLocalizations.of(context)!.empty}"),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../../core/constants/constants.dart';
import 'bottom_app_bar_slide.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar(
      {super.key,
      required this.selectedPageIndex,
      required this.selectedPage,
      required this.size});
  final int selectedPageIndex;
  final void Function(int)? selectedPage;
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        BottomAppBar(
          clipBehavior: Clip.antiAlias,
          notchMargin: 5,
          shape: const CircularNotchedRectangle(),
          surfaceTintColor: Colors.transparent,
          padding: const EdgeInsets.all(0),
          child: BottomNavigationBar(
            showSelectedLabels: true,
            selectedFontSize: CoustomIconTheme.smallize,
            unselectedFontSize: CoustomIconTheme.smallize,
            backgroundColor: Colors.white,
            selectedItemColor: CustomColorsTheme.headLineColor,
            currentIndex: selectedPageIndex,
            type: BottomNavigationBarType.fixed,
            onTap: selectedPage,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                label: AppLocalizations.of(context)!.home,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.map_outlined),
                label: AppLocalizations.of(context)!.map,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.notifications_outlined),
                label: AppLocalizations.of(context)!.notifications,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings_outlined),
                label: AppLocalizations.of(context)!.settings,
              ),
            ],
          ),
        ),
        BottomAppBarSlide(selectedPageIndex: selectedPageIndex, size: size),
      ],
    );
  }
}

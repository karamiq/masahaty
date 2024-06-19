import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:masahaty/core/constants/constants.dart';
import 'package:masahaty/pages/google_maps_page/google_maps_page.dart';
import 'package:masahaty/pages/home_page/home_page.dart';
import 'package:masahaty/pages/notifications_page/notifications_page.dart';
import 'package:masahaty/pages/profile_page/profile_page.dart';
import 'package:masahaty/routes/routes.dart';

import 'components/custom_botton_app_bar.dart';

class TabsPage extends StatefulWidget {
   TabsPage({super.key, this.pageIndex = 0});
   int pageIndex;
  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  void _selectedPage(int index) {
    setState(() {
     // selectedPageIndex = index;
      widget.pageIndex = index;
    });
  }

 // int selectedPageIndex = 0;
  double slideSize = 0;
  List<Widget> _pages = [];
  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const GoogleMapsPage(),
      const NotificationsPage(),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      backgroundColor: CustomColorsTheme.scaffoldBackGroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        elevation: 0,
        onPressed: () => context.pushNamed(Routes.addPostPage),
        mini: true,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: const Color(0xFFC9DEE5),
              borderRadius: BorderRadius.circular(50)),
          child: const Icon(
            Icons.add_circle_outline_rounded,
            color: CustomColorsTheme.headLineColor,
            size: 40,
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomAppBar(
        selectedPage: _selectedPage,
        selectedPageIndex: widget.pageIndex,
        size: size,
      ),
      body: _pages[widget.pageIndex],
    );
  }
}

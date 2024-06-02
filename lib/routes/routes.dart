import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:masahaty/pages/add_warehouse/add_warehouse.dart';
import 'package:masahaty/pages/closest_to_you/closest_to_you.dart';
import 'package:masahaty/pages/getting_started/getting_started_page.dart';
import 'package:masahaty/pages/google_maps_page/google_maps_page.dart';
import 'package:masahaty/pages/my_books_page/my_books_page.dart';
import 'package:masahaty/pages/my_favorites_page/my_favorites_page.dart';
import 'package:masahaty/pages/my_posts_page/my_post_page.dart';
import 'package:masahaty/pages/notifications_page/notifications_page.dart';
import 'package:masahaty/pages/profile_page/profile_page.dart';
import 'package:masahaty/pages/register_page/register_page.dart';
import 'package:masahaty/pages/splash_page.dart/splash_page.dart';
import '../pages/home_page/home_page.dart';
import '../pages/login_page/login_page.dart';
import '../pages/tabs_page/tabs_page.dart';
import '../pages/wharehouse_pages/warehouse_details_page.dart';
import '../pages/wharehouse_pages/warehouse_send_reservation.dart';
import '../pages/wharehouse_pages/wharehouse_reserve_form.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const SplashPage(),
      ),
      GoRoute(
        path: Routes.gettingStated,
        name: Routes.gettingStated,
        builder: (BuildContext context, GoRouterState state) =>
            const GettingStarted(),
      ),
      GoRoute(
        path: Routes.homePage,
        name: Routes.homePage,
        builder: (BuildContext context, GoRouterState state) =>
            const HomePage(),
      ),
      GoRoute(
        path: Routes.googleMapsPage,
        name: Routes.googleMapsPage,
        builder: (BuildContext context, GoRouterState state) =>
            GoogleMapsPage(),
      ),
      GoRoute(
        path: Routes.notificationsPage,
        name: Routes.notificationsPage,
        builder: (BuildContext context, GoRouterState state) =>
            const NotificationsPage(),
      ),
      GoRoute(
        path: Routes.profilePage,
        name: Routes.profilePage,
        builder: (BuildContext context, GoRouterState state) =>
            const ProfilePage(),
      ),
      GoRoute(
        path: Routes.tabsPage,
        name: Routes.tabsPage,
        builder: (BuildContext context, GoRouterState state) =>
            const TabsPage(),
      ),
      GoRoute(
        path: Routes.addPostPage,
        name: Routes.addPostPage,
        builder: (BuildContext context, GoRouterState state) =>
            const AddWarehousePost(),
      ),
      GoRoute(
        path: Routes.registerPage,
        name: Routes.registerPage,
        builder: (BuildContext context, GoRouterState state) =>
            const RegisterPage(),
      ),
      GoRoute(
        path: Routes.logIn,
        name: Routes.logIn,
        builder: (BuildContext context, GoRouterState state) =>
            const LogInPage(),
      ),
      GoRoute(
        path: Routes.warehouseInfoPage,
        name: Routes.warehouseInfoPage,
        builder: (BuildContext context, GoRouterState state) =>
            const WarehouseDetailesPage(),
      ),
      GoRoute(
        path: Routes.wharehouseReserveFormPage,
        name: Routes.wharehouseReserveFormPage,
        builder: (BuildContext context, GoRouterState state) =>
            const WharehouseReserveForm(),
      ),
      GoRoute(
        path: Routes.myFavoritesPage,
        name: Routes.myFavoritesPage,
        builder: (BuildContext context, GoRouterState state) =>
            const MyFavoritesPage(),
      ),
      GoRoute(
        path: Routes.myBooksPage,
        name: Routes.myBooksPage,
        builder: (BuildContext context, GoRouterState state) =>
            const MyBooksPage(),
      ),
      GoRoute(
        path: Routes.myPostsPage,
        name: Routes.myPostsPage,
        builder: (BuildContext context, GoRouterState state) =>
            const MyPostPage(),
      ),
      GoRoute(
        path: Routes.wharehouseSendReservation,
        name: Routes.wharehouseSendReservation,
        builder: (BuildContext context, GoRouterState state) =>
            const WarehouseSendReservation(),
      ),
      GoRoute(
        path: Routes.morePage,
        name: Routes.morePage,
        builder: (BuildContext context, GoRouterState state) =>
            const MorePage([]),
      ),
    ],
  );
}

class Routes {
  static const morePage = '/more_page';
  static const myBooksPage = '/my_books_page';
  static const myPostsPage = '/my_posts_page';
  static const myFavoritesPage = '/favorites_page';
  static const wharehouseSendReservation = '/send_reservation_page';
  static const wharehouseReserveFormPage = '/reserv_from_Page';
  static const warehouseInfoPage = '/info_page';
  static const registerPage = '/register';
  static const logIn = '/Log_in';
  static const addPostPage = '/add_post';
  static const gettingStated = '/getting_started';
  static const homePage = '/home_page';
  static const googleMapsPage = '/google_maps_page';
  static const notificationsPage = '/notifications_page';
  static const profilePage = '/profile_page';
  static const tabsPage = '/tabs_page';
}
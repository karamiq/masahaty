import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masahaty/provider/all_warehouses.dart';
import 'package:masahaty/provider/current_user.dart';
import 'package:masahaty/provider/location.dart';
import '../../components/custom_search_text_field.dart';
import '../../core/constants/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../models/storage&features_model.dart';
import '../../services/dio_storage.dart';
import 'components/home_app_bar.dart';
import 'components/home_page_content.dart';
import 'components/home_page_skeleton.dart';
import 'components/search_results.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  get currentUser => ref.watch(currentUserProvider);
  get userLongitude => ref.watch(locationProvider)?.longitude;
  get userLatitdue => ref.watch(locationProvider)?.latitude;
  List<Storage>? storagesRecentlyAdded = [];
  List<Storage>? storagesClosestToYou = [];
  List<Storage>? filteredStorages = [];
  final TextEditingController textFiledController = TextEditingController();
  String searchQuery = '';

  Future<void> recentlyAdded() async {
    try {
      StorageService storageService = StorageService();
      List<Storage> temp = await storageService.storageGet();
      temp.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      setState(() {
        storagesRecentlyAdded = temp;
      });
      ref
          .read(allWarehousesPorvider.notifier)
          .getAllWarehouses(storagesRecentlyAdded);
    } catch (e) {
      print(e);
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371; // Earth radius in kilometers

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  Future<void> closestToYou() async {
    try {
      StorageService storageService = StorageService();
      List<Storage> temp = await storageService.storageGet();

      if (temp.isEmpty) {
        print("No warehouses found.");
        return;
      }
      //the location is set by defult to baghdad if the user didnt agree to
      //give the premission of his location Your location (Baghdad)
      double myLatitude = userLongitude ?? 33.3152;
      double myLongitude = userLatitdue ?? 44.3661;

      temp.sort((a, b) {
        double distanceA =
            calculateDistance(myLatitude, myLongitude, a.latitude, a.longitude);
        double distanceB =
            calculateDistance(myLatitude, myLongitude, b.latitude, b.longitude);
        return distanceA.compareTo(distanceB);
      });
      setState(() {
        storagesClosestToYou = temp;
      });
    } catch (e) {}
  }

  dynamic placemark;
  Future<void> feachData() async {
    recentlyAdded();
    closestToYou();
  }

  @override
  void initState() {
    super.initState();
    feachData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.watch(locationProvider.notifier).getCurrentLocation();
  }

  void filterWarehouses(String query) {
    setState(() {
      searchQuery = query;
      filteredStorages = storagesRecentlyAdded!
          .where((warehouse) =>
              warehouse.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _refresh() async {
    feachData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userCurrentAddress = ref.watch(locationProvider)?.placemarks;
    String? district = userCurrentAddress?.subLocality ??
        AppLocalizations.of(context)!.alMansour;
    String? governorate =
        userCurrentAddress?.locality ?? AppLocalizations.of(context)!.baghdad;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              HomePageBar(
                onTap: () =>
                    ref.watch(locationProvider.notifier).getCurrentLocation(),
                userName: currentUser?.fullName ??
                    AppLocalizations.of(context)!.visitor,
                id: currentUser?.shortId ?? AppLocalizations.of(context)!.id,
                district: district,
                governorate: governorate,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: CustomPageTheme.veryBigpadding),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        CoustomBorderTheme.normalBorderRaduis),
                  ),
                  child: CoustomSearchTextField(
                    controller: textFiledController,
                    prefixIcon: Icons.search_rounded,
                    labelText: AppLocalizations.of(context)!.search,
                    onChange: filterWarehouses,
                  ),
                ),
              ),
              const SizedBox(
                height: CustomPageTheme.bigPadding,
              ),
              if (searchQuery.isEmpty)
                storagesRecentlyAdded!.isNotEmpty || storagesClosestToYou!.isNotEmpty
                    ? HomePageContent(
                        storagesClosestToYou: storagesClosestToYou,
                        storagesRecentlyAdded: storagesRecentlyAdded,
                      )
                    : const HomPageSkeleton()
              else
                SearchResults(storages: filteredStorages),
              SizedBox(
                height: MediaQuery.of(context).size.height / 9,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

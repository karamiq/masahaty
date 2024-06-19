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
import '../../services/api/dio_storage.dart';
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
    StorageService storageService = StorageService();
    List<Storage> temp = await storageService.storageGet();
    temp.sort((a, b) => b.creationDate.compareTo(a.creationDate));
    if (mounted) {
      setState(() {
        storagesRecentlyAdded = temp;
      });
    }
    if(mounted) {
    ref
        .read(allWarehousesPorvider.notifier)
        .getAllWarehouses(storagesRecentlyAdded);
    }
  }


  Future<void> closestToYou() async {
    try {
      StorageService storageService = StorageService();
      List<Storage> temp = await storageService.storageGet();

      if (temp.isEmpty) {
        print("No warehouses found.");
        return;
      }
      //the location is set by default to Baghdad if the user didn't agree to
      //give the permission of his location Your location (Baghdad)
      double myLatitude = userLongitude ?? defaultLocation.latitude;
      double myLongitude = userLatitdue ?? defaultLocation.longitude;

      temp.sort((a, b) {
        double distanceA =
            calculateDistance(myLatitude, myLongitude, a.latitude, a.longitude);
        double distanceB =
            calculateDistance(myLatitude, myLongitude, b.latitude, b.longitude);
        return distanceA.compareTo(distanceB);
      });
      if (mounted) {
        setState(() {
          storagesClosestToYou = temp;
        });
      }
    } catch (e) {}
  }

  dynamic placemark;
  Future<void> feachData() async {
    await recentlyAdded();
    await closestToYou();
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
    if (mounted) {
      setState(() {
        searchQuery = query;
        filteredStorages = storagesRecentlyAdded!
            .where((warehouse) =>
                warehouse.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  Future<void> _refresh() async {
    await feachData();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    textFiledController.dispose();
    super.dispose();
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
                onTap: () async {
                  await ref.watch(locationProvider.notifier).getCurrentLocation();
                  if (mounted) {
                    setState(() {});
                  }
                },
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
                storagesRecentlyAdded!.isNotEmpty ||
                        storagesClosestToYou!.isNotEmpty
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
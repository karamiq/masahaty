import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:masahaty/components/shimmer_container.dart';
import 'package:masahaty/models/storage&features_model.dart';
import 'package:masahaty/provider/current_user.dart';
import 'package:masahaty/provider/location.dart';
import 'package:masahaty/services/api/dio_bookmark.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/constants.dart';
import '../../services/api/dio_storage.dart';
import 'components/custom_marker.dart';
import 'components/marked_warehouse_info.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class GoogleMapsPage extends ConsumerStatefulWidget {
  const GoogleMapsPage({super.key});

  @override
  ConsumerState<GoogleMapsPage> createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends ConsumerState<GoogleMapsPage> {
  get currentLocation => ref.watch(locationProvider);
  final searchController = TextEditingController();
  List<Marker> filteredMarkers = [];
  get currentUserToken => ref.read(currentUserProvider)?.token;
  final bookmarkService = BookmarkService();
  late GoogleMapController mapController;
  Map<String, Marker> markers = {};

  List<Storage> allWarehouses = [];

  Future<void> fetchData() async {
    try {
      StorageService storageService = StorageService();
      List<Storage> temp = await storageService.storageGet();
      setState(() {
        allWarehouses = temp;
      });
    } catch (e) {
      print(e);
    }
  }

  void _filterMarkers(String searchText) {
    setState(() {
      filteredMarkers = markers.values
          .where((marker) => marker.infoWindow.title!
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  String themeForMap = '';
  @override
  void initState() {
    super.initState();
    fetchData();
    DefaultAssetBundle.of(context)
        .loadString(Assets.assetsThemesDarkMapStyle)
        .then((value) {
      themeForMap = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    LatLng pos;
    if (currentLocation == null) {
      pos = defaultLocation;
    } else {
      pos = LatLng(currentLocation?.latitude, currentLocation?.longitude);
    }
    Widget content;
    if (allWarehouses.isEmpty) {
      content = const Center(
        child: ShimmerContainer(
          width: double.infinity,
          height: double.infinity,
        ),
      );
    } else {
      content = Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
              mapController.setMapStyle(themeForMap);
              for (var warehouse in allWarehouses) {
                addMarker(
                    warehouse.id,
                    LatLng(warehouse.latitude, warehouse.longitude),
                    warehouse.name,
                    warehouse.price,
                    context);
              }
            },
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            onTap: (pos) {
              setState(() {});
            },
            liteModeEnabled: false,
            initialCameraPosition:
                CameraPosition(target: pos, zoom: 10),
            markers: markers.values.toSet(),
          ),
          Positioned(
            top: CustomPageTheme.bigPadding * 2,
            left: CustomPageTheme.normalPadding,
            right: CustomPageTheme.normalPadding,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                    CoustomBorderTheme.normalBorderRaduis),
              ),
              child: Autocomplete<Storage>(
                optionsViewOpenDirection: OptionsViewOpenDirection.down,
                optionsBuilder: (textEditingValue) {
                  return allWarehouses
                      .where((storage) => storage.name
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()))
                      .toList();
                },
                displayStringForOption: (storage) => storage.name,
                onSelected: (option) {
                  final selectedMarker = markers[option.id];
                  if (selectedMarker != null) {
                    mapController
                        .animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(option.latitude, option.longitude),
                          zoom: 13,
                        ),
                      ),
                    )
                        .then((_) {
                      setState(() {
                        selectedMarker.onTap!();
                      });
                    });
                  }
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            CoustomBorderTheme.normalBorderRaduis),
                        border: Border.all(
                          width: CoustomBorderTheme.borderWidth,
                          color: CustomColorsTheme.handColor,
                        ),
                      ),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final storage = options.elementAt(index);
                          return ListTile(
                            title: Text(storage.name),
                            onTap: () {
                              onSelected(storage);
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.search,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: CustomColorsTheme.headLineColor,
                      ),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(CustomPageTheme.normalPadding))),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) onFieldSubmitted();
                    },
                  );
                },
              ),
            ),
          ),
        ],
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: content,
    );
  }

  Future<void> addMarker(String id, LatLng location, String name, double price,
      BuildContext context) async {
    String formatedPrice = NumberFormat.decimalPattern().format(price);
    final marker = Marker(
      onTap: () => getMarkedInfo(context: context, id: id),
      markerId: MarkerId(id),
      position: location,
      icon: await CustomMarker(
        price: formatedPrice,
        currency: AppLocalizations.of(context)!.iqd,
      ).toBitmapDescriptor(logicalSize: const Size(450, 450)),
    );

    setState(() {
      markers[id] = marker;
    });
  }
}

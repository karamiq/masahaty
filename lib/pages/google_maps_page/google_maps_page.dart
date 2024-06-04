import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:masahaty/components/custom_search_text_field.dart';
import 'package:masahaty/components/shimmer_container.dart';
import 'package:masahaty/models/storage&features_model.dart';
import 'package:masahaty/provider/current_user.dart';
import 'package:masahaty/services/dio_bookmark.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/constants.dart';
import '../../services/dio_storage.dart';
import 'components/marked_warehouse_info.dart';

class GoogleMapsPage extends ConsumerStatefulWidget {
  const GoogleMapsPage({super.key});

  @override
  ConsumerState<GoogleMapsPage> createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends ConsumerState<GoogleMapsPage> {
  final searchController = TextEditingController();
  List<Marker> filteredMarkers = [];
  get currentUserToken => ref.read(currentUserProvider)?.token;
  final bookmarkService = BookmarkService();
  late GoogleMapController mapController;
  Map<String, Marker> markers = {};

  List<Storage> allWarehouses = [];

  Future<void> recentlyAdded() async {
    try {
      StorageService storageService = StorageService();
      List<Storage> temp = await storageService.storageGet();
      temp.sort((a, b) => b.creationDate.compareTo(a.creationDate));
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
    recentlyAdded();
    DefaultAssetBundle.of(context)
        .loadString(Assets.assetsThemesDarkMapStyle)
        .then((value) {
      themeForMap = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    const myPos = LatLng(33.312805, 44.361488);
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
                final formattedPrice =
                    NumberFormat.decimalPattern().format(warehouse.price);
                addMarker(
                    warehouse.id,
                    LatLng(warehouse.latitude, warehouse.longitude),
                    warehouse.name,
                    formattedPrice,
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
                const CameraPosition(target: myPos, zoom: 13),
            markers: markers.values.toSet(),
          ),
          Positioned(
            top: 50.0,
            left: 15.0,
            right: 15.0,
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
            zoom: 15,
          ),
        ),
      )
          .then((_) {
        setState(() {
          markers[option.id] = selectedMarker.copyWith(
            infoWindowParam:
            selectedMarker.infoWindow.copyWith(),
          );
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
          borderRadius: BorderRadius.circular(CoustomBorderTheme.normalBorderRaduis),
          border: Border.all(width: CoustomBorderTheme.borderWidth, color: CustomColorsTheme.handColor)
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
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
  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onSubmitted: (d){},
      decoration:  InputDecoration(
        hintText: AppLocalizations.of(context)!.search,
        prefixIcon: const Icon(Icons.search, color: CustomColorsTheme.headLineColor,),
        border: const OutlineInputBorder(),
      ),
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

  Future<void> addMarker(String id, LatLng location, String name, String price,
      BuildContext context) async {
    //final customMarkerWidget = CustomMarker(
    //  title: name,
    //  color: Colors.blue,
    //);
    //final bitmapDescriptor =
    //    await _bitmapFromWidget(customMarkerWidget, context);
    final marker = Marker(
      onTap: () => getMarkedInfo(context: context, id: id),
      markerId: MarkerId(id),
      position: location,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: name,
        snippet:
            "$price ${AppLocalizations.of(context)!.iqd}/${AppLocalizations.of(context)!.night} ", // Optional snippet
      ),
    );

    setState(() {
      markers[id] = marker;
    });
  }

  //Future<BitmapDescriptor> _bitmapFromWidget(
  //    Widget child, BuildContext context) async {
  //  final GlobalKey repaintBoundaryKey = GlobalKey();
//
  //  final boundary = RepaintBoundary(
  //    key: repaintBoundaryKey,
  //    child: Material(
  //      type: MaterialType.transparency,
  //      child: SizedBox(child: child),
  //    ),
  //  );
//
  //  final overlayEntry = OverlayEntry(builder: (context) => boundary);
  //  Overlay.of(context).insert(overlayEntry);
//
  //  await Future.delayed(const Duration(milliseconds: 20));
//
  //  final RenderRepaintBoundary renderBoundary =
  //      repaintBoundaryKey.currentContext!.findRenderObject()
  //          as RenderRepaintBoundary;
  //  final ui.Image image = await renderBoundary.toImage(pixelRatio: 4.2);
  //  final ByteData? byteData =
  //      await image.toByteData(format: ui.ImageByteFormat.png);
//
  //  overlayEntry.remove();
//
  //  if (byteData != null) {
  //    final Uint8List pngBytes = byteData.buffer.asUint8List();
  //    return BitmapDescriptor.fromBytes(pngBytes);
  //  } else {
  //    throw Exception('ByteData is null');
  //  }
  //}
}

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:masahaty/components/custom_search_text_field.dart';
import 'package:masahaty/components/shimmer_container.dart';
import 'package:masahaty/components/viewed_item_title.dart';
import 'package:masahaty/models/warehouse_model.dart';
import 'package:masahaty/pages/wharehouse_pages/components/images_slides.dart';
import 'package:masahaty/provider/current_user.dart';
import 'package:masahaty/services/dio_bookmark.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../components/custom_favorites_button.dart';
import '../../components/rating_button.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/constants.dart';
import '../../services/dio_storage.dart';
import '../wharehouse_pages/warehouse_details_page.dart';
import 'components/custom_marker.dart';
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
  final Completer<GoogleMapController> _controller = Completer();
  Map<String, Marker> _markers = {};

  List<Warehouse> allWarehouses = [];

  Future<void> recentlyAdded() async {
    try {
      StorageService storageService = StorageService();
      List<Warehouse> temp = await storageService.storageGet();
      temp.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      setState(() {
        allWarehouses = temp;
      });
    } catch (e) {}
  }

  void _filterMarkers(String searchText) {
    setState(() {
      filteredMarkers = _markers.values
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
        child: ShimmerContainer(width: double.infinity,height: double.infinity,),
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
              setState(() {
              });
            },
            liteModeEnabled: false,
            initialCameraPosition:
                const CameraPosition(target: myPos, zoom: 13),
            markers: _markers.values.toSet(),
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
              child: CoustomSearchTextField(
                prefixIcon: Icons.search,
                labelText: AppLocalizations.of(context)!.search,
                controller: searchController,
                onChange: _filterMarkers,
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => FocusScope.of(context)
            .unfocus(), // Dismiss the keyboard when tapping outside
        child: content,
      ),
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
      _markers[id] = marker;
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

dynamic getMarkedInfo(
    {required BuildContext context, required String id}) async {
  showModalBottomSheet(
    isScrollControlled: true,
    showDragHandle: true,
    enableDrag: true,
    barrierColor: const ui.Color.fromARGB(90, 0, 0, 0),
    context: context,
    builder: (context) => SizedBox(
      width: double.infinity,
      height: 400,
      child: MarkedWarehouseInfo(
        id: id,
      ),
    ),
  );
}

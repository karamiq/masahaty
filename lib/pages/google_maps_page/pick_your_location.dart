import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:masahaty/components/custom_back_botton.dart';
import 'package:masahaty/core/constants/constants.dart';
import 'package:masahaty/models/location_model.dart';
import 'package:masahaty/provider/selected_location.dart';

import '../../core/constants/assets.dart';
import '../../provider/location.dart';

class PickYourLocation extends ConsumerStatefulWidget {
  const PickYourLocation({Key? key, required this.defaultLocation}) : super(key: key);

  final LatLng defaultLocation;
  
  @override
  ConsumerState<PickYourLocation> createState() => _PickYourLocationState();
}

class _PickYourLocationState extends ConsumerState<PickYourLocation> {
  late GoogleMapController mapController;
  String themeForMap = '';
  Set<Marker> markers = {}; // Maintain a set of markers
  bool heSelected = false;
  
  @override
  void initState() {
    super.initState();
    DefaultAssetBundle.of(context)
        .loadString(Assets.assetsThemesDarkMapStyle)
        .then((value) {
      setState(() {
        themeForMap = value;
      });
    });
  }

  void selectLocation(LatLng pos) async {
    setState(() {
      
    });
    List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
    LocationService locationService = LocationService(
      latitude: pos.latitude,
      longitude: pos.longitude,
      placemarks: placemarks.isNotEmpty ? placemarks[0] : null,
    );
    ref.watch(selectLocationProvider.notifier).selectLocation(locationService);
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    final userPostion = ref.watch(locationProvider);
    LatLng cameraPosition = widget.defaultLocation;

    if (userPostion != null && userPostion.latitude != null && userPostion.longitude != null) {
      cameraPosition = LatLng(userPostion.latitude!, userPostion.longitude!);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.pickLocation),
        leading: const Padding(
          padding: EdgeInsets.all(CustomPageTheme.smallPadding),
          child: CustomBackButton(),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(target: cameraPosition, zoom: 11),
            onMapCreated: (controller) {
              mapController = controller;
              mapController.setMapStyle(themeForMap);
            },
            onTap: (pos) {
              setState(() {
                selectLocation(pos);
                heSelected = true;
                markers.clear();
                markers.add(
                  Marker(
                    markerId: const MarkerId('m1'),
                    position: pos,
                  ),
                );
              });
            },
            markers: markers, // Set markers
          ),
          Positioned(
            bottom: 30.0,
            left: 95.0,
            right: 95.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: heSelected ? () => context.pop() : null,
                child: Text(AppLocalizations.of(context)!.pickLocation),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

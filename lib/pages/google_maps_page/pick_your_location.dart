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
  const PickYourLocation({super.key});

  @override
  ConsumerState<PickYourLocation> createState() => _PickYourLocationState();
}

class _PickYourLocationState extends ConsumerState<PickYourLocation> {
  late GoogleMapController mapController;
  String themeForMap = '';
  Set<Marker> markers = {};
  bool heSelected = false;
  bool isPlaceValid = true;
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

  LocationService? locationService;
  void selectLocation(LatLng pos) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);
      setState(() {
        isPlaceValid = true;
        locationService = LocationService(
          latitude: pos.latitude,
          longitude: pos.longitude,
          placemarks: placemarks.isNotEmpty ? placemarks[0] : null,
        );
        ref
            .watch(selectLocationProvider.notifier)
            .selectLocation(locationService);
      });
    } catch (e) {
      setState(() => isPlaceValid = false);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userLocation = ref.watch(locationProvider);
    LatLng cameraPosition = defaultLocation;

    if (userLocation != null &&
        userLocation.latitude != null &&
        userLocation.longitude != null) {
      cameraPosition = LatLng(userLocation.latitude!, userLocation.longitude!);
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
              initialCameraPosition:
                  CameraPosition(target: cameraPosition, zoom: 10),
              onMapCreated: (controller) {
                mapController = controller;
                // ignore: deprecated_member_use
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
              markers: markers),
          Positioned(
            bottom: 30.0,
            left: 95.0,
            right: 95.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: heSelected && isPlaceValid
                    ? () {
                        context.pop(locationService);
                      }
                    : null,
                child: Text(AppLocalizations.of(context)!.pickLocation),
              ),
            ),
          ),
          if (isPlaceValid == false)
            Positioned(
              top: 30.0,
              left: 95.0,
              right: 95.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.all(CustomPageTheme.normalPadding),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(131, 186, 26, 26),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.choseValidLocation,
                      style: const TextStyle(
                        fontWeight: CustomFontsTheme.bigWeight,
                        color: Colors.white),
                    )),
              ),
            ),
        ],
      ),
    );
  }
}

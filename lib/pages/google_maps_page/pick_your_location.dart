import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:masahaty/components/custom_back_botton.dart';
import 'package:masahaty/core/constants/constants.dart';
import 'package:masahaty/models/location_model.dart';
import '../../core/constants/assets.dart';
import '../../provider/location.dart';
import '../../provider/location_helper.dart';

class PickYourLocation extends ConsumerStatefulWidget {
  const PickYourLocation({super.key});

  @override
  ConsumerState<PickYourLocation> createState() => _PickYourLocationState();
}

class _PickYourLocationState extends ConsumerState<PickYourLocation> {
  late GoogleMapController mapController;
  String themeForMap = '';
  Set<Marker> markers = {};
  bool locationSelected = false;
  bool isPlaceValid = true;
  bool isLoading = false;
  LocationService? locationService;

  @override
  void initState() {
    super.initState();
    _loadMapTheme();
  }

  Future<void> _loadMapTheme() async {
    themeForMap = await DefaultAssetBundle.of(context).loadString(Assets.assetsThemesDarkMapStyle);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> selectLocation(LatLng pos) async {
    setState(() {
      isLoading = true;
      isPlaceValid = true;
    });

    try {
      Placemark placemark = await convertToAddress(pos.latitude, pos.longitude);
      setState(() {
        locationService = LocationService(
          latitude: pos.latitude,
          longitude: pos.longitude,
          placemarks: placemark,
        );
        isPlaceValid = true;
      });
    } catch (e) {
      setState(() {
        isPlaceValid = false;
        locationService = null;
      });
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final userLocation = ref.watch(locationProvider);
    LatLng cameraPosition = defaultLocation;

    if (userLocation?.latitude != null && userLocation?.longitude != null) {
      cameraPosition = LatLng(userLocation!.latitude!, userLocation.longitude!);
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
            initialCameraPosition: CameraPosition(target: cameraPosition, zoom: 10),
            onMapCreated: (controller) {
              mapController = controller;
              mapController.setMapStyle(themeForMap);
            },
            onTap: (pos) {
              setState(() {
                locationSelected = true;
                markers.clear();
                markers.add(Marker(markerId: const MarkerId('m1'), position: pos));
              });
              selectLocation(pos);
            },
            markers: markers,
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 30.0,
            left: 95.0,
            right: 95.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: locationSelected && isPlaceValid && !isLoading
                    ? () {
                        if (locationService != null) {
                          context.pop<LocationService?>(locationService);
                        }
                      }
                    : null,
                child: Text(AppLocalizations.of(context)!.pickLocation),
              ),
            ),
          ),
          if (!isPlaceValid)
            Positioned(
              top: 30.0,
              left: 95.0,
              right: 95.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(CustomPageTheme.normalPadding),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(131, 186, 26, 26),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.choseValidLocation,
                    style: const TextStyle(
                      fontWeight: CustomFontsTheme.bigWeight,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

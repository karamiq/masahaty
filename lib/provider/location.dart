import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:masahaty/provider/location_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/location_model.dart';
class LocationNotifier extends StateNotifier<LocationService?> {
  LocationNotifier() : super(null) {
    _loadSavedLocation();
  }

  Future<void> _loadSavedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('latitude');
    double? longitude = prefs.getDouble('longitude');

    if (latitude != null && longitude != null) {
      dynamic placemarks = await convertToAddress(latitude, longitude);
      state = LocationService(
        latitude: latitude,
        longitude: longitude,
        placemarks: placemarks,
      );
    }
  }

  Future<void> getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        state = null;
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        state = null;
        return;
      }
    }

    try {
      LocationData locationData = await location.getLocation();
      double latitude = locationData.latitude!;
      double longitude = locationData.longitude!;
      dynamic placemarks = await convertToAddress(latitude, longitude);

      // Save the location in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('latitude', latitude);
      await prefs.setDouble('longitude', longitude);

      state = LocationService(
        latitude: latitude,
        longitude: longitude,
        placemarks: placemarks,
      );
    } catch (e) {
      state = null;
    }
  }
}

final locationProvider =
    StateNotifierProvider<LocationNotifier, LocationService?>((ref) {
  return LocationNotifier();
});

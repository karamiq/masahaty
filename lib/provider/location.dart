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
    try {
      final prefs = await SharedPreferences.getInstance();
      final latitude = prefs.getDouble('latitude');
      final longitude = prefs.getDouble('longitude');

      if (latitude != null && longitude != null) {
        final placemarks = await convertToAddress(latitude, longitude);
        state = LocationService(
          latitude: latitude,
          longitude: longitude,
          placemarks: placemarks,
        );
      }
    } catch (e) {
      state = null;
    }
  }

  Future<void> getCurrentLocation() async {
    final location = Location();

    try {
      if (!await _checkAndRequestService(location)) return;
      if (!await _checkAndRequestPermission(location)) return;

      final locationData = await location.getLocation();
      final latitude = locationData.latitude!;
      final longitude = locationData.longitude!;
      final placemarks = await convertToAddress(latitude, longitude);

      // Save the location in shared preferences
      final prefs = await SharedPreferences.getInstance();
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

  Future<bool> _checkAndRequestService(Location location) async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    if (!serviceEnabled) {
      state = null;
    }
    return serviceEnabled;
  }

  Future<bool> _checkAndRequestPermission(Location location) async {
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    if (permissionGranted != PermissionStatus.granted) {
      state = null;
    }
    return permissionGranted == PermissionStatus.granted;
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, LocationService?>((ref) {
  return LocationNotifier();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:masahaty/provider/location_helper.dart';

import '../models/location_model.dart';
class SelectedLocationNotifier extends StateNotifier<LocationService?> {
  SelectedLocationNotifier() : super(null);

  Future<void> selectLocation(LocationService? pos) async {

    try {
      double? latitude = pos?.latitude;
      double? longitude = pos?.longitude;
      dynamic placemarks = await convertToAddress(latitude!, longitude!);
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

final selectLocationProvider =
    StateNotifierProvider<SelectedLocationNotifier, LocationService?>((ref) {
  return SelectedLocationNotifier();
});

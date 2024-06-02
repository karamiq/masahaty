import 'package:geocoding/geocoding.dart';

class LocationService {
  final double? latitude;
  final double? longitude;
  final Placemark? placemarks;
  LocationService({required this.latitude, required this.longitude, required this.placemarks});
}
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:weatherapp/controllers/home_controller.dart';
import 'package:weatherapp/services/latlong_services.dart';

class AppMapController extends GetxController {
  /// flutter map package no controller
  final MapControllerImpl mapControllerImpl = MapControllerImpl();
  final LatLongServices _latLongServices = LatLongServices();
  RxList<Marker> markers = <Marker>[].obs;

  @override
  void onInit() {
    super.onInit();
    setCurrentLocation();
  }

  Future<void> setCurrentLocation() async {
    /// get current location using LatLong services
    Position? position = await _latLongServices.getCurrentLocation();
    if (position != null) {
      LatLng pos = LatLng(position.latitude, position.longitude);

      mapControllerImpl.move(pos, 14);

      markers.clear();
      markers.add(
        Marker(
          point: pos,
          width: 50.w,
          height: 50.h,
          child: const Icon(Icons.location_on, color: Colors.red, size: 40),
        ),
      );
    }
  }

  void moveToLocation(double lat, double long) {
    LatLng newPos = LatLng(lat, long);
    mapControllerImpl.move(newPos, 14);

    markers.clear();
    markers.assignAll([
      Marker(
        point: newPos,
        width: 50.w,
        height: 50.h,
        child: const Icon(Icons.location_on, color: Colors.red, size: 40),
      ),
    ]);
  }

  void handleMapOnTap(LatLng point) {
    mapControllerImpl.move(point, 14);

    markers.clear();
    markers.assignAll([
      Marker(
        point: point,
        width: 50.w,
        height: 50.h,
        child: Icon(Icons.location_on, color: Colors.red, size: 40),
      ),
    ]);

    final WeatherController weatherCtrl = Get.find<WeatherController>();

    /// on tap karse etle je te point parhi lat long select kari weather data get karse
    weatherCtrl.getApiCall(point.latitude, point.longitude);
  }
}

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
  RxBool isMapReady = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    setCurrentLocation();
  }

  Future<void> setCurrentLocation() async {
    /// get current location using LatLong services
    Position? position = await _latLongServices.getCurrentLocation();
    if (position != null) {
      LatLng pos = LatLng(position.latitude, position.longitude);
      if (isMapReady.value) {
        try {
          mapControllerImpl.move(pos, 14);
        } catch (e) {
          print("MoveToLocation Error: $e");
        }
      }
    }
  }

  void moveToLocation(double lat, double long) {
    LatLng newPos = LatLng(lat, long);

    // જો મેપ તૈયાર હોય તો જ મૂવ કરવો
    if (isMapReady.value) {
      try {
        mapControllerImpl.move(newPos, 14);
      } catch (e) {
        print("Map Move Error: $e");
      }
    } else {
      print("Map is not ready yet. Just updating variables.");
    }

    // માર્કર તો તમે ગમે ત્યારે અપડેટ કરી શકો છો, તેમાં એરર નહીં આવે
    markers.assignAll([
      Marker(
        point: newPos,
        width: 50.w,
        height: 50.h,
        child: const Icon(Icons.location_on, color: Colors.red, size: 40),
      ),
    ]);
  }

  void updateMarker(LatLng point) {
    markers.assignAll([
      Marker(
        point: point,
        width: 50.w,
        height: 50.h,
        child: Icon(Icons.location_on, color: Colors.red, size: 40),
      ),
    ]);
  }

  void handleMapOnTap(LatLng point) {
    if (isMapReady.value) {
      mapControllerImpl.move(point, 14);
    }
    markers.clear();
    updateMarker(point);

    final WeatherController weatherCtrl = Get.find<WeatherController>();
    weatherCtrl.getCityName(point.latitude, point.longitude);

    /// on tap karse etle je te point parhi lat long select kari weather data get karse
    weatherCtrl.getApiCall(point.latitude, point.longitude);
  }
}

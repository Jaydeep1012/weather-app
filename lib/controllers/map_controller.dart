import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:weatherapp/controllers/currentlocation_controller.dart';
import 'package:weatherapp/controllers/home_controller.dart';

class AppMapController extends GetxController {
  /// flutter map package no controller

  static AppMapController get to => Get.isRegistered<AppMapController>()
      ? Get.find<AppMapController>()
      : Get.put(AppMapController());
  final RxString? currentCity = "".obs;

  WeatherController get weatherCtrl => WeatherController.to;
  LocationController get locationCtrl => LocationController.to;

  /// MAP view in UI and LatLong fetch using latLong Services
  final MapController mapController = MapController();
  RxList<Marker> markers = <Marker>[].obs;
  RxBool isMapReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeMapLocation();
  }

  @override
  void onReady() {
    super.onReady();
    setCurrentLocation();
  }

  Future<void> initializeMapLocation() async {
    Position? position = await locationCtrl.getCurrentLocation();
    if (position != null) {
      updateLocationAndWeather(position.latitude, position.longitude);
    }
  }

  Future<void> setCurrentLocation() async {
    /// get current location using LatLong services (device current location)
    Position? position = await locationCtrl.getCurrentLocation();
    if (position != null) {
      LatLng pos = LatLng(position.latitude, position.longitude);
      if (isMapReady.value) {
        try {
          mapController.move(pos, 14);

          /// map na Camara user search location par lai jay
        } catch (e) {
          print("MoveToLocation Error: $e");
        }
      }
    }
  }

  void updateLocationAndWeather(double lat, double long,
      {bool gpsCityName = true}) {
    LatLng newPos = LatLng(lat, long);

    markers.assignAll([
      Marker(
        point: newPos,
        width: 50.w,
        height: 50.h,
        child: const Icon(Icons.location_on, color: Colors.red, size: 40),
      ),
    ]);

    if (isMapReady.value && mapController != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mapController != null) {
          try {
            mapController.move(newPos, 14);
          } catch (e) {
            debugPrint("Map Move Error : $e");
          }
        }
      });
    }

    if (gpsCityName) {
      weatherCtrl.getCityName(
        lat,
        long,
      );
    }
    weatherCtrl.getApiCall(lat, long);
  }

  /// MAP par tap karse te location par mark set thase ane te location na data show karse
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
      mapController.move(point, 14);
    }
    markers.clear();
    updateMarker(point);

    /// Lat Long parthi city name find karse
    weatherCtrl.getCityName(point.latitude, point.longitude);

    /// on tap karse etle je te point parhi lat long select kari weather data get karse
    weatherCtrl.getApiCall(point.latitude, point.longitude);
  }
}

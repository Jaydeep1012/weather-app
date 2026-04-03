import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../core/constants/app_colors.dart';

class LatLongServices {
  Future<Position?> getCurrentLocation() async {
    bool serviceEnable;
    LocationPermission permition;

    /// Geolocatior check karse Enable se k nahi (GPS Activation  )
    serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      _showLocationDialog(
        "Please turn on Location Services for better accuracy.",
      );
      return null;
    }

    /// permition check karse
    permition = await Geolocator.checkPermission();
    if (permition == LocationPermission.denied) {
      permition = await Geolocator.requestPermission();

      if (permition == LocationPermission.denied) return null;
    }

    ///geolocation permition made to current location aapo

    return await Geolocator.getCurrentPosition();
  }

  void _showLocationDialog(String message) {
    Get.defaultDialog(
      title: "Location Accuracy",
      middleText: message,
      backgroundColor: AppColors.bgColor,
      textConfirm: "Settings",
      textCancel: "Cancel",
      confirmTextColor: AppColors.white,
      onConfirm: () {
        Geolocator.openLocationSettings(); // યુઝરને સેટિંગ્સમાં લઈ જશે
        Get.back();
      },
    );
  }
}

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  static LocationController get to => Get.isRegistered()
      ? Get.find<LocationController>()
      : Get.put(LocationController());

  var latitude = Rxn<double>();
  var longitude = Rxn<double>();
  var isLoading = false.obs;

  /// Geo locator no used
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      isLoading.value = true;

      ///GPS service check
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar("Location Error", "Please enable GPS/Location Services");
        return null;
      }

      /// Geo locator Permission check kare
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("Permission Denied", "Location permission is required");
          return null;
        }
      }

      /// Service permanently Denied hoy to
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
            "Permission Error", "Please enable location from settings");
        return null;
      }

      /// get accurate search location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      return position;
    } catch (e) {
      print("Error fetching location: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}

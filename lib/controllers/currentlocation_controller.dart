import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weatherapp/services/latlong_services.dart';

class LocationController extends GetxController {
  final LatLongServices _latLongServices = LatLongServices();
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isLoading = false.obs;

  Future<Position?> getCurrentLocation() async {
    try {
      isLoading.value = true;

      Position? position = await _latLongServices.getCurrentLocation();

      if (position != null) {
        latitude.value = position.latitude;
        longitude.value = position.longitude;
        return position;
      }
    } catch (e) {
      print("Error Show $e");
    } finally {
      isLoading.value = false;
    }
    return null;
  }
}

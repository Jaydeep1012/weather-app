import 'package:geolocator/geolocator.dart';

class LatLongServices {
  Future<Position?> getCurrentLocation() async {
    bool serviceEnable;
    LocationPermission permition;

    /// Geolocatior check karse Enable se k nahi
    serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) return null;

    /// permition check karse
    permition = await Geolocator.checkPermission();
    if (permition == LocationPermission.denied) {
      permition = await Geolocator.requestPermission();

      if (permition == LocationPermission.denied) return null;
    }

    ///geolocation permition made to current location aapo

    return await Geolocator.getCurrentPosition();
  }
}

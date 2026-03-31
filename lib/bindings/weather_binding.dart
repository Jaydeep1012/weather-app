import 'package:get/get.dart';
import 'package:weatherapp/controllers/home_controller.dart';
import 'package:weatherapp/controllers/map_controller.dart';
import 'package:weatherapp/controllers/segment_controller.dart';
import 'package:weatherapp/controllers/weather_controller.dart';

class WeatherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeatherController>(() => WeatherController());
    Get.lazyPut<WeatherDetailsController>(() => WeatherDetailsController());
    Get.lazyPut<SegmentController>(() => SegmentController());
    Get.lazyPut<AppMapController>(() => AppMapController());
  }
}

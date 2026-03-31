import 'package:get/get.dart';
import 'package:weatherapp/core/routes/app_routes.dart';
import 'package:weatherapp/views/homeScreen.dart';
import 'package:weatherapp/views/map_screen.dart';
import 'package:weatherapp/views/segment_view.dart';
import 'package:weatherapp/views/weather_Splash.dart';

import '../../bindings/weather_binding.dart';
import '../../views/weather_details.dart';

class AppPages {
  static const splash = AppRoutes.initial;

  static final routes = [
    GetPage(name: splash, page: () => const WeatherSplashScreen()),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      binding: WeatherBinding(),
    ),
    GetPage(
      name: AppRoutes.weatherDetail,
      page: () => WeatherDetails(),
      binding: WeatherBinding(),
    ),

    GetPage(
      name: AppRoutes.segmentTab,
      page: () => SegmentView(),
      binding: WeatherBinding(),
    ),
    GetPage(
      name: AppRoutes.map,
      page: () => MapScreen(),
      binding: WeatherBinding(),
    ),
  ];
}

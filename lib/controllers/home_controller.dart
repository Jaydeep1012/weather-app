import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
//import 'package:timezone/browser.dart' as tz;
import 'package:weatherapp/controllers/map_controller.dart';

import '../core/constants/image_assets.dart';
import '../core/enums/weather_theam.dart';
import '../models/weatherModel.dart' show HourlyItem, WeatherModel;
import '../services/weather_services.dart' show WeatherServices;
import 'currentlocation_controller.dart' show LocationController;

class WeatherController extends GetxController
    with StateMixin<List<HourlyItem>> {
  // Services
  final WeatherServices _weatherServices = WeatherServices();
  final LocationController locationController = Get.put(LocationController());
  final TextEditingController searchController = TextEditingController();

  // Observable Variables
  final Rxn<WeatherModel> weather = Rxn<WeatherModel>();
  final RxList<HourlyItem> listData = <HourlyItem>[].obs;

  // Time Variables
  final RxString currentTime = "".obs; // Device (India) Time
  final RxString weatherCurrentTime = "".obs; // Searched Location Time
  final RxBool showLocalTime = false.obs; // Flag to show/hide extra time
  final RxInt utcOffsetSecond = 19800.obs; // Default to India Offset (5.5 hrs)
  final weatherModel = Rxn<WeatherModel>();

  /// required parameter hoy to WeatherModel model ne aa type declare karo
  final RxString searchQuery = "".obs;
  final RxBool isLoading = false.obs;
  final RxInt selectedHourIndex = DateTime.now().hour.obs;
  final now = DateTime.now();

  Timer? _globalTimer;

  @override
  void onInit() {
    super.onInit();

    _startGlobalTimer();
    fetchWeatherByLocation(); // Initial Load
  }

  /// create getter
  HourlyItem get currentHourWeather {
    int hour = DateTime.now().hour;
    return (listData.isNotEmpty && listData.length > hour)
        ? listData[hour]
        : HourlyItem.empty();
  }

  // --- API Methods ---

  /// GPS દ્વારા વેધર ફેચ કરવું
  Future<void> fetchWeatherByLocation() async {
    try {
      isLoading.value = true;
      change(null, status: RxStatus.loading());

      Position? position = await locationController.getCurrentLocation();
      if (position != null) {
        searchQuery.value = "";
        await getApiCall(position.latitude, position.longitude);
      } else {
        _handleError("Location access denied.");
      }
    } catch (e) {
      _handleError("Location Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateLocalTime(String timeZoneName) {
    try {
      // var location = tz.getLocation(timeZoneName);
      // var nowTime = tz.TZDateTime.now(location);
      weatherCurrentTime.value = DateFormat("hh:mm a").format(now);
    } catch (e) {
      /// જો એરર આવે તો ડિફોલ્ટ UTC ટાઈમ બતાવો
      weatherCurrentTime.value = DateFormat(
        'hh:mm a',
      ).format(DateTime.now().toUtc());
      print("Time Error show : $e");
    }
  }

  /// શહેરના નામ દ્વારા સર્ચ કરવું
  Future<void> searchByCity(String cityName) async {
    if (cityName.isEmpty) return;
    try {
      isLoading.value = true;
      List<geo.Location> locations = await geo.locationFromAddress(cityName);

      if (locations.isNotEmpty) {
        final loc = locations.first;
        await getApiCall(loc.latitude, loc.longitude);

        // અહીં '.value' વાપરજો જો તમે Rxn<WeatherModel> અથવા .obs વાપર્યું હોય
        if (weatherModel.value != null &&
            weatherModel.value!.timezone != null) {
          updateLocalTime(weatherModel.value!.timezone!);
        }

        final mapCtrl = Get.find<AppMapController>();
        if (mapCtrl.isMapReady.value) {
          mapCtrl.moveToLocation(loc.latitude, loc.longitude);
        }

        searchQuery.value = cityName;
        FocusManager.instance.primaryFocus?.unfocus();
        print("Search CITY Name :${searchQuery.value}");
      }
    } catch (e) {
      _handleError("City not found: $cityName");
    } finally {
      isLoading.value = false;
    }
  }

  /// મુખ્ય API ફંક્શન
  Future<void> getApiCall(double lat, double long) async {
    try {
      final apiResponse = await _weatherServices.fetchWeatherApi(
        lat: lat,
        long: long,
      );

      if (apiResponse != null) {
        // ૧. ઓફસેટ અપડેટ કરો
        utcOffsetSecond.value = apiResponse.utcOffsetSeconds ?? 19800;

        // ૨. ડેટા સ્ટોર કરો
        weather.value = apiResponse;
        listData.assignAll(apiResponse.getItems);
        selectedHourIndex.value = DateTime.now().hour;

        // ૩. ટાઈમ તરત જ અપડેટ કરો (Timer ની રાહ જોયા વગર)
        _updateLocalTime();

        change(listData, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch (e) {
      _handleError("Failed to fetch weather data");
    }
  }

  // --- Time Logic ---

  void _startGlobalTimer() {
    _globalTimer?.cancel();
    _globalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateLocalTime();

      // Auto-refresh logic every hour
      final now = DateTime.now();
      if (now.minute == 0 && now.second == 0) {
        searchQuery.value.isEmpty
            ? fetchWeatherByLocation()
            : searchByCity(searchQuery.value);
      }
    });
  }

  /// લોકલ અને સર્ચ કરેલા શહેરનો સમય ગણવાની મેથડ
  void _updateLocalTime() {
    // ૧. ઇન્ડિયા (Device) ટાઈમ
    currentTime.value = DateFormat("hh:mm:ss a").format(now);

    // ૨. ફોનનો પોતાનો ટાઈમઝોન ઓફસેટ મેળવો
    int deviceOffset = now.timeZoneOffset.inSeconds;

    // ૩. જો API નો ઓફસેટ તમારા ફોન કરતા અલગ હોય, તો જ બીજો ટાઈમ બતાવો
    if (utcOffsetSecond.value != deviceOffset) {
      DateTime nowUtc = DateTime.now().toUtc();
      DateTime localDateTime = nowUtc.add(
        Duration(seconds: utcOffsetSecond.value),
      );

      weatherCurrentTime.value = DateFormat("hh:mm:ss a").format(localDateTime);
      print("Current Location Time : ${weatherCurrentTime.value}");
      showLocalTime.value = true;
    } else {
      showLocalTime.value = false;
    }
  }

  // --- UI Helpers ---

  void getCityName(double lat, double long) async {
    try {
      List<geo.Placemark> placeMarks = await geo.placemarkFromCoordinates(
        lat,
        long,
      );
      if (placeMarks.isNotEmpty) {
        geo.Placemark place = placeMarks[0];
        searchController.text =
            place.locality ?? place.administrativeArea ?? "Unknown";
      }
    } catch (e) {
      log("Reverse Geocoding Error: $e");
    }
  }

  List<HourlyItem> getFilterWeather({int hourStep = 1, int? limit}) {
    if (listData.isEmpty) return [];

    List<HourlyItem> filterList = [];

    int currentHour = (hourStep >= 24) ? 0 : DateTime.now().hour;

    for (int i = currentHour; i < listData.length; i += hourStep) {
      filterList.add(listData[i]);

      if (limit != null && filterList.length == limit) break;
    }

    return filterList;
  }

  void _handleError(String message) {
    change(null, status: RxStatus.error(message));
    Get.snackbar(
      "Weather Update",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  /// કોઈ પણ HourlyItem પરથી તેની WeatherCondition (Icon/Label) નક્કી કરવા માટે

  WeatherCondition getWeatherCondition(HourlyItem item) {
    if (item.time == null || item.time!.isEmpty) return WeatherCondition.clear;

    try {
      // ૧. ટાઈમ પાર્સ કરીને કલાક મેળવો
      DateTime itemTime = DateTime.parse(item.time!);
      int hour = itemTime.hour;

      // ૨. રાતનું લોજિક (તમારા પ્રોજેક્ટ મુજબ): રાત્રે ૭ થી સવારે ૫
      bool isNight = hour >= 19 || hour <= 5;

      // ૩. તમારા Enum માંથી ડેટા મેળવો (weatherCode નો ઉપયોગ કરીને)
      return WeatherCondition.fromCode(item.weatherCode, isNight: isNight);
    } catch (e) {
      log("Error in getWeatherCondition: $e");

      return WeatherCondition.clear;
    }
  }

  @override
  void onClose() {
    _globalTimer?.cancel();
    searchController.dispose();
    super.onClose();
  }

  void updateSelectedHour(int index) {
    if (index >= 0 && index < listData.length) {
      selectedHourIndex.value = index;
    }
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = "";
  }

  WeatherTheme get currentTheme {
    final item = currentHourWeather;

    if (item.time == null || item.time!.isEmpty) return WeatherTheme.day;

    try {
      final hour = DateTime.parse(item.time!).hour;

      final code = item.weatherCode;

      if (hour >= 20 || hour < 5) return WeatherTheme.night;

      if (code >= 51 && code <= 99) return WeatherTheme.rainy;

      if ((hour >= 18 && hour < 20) || (hour >= 5 && hour < 7)) {
        return WeatherTheme.sunset;
      }

      return WeatherTheme.day;
    } catch (e) {
      return WeatherTheme.day;
    }
  }

  List<Color> get dynamicBackground => currentTheme.setColor;
}

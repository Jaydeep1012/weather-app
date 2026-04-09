import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/controllers/map_controller.dart';

import '../core/constants/image_assets.dart';
import '../core/enums/weather_theam.dart';
import '../models/weatherModel.dart' show HourlyItem, WeatherModel;
import '../services/weather_services.dart' show WeatherServices;
import 'currentlocation_controller.dart' show LocationController;

class WeatherController extends GetxController
    with StateMixin<List<HourlyItem>> {
  static WeatherController get to => Get.isRegistered<WeatherController>()
      ? Get.find<WeatherController>()
      : Get.put(WeatherController());

  /// Services & Controllers
  final WeatherServices _weatherServices = WeatherServices();
  final locationController = Get.put(LocationController());
  final TextEditingController searchController = TextEditingController();
  AppMapController get appMapCtrl => Get.find<AppMapController>();

  /// Observable Variables
  final Rxn<WeatherModel> weather = Rxn<WeatherModel>();
  final RxList<HourlyItem> listData = <HourlyItem>[].obs;
  final RxString currentTime = "".obs;
  final RxString weatherCurrentTime = "".obs;
  var isSearch = false.obs;
  final RxString searchQuery = "".obs;
  final RxInt utcOffsetSecond = 19800.obs;
  final RxInt selectedHourIndex = DateTime.now().hour.obs;
  final RxBool showLocalTime = false.obs;

  DateTime? weatherCurrentDateTime;
  Timer? _globalTimer;

  @override
  void onInit() {
    super.onInit();

    /// Initially Load
    _startGlobalTimer();
    fetchWeatherByLocation();
  }

  /// create getter for current hour
  HourlyItem get currentHourWeather {
    int hour = weatherCurrentDateTime?.hour ?? DateTime.now().hour;
    if (listData.isEmpty) return HourlyItem.empty();
    return listData.length > hour ? listData[hour] : listData.first;
  }

  /// API Methods
  /// weather data fetch using GPS
  Future<void> fetchWeatherByLocation() async {
    try {
      if (weather.value == null) change(null, status: RxStatus.loading());

      /// GPS Location get
      final position = await locationController.getCurrentLocation();

      if (position != null) {
        /// Reset for GPS
        await getApiCall(position.latitude, position.longitude);
        List<geo.Placemark> placeMarks = await geo.placemarkFromCoordinates(
            position.latitude, position.longitude);

        if (placeMarks.isNotEmpty) {
          String currentCity = placeMarks.first.locality ??
              placeMarks.first.subAdministrativeArea ??
              "";

          //  searchController.text = currentCity;
          searchQuery.value = currentCity;

          /// current location par map move thase
          appMapCtrl.updateLocationAndWeather(
              position.latitude, position.longitude);
        }
      } else {
        await searchByCity("asd");
      }
    } catch (e) {
      _handleError("Location Access Error");
    }
  }

  /// weather data search by city name
  Future<void> searchByCity(String cityName) async {
    if (cityName.isEmpty) return;
    try {
      change(null, status: RxStatus.loading());
      final locations = await geo.locationFromAddress(cityName);

      if (locations.isNotEmpty) {
        final loc = locations.first;

        /// used location search kare
        isSearch.value = true;

        /// search location name store kare
        searchQuery.value = cityName;

        searchController.clear();
        FocusManager.instance.primaryFocus?.unfocus();

        /// map an Weather update kare
        appMapCtrl.updateLocationAndWeather(loc.latitude, loc.longitude);

        change(null, status: RxStatus.success());
      }
    } catch (e) {
      _handleError("City not found: $cityName");
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> clearSearch() async {
    isSearch.value = false;
    searchController.clear();

    await fetchWeatherByLocation();
  }

  /// API CALL
  Future<void> getApiCall(double lat, double long) async {
    try {
      final apiResponse =
          await _weatherServices.fetchWeatherApi(lat: lat, long: long);

      if (apiResponse != null) {
        _syncWeatherData(apiResponse);

        /// user input na kare to j current location show karavvu
        if (searchController.text.isEmpty) {
          getCityName(
            lat,
            long,
          );
        }

        change(listData, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch (e) {
      _handleError("Failed to fetch weather data");
    }
  }

  /// Helper Methods (Internal Logic)

  void _syncWeatherData(WeatherModel response) {
    utcOffsetSecond.value = response.utcOffsetSeconds;
    weather.value = response;
    listData.assignAll(response.getItems);
    selectedHourIndex.value = DateTime.now().hour;
    _updateAllTimers();
  }

  void _startGlobalTimer() {
    _globalTimer?.cancel();
    _globalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateAllTimers();

      /// Auto-refresh logic every hour
      final now = DateTime.now();
      if (now.minute == 0 && now.second == 0) {
        searchQuery.isEmpty
            ? fetchWeatherByLocation()
            : searchByCity(searchQuery.value);
      }
    });
  }

  void _updateAllTimers() {
    final now = DateTime.now();
    currentTime.value = DateFormat("hh:mm:ss a").format(now);

    int deviceOffset = now.timeZoneOffset.inSeconds;
    if (utcOffsetSecond.value != deviceOffset) {
      final localDateTime =
          DateTime.now().toUtc().add(Duration(seconds: utcOffsetSecond.value));
      weatherCurrentTime.value = DateFormat("hh:mm:ss a").format(localDateTime);
      weatherCurrentDateTime = localDateTime;
      showLocalTime.value = true;
    } else {
      weatherCurrentDateTime = now;
      showLocalTime.value = false;
    }
  }

  /// latLong thi City Name get karisakay
  void getCityName(double lat, double long, {bool isFromMap = false}) async {
    try {
      final marks = await geo.placemarkFromCoordinates(lat, long);
      if (marks.isNotEmpty) {
        /// city name get karva mate used thay se
        String currentCity =
            marks.first.locality ?? marks.first.subAdministrativeArea ?? "";

        searchQuery.value = currentCity;
      }
    } catch (e) {
      log("Geocoding Error: $e");
    }
  }

  List<HourlyItem> getFilterWeather({int hourStep = 1, int? limit}) {
    if (listData.isEmpty) return [];

    List<HourlyItem> filterList = [];

    // int currentHour = (hourStep >= 24) ? 0 : DateTime.now().hour;

    int startHour = weatherCurrentDateTime?.hour ?? DateTime.now().hour;

    for (int i = startHour; i < listData.length; i += hourStep) {
      filterList.add(listData[i]);

      if (limit != null && filterList.length == limit) break;
    }

    return filterList;
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

  void _handleError(String message) {
    change(null, status: RxStatus.error(message));
    Get.snackbar("Weather Update", message,
        snackPosition: SnackPosition.BOTTOM);
  }

  /// weather condition wise change theme///
  WeatherCondition getWeatherCondition(HourlyItem item) {
    if (item.time == null || item.time!.isEmpty) return WeatherCondition.clear;

    try {
      DateTime itemTime = DateTime.parse(item.time!);
      int hour = itemTime.hour;

      bool isNight = hour >= 19 || hour <= 5;

      return WeatherCondition.fromCode(item.weatherCode, isNight: isNight);
    } catch (e) {
      log("Error in getWeatherCondition: $e");

      return WeatherCondition.clear;
    }
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

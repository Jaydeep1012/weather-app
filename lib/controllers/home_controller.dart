import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/controllers/map_controller.dart';

import '../core/constants/image_assets.dart';
import '../core/enums/weather_theam.dart';
import '../models/weatherModel.dart';
import '../services/weather_services.dart';
import 'currentlocation_controller.dart';

class WeatherController extends GetxController
    with StateMixin<List<HourlyItem>> {
  // Services
  final WeatherServices _weatherServices = WeatherServices();
  final LocationController locationController = Get.put(LocationController());
  final TextEditingController searchController = TextEditingController();

  // Observable Variables
  final Rxn<WeatherModel> weather = Rxn<WeatherModel>();
  final RxList<HourlyItem> listData = <HourlyItem>[].obs;
  final RxString currentTime = "".obs;
  final searchQuery = "".obs;
  final isLoading = false.obs;
  final RxInt selectedHourIndex = DateTime.now().hour.obs;

  Timer? _globalTimer;

  @override
  void onInit() {
    super.onInit();
    _startGlobalTimer();
    // એપ લોડ થાય ત્યારે સીધું જ કરંટ લોકેશનથી ડેટા ફેચ કરો
    fetchWeatherByLocation();
  }

  // --- Core Logic ---

  /// ૧. કરંટ GPS લોકેશન દ્વારા વેધર મેળવવું
  Future<void> fetchWeatherByLocation() async {
    try {
      isLoading.value = true;
      change(null, status: RxStatus.loading());

      Position? position = await locationController.getCurrentLocation();
      if (position != null) {
        searchQuery.value = ""; // GPS લોકેશન હોય ત્યારે સર્ચ ખાલી કરો
        await getApiCall(position.latitude, position.longitude);
      } else {
        _handleError("Location permission denied or disabled");
      }
    } catch (e) {
      _handleError("Location Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ૨. શહેરના નામ દ્વારા વેધર સર્ચ કરવું (Geocoding)
  Future<void> searchByCity(String cityName) async {
    if (cityName.isEmpty) return;

    try {
      isLoading.value = true;
      List<geo.Location> locations = await geo.locationFromAddress(cityName);

      if (locations.isNotEmpty) {
        final loc = locations.first;
        await getApiCall(loc.latitude, loc.longitude);

        final mapCtrl = Get.find<AppMapController>();
        mapCtrl.moveToLocation(loc.latitude, loc.longitude);

        searchQuery.value = cityName;
        FocusManager.instance.primaryFocus?.unfocus();
      }
    } catch (e) {
      log("Geocoding Error: $e");
      _handleError("City not found: $cityName");
    } finally {
      isLoading.value = false;
    }
  }

  /// ૩. મેઈન API કોલ જે ડેટા સેટ કરે છે
  Future<void> getApiCall(double lat, double long) async {
    try {
      final apiResponse = await _weatherServices.fetchWeatherApi(
        lat: lat,
        long: long,
      );

      if (apiResponse != null) {
        weather.value = apiResponse;
        listData.assignAll(apiResponse.getItems);

        selectedHourIndex.value = DateTime.now().hour;
        change(listData, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch (e) {
      log("API Error: $e");
      _handleError("Failed to fetch weather data");
    }
  }

  // --- Getters & Helpers ---

  void clearSearch() {
    searchController.clear();
    searchQuery.value = "";
  }

  void updateSelectedHour(int index) {
    if (index >= 0 && index < listData.length) {
      selectedHourIndex.value = index;
    }
  }

  HourlyItem get currentHourWeather {
    int hour = DateTime.now().hour;
    return (listData.isNotEmpty && listData.length > hour)
        ? listData[hour]
        : HourlyItem.empty();
  }

  HourlyItem get selectedDisplayData {
    return (listData.isNotEmpty && selectedHourIndex.value < listData.length)
        ? listData[selectedHourIndex.value]
        : HourlyItem.empty();
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

  // --- Background Tasks ---

  void _startGlobalTimer() {
    _globalTimer?.cancel();
    _globalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = DateFormat("hh:mm:ss a").format(DateTime.now());

      // દર કલાકે ઓટો-રિફ્રેશ
      final now = DateTime.now();
      if (now.minute == 0 && now.second == 0) {
        if (searchQuery.value.isEmpty) {
          fetchWeatherByLocation();
        } else {
          searchByCity(searchQuery.value);
        }
      }
    });
  }

  void _handleError(String message) {
    change(null, status: RxStatus.error(message));
    Get.snackbar("Weather", message, snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void onClose() {
    _globalTimer?.cancel();
    searchController.dispose();
    super.onClose();
  }

  // --- Weather Condition Logic ---

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

  // --- Theme Logic ---

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

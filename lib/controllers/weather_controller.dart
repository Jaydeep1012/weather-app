import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../core/constants/image_assets.dart';
import '../models/weatherModel.dart';

class WeatherDetailsController extends GetxController
    with StateMixin<List<HourlyItem>> {
  // ૧. Dependency Injection (Using underscore for private instance)

  static WeatherDetailsController get to => Get.find();
  final _homeController = WeatherController.to;

  // ૨. Reactive Variables (Rx)
  final RxList<HourlyItem> dayDataList = <HourlyItem>[].obs;
  final Rxn<HourlyItem> currentHourData = Rxn<HourlyItem>();
  final RxInt selectedSegment = 0.obs; // 0: Hourly, 1: Day Wise

  // Late variable for passed data
  late HourlyItem selectedWeather;

  int get currentSelectedIndex => _homeController.selectedHourIndex.value;

  HourlyItem? get activeDisplayData {
    if (_homeController.listData.isEmpty) return null;

    // Index check to prevent out of bounds
    return (currentSelectedIndex < _homeController.listData.length)
        ? _homeController.listData[currentSelectedIndex]
        : _homeController.listData.first;
  }

  @override
  void onInit() {
    super.onInit();
    _initialSetup();
  }

  /// Initial entry point for the controller logic
  void _initialSetup() {
    _handleArguments();
    fetchForecastData();
  }

  // ૪. Argument Handling with safety
  void _handleArguments() {
    if (Get.arguments is HourlyItem) {
      selectedWeather = Get.arguments;
    } else {
      // Default fallback if no arguments are passed
      selectedWeather = _homeController.listData.isNotEmpty
          ? _homeController.listData.first
          : HourlyItem.empty();
    }
  }

  // ૫. Data Processing Logic
  void fetchForecastData() {
    try {
      change(null, status: RxStatus.loading());

      final int totalDays = (_homeController.listData.length / 24).floor();

      final List<HourlyItem> filteredData = _homeController.getFilterWeather(
        hourStep: 24,
        limit: totalDays,
      );

      dayDataList.assignAll(filteredData);

      if (filteredData.isNotEmpty) {
        currentHourData.value = filteredData.first;
        change(filteredData, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch (e) {
      change(
        null,
        status: RxStatus.error("Failed to load forecast: ${e.toString()}"),
      );
    }
  }

  // ૬. UI Actions & Handlers
  /// day change then index change
  void onForecastTileTap(int index) {
    _homeController.updateSelectedHour(index);
  }

  ///for get WeatherCondition  (Delegation pattern)
  WeatherCondition getWeatherCondition(HourlyItem item) {
    return _homeController.getWeatherCondition(item);
  }

  ///for Change Segment
  void onSegmentChanged(int index) {
    if (selectedSegment.value == index) return;
    selectedSegment.value = index;
    fetchForecastData();
  }
}

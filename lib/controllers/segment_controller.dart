import 'package:get/get.dart';

import '../core/constants/image_assets.dart';
import '../models/weatherModel.dart';
import 'home_controller.dart';

class SegmentController extends GetxController
    with StateMixin<List<HourlyItem>> {
  // static SegmentController get to => Get.isRegistered<SegmentController>()
  //     ? Get.find<SegmentController>()
  //     : Get.put(SegmentController());

  // Dependency
  /// Get view Controller no UI ma Used kare etle tena controller ne Get.find() thi inject karvu comparably
  static SegmentController get to => Get.find();

  final _homeController = WeatherController.to;
  // Observable Variables
  final RxMap<int, WeatherCondition> itemConditions =
      <int, WeatherCondition>{}.obs;
  final Rxn<HourlyItem> selectDayData = Rxn<HourlyItem>();
  final RxString titleBar = "Weather Details".obs;
  final RxInt selectedSegment = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initialSetup();
  }

  /// Initial setup to handle arguments and load data
  void _initialSetup() {
    final dynamic args = Get.arguments;
    if (args != null && args is HourlyItem) {
      selectDayData.value = args;
      _updateTitle(args.time);
    }

    // Default load
    loadFilteredData();
  }

  /// Updates the AppBar title based on the selected date
  void _updateTitle(String? timeStr) {
    if (timeStr == null) return;

    /// string to DateTime formate ma convert kare
    final DateTime tappedDate = DateTime.parse(timeStr);

    /// current date get
    final DateTime now = DateTime.now();
    final bool isToday = tappedDate.year == now.year &&
        tappedDate.month == now.month &&
        tappedDate.day == now.day;

    if (isToday) {
      titleBar.value = "Today";
    } else {
      titleBar.value =
          "${_getDayName(tappedDate.weekday)}, ${tappedDate.day} ${_getMonthName(tappedDate.month)}";
    }
  }

  /// Helpers
  String _getDayName(int weekday) {
    return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][weekday - 1];
  }

  String _getMonthName(int month) {
    return [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ][month - 1];
  }

  /// Professional approach to get Step and Limit based on Segment
  Map<String, int> _getSegmentConfig() {
    final configs = {
      0: {"step": 2, "limit": 12}, // 24 hours / 2 = 12 items
      1: {"step": 4, "limit": 6}, // 24 hours / 4 = 6 items
      2: {"step": 6, "limit": 4},
      3: {"step": 8, "limit": 3},
      4: {"step": 12, "limit": 2},
    };
    return configs[selectedSegment.value] ?? {"step": 2, "limit": 12};

    /// default step 2 selected show
  }

  void loadFilteredData() {
    try {
      change(null, status: RxStatus.loading());
      itemConditions.clear();

      final selectDay = selectDayData.value;
      if (selectDay == null) {
        change(null, status: RxStatus.empty());
        return;
      }

      final config = _getSegmentConfig();
      final int hourStep = config["step"]!;
      final int limit = config["limit"]!;

      final DateTime now = DateTime.now();
      final DateTime tappedDate = DateTime.parse(
        selectDay.time ?? now.toIso8601String(),
      );

      int startIndex = _homeController.listData.indexWhere((item) {
        DateTime itemDate = DateTime.parse(item.time!);
        bool isSameDay = itemDate.year == tappedDate.year &&
            itemDate.month == tappedDate.month &&
            itemDate.day == tappedDate.day;

        if (tappedDate.day == now.day && tappedDate.month == now.month) {
          return isSameDay && itemDate.hour == now.hour;
        }
        return item.time == selectDay.time;
      });

      if (startIndex == -1) startIndex = 0;

      List<HourlyItem> filterData = [];
      for (int i = 0; i < limit; i++) {
        int nextIndex = startIndex + (i * hourStep);

        if (nextIndex < _homeController.listData.length) {
          final item = _homeController.listData[nextIndex];
          filterData.add(item);
          itemConditions[i] = _homeController.getWeatherCondition(item);
        }
      }
      if (filterData.isNotEmpty) {
        change(filterData, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  void updateSegment(int index) {
    selectedSegment.value = index;
    loadFilteredData();
  }
}

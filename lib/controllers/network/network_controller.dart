import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:weatherapp/controllers/home_controller.dart';
import 'package:weatherapp/core/constants/app_colors.dart';
import 'package:weatherapp/core/widgets/custom_text.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  /// network type check kare wifi ,Mobile Data used thay
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  /// check kare internet data transfer thay k nahi (internet access thay se k nahi)
  late StreamSubscription<InternetStatus> _internetSubscription;

  var connectionStatus = <ConnectivityResult>[].obs;
  var isConnected = true.obs;
  Timer? _timer;

  ///internet check karva variable used

  @override
  void onInit() {
    super.onInit();
    _initConnectivityStatus();
  }

  Future<void> _initConnectivityStatus() async {
    /// initial Check
    List<ConnectivityResult> initialResult =
        await _connectivity.checkConnectivity();
    connectionStatus.value = initialResult;

    print("Initial Result 1st check : $initialResult");

    /// connectivity wifi , mobile listen
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((results) {
      connectionStatus.value = results;

      if (results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.mobile)) {
        print("Internet Connection Mobile, Wi-Fi");
      } else if (results.contains(ConnectivityResult.wifi)) {
        print("Internet Connection  Wi-Fi");
      } else if (results.contains(ConnectivityResult.mobile)) {
        print("Internet Connection Mobile, Wi-Fi");
      } else {
        print(" No Internet Connection");
      }
    });

    _internetSubscription =
        InternetConnection().onStatusChange.listen((status) {
      bool hasAccess = (status == InternetStatus.connected);

      if (isConnected.value != hasAccess) {
        _handleStatusChange(hasAccess);
      }

      print("Current Network Status :$status");
    });
  }

  void _handleStatusChange(bool hasAccess) {
    bool wasOffLine = !isConnected.value;
    isConnected.value = hasAccess;

    if (!hasAccess) {
      _startRepeatingSnackBar();
    } else {
      /// internet connection aavi jay to snackbar auto closed thai jase
      _stopRepeatingSnackBar();
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }

      /// if 1st OfLine after Online then fetch data
      if (wasOffLine) {
        if (Get.isRegistered<WeatherController>()) {
          Get.find<WeatherController>().fetchWeatherByLocation();
        }
      }
    }
  }

  void _stopRepeatingSnackBar() {
    _timer?.cancel();
    _timer = null;
  }

  void _startRepeatingSnackBar() {
    _stopRepeatingSnackBar();

    ///old time cancel
    _showSnackBar();

    /// every 10 sec. snack-bar will be show
    _timer = Timer.periodic(
      Duration(seconds: 10),
      (timer) {
        if (!Get.isSnackbarOpen) {
          _showSnackBar();
        }
      },
    );
  }

  void _showSnackBar() {
    Get.rawSnackbar(
        backgroundColor: AppColors.red,
        isDismissible: false,
        messageText: CustomText(text: "No Internet Access "));
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    _internetSubscription.cancel();
    _stopRepeatingSnackBar();
    super.onClose();
  }
}

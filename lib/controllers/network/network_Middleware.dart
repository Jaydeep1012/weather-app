import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:weatherapp/controllers/network/network_controller.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_text.dart';

class NetworkMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final controller = Get.find<NetworkController>();
    if (!controller.isConnected.value) {
      print("Current Status # : ${!controller.isConnected.value}");
      if (!Get.isSnackbarOpen) {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.red,
            messageText: CustomText(
              text: "No Internet Connection",
            ));
      }
      if (route != "/") {
        return RouteSettings(name: "/");
      }
      return null;
    }

    /// internet hoy to next page navigate thase
    return null;
  }
}

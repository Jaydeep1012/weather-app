import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:weatherapp/core/enums/weather_theam.dart';

import '../../controllers/home_controller.dart';

class WeatherScaffold extends GetView<WeatherController> {
  final Widget body;
  final PreferredSizeWidget? appBar;

  const WeatherScaffold({super.key, required this.body, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = controller.currentTheme;

      // અહીં AnnotatedRegion એડ કરો
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          // થીમ મુજબ આઈકોન્સ કાળા કે સફેદ થશે
          statusBarIconBrightness: theme.statusBrightness,
          statusBarBrightness: theme.statusBrightness, // iOS માટે
          statusBarColor: Colors.transparent, // સ્ટેટસ બારને ટ્રાન્સપરન્ટ રાખવા
        ),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: appBar,
          body: Stack(
            children: [
              // ૧. ગ્રેડિયન્ટ બેકગ્રાઉન્ડ
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: theme.setColor,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // ૨. મેઈન UI
              body,
            ],
          ),
        ),
      );
    });
  }
}

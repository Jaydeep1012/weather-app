import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:weatherapp/bindings/weather_binding.dart';
import 'package:weatherapp/core/constants/app_colors.dart';

import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.bgColor,
            appBarTheme: AppBarTheme(
              color: AppColors.bgColor,
              elevation: 0,
              scrolledUnderElevation: 0,
            ),
          ),
          initialRoute: AppRoutes.initial,
          getPages: AppPages.routes,
          initialBinding: WeatherBinding(),
        );
      },
    );
  }
}

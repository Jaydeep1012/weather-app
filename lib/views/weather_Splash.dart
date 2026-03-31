import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/image_assets.dart';
import '../core/routes/app_routes.dart';
import '../core/widgets/custom_ElevatedBtn.dart';
import '../core/widgets/custom_text.dart';

class WeatherSplashScreen extends StatelessWidget {
  const WeatherSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Image.asset(ImageAssets.splash, width: 120.w, height: 120.h),
              SizedBox(height: 50.h),
              CustomText(
                text: "Weather",
                fontSize: 50.sp,
                fontWeight: FontWeight.w800,
              ),
              CustomText(
                text: "Forecasts",
                fontSize: 50.sp,
                color: AppColors.yellow,
              ),

              SizedBox(height: 30.h),

              CustomElevatedBtn(
                text: "Get Start",
                textColor: AppColors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                bgColor: AppColors.yellow,
                onTap: () {
                  Get.toNamed(AppRoutes.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

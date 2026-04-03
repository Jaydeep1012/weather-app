import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weatherapp/core/utils/extention_layout.dart';
import 'package:weatherapp/core/widgets/custom_icon.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/image_assets.dart';
import '../core/routes/app_routes.dart';
import '../core/widgets/custom_ElevatedBtn.dart';
import '../core/widgets/custom_text.dart';

class WeatherSplashScreen extends StatelessWidget {
  const WeatherSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resUI = context.appRes;
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 50.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    CustomImage(
                      imagePath: ImageAssets.splash,
                      height: resUI.splashImg,
                      width: resUI.splashImg,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 50.h),
                    CustomText(
                      leadingDistribution: TextLeadingDistribution.proportional,
                      text: "Weather",
                      fontSize: resUI.largeFont,
                      fontWeight: FontWeight.w800,
                      height: resUI.textLineHeight,
                      strutStyle: StrutStyle(
                        fontSize: resUI.largeFont,
                        height: resUI.textLineHeight,
                        forceStrutHeight: true,
                      ),
                    ),

                    CustomText(
                      leadingDistribution: TextLeadingDistribution.proportional,

                      text: "Forecasts",
                      fontSize: resUI.largeFont,
                      color: AppColors.yellow,
                      height: resUI.textLineHeight,
                      strutStyle: StrutStyle(
                        fontSize: resUI.largeFont,
                        height: resUI.textLineHeight,
                        forceStrutHeight: true,
                      ),
                    ),

                    SizedBox(height: context.res(mobile: 30.h)),

                    CustomElevatedBtn(
                      text: "Get Start",
                      textColor: AppColors.black,
                      fontSize: resUI.semiLargeFont,
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
          ),
        ),
      ),
    );
  }
}

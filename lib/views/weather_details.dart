import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weatherapp/core/utils/responsive%20helperclass.dart';

import '../controllers/weather_controller.dart';
import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../core/widgets/customContainer.dart';
import '../core/widgets/custom_icon.dart';
import '../core/widgets/custom_text.dart';
import '../core/widgets/custom_weatherScaffold.dart';
import '../models/weatherModel.dart';

class WeatherDetails extends GetView<WeatherDetailsController> {
  const WeatherDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final resUI = AppSize(context);
    return WeatherScaffold(
      body: controller.obx(
        onLoading: Center(child: CircularProgressIndicator()),
        onError: (error) => Center(child: Text("Error: $error")),
        onEmpty: const Center(child: Text("Data Not available")),
        (data) {
          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 320.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.dg),
                        bottomRight: Radius.circular(30.dg),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        children: [
                          _buildAppBar(resUI),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                        top: 80.dg,
                        left: 10.dg,
                        right: 10.dg,
                        bottom: 20.dg,
                      ),
                      itemCount: data!.length ?? 0,
                      itemBuilder: (context, index) {
                        final HourlyItem dayTime = data![index];

                        return InkWell(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.segmentTab,
                              arguments: dayTime,
                            );
                          },
                          child: _buildForecastCard(dayTime, index, resUI),
                        );
                      },
                    ),
                  ),
                ],
              ),

              /// (Overlay Card)
              Positioned(
                top: context.isLandscape ? 80.dg : 200.dg,
                left: 30.w,
                right: 30.w,
                child: CustomContainer(
                  //   height: 200.h,
                  width: double.infinity,
                  defaultGradient: false,
                  color: Colors.white,
                  borderRadius: 20.r,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.dg, vertical: 20.dg),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 10,
                      spreadRadius: -10,
                      offset: const Offset(0, 30),
                    ),
                  ],
                  child: Obx(() {
                    final selectedWeather = controller.activeDisplayData;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                            Icons.umbrella,
                            "${selectedWeather?.temperature2M ?? ""}%",
                            "Projection",
                            resUI),
                        _buildStatItem(
                            Icons.sunny,
                            "${selectedWeather?.relativeHumidity2M ?? ""} %",
                            "Humidity",
                            resUI),
                        _buildStatItem(
                            Icons.wind_power,
                            "${selectedWeather?.windSpeed10M ?? ""} KM/h",
                            "Wind",
                            resUI),
                      ],
                    );
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String value,
    String label,
    AppSize? resUI,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomIcon(
          icon: icon,
          iconColor: AppColors.primaryLight,
          iconSize: resUI?.weatherImg,
        ),
        SizedBox(height: 6.dg),
        CustomText(
          text: value,
          fontSize: resUI?.normalFont,
          fontColor: AppColors.black,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 6.dg),
        CustomText(
            text: label,
            fontColor: AppColors.gray,
            fontSize: resUI?.normalFont),
      ],
    );
  }

  Widget _buildForecastCard(HourlyItem item, int index, AppSize resUI) {
    String dateLabel = index == 0 ? "Today" : item.dateOnly;
    final condition = controller.getWeatherCondition(item);
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 10.dg, vertical: 10.dg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.dg),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ૧. દિવસનું નામ
          SizedBox(
            child: Text(
              dateLabel,
              style: TextStyle(
                  fontSize: resUI.smallFont, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImage(imagePath: condition.imagePath),
                SizedBox(width: 10.dg),
                Text(
                  "${item.relativeHumidity2M}%",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 30.dg,
            child: Text(
              "${item.temperature2M?.toStringAsFixed(0)}°",
              style: TextStyle(
                  fontSize: resUI.normalFont, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(AppSize resUI) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.dg, vertical: 20.dg),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: resUI.normalFont,
            ),
          ),
          CustomText(
            text: "7 Day Forecast",
            fontSize: resUI.normalFont,
            fontWeight: FontWeight.bold,
            fontColor: Colors.white,
          ),
          const Spacer(),
          Icon(Icons.more_vert, color: Colors.white, size: resUI.normalFont),
        ],
      ),
    );
  }
}

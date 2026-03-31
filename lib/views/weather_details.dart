import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weatherapp/controllers/weather_controller.dart';
import 'package:weatherapp/core/widgets/customContainer.dart';
import 'package:weatherapp/core/widgets/custom_weatherScaffold.dart';
import 'package:weatherapp/models/weatherModel.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../core/widgets/custom_icon.dart';
import '../core/widgets/custom_text.dart';

class WeatherDetails extends GetView<WeatherDetailsController> {
  static WeatherDetailsController get to =>
      Get.isRegistered<WeatherDetailsController>()
      ? Get.find<WeatherDetailsController>()
      : Get.put(WeatherDetailsController());

  const WeatherDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return WeatherScaffold(
      body: controller.obx(
        onLoading: Center(child: CircularProgressIndicator()),

        onError: (error) => Center(child: Text("Error: $error")),

        // ૪. Empty State (જો ડેટા ન મળે ત્યારે) - Optional
        onEmpty: const Center(child: Text("Data Not available")),

        (data) {
          return Stack(
            children: [
              // ૧. મુખ્ય સ્ટ્રક્ચર (Gradient + List)
              Column(
                children: [
                  // ઉપરનો ગ્રેડિયન્ટ ભાગ
                  Container(
                    height: 320.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: AppColors
                          .primaryGradient, // આ કલર સ્ટેટસ બારની પાછળ પણ દેખાશે
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.r),
                        bottomRight: Radius.circular(40.r),
                      ),
                    ),
                    child: SafeArea(
                      // આ કન્ટેનરની અંદર જ હોવું જોઈએ
                      bottom: false,
                      child: Column(
                        children: [
                          _buildAppBar(),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),

                  // ૨. નીચેનું લિસ્ટ
                  Expanded(
                    child: ListView.builder(
                      // પેલા કાર્ડ માટે ઉપરથી જગ્યા (Padding) છોડવી
                      padding: EdgeInsets.only(
                        top: 80.h,
                        left: 10.w,
                        right: 10.w,
                        bottom: 20.h,
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
                          child: _buildForecastCard(dayTime, index),
                        );
                      },
                    ),
                  ),
                ],
              ),

              /// ૩. તરતું કન્ટેનર (Overlay Card)
              Positioned(
                top: 200.h,

                /// ગ્રેડિયન્ટ અને લિસ્ટની બરાબર વચ્ચે
                left: 30.w,
                right: 30.w,
                child: CustomContainer(
                  height: 200.h,
                  width: double.infinity,
                  defaultGradient: false,
                  color: Colors.white,
                  borderRadius: 20.r,
                  // શેડો આપવો ખૂબ જરૂરી છે પ્રોફેશનલ લુક માટે
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
                        ),
                        _buildStatItem(
                          Icons.sunny,
                          "${selectedWeather?.relativeHumidity2M ?? ""} %",
                          "Humidity",
                        ),
                        _buildStatItem(
                          Icons.wind_power,
                          "${selectedWeather?.windSpeed10M ?? ""} KM/h",
                          "Wind",
                        ),
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

  // Stats માટે પ્રોફેશનલ વિજેટ
  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomIcon(
          icon: icon,
          iconColor: AppColors.primaryLight,
          iconSize: 28.sp,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: value,
          color: AppColors.black,
          fontWeight: FontWeight.bold,
        ),
        CustomText(text: label, color: AppColors.gray, fontSize: 12.sp),
      ],
    );
  }

  // લિસ્ટ આઈટમ માટે પ્રોફેશનલ કાર્ડ
  Widget _buildForecastCard(HourlyItem item, int index) {
    // તારીખમાંથી દિવસનું નામ મેળવવા માટે (દા.ત. 2026-03-25 -> Wednesday)
    // અત્યારે સાદી રીતે બતાવવા માટે:
    String dateLabel = index == 0 ? "Today" : item.dateOnly;
    final condition = controller.getWeatherCondition(item);
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
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
            width: 70.w,
            child: Text(
              dateLabel,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ),

          // ૨. વેધર આઈકોન અને સ્થિતિ
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImage(imagePath: condition.imagePath),
                SizedBox(width: 10.w),
                Text(
                  "${item.relativeHumidity2M}%",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          // ૩. તાપમાન (Min/Max જો મોડેલમાં હોય તો, અત્યારે સિંગલ)
          SizedBox(
            width: 50.w,
            child: Text(
              "${item.temperature2M?.toStringAsFixed(0)}°",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
          ),
          CustomText(
            text: "7 Day Forecast",
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          const Spacer(),
          const Icon(Icons.more_vert, color: Colors.white, size: 25),
        ],
      ),
    );
  }
}

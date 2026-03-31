import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weatherapp/controllers/home_controller.dart';
import 'package:weatherapp/core/constants/app_colors.dart';
import 'package:weatherapp/core/constants/image_assets.dart';
import 'package:weatherapp/core/routes/app_routes.dart';
import 'package:weatherapp/core/widgets/customContainer.dart';
import 'package:weatherapp/core/widgets/custom_icon.dart';
import 'package:weatherapp/core/widgets/custom_text.dart';
import 'package:weatherapp/core/widgets/custom_weatherScaffold.dart';

import '../core/widgets/custom_search.dart';

class HomeScreen extends StatelessWidget {
  final WeatherController controller = Get.find<WeatherController>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WeatherScaffold(
      body: controller.obx(
        // ૨. Loading State (જ્યારે ડેટા લોડ થતો હોય) - Optional
        onLoading: const Center(child: CircularProgressIndicator()),

        // ૩. Error State (જો એરર આવે ત્યારે) - Optional
        onError: (error) => Center(child: Text("Error: $error")),

        // ૪. Empty State (જો ડેટા ન મળે ત્યારે) - Optional
        onEmpty: const Center(child: Text("Data Not available")),
        (data) {
          return RefreshIndicator(
            onRefresh: () => controller.fetchWeatherByLocation(),

            /// current location made
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 20.h,
                    ),
                    child: SizedBox(
                      child: CustomContainer(
                        borderRadius: 10.r,
                        defaultGradient: false,
                        color: AppColors.white.withOpacity(0.3),
                        child: Obx(
                          () => CustomSearch(
                            textEditingController: controller.searchController,
                            hintText: "Search Location",

                            prefixIcon: Icons.search,
                            suffixIcon: controller.searchQuery.value.isNotEmpty
                                ? Icons.close
                                : null,

                            onTap: () => controller.clearSearch(),
                            onChange: (v) => controller.searchQuery.value = v,
                            onSubmit: (value) => controller.searchByCity(value),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.search,

                            /// keyboard na search par tap kare to search action execute thay
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),

                    child: Obx(() {
                      final listD = controller.listData;

                      final currentData = controller.currentHourWeather;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CustomContainer(
                            height: 200.h,
                            width: double.infinity,
                            defaultGradient: false,
                            gradient: AppColors.primaryGradient,

                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 10.h,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize
                                    .min, // કોલમ જરૂર જેટલી જ જગ્યા રોકશે
                                children: [
                                  CustomText(
                                    text: "${currentData.temperature2M}",
                                    //"${listD[DateTime.now().hour].temperature2M}",
                                    fontSize: 80.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.white.withValues(
                                      alpha: 0.9,
                                    ), // સફેદ બેકગ્રાઉન્ડ પર બ્લેક કલર રાખવો
                                  ),
                                  SizedBox(height: 20.h),
                                  Padding(
                                    padding: EdgeInsets.only(right: 40.w),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: CustomText(
                                        text:
                                            controller.searchQuery.value.isEmpty
                                            ? "Mostly\nClear"
                                            : controller.searchQuery.value
                                                  .toUpperCase(),
                                        color: AppColors.primary,
                                        fontSize: 35.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: CustomText(
                                      text:
                                          "Current Time : ${controller.currentTime.value}",
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 2.h,
                            left: -20.w,
                            child: Image.asset(
                              ImageAssets.splash,
                              width: 120.w,
                              height: 120.h,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: CustomContainer(
                      defaultGradient: false,
                      color: AppColors.white.withOpacity(0.3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                          offset: const Offset(
                            0,
                            10,
                          ), // Y ને વધારવાથી શેડો માત્ર નીચે જ દેખાશે
                        ),
                      ],
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 10.h,
                        ),
                        child: Obx(() {
                          final currentData = controller.getFilterWeather(
                            hourStep: 1,
                            limit: 1,
                          );
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildWeatherDetail(
                                icon: Icons.umbrella,
                                value:
                                    "${currentData.first.temperature2M}  %", // અહીં તમારો વરસાદનો ડેટા મૂકો
                                label: "Temperature",
                              ),
                              // ૨. ભેજ / Humidity Column
                              _buildWeatherDetail(
                                icon: Icons.sunny,
                                value:
                                    "${currentData.first.relativeHumidity2M} %",
                                label: "Humidity",
                              ),

                              // ૩. પવન / Wind Speed Column
                              _buildWeatherDetail(
                                icon: Icons.wind_power,
                                value: "${currentData.first.windSpeed10M} KM/h",
                                label: "Wind Speed",
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: CustomContainer(
                      defaultGradient: false,
                      color: AppColors.white.withOpacity(0.3),
                      child: Column(
                        children: [
                          ListTile(
                            leading: CustomText(
                              text: "Today",
                              color: AppColors.black,
                            ),
                            trailing: CustomText(
                              text: "7 - Day Forecasts >",
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(
                            height: 110.h,
                            child: Builder(
                              builder: (context) {
                                // લિસ્ટને એકવાર મેળવી લો જેથી builder માં વારંવાર લૂપ ન ફરે
                                final hourlyList = controller.getFilterWeather(
                                  hourStep: 1,
                                  limit: 24,
                                );

                                return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: hourlyList.length,
                                  itemBuilder: (context, index) {
                                    final item = hourlyList[index];

                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 10.h,
                                      ),
                                      child: Obx(() {
                                        // ૧. સિલેક્શન ચેક કરવા માટે Controller નો Rx variable (selectedHourIndex) વપરાય છે
                                        bool selected =
                                            controller
                                                .selectedHourIndex
                                                .value ==
                                            index;

                                        /// aa method thi enum mathi code pramane image show thase
                                        final condition = controller
                                            .getWeatherCondition(item);

                                        return InkWell(
                                          onTap: () {
                                            // ૩. ક્લિક કરવા પર ઇન્ડેક્સ અપડેટ કરો
                                            controller.updateSelectedHour(
                                              index,
                                            );

                                            // ૪. ડિટેલ પેજ પર જાવ
                                            Get.toNamed(
                                              AppRoutes.weatherDetail,
                                              arguments: item,
                                            );
                                          },
                                          child: CustomContainer(
                                            gradient: selected
                                                ? AppColors.selected
                                                : AppColors.unSelected,
                                            height: 100.h,
                                            width: 65.w,
                                            border: Border.all(
                                              color: selected
                                                  ? AppColors.white
                                                  : AppColors.white.withOpacity(
                                                      0.5,
                                                    ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                // સમય બતાવવા માટે Getter નો ઉપયોગ
                                                CustomText(
                                                  text: item
                                                      .timeOnly, // જો Getter હોય તો () વગર
                                                  fontSize: 12.sp,
                                                  textAlign: TextAlign.center,
                                                ),

                                                // વેધર ઈમેજ
                                                CustomImage(
                                                  imagePath:
                                                      condition.imagePath,
                                                  width: 30.w,
                                                  height: 30.h,
                                                ),

                                                // તાપમાન
                                                CustomText(
                                                  text:
                                                      "${item.temperature2M?.toStringAsFixed(0)}°C",
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: CustomContainer(
                      defaultGradient: false,
                      color: AppColors.white.withOpacity(0.3),
                      child: Column(
                        children: [
                          ListTile(
                            leading: CustomText(
                              text: "Other Cities",
                              color: AppColors.black,
                            ),
                            trailing: CustomIcon(
                              icon: Icons.add,
                              iconSize: 22.sp,
                              iconColor: AppColors.black,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ),
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(AppRoutes.map);
                              },
                              child: CustomContainer(
                                height: 50.h,
                                gradient: AppColors.selected,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      text: "Go to Map  ",
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                    ),

                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 10.h,
                                      ),
                                      child: Image.asset(
                                        ImageAssets.mapImg,
                                        width: 50.w,
                                        height: 50.h,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// કોડને ક્લીન રાખવા માટે આ નાનું ફંક્શન વાપરો
Widget _buildWeatherDetail({
  required IconData icon,
  String? image,
  required String value,
  required String label,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      image != null
          ? Image.asset(image, height: 30.h, width: 30.w)
          : CustomIcon(
              icon: icon,
              iconColor: AppColors.primaryLight,
              iconSize: 30.sp,
            ),

      SizedBox(height: 5.h),
      CustomText(text: value, color: AppColors.black),
      CustomText(text: label, color: AppColors.gray, fontSize: 12.sp),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weatherapp/controllers/home_controller.dart';
import 'package:weatherapp/core/constants/app_colors.dart';
import 'package:weatherapp/core/constants/image_assets.dart';
import 'package:weatherapp/core/routes/app_routes.dart';
import 'package:weatherapp/core/utils/extention_layout.dart';
import 'package:weatherapp/core/utils/responsive%20helperclass.dart';
import 'package:weatherapp/core/widgets/customContainer.dart';
import 'package:weatherapp/core/widgets/custom_icon.dart';
import 'package:weatherapp/core/widgets/custom_text.dart';
import 'package:weatherapp/core/widgets/custom_weatherScaffold.dart';

import '../core/widgets/custom_search.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WeatherController.to;
    final resUI = context.appRes;

    return WeatherScaffold(
      body: controller.obx(
        // ૨. Loading State (જ્યારે ડેટા લોડ થતો હોય) - Optional
        onLoading: const Center(child: CircularProgressIndicator()),

        // ૩. Error State (જો એરર આવે ત્યારે) - Optional
        onError: (error) => Center(child: Text("Error: $error")),

        // ૪. Empty State (જો ડેટા ન મળે ત્યારે) - Optional
        onEmpty: const Center(child: Text("Data Not available")),
        (data) {
          /// current location made
          return RefreshIndicator(
            onRefresh: () async => await controller.clearSearch(),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.all(16.dg),
                    child: SizedBox(
                      child: CustomContainer(
                        borderRadius: resUI.borderRadius,
                        defaultGradient: false,
                        color: AppColors.white.withOpacity(0.3),
                        child: CustomSearch(
                          textEditingController: controller.searchController,
                          hintText: "Search Location",

                          prefixIcon: Icons.search,
                          suffixIcon: Icons.close,

                          onTap: () => controller.clearSearch(),
                          onChange: (v) => controller.searchQuery.value = v,
                          onSubmit: (value) {
                            if (value.isNotEmpty) {
                              controller.searchByCity(value);
                              FocusManager.instance.primaryFocus?.unfocus();
                              controller.clearSearch();
                            }
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,

                          /// keyboard na search par tap kare to search action execute thay
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.dg),
                    child: Obx(() {
                      //  final listD = controller.listData;

                      /// getter call here
                      final currentData = controller.currentHourWeather;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CustomContainer(
                            width: double.infinity,
                            defaultGradient: false,
                            gradient: AppColors.primaryGradient,
                            borderRadius: resUI.borderRadius,
                            child: Padding(
                              padding: EdgeInsets.all(10.dg),
                              child: Obx(
                                () => Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(
                                      text:
                                          "  ${currentData.temperature2M.round()}°C",
                                      //  height: 0.20,
                                      //"${listD[DateTime.now().hour].temperature2M}",
                                      fontSize: resUI.largeFont,
                                      fontWeight: FontWeight.w800,
                                      fontColor: AppColors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.dg,
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: CustomText(
                                        maxLine: 2,
                                        textAlign: TextAlign.right,
                                        text: controller
                                                .searchQuery.value.isNotEmpty
                                            ? controller.searchQuery.value
                                            : controller.searchController.text
                                                    .isNotEmpty
                                                ? controller
                                                    .searchController.text
                                                : "Mostly Clear",
                                        fontColor: AppColors.primary,
                                        fontSize: resUI.smallLargeFont,
                                        fontWeight: FontWeight.w500,
                                        leadingDistribution:
                                            TextLeadingDistribution.even,
                                      ),
                                    ),
                                    SizedBox(height: 20.dg),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: CustomText(
                                        text:
                                            "Current Time : ${controller.currentTime.value}",
                                        fontSize: resUI.normalFont,
                                        fontWeight: FontWeight.w600,
                                        fontColor: AppColors.white.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.dg),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Obx(() {
                                        if (controller.showLocalTime.value) {
                                          return CustomText(
                                            text:
                                                "Weather Time : ${controller.weatherCurrentTime.value}",
                                            fontSize: resUI.normalFont,
                                            fontWeight: FontWeight.w600,
                                            fontColor:
                                                AppColors.white.withValues(
                                              alpha: 0.6,
                                            ),
                                          );
                                        } else {
                                          return const SizedBox.shrink();
                                        }
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            //top: context.isLandscape ? 80.dg : 1.dg,
                            top: resUI.sunImgPosition,
                            left: resUI.sunImgAngle,
                            child: CustomImage(
                              imagePath: ImageAssets.splash,
                              height: resUI.sunImg,
                              width: resUI.sunImg,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.dg),
                    child: CustomContainer(
                      borderRadius: resUI.borderRadius,
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
                          ),
                        ),
                      ],
                      child: Padding(
                        padding: EdgeInsets.all(10.dg),
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
                                      "${currentData.first.temperature2M}  %",
                                  label: "Temperature",
                                  resUI: resUI),
                              _buildWeatherDetail(
                                  icon: Icons.sunny,
                                  value:
                                      "${currentData.first.relativeHumidity2M} %",
                                  label: "Humidity",
                                  resUI: resUI),
                              _buildWeatherDetail(
                                  icon: Icons.wind_power,
                                  value:
                                      "${currentData.first.windSpeed10M} KM/h",
                                  label: "Wind Speed",
                                  resUI: resUI),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.dg),
                    child: CustomContainer(
                      borderRadius: resUI.borderRadius,
                      defaultGradient: false,
                      color: AppColors.white.withOpacity(0.3),
                      child: Padding(
                        padding: EdgeInsets.all(6.dg),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.dg, vertical: 5.dg),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: "Today",
                                    fontColor: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: resUI.semiLargeFont,
                                  ),
                                  InkWell(
                                    onTap: () =>
                                        Get.toNamed(AppRoutes.weatherDetail),
                                    child: Row(
                                      children: [
                                        CustomText(
                                          text: "Hourly Forecasts",
                                          fontColor: AppColors.black,
                                          fontSize: resUI.semiLargeFont,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        Icon(Icons.arrow_forward_ios,
                                            size: resUI.iconSize,
                                            color: AppColors.black),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: resUI.hourlyListHeight,
                              child: Builder(
                                builder: (context) {
                                  final hourlyList = controller
                                      .getFilterWeather(hourStep: 1, limit: 24);
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: hourlyList.length,
                                    itemBuilder: (context, index) {
                                      final item = hourlyList[index];
                                      final condition =
                                          controller.getWeatherCondition(item);

                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 4.dg,
                                          vertical: 10.dg,
                                        ),
                                        child: Obx(() {
                                          final isSelected = controller
                                                  .selectedHourIndex.value ==
                                              index;

                                          return InkWell(
                                            onTap: () {
                                              controller.updateSelectedHour(
                                                index,
                                              );
                                              Get.toNamed(
                                                AppRoutes.weatherDetail,
                                                arguments: item,
                                              );
                                            },
                                            child: CustomContainer(
                                              borderRadius: resUI.borderRadius,
                                              gradient: isSelected
                                                  ? AppColors.selected
                                                  : AppColors.unSelected,
                                              border: Border.all(
                                                color: isSelected
                                                    ? AppColors.white
                                                    : AppColors.white
                                                        .withOpacity(0.5),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // સમય
                                                  FittedBox(
                                                    child: CustomText(
                                                      text: item.getLocalTime(),
                                                      fontSize:
                                                          resUI.normalFont,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5.dg,
                                                  ),

                                                  /// weather image
                                                  Flexible(
                                                    child: CustomImage(
                                                      imagePath:
                                                          condition.imagePath,
                                                      width: resUI.weatherImg,
                                                      height: resUI.weatherImg,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5.dg,
                                                  ),
                                                  // તાપમાન
                                                  FittedBox(
                                                    child: CustomText(
                                                      text:
                                                          "${item.temperature2M}°C",
                                                      fontSize:
                                                          resUI.normalFont,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
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
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.dg),
                    child: CustomContainer(
                      borderRadius: resUI.borderRadius,
                      defaultGradient: false,
                      color: AppColors.white.withOpacity(0.3),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 8.dg),
                          Align(
                            alignment: Alignment.topLeft,
                            child: CustomText(
                              textAlign: TextAlign.left,
                              text: "\t\t Maps",
                              fontColor: AppColors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15.dg),
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(AppRoutes.map);
                              },
                              child: CustomContainer(
                                gradient: AppColors.selected,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      text: "Go to Map  ",
                                      fontSize: resUI.semiLargeFont,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.dg),
                                      child: Image.asset(
                                        ImageAssets.mapImg,
                                        width: resUI.imageSize,
                                        height: resUI.imageSize,
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

Widget _buildWeatherDetail(
    {required IconData icon,
    String? image,
    required String value,
    required String label,
    AppSize? resUI}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      image != null
          ? CustomImage(
              imagePath: image,
              height: resUI?.weatherImg,
              width: resUI?.weatherImg,
              fit: BoxFit.contain,
            )
          : CustomIcon(
              icon: icon,
              iconColor: AppColors.primaryLight,
              iconSize: resUI?.iconSize,
            ),
      SizedBox(height: 10.dg),
      CustomText(
        text: value,
        fontColor: AppColors.black,
        fontSize: resUI?.normalFont,
        fontWeight: FontWeight.w500,
      ),
      CustomText(
          text: label, fontColor: AppColors.gray, fontSize: resUI?.normalFont),
    ],
  );
}

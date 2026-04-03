import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:weatherapp/controllers/map_controller.dart';
import 'package:weatherapp/core/routes/app_routes.dart';
import 'package:weatherapp/core/widgets/custom_text.dart';

import '../controllers/home_controller.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/responsive helperclass.dart';
import '../core/widgets/customContainer.dart';
import '../core/widgets/custom_search.dart';

class MapScreen extends StatefulWidget {
  MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final AppMapController mapCtrl = Get.put(AppMapController());
  final WeatherController controller = Get.find<WeatherController>();

  @override
  Widget build(BuildContext context) {
    final resUI = AppSize(context);
    bool isLandscap = context.isLandscape;
    return Scaffold(
      body: SafeArea(
        left: !isLandscap,
        top: !isLandscap,
        right: !isLandscap,
        bottom: !isLandscap,
        child: Padding(
          padding: EdgeInsets.all(16.dg),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ૧. સર્ચ બાર (આખી જગ્યા રોકશે પણ લિમિટમાં)
                  Expanded(
                    flex: context.isLandscape
                        ? 7
                        : 8, // લેન્ડસ્કેપમાં ૭ ભાગ, પોટ્રેટમાં ૮
                    child: CustomContainer(
                      borderRadius: resUI.borderRadius,
                      defaultGradient: false,
                      color: AppColors.white.withOpacity(0.3),
                      child: Obx(
                        () => Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.dg, vertical: 3.dg),
                          child: CustomSearch(
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
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                      width: 8
                          .w), // થોડી વધારે જગ્યા આપવી (લેન્ડસ્કેપ માટે સારી લાગે)

                  // ૨. હોમ બટન (રેપ વિથ ઇન્ટ્રિન્સિક અથવા ફિક્સ્ડ પેડિંગ)
                  CustomContainer(
                    borderRadius: resUI.borderRadius,
                    defaultGradient: false,
                    color: AppColors.white.withOpacity(0.3),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () => Get.toNamed(AppRoutes.home),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          // લેન્ડસ્કેપમાં વર્ટિકલ પેડિંગ થોડું ઘટાડવું કારણ કે હાઈટ ઓછી હોય છે
                          horizontal: 15.dg,
                          vertical: context.isLandscape ? 4.dg : 15.dg,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "Home",
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: Colors.deepOrange,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: FlutterMap(
                    mapController: mapCtrl.mapControllerImpl,
                    options: MapOptions(
                      onMapReady: () {
                        mapCtrl.isMapReady.value = true;
                      },
                      initialCenter: LatLng(
                        28.6139,
                        77.2090,
                      ), // LatLng(lat, long)
                      initialZoom: 12,
                      onTap: (tapPosition, point) {
                        print(
                          "Map Tapped at: ${point.latitude}, ${point.longitude}",
                        ); // આ પ્રિન્ટ થાય છે કે નહીં તે ચેક કરો
                        mapCtrl.handleMapOnTap(point);
                      },
                    ),
                    children: [
                      // 1. મેપના લેયર (Tiles) બતાવવા માટે (OpenStreetMap)
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.your.app.weather',
                      ),
                      Obx(() => MarkerLayer(markers: mapCtrl.markers.value)),
                      // 2. તમારા કંટ્રોલરમાંથી માર્કર્સ બતાવવા માટે
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

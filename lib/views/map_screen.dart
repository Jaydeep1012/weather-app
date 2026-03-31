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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
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
                  SizedBox(width: 5.w),
                  CustomContainer(
                    height: 40.h,
                    width: 60.w,
                    borderRadius: 10.r,
                    defaultGradient: false,
                    color: AppColors.white.withOpacity(0.3),

                    child: InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.home);
                      },
                      child: Center(
                        child: CustomText(
                          text: "Home",
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: Colors.deepOrange,
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
                        userAgentPackageName: 'com.your.app.weatherapp',
                      ),

                      // 2. તમારા કંટ્રોલરમાંથી માર્કર્સ બતાવવા માટે
                      Obx(() => MarkerLayer(markers: mapCtrl.markers.value)),
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

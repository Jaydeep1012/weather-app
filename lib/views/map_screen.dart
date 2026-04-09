import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:weatherapp/controllers/map_controller.dart';
import 'package:weatherapp/core/routes/app_routes.dart';
import 'package:weatherapp/core/widgets/custom_text.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/responsive helperclass.dart';
import '../core/widgets/customContainer.dart';
import '../core/widgets/custom_search.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final mapCtrl = AppMapController.to;

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
                  Expanded(
                    flex: context.isLandscape ? 7 : 8,
                    child: CustomContainer(
                      borderRadius: resUI.borderRadius,
                      defaultGradient: false,
                      color: AppColors.white.withOpacity(0.3),
                      child: Obx(
                        () => Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.dg, vertical: 3.dg),
                          child: CustomSearch(
                            textEditingController:
                                mapCtrl.weatherCtrl.searchController,
                            hintText: "search Location",
                            prefixIcon: Icons.search,
                            suffixIcon:
                                mapCtrl.weatherCtrl.searchQuery.value.isNotEmpty
                                    ? Icons.close
                                    : null,
                            onTap: () => mapCtrl.weatherCtrl.clearSearch(),
                            onChange: (v) =>
                                mapCtrl.weatherCtrl.searchQuery.value = v,
                            onSubmit: (value) =>
                                mapCtrl.weatherCtrl.searchByCity(value),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.search,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  CustomContainer(
                    borderRadius: resUI.borderRadius,
                    defaultGradient: false,
                    color: AppColors.white.withOpacity(0.3),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () => Get.toNamed(AppRoutes.home),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
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
                              fontColor: Colors.deepOrange,
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
                    mapController: mapCtrl.mapController,
                    options: MapOptions(
                      onMapReady: () {
                        mapCtrl.isMapReady.value = true;
                      },
                      initialCenter: LatLng(
                        mapCtrl.locationCtrl.latitude.value!,
                        mapCtrl.locationCtrl.longitude.value!,
                      ), // LatLng(lat, long)
                      initialZoom: 12,
                      onTap: (tapPosition, point) {
                        print(
                          "Map Tapped at: ${point.latitude}, ${point.longitude}",
                        );
                        mapCtrl.handleMapOnTap(point);
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.your.app.weather',
                      ),
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

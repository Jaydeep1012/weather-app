import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weatherapp/core/widgets/custom_icon.dart';
import 'package:weatherapp/core/widgets/custom_weatherScaffold.dart';

import '../controllers/segment_controller.dart';
import '../models/weatherModel.dart';

class SegmentView extends GetView<SegmentController> {
  const SegmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return WeatherScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Obx(
          () => Text(
            "${controller.titleBar.value} Weather Details",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: controller.obx(
        (data) => SafeArea(
          child: Column(
            children: [
              SizedBox(height: 10.h),

              // ૧. સેગમેન્ટ ટેબ્સ
              SizedBox(
                height: 55.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Obx(
                    () => CustomSlidingSegmentedControl<int>(
                      initialValue: controller.selectedSegment.value,
                      children: {
                        0: _buildTab(label: "2 Hour"),
                        1: _buildTab(label: "4 Hour"),
                        2: _buildTab(label: "6 Hour"),
                        3: _buildTab(label: "8 Hour"),
                        4: _buildTab(label: "12 Hour"),
                      },
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      thumbDecoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      onValueChanged: (v) {
                        // સેગમેન્ટ બદલાય ત્યારે કંટ્રોલરને અપડેટ કરો
                        controller.updateSegment(v);
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              // ૨. ફિલ્ટર થયેલું લિસ્ટવ્યુ
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 20.h),
                  // 'data' ની લંબાઈ ઓટોમેટિકલી બદલાશે
                  itemCount: data?.length ?? 0,
                  itemBuilder: (context, index) {
                    // લિસ્ટમાંથી એક આઈટમ મેળવો
                    final HourlyItem item = data![index];
                    return _buildForecastCard(item, index);
                  },
                ),
              ),
            ],
          ),
        ),
        // લોડિંગ સ્ટેટ માટે
        onLoading: Center(child: CircularProgressIndicator()),
        // એરર સ્ટેટ માટે
        onError: (error) => Text(error ?? "કંઈક ખોટું થયું"),
        // ખાલી સ્ટેટ માટે (જો change(data, status: RxStatus.empty()) કોલ થાય)
        onEmpty: Text("કોઈ ડેટા ઉપલબ્ધ નથી"),
      ),
    );
  }

  // ટેબ વીજેટ બનાવવા માટેનું સાદું ફંક્શન
  Widget _buildTab({required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Center(
        child: Text(
          label,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ૩. લિસ્ટ આઈટમ માટે પ્રોફેશનલ કાર્ડ (તમારું કોમન વીજેટ)
  Widget _buildForecastCard(HourlyItem getHour, int index) {
    final condition = controller.itemConditions[index];

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        contentPadding: EdgeInsets.all(12.w),
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: CustomImage(imagePath: condition?.imagePath ?? ""),
        ),
        title: Text(
          "${getHour.temperature2M}°C",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Humidity: ${getHour.relativeHumidity2M}%"),
            Text(
              getHour.fullDateTime,
              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

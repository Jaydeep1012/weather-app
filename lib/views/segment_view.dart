import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weatherapp/core/constants/app_colors.dart';
import 'package:weatherapp/core/constants/image_assets.dart';
import 'package:weatherapp/core/utils/responsive%20helperclass.dart';
import 'package:weatherapp/core/widgets/custom_icon.dart';
import 'package:weatherapp/core/widgets/custom_text.dart';
import 'package:weatherapp/core/widgets/custom_weatherScaffold.dart';

import '../controllers/segment_controller.dart';
import '../models/weatherModel.dart';

class SegmentView extends GetView<SegmentController> {
  const SegmentView({super.key});

  @override
  Widget build(BuildContext context) {
    ///    final controller = SegmentController.to;
    final resUI = AppSize(context);

    return WeatherScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Obx(
          () => Text(
            "${controller.titleBar.value} Weather",
            style: TextStyle(
              fontSize: resUI.normalFont,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: controller.obx(
        (data) => SafeArea(
          child: Column(
            children: [
              _buildSegmentSection(resUI),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      EdgeInsets.symmetric(vertical: 10.dg, horizontal: 5.dg),
                  itemCount: data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return _buildForecastCard(data![index], index, resUI);
                  },
                ),
              ),
            ],
          ),
        ),
        onLoading: const Center(child: CircularProgressIndicator()),
        onError: (error) =>
            Center(child: Text(error ?? "Something went wrong")),
        onEmpty: const Center(child: Text("No weather data found")),
      ),
    );
  }

  Widget _buildSegmentSection(
    AppSize resUI,
  ) {
    /// final controller = SegmentController.to;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.dg, vertical: 5.dg),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(resUI.borderRadius ?? 12.dg),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Obx(
            () => CustomSlidingSegmentedControl<int>(
              key: ValueKey(resUI.isLandscape),
              fixedWidth: resUI.segmentWidth,
              initialValue: controller.selectedSegment.value,
              children: {
                0: _buildTab(label: "2 Hour", res: resUI),
                1: _buildTab(label: "4 Hour", res: resUI),
                2: _buildTab(label: "6 Hour", res: resUI),
                3: _buildTab(label: "8 Hour", res: resUI),
                4: _buildTab(label: "12 Hour", res: resUI),
              },
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius:
                    BorderRadius.circular(resUI.borderRadius ?? 12.dg),
              ),
              thumbDecoration: BoxDecoration(
                color: AppColors.prim,
                borderRadius:
                    BorderRadius.circular(resUI.borderRadius ?? 12.dg),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              onValueChanged: (v) => controller.updateSegment(v),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab({required String label, required AppSize res}) {
    return Container(
      width: res.segmentWidth,
      height: res.isLandscape ? 40.dg : 50.dg,
      alignment: Alignment.center,
      child: CustomText(
        text: label,
        maxLine: 1,
        fontSize: res.isLandscape ? 12.sp : 16.sp,
        fontWeight: FontWeight.bold,
        fontColor: AppColors.black,
        softWrap: false,
        textOverflow: TextOverflow.clip,
      ),
    );
  }

  Widget _buildForecastCard(HourlyItem item, int index, AppSize resUI) {
    ///  final controller = SegmentController.to;
    final res = resUI;
    final condition = controller.itemConditions[index];

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10.dg, vertical: 6.dg),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(res.borderRadius ?? 12.dg),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.dg, vertical: 8.dg),
        leading: Container(
          padding: EdgeInsets.all(8.dg),
          decoration: BoxDecoration(
            color: AppColors.prim.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: CustomImage(
            imagePath: condition?.imagePath ?? ImageAssets.byDefault,
            height: res.weatherImg,
            width: res.weatherImg,
          ),
        ),
        title: Text(
          "${item.temperature2M}°C",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: res.normalFont,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 4.dg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Humidity: ${item.relativeHumidity2M}%",
                fontSize: res.normalFont! * 0.9,
                fontColor: Colors.grey.shade700,
              ),
              Text(
                item.fullDateTime,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: res.normalFont! * 0.8,
                ),
              ),
            ],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: res.iconSize,
          color: Colors.grey,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/core/ui/widgets/loading/text_loading_widget.dart';
import 'package:posto360/core/ui/widgets/select_date_widget.dart';
import 'package:posto360/modules/dash/dash_controller.dart';

class DashboardSectionHeaderWidget extends GetView<DashController> {
  const DashboardSectionHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() {
          return TextLoadingWidget(
            isLoading: controller.isLoading,
            height: 30,
            width: 90,
            child: Text(
              'Dashboard',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: PostoAppUiConfigurations.textDarkColor,
              ),
            ),
          );
        }),
        Obx(() {
          return SelectDateWidget(
            hideBackground: true,
            nextMonthPressed: controller.nextMonth,
            period: controller.monthSelected,
            hasNextMonth: controller.hasNextMonth,
            prevMonthPressed: controller.prevMonth,
          );
        }),
      ],
    );
  }
}

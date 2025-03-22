import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/dash/dash_controller.dart';

class DashboardSectionHeaderWidget extends GetView<DashController> {
  const DashboardSectionHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: PostoAppUiConfigurations.textDarkColor,
          ),
        ),
        // SelectDateWidget(),
      ],
    );
  }
}

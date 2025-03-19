import 'package:flutter/material.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/dash/widgets/select_date_dashboard_widget.dart';

class DashboardSectionHeaderWidget extends StatelessWidget {
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
        SelectDateDashboardWidget(),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';

class SelectDateDashboardWidget extends StatelessWidget {
  const SelectDateDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.calendar_month_outlined,
          color: PostoAppUiConfigurations.blueMediumColor,
          size: 20,
        ),
        Text(
          'Período: ',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
        Text(
          '01/01/25 - 12/01/25',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        Icon(Icons.keyboard_arrow_down_outlined),
      ],
    );
  }
}

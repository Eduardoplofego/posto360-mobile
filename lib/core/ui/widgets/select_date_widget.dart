import 'package:flutter/material.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';

class SelectDateWidget extends StatelessWidget {
  final bool withBackground;
  final bool extendBody;
  final String period;
  const SelectDateWidget({
    super.key,
    this.withBackground = false,
    this.extendBody = false,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: withBackground ? EdgeInsets.all(14) : null,
      decoration:
          withBackground
              ? BoxDecoration(
                color: PostoAppUiConfigurations.lightPurpleColor,
                borderRadius: BorderRadius.circular(10),
              )
              : null,
      child: Row(
        children: [
          Icon(
            Icons.calendar_month_outlined,
            color: PostoAppUiConfigurations.blueMediumColor,
            size: 22,
          ),
          const SizedBox(width: 5),
          Text(
            'Período: ',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          Text(
            period,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          extendBody ? Spacer() : const SizedBox.shrink(),
          Icon(Icons.keyboard_arrow_down_outlined),
        ],
      ),
    );
  }
}

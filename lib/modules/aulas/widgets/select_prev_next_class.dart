import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';

class SelectPrevNextClass extends StatelessWidget {
  final VoidCallback? prevClass;
  final VoidCallback? nextClass;
  const SelectPrevNextClass({
    super.key,
    required this.prevClass,
    required this.nextClass,
  });

  @override
  Widget build(BuildContext context) {
    bool hasPrev = prevClass != null;
    bool hasNext = nextClass != null;
    return Container(
      height: 65,
      width: Get.width,
      color: PostoAppUiConfigurations.blueLightColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.chevron_left_rounded,
                color: hasPrev ? Colors.white : Colors.white54,
              ),
              Text(
                'Anterior',
                style: TextStyle(
                  color: hasPrev ? Colors.white : Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Próximo',
                style: TextStyle(
                  color: hasNext ? Colors.white : Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: hasNext ? Colors.white : Colors.white54,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

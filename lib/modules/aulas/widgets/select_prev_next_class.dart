import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      width: Get.width,
      padding: EdgeInsets.symmetric(vertical: 16),
      color: Color(0xFF2051E5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: prevClass,
            child: Row(
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
          ),
          InkWell(
            onTap: nextClass,
            child: Row(
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
          ),
        ],
      ),
    );
  }
}

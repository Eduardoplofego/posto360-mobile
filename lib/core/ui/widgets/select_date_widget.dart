import 'package:flutter/material.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/core/utils/data_formatters.dart';

class SelectDateWidget extends StatelessWidget {
  final Function(DateTime) nextMonthPressed;
  final Function(DateTime) prevMonthPressed;
  final DateTime period;
  final bool hasNextMonth;
  const SelectDateWidget({
    super.key,
    required this.nextMonthPressed,
    required this.period,
    required this.hasNextMonth,
    required this.prevMonthPressed,
  });

  void previouslyMonth() {
    final prev = period.month - 1;
    prevMonthPressed(DateTime(period.year, prev, 1));
  }

  void nextMonth() {
    if (hasNextMonth) {
      final nextMonth = period.month + 1;
      nextMonthPressed(DateTime(period.year, nextMonth, 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: previouslyMonth,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: PostoAppUiConfigurations.lightPurpleColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.chevron_left_rounded),
            ),
          ),
          Text(DataFormatters.formatarDataExtensoComAno(period)),
          InkWell(
            onTap: nextMonth,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: PostoAppUiConfigurations.lightPurpleColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.chevron_right_rounded,
                color: !hasNextMonth ? Colors.grey.shade400 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

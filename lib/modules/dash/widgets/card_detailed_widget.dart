import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/dash/widgets/button_card_widget.dart';

class CardDetailedWidget extends StatelessWidget {
  final IconData icon;
  final int totalNumber;
  final String title;
  final bool isGoodPerformance;
  final int totalNumberDetailed;
  final String totalNumberDetailedText;
  final String totalTakeNumberDetailedText;
  final VoidCallback? onPressed;

  const CardDetailedWidget({
    super.key,
    required this.icon,
    required this.totalNumber,
    required this.title,
    required this.isGoodPerformance,
    required this.totalNumberDetailed,
    required this.totalNumberDetailedText,
    required this.totalTakeNumberDetailedText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final percentTaked = totalNumber / totalNumberDetailed;
    // TODO: pesquisar icons exatos
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(
        top: 20,
        right: onPressed != null ? 0 : 16,
        left: 16,
        bottom: onPressed != null ? 0 : 20,
      ),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.lightPurpleColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            color: PostoAppUiConfigurations.blueMediumColor,
                          ),
                        ),
                        Text(
                          totalNumber.toString(),
                          style: TextStyle(fontSize: 38),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Row(
                      spacing: 7,
                      children: [
                        Text(title, style: TextStyle(fontSize: 16)),
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color:
                                isGoodPerformance
                                    ? Color(0xFF97CE71)
                                    : Color.fromARGB(255, 195, 153, 153),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.transparent),
                          ),
                          child: Icon(
                            isGoodPerformance
                                ? Icons.trending_up_outlined
                                : Icons.trending_down_outlined,
                            size: 12,
                            color:
                                isGoodPerformance
                                    ? Color(0xFF43900C)
                                    : Color(0xFF900C0C),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    Row(
                      spacing: 6,
                      children: [
                        CircleAvatar(radius: 4, backgroundColor: Colors.blue),
                        Text('$totalNumberDetailed $totalNumberDetailedText'),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      spacing: 6,
                      children: [
                        CircleAvatar(radius: 4, backgroundColor: Colors.orange),
                        Text('$totalNumber $totalTakeNumberDetailedText'),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: onPressed != null ? 16 : 0),
                  child: Center(
                    child: CircularPercentIndicator(
                      radius: 50,
                      lineWidth: 10,
                      percent: percentTaked,
                      animation: true,
                      center: Text(
                        '${(percentTaked * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 20,
                          color: PostoAppUiConfigurations.blueMediumColor,
                        ),
                      ),
                      progressColor: PostoAppUiConfigurations.orangeColor,
                      backgroundColor: PostoAppUiConfigurations.blueMediumColor,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  ),
                ),
              ),
            ],
          ),
          onPressed != null ? ButtonCardWidget() : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

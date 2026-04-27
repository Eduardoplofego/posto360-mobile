import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/dash/widgets/button_card_widget.dart';

class CardDetailedWidget extends StatelessWidget {
  final IconData icon;
  final int totalNumber;
  final String title;
  final int totalNumberDetailed;
  final double penalidade;
  final String totalNumberDetailedText;
  final String totalTakeNumberDetailedText;
  final VoidCallback? onPressed;
  final bool hideNumberDetailed;
  final bool hideTrendingDetail;
  final bool trendingUp;

  const CardDetailedWidget({
    super.key,
    required this.icon,
    required this.totalNumber,
    required this.title,
    required this.penalidade,
    required this.totalNumberDetailed,
    required this.totalNumberDetailedText,
    required this.totalTakeNumberDetailedText,
    this.hideNumberDetailed = false,
    this.onPressed,
    this.hideTrendingDetail = false,
    this.trendingUp = false,
  });

  @override
  Widget build(BuildContext context) {
    final percentTaked = 1 - (penalidade.abs() / 10);
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(
        top: 10,
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
                            size: 30,
                          ),
                        ),
                        Text(
                          totalNumber.toString(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    Row(
                      spacing: 7,
                      children: [
                        SizedBox(
                          width: 140,
                          child: Text(title, style: TextStyle(fontSize: 14)),
                        ),
                        !hideTrendingDetail
                            ? Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color:
                                    !trendingUp
                                        ? Color.fromARGB(255, 195, 153, 153)
                                        : Color(0xFF97CE71),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.transparent),
                              ),
                              child: Icon(
                                !trendingUp
                                    ? Icons.trending_down_outlined
                                    : Icons.trending_up_outlined,
                                size: 12,
                                color:
                                    !trendingUp
                                        ? Color(0xFF900C0C)
                                        : Color(0xFF43900C),
                              ),
                            )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    const SizedBox(height: 17),
                    Row(
                      spacing: 6,
                      children: [
                        CircleAvatar(radius: 4, backgroundColor: Colors.blue),
                        Text(
                          '${!hideNumberDetailed ? totalNumberDetailed : ''} $totalNumberDetailedText',
                          style: TextStyle(fontSize: 12, color: Colors.black38),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      spacing: 6,
                      children: [
                        CircleAvatar(radius: 4, backgroundColor: Colors.orange),
                        Text(
                          '${!hideNumberDetailed ? totalNumber : ''} $totalTakeNumberDetailedText',
                          style: TextStyle(fontSize: 12, color: Colors.black38),
                        ),
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
                      percent: 1 - percentTaked.toDouble(),
                      animation: true,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            penalidade.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 18,
                              color: PostoAppUiConfigurations.orangeColor,
                            ),
                          ),
                          Text(
                            'Penalidade',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black38,
                            ),
                          ),
                        ],
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
          onPressed != null
              ? ButtonCardWidget(onPressed: onPressed!)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

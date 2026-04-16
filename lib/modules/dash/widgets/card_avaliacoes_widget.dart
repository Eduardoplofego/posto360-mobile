import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/dash/widgets/button_card_widget.dart';

class CardAvaliacoesWidget extends StatelessWidget {
  final int feitas;
  final int total;
  final double penalidade;
  final VoidCallback? onPressed;

  const CardAvaliacoesWidget({
    super.key,
    required this.onPressed,
    required this.total,
    required this.feitas,
    required this.penalidade,
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
                            Icons.playlist_add_check_rounded,
                            color: PostoAppUiConfigurations.blueMediumColor,
                            size: 30,
                          ),
                        ),
                        Text(
                          '$total',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    Row(
                      children: [
                        SizedBox(
                          width: 140,
                          child: Text(
                            'Avaliações',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(right: 16, bottom: 12),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                spacing: 6,
                                children: [
                                  CircleAvatar(
                                    radius: 4,
                                    backgroundColor: Colors.blue,
                                  ),
                                  Text(
                                    'Total de avaliações: $total',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                spacing: 6,
                                children: [
                                  CircleAvatar(
                                    radius: 4,
                                    backgroundColor: Colors.orange,
                                  ),
                                  Text(
                                    'Avaliações feitas: $feitas',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
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
                            (penalidade).toStringAsFixed(2),
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

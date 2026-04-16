import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/dash/domain/models/horario_faltas_model.dart';
import 'package:posto360/modules/dash/widgets/button_card_widget.dart';

class CardRhWidget extends StatelessWidget {
  final HorarioFaltasModel model;
  final VoidCallback onPressed;
  const CardRhWidget({super.key, required this.model, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final percentTaked = 1 - (model.penalidade.abs() / 10);
    final totalFaltas = model.faltasInjustificadas + model.faltasPonto;
    final totalAtrasos =
        model.atrasosGrave + model.atrasosMedio + model.atrasosLeve;
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(top: 10, right: 0, left: 16, bottom: 0),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.lightPurpleColor,
        borderRadius: BorderRadius.circular(15),
      ),
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
                  Icons.person,
                  color: PostoAppUiConfigurations.blueMediumColor,
                  size: 30,
                ),
              ),
              Text(
                'Faltas: $totalFaltas | Atrasos: ${totalAtrasos.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 140,
                          child: Text(
                            'Faltas e atrasos',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
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
                                    'Falta injustificada: ${model.faltasInjustificadas}',
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
                                    'Falta de ponto: ${model.faltasPonto}',
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
                                    backgroundColor: Colors.blue,
                                  ),
                                  Text(
                                    'Atrasos graves: ${model.atrasosGrave.toStringAsFixed(2)}',
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
                                    'Atrasos médios: ${model.atrasosMedio.toStringAsFixed(2)}',
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
                                    'Atrasos leves: ${model.atrasosLeve.toStringAsFixed(2)}',
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
                            model.penalidade.toStringAsFixed(2),
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
          ButtonCardWidget(onPressed: onPressed),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/registro_pontos/domain/models/ponto_timeline_model.dart';
import 'package:posto360/modules/registro_pontos/domain/models/pontos_model.dart';
import 'package:posto360/modules/registro_pontos/widgets/ponto_badge_widget.dart';

class PontoCardWidget extends StatelessWidget {
  final PontosModel model;
  const PontoCardWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final dayMonth = DateFormat('dd/MM', 'pt_BR').format(model.data);
    final weekDay = DateFormat('EEEE', 'pt_BR').format(model.data);
    final isCompleted =
        model.pontos[0].isNotEmpty && model.pontos[2].isNotEmpty;

    final ponto1 = model.pontos[0];
    final ponto2 = model.pontos[1];
    final ponto3 = model.pontos[2];
    final ponto4 = model.pontos[3];

    final pontoItems = [
      PontoBadgeWidget(
        model: PontoTimelineModel(
          ponto: ponto1,
          icon: Icons.login,
          text: 'Entrada 1',
        ),
      ),
      PontoBadgeWidget(
        model: PontoTimelineModel(
          ponto: ponto2,
          icon: Icons.coffee,
          text: 'Saída 2',
        ),
      ),
      PontoBadgeWidget(
        model: PontoTimelineModel(
          ponto: ponto3,
          icon: Icons.start,
          text: 'Entrada 2',
        ),
      ),
      PontoBadgeWidget(
        model: PontoTimelineModel(
          ponto: ponto4,
          icon: Icons.logout,
          text: 'Saída 2',
        ),
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 23, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFECECEC)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    dayMonth,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: PostoAppUiConfigurations.textDarkColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    weekDay[0].toUpperCase() + weekDay.substring(1),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: PostoAppUiConfigurations.darkGreyColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      isCompleted ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isCompleted ? Colors.green : Colors.red,
                  ),
                ),
                child: Text(
                  isCompleted ? 'Completo' : 'Incompleto',
                  style: TextStyle(
                    fontSize: 8,
                    color:
                        isCompleted
                            ? Colors.green.shade800
                            : Colors.red.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _timeline(pontoItems),
              _totalWorkDay(model.getTotalWorkHours()),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _totalWorkDay(String totalTime) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('Total', style: TextStyle(fontSize: 12)),
        Text(
          totalTime,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

Widget _timeline(List<PontoBadgeWidget> items) {
  return Row(
    children: [
      items[0],
      _timelineDivider(),
      items[1],
      _timelineDivider(),
      items[2],
      _timelineDivider(),
      items[3],
    ],
  );
}

Widget _timelineDivider() {
  return Row(
    children: [
      SizedBox(width: 20, child: Divider(thickness: 2)),
      const SizedBox(width: 2),
    ],
  );
}

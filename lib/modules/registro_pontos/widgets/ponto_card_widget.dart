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

    final pontoItems =
        model.pontos.asMap().entries.map((entry) {
          final index = entry.key;
          final ele = entry.value;

          final sanitizedEle = ele.replaceAll(RegExp(r'[^\d:]'), '');

          final timeParts = sanitizedEle.split(':');

          final hour = int.tryParse(timeParts[0]);
          final minute = int.tryParse(timeParts[1]);

          final pontoDateTime = DateTime(
            model.data.year,
            model.data.month,
            model.data.day,
            hour ?? 0,
            minute ?? 0,
          );

          return PontoBadgeWidget(
            model: PontoTimelineModel(
              ponto: pontoDateTime,
              icon: switch (index) {
                0 => Icons.login,
                1 => Icons.coffee,
                2 => Icons.start,
                _ => Icons.logout,
              },
              text: switch (index) {
                0 => 'Entrada 1',
                1 => 'Saída 1',
                2 => 'Entrada 2',
                _ => 'Saída 2',
              },
            ),
          );
        }).toList();

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

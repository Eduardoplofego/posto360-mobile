import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/registro_pontos/domain/models/penalidade_model.dart';
import 'package:posto360/modules/registro_pontos/domain/models/ponto_timeline_model.dart';
import 'package:posto360/modules/registro_pontos/domain/models/pontos_model.dart';
import 'package:posto360/modules/registro_pontos/widgets/ponto_badge_widget.dart';

String _tipoLabel(String tipo) =>
    tipo == 'Falta de ponto' ? 'Registro incompleto' : tipo;

class PontoCardWidget extends StatelessWidget {
  final PontosModel model;
  final DiaPenalidades penalidades;
  const PontoCardWidget({
    super.key,
    required this.model,
    required this.penalidades,
  });

  @override
  Widget build(BuildContext context) {
    final dayMonth = DateFormat('dd/MM', 'pt_BR').format(model.data);
    final weekDay = DateFormat('EEEE', 'pt_BR').format(model.data);
    final hasPenalidade = penalidades.hasPenalidade;

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.lightGreyBgColor,
        borderRadius: BorderRadius.circular(15),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 4,
                children:
                    hasPenalidade
                        ? (penalidades.porTipo.entries.toList()
                              ..sort((a, b) => a.value.compareTo(b.value)))
                            .map(
                              (e) => _PenalidadeBadge(
                                label: _tipoLabel(e.key),
                                valor: e.value,
                                isPenalidade: true,
                              ),
                            )
                            .toList()
                        : [
                          _PenalidadeBadge(
                            label: 'OK',
                            valor: 0,
                            isPenalidade: false,
                          ),
                        ],
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

class _PenalidadeBadge extends StatelessWidget {
  final String label;
  final double valor;
  final bool isPenalidade;

  const _PenalidadeBadge({
    required this.label,
    required this.valor,
    required this.isPenalidade,
  });

  @override
  Widget build(BuildContext context) {
    final fg = isPenalidade ? Colors.red.shade800 : Colors.green.shade800;
    final bg = isPenalidade ? Colors.red.shade100 : Colors.green.shade100;
    final border = isPenalidade ? Colors.red : Colors.green;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 9, color: fg)),
          const SizedBox(width: 6),
          Text(
            valor.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

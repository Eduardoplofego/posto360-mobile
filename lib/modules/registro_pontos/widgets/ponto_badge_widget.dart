import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/registro_pontos/domain/models/ponto_timeline_model.dart';

class PontoBadgeWidget extends StatelessWidget {
  final PontoTimelineModel model;
  const PontoBadgeWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    // final hour = model.ponto.hour.toString().padLeft(2, '0');
    // final minute = model.ponto.minute.toString().padLeft(2, '0');
    // final pontoText = '$hour:$minute';
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
          ),
          child: Icon(model.icon, color: Colors.grey.shade500, size: 16),
        ),
        const SizedBox(height: 4),
        Text(
          model.ponto,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        Text(
          model.text,
          style: TextStyle(
            fontSize: 10,
            color: PostoAppUiConfigurations.darkGreyColor,
          ),
        ),
      ],
    );
  }
}

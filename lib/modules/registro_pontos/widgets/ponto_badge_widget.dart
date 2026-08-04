import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/registro_pontos/domain/models/ponto_timeline_model.dart';

class PontoBadgeWidget extends StatelessWidget {
  final PontoTimelineModel model;
  const PontoBadgeWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final batida = model.ponto;
    final hasMarcador = batida.hasMarcador;
    final destaque = PostoAppUiConfigurations.orangeColor;

    return Tooltip(
      message: hasMarcador ? '${model.text}: ${batida.marcadorDescricao}' : '',
      triggerMode:
          hasMarcador ? TooltipTriggerMode.tap : TooltipTriggerMode.manual,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  hasMarcador
                      ? destaque.withValues(alpha: 0.15)
                      : Colors.grey.shade200,
              border:
                  hasMarcador ? Border.all(color: destaque, width: 1) : null,
            ),
            child: Icon(
              model.icon,
              color: hasMarcador ? destaque : Colors.grey.shade500,
              size: 16,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                batida.hora,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              if (hasMarcador) ...[
                const SizedBox(width: 2),
                Text(
                  batida.marcadorSigla,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                    color: destaque,
                  ),
                ),
              ],
            ],
          ),
          Text(
            model.text,
            style: TextStyle(
              fontSize: 10,
              color: PostoAppUiConfigurations.darkGreyColor,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/dash/widgets/button_card_widget.dart';
import 'package:posto360/modules/equipe/domain/models/resumo_equipe_model.dart';

class CardResumoEquipeWidget extends StatelessWidget {
  final ResumoEquipeModel resumo;
  final VoidCallback? onPressed;

  const CardResumoEquipeWidget({
    super.key,
    required this.resumo,
    this.onPressed,
  });

  Color _notaColor() {
    if (resumo.mediaEquipe >= 8) return Colors.green.shade700;
    if (resumo.mediaEquipe >= 6) return PostoAppUiConfigurations.orangeColor;
    return Colors.red.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(
        top: 14,
        right: onPressed != null ? 0 : 16,
        left: 16,
        bottom: onPressed != null ? 0 : 20,
      ),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.lightGreyBgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.groups_2_outlined,
                  color: PostoAppUiConfigurations.blueMediumColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Performance da equipe',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${resumo.numeroUsuariosEquipe} colaboradores',
                      style: TextStyle(
                        fontSize: 12,
                        color: PostoAppUiConfigurations.greyColor,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  resumo.mediaEquipe.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 24,
                    color: _notaColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Padding(
            padding: EdgeInsets.only(right: onPressed != null ? 16 : 0),
            child: Row(
              children: [
                const Text(
                  'Penalidade do gerente',
                  style: TextStyle(fontSize: 13),
                ),
                const Spacer(),
                Text(
                  resumo.penalidade.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 14,
                    color: resumo.penalidade < 0
                        ? Colors.red.shade700
                        : PostoAppUiConfigurations.blueMediumColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          onPressed != null
              ? ButtonCardWidget(onPressed: onPressed!)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

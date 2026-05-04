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

  @override
  Widget build(BuildContext context) {
    final hasButton = onPressed != null;
    final colaboradoresLabel = resumo.numeroUsuariosEquipe == 1
        ? 'Total de colaboradores: 1'
        : 'Total de colaboradores: ${resumo.numeroUsuariosEquipe}';
    return Container(
      width: Get.width,
      padding: EdgeInsets.fromLTRB(16, 12, hasButton ? 0 : 16, hasButton ? 0 : 16),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.lightGreyBgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: hasButton ? 16 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10,
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
                        size: 30,
                      ),
                    ),
                    Text(
                      resumo.numeroUsuariosEquipe.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Performance da equipe',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: PostoAppUiConfigurations.textDarkColor,
                  ),
                ),
                const SizedBox(height: 12),
                _BulletItem(color: Colors.blue, label: colaboradoresLabel),
                const SizedBox(height: 6),
                _BulletItem(
                  color: Colors.orange,
                  label:
                      'Nota média da equipe: ${resumo.mediaEquipe.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 12),
                Divider(height: 1, color: Colors.black12),
                const SizedBox(height: 10),
                _PenalidadeRow(valor: resumo.penalidade),
              ],
            ),
          ),
          if (hasButton) ...[
            const SizedBox(height: 12),
            ButtonCardWidget(onPressed: onPressed!),
          ],
        ],
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final Color color;
  final String label;

  const _BulletItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6,
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}

class _PenalidadeRow extends StatelessWidget {
  final double valor;

  const _PenalidadeRow({required this.valor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Penalidade do gerente',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const Spacer(),
        Text(
          valor.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: valor < 0
                ? Colors.red.shade700
                : PostoAppUiConfigurations.textDarkColor,
          ),
        ),
      ],
    );
  }
}

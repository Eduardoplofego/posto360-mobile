import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class CardResumeWidget extends StatelessWidget {
  final double premioFuncao;
  final double premioCampanhas;
  final double penalidades;
  const CardResumeWidget({
    super.key,
    required this.premioFuncao,
    required this.premioCampanhas,
    required this.penalidades,
  });

  Color _notaColor(double nota) {
    if (nota >= 8) return Colors.green.shade700;
    if (nota >= 6) return PostoAppUiConfigurations.orangeColor;
    return Colors.red.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final finalNote = (10 - penalidades.abs()).clamp(0.0, 10.0);
    final maxBonus = premioFuncao + premioCampanhas;
    final premioFinal = maxBonus * (finalNote / 10);
    final notaColor = _notaColor(finalNote);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.lightGreyBgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumo de performance',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Penalidades: ${penalidades.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: penalidades < 0
                        ? Colors.red.shade700
                        : Colors.black54,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Nota final',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: PostoAppUiConfigurations.greyColor,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    finalNote.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: notaColor,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(height: 1, color: Colors.black12),
          const SizedBox(height: 12),
          _LinhaInfo(
            label: 'Prêmio máximo por função',
            valor: UtilBrasilFields.obterReal(premioFuncao),
          ),
          const SizedBox(height: 6),
          _LinhaInfo(
            label: 'Prêmio máximo campanha',
            valor: UtilBrasilFields.obterReal(premioCampanhas),
          ),
          const SizedBox(height: 6),
          _LinhaInfo(
            label: 'Prêmio máximo total',
            valor: UtilBrasilFields.obterReal(maxBonus),
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: Colors.black12),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Prêmio final',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: PostoAppUiConfigurations.textDarkColor,
                ),
              ),
              const Spacer(),
              Text(
                UtilBrasilFields.obterReal(premioFinal),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: PostoAppUiConfigurations.textDarkColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LinhaInfo extends StatelessWidget {
  final String label;
  final String valor;

  const _LinhaInfo({required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

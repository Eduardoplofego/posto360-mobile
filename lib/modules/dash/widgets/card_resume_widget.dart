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

  @override
  Widget build(BuildContext context) {
    final finalNote = 10 - penalidades.abs();
    final maxBonus = premioFuncao + premioCampanhas;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: PostoAppUiConfigurations.lightPurpleColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                Text(
                  'Resumo de performance',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  spacing: 6,
                  children: [
                    CircleAvatar(radius: 4, backgroundColor: Colors.blue),
                    Text(
                      'Prêmio máximo por função: ${UtilBrasilFields.obterReal(premioFuncao)}',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  spacing: 6,
                  children: [
                    CircleAvatar(radius: 4, backgroundColor: Colors.orange),
                    Text(
                      'Prêmio máximo campanha: ${UtilBrasilFields.obterReal(premioCampanhas)}',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  spacing: 6,
                  children: [
                    CircleAvatar(radius: 4, backgroundColor: Colors.blue),
                    Text(
                      'Prêmio máximo total: ${UtilBrasilFields.obterReal(maxBonus)}',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  spacing: 6,
                  children: [
                    CircleAvatar(radius: 4, backgroundColor: Colors.blue),
                    Text(
                      'Nota final: $finalNote',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Divider(),
                Row(
                  children: [
                    Text(
                      'Prêmio final: ${UtilBrasilFields.obterReal(maxBonus * (finalNote / 10))}',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

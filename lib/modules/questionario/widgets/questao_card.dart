import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/questionario/domain/models/questao_model.dart';
import 'package:posto360/modules/questionario/widgets/alternativa_option.dart';

class QuestaoCard extends StatelessWidget {
  final QuestaoModel questao;
  final int? alternativaSelecionada;
  final ValueChanged<int> onSelecionar;

  const QuestaoCard({
    super.key,
    required this.questao,
    required this.alternativaSelecionada,
    required this.onSelecionar,
  });

  @override
  Widget build(BuildContext context) {
    final destacarErro = questao.erradaNaRodadaAnterior;
    final bloqueada = questao.bloqueada;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              bloqueada
                  ? Colors.green.shade300
                  : destacarErro
                  ? Colors.red.shade300
                  : Colors.grey.shade200,
          width: bloqueada || destacarErro ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (bloqueada)
                const Padding(
                  padding: EdgeInsets.only(right: 8, top: 2),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
              Expanded(
                child: Text(
                  questao.enunciado,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PostoAppUiConfigurations.textDarkColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...questao.alternativas.map((alternativa) {
            final selecionada = alternativaSelecionada == alternativa.id;
            final marcadaErrada =
                destacarErro && questao.alternativaMarcadaId == alternativa.id;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AlternativaOption(
                label: alternativa.texto,
                isSelected: selecionada,
                isLocked: bloqueada,
                isWrongPick: marcadaErrada,
                onPressed:
                    bloqueada ? null : () => onSelecionar(alternativa.id),
              ),
            );
          }),
        ],
      ),
    );
  }
}

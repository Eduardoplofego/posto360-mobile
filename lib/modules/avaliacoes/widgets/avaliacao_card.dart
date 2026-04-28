import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/avaliacoes/domain/adapters/color_adapter.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacoes_model.dart';
import 'package:posto360/modules/avaliacoes/widgets/avaliator_widget.dart';
import 'package:posto360/modules/avaliacoes/widgets/penality_presentation_widget.dart';
import 'package:posto360/modules/avaliacoes/widgets/progress_discretions_widget.dart';

class AvaliacaoCard extends StatelessWidget {
  final AvaliacoesModel model;
  const AvaliacaoCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final progress = (model.criteriosCumpridos / model.numeroCriterios) * 100;
    final defaultColor = ColorAdapter.colorByProgressLevel(progress);
    final lighColor = ColorAdapter.lightColorByProgressLevel(progress);
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(model.nome, style: TextStyle(fontWeight: FontWeight.w500)),
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                  color: model.isConcluded ? Colors.blue : Colors.transparent,
                ),
                child: Icon(
                  Icons.check,
                  color: model.isConcluded ? Colors.white : Colors.transparent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            model.descricao,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 12),
          ProgressDiscretionsWidget(
            totaldiscretions: model.numeroCriterios,
            concludedsDiscretions: model.criteriosCumpridos,
            defaultColor: defaultColor,
          ),
          const SizedBox(height: 12),
          PenalityPresentationWidget(
            penality: model.penalidade,
            defaultColor: defaultColor,
            lightColor: lighColor,
          ),
          const SizedBox(height: 12),
          const Divider(height: 0),
          const SizedBox(height: 12),
          AvaliatorWidget(
            name: model.avaliador,
            leadingText: 'Avaliador',
            createdAt:
                model.dataConclusao != null
                    ? UtilData.obterDataDDMMAAAA(model.dataConclusao!)
                    : '-',
          ),
        ],
      ),
    );
  }
}

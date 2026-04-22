import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/campanhas/domain/models/performance_individual_model.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/utils/enums/type_bonificacao.dart';
import 'package:posto360/modules/campanhas/domain/models/campanha_model.dart';
import 'package:posto360/modules/campanhas/domain/models/performance_equipe_model.dart';

class CampanhaCardWidget extends StatelessWidget {
  final CampanhaModel campanha;
  final PerformanceIndividualModel performaceIndividual;
  final PerformanceEquipeModel performaceEquipe;
  const CampanhaCardWidget({
    super.key,
    required this.campanha,
    required this.performaceIndividual,
    required this.performaceEquipe,
  });

  @override
  Widget build(BuildContext context) {
    final totalEquipeCompleted = performaceEquipe.progresso ~/ 100;
    final remainingEquipeProgress =
        (performaceEquipe.progresso - totalEquipeCompleted * 100) as num;

    final totalIndividualCompleted = performaceIndividual.progresso ~/ 100;
    final remainingIndividualProgress =
        (performaceIndividual.progresso - totalIndividualCompleted * 100)
            as num;
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 23, vertical: 26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFECECEC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                campanha.nomeCampanha,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ],
          ),
          if (campanha.descricao != '') ...[
            const SizedBox(height: 6),
            Row(children: [Text(campanha.descricao)]),
          ],
          const SizedBox(height: 6),
          ItemCampanhaDetail(
            titleItem: 'Tipo de Apuração',
            value: Text(campanha.tipoBonificacao.description().toLowerCase()),
          ),
          Divider(color: Color(0xFFECECEC)),
          const SizedBox(height: 6),
          Text('Performance Individual'),
          const SizedBox(height: 8),
          ItemCampanhaDetail(
            titleItem: 'Meta Individual',
            value: Text(
              campanha.tipoBonificacao == TypeBonificacao.unidade
                  ? '${campanha.metaIndividual.toStringAsFixed(0)} unid.'
                  : UtilBrasilFields.obterReal((0).toDouble()),
            ),
          ),
          const SizedBox(height: 6),
          ItemCampanhaDetail(
            titleItem: 'Valor por Meta',
            value: Text(
              UtilBrasilFields.obterReal(campanha.bonificacaoIndividual),
            ),
          ),
          const SizedBox(height: 6),
          ItemCampanhaDetail(
            titleItem: 'Resultado Individual',
            value: Text(
              campanha.tipoBonificacao == TypeBonificacao.unidade
                  ? '${campanha.resultadoIndividual.toStringAsFixed(0)} unid.'
                  : UtilBrasilFields.obterReal(campanha.resultadoIndividual),
            ),
          ),
          const SizedBox(height: 6),
          ItemCampanhaDetail(
            titleItem: 'Premiação Conquistada',
            value: Text(
              UtilBrasilFields.obterReal(
                campanha.bonificacaoIndividualConquistada,
              ),
            ),
          ),
          const SizedBox(height: 6),
          ItemCamapanhaPercentCompletedWidget(
            titleItem: 'Realizado',
            value: '${remainingIndividualProgress.toInt()}%',
            totalPercentCompleted: totalIndividualCompleted,
            dotColor: PostoAppUiConfigurations.blueMediumColor,
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: remainingIndividualProgress.toInt() / 100,
            backgroundColor: Color(0xFFECECEC),
            color: PostoAppUiConfigurations.blueMediumColor,
            minHeight: 11,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 6),
          Divider(color: Color(0xFFECECEC)),
          const SizedBox(height: 6),
          Text('Performance Equipe'),
          const SizedBox(height: 6),
          ItemCampanhaDetail(
            titleItem: 'Meta Equipe',
            value: Text(
              campanha.tipoBonificacao == TypeBonificacao.unidade
                  ? '${campanha.metaEquipe.toStringAsFixed(0)} unid.'
                  : UtilBrasilFields.obterReal(campanha.metaEquipe),
            ),
          ),
          const SizedBox(height: 6),
          ItemCampanhaDetail(
            titleItem: 'Valor por Meta',
            value: Text(UtilBrasilFields.obterReal(campanha.bonificacaoEquipe)),
          ),
          const SizedBox(height: 6),
          ItemCampanhaDetail(
            titleItem: 'Resultado Equipe',
            value: Text(
              campanha.tipoBonificacao == TypeBonificacao.unidade
                  ? '${campanha.resultadoEquipe.toStringAsFixed(0)} unid.'
                  : UtilBrasilFields.obterReal(campanha.resultadoEquipe),
            ),
          ),
          const SizedBox(height: 6),
          ItemCampanhaDetail(
            titleItem: 'Premiação Conquistada',
            value: Text(
              UtilBrasilFields.obterReal(campanha.bonificacaoEquipeConquistada),
            ),
          ),
          const SizedBox(height: 6),
          ItemCamapanhaPercentCompletedWidget(
            titleItem: 'Realizado',
            value: '${remainingEquipeProgress.toInt()}%',
            totalPercentCompleted: totalEquipeCompleted,
            dotColor: PostoAppUiConfigurations.blueMediumColor,
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: remainingEquipeProgress.toInt() / 100,
            backgroundColor: Color(0xFFECECEC),
            color: PostoAppUiConfigurations.blueMediumColor,
            minHeight: 11,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }
}

class ItemCamapanhaPercentCompletedWidget extends StatelessWidget {
  final String titleItem;
  final String value;
  final Color? dotColor;
  final int totalPercentCompleted;
  const ItemCamapanhaPercentCompletedWidget({
    super.key,
    required this.titleItem,
    required this.value,
    this.dotColor,
    this.totalPercentCompleted = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: dotColor ?? Color(0xFF7BA9F2), radius: 6),
        const SizedBox(width: 10),
        Text(titleItem),
        const SizedBox(width: 10),
        if (totalPercentCompleted < 5)
          Expanded(
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: List.generate(
                totalPercentCompleted,
                (index) => Icon(
                  Icons.workspace_premium_outlined,
                  size: 18,
                  color: Colors.yellow.shade900,
                ),
              ),
            ),
          ),
        if (totalPercentCompleted >= 5) ...[
          Row(
            children: [
              Text('+$totalPercentCompleted'),
              Icon(
                Icons.workspace_premium_outlined,
                size: 18,
                color: Colors.yellow.shade900,
              ),
            ],
          ),
          Spacer(),
        ],

        Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class ItemCampanhaDetail extends StatelessWidget {
  final String titleItem;
  final Widget value;
  final Color? dotColor;
  const ItemCampanhaDetail({
    super.key,
    required this.titleItem,
    required this.value,
    this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: dotColor ?? Color(0xFF7BA9F2), radius: 6),
        const SizedBox(width: 10),
        Text(titleItem),
        Spacer(),
        value,
      ],
    );
  }
}

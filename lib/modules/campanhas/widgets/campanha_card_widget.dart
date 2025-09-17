import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/utils/enums/type_bonificacao.dart';
import 'package:posto360/modules/campanhas/domain/models/campanha_model.dart';
import 'package:posto360/modules/campanhas/domain/models/performance_model.dart';

class CampanhaCardWidget extends StatelessWidget {
  final CampanhaModel campanha;
  final PerformanceModel performace;
  const CampanhaCardWidget({
    super.key,
    required this.campanha,
    required this.performace,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (performace.unidadesVendidas / campanha.volumeBonificacao);
    final totalHundredCompleted = percent ~/ 1;
    final percentRemaining = percent - totalHundredCompleted;
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 23, vertical: 26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFECECEC)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(campanha.nomeCampanha)],
          ),
          const SizedBox(height: 6),
          Divider(color: Color(0xFFECECEC)),
          const SizedBox(height: 11),
          Text('Campanha de incentivo aos colaboradores.'),
          const SizedBox(height: 16),
          ItemCampanhaDetail(
            titleItem: 'Tipo de Bonificação',
            typeBonificacao: campanha.tipoBonificacao,
            value: Text(campanha.tipoBonificacao.description()),
          ),
          const SizedBox(height: 6),
          ItemCampanhaDetail(
            titleItem: 'Meta Bonificação',
            typeBonificacao: campanha.tipoBonificacao,
            value: Text(
              campanha.tipoBonificacao == TypeBonificacao.unidade
                  ? '${campanha.volumeBonificacao.toStringAsFixed(0)} unid.'
                  : UtilBrasilFields.obterReal(
                    (campanha.volumeBonificacao).toDouble(),
                  ),
            ),
          ),
          const SizedBox(height: 6),
          ItemCampanhaDetail(
            titleItem: 'Valor bonificação',
            typeBonificacao: campanha.tipoBonificacao,
            value: Text(
              UtilBrasilFields.obterReal(campanha.valorBonificacao.toDouble()),
            ),
          ),
          const SizedBox(height: 6),
          ItemCampanhaDetail(
            titleItem:
                '${campanha.tipoBonificacao == TypeBonificacao.valor ? 'Valor' : 'Qtd.'} Realizad${campanha.tipoBonificacao == TypeBonificacao.valor ? 'o' : 'a'}',
            typeBonificacao: campanha.tipoBonificacao,
            value: Text(
              campanha.tipoBonificacao == TypeBonificacao.unidade
                  ? '${performace.unidadesVendidas.toStringAsFixed(0)} unid.'
                  : UtilBrasilFields.obterReal(performace.unidadesVendidas),
            ),
          ),
          const SizedBox(height: 6),

          Divider(color: Color(0xFFECECEC)),
          const SizedBox(height: 11),
          ItemCamapanhaPercentCompletedWidget(
            titleItem: 'Realizado',
            totalPercentCompleted: totalHundredCompleted,
            value: '${(percentRemaining * 100).toStringAsFixed(0)}%',
            dotColor: PostoAppUiConfigurations.blueMediumColor,
          ),
          const SizedBox(height: 11),
          LinearPercentIndicator(
            percent: percentRemaining,
            lineHeight: 12,
            progressColor: PostoAppUiConfigurations.blueMediumColor,
            backgroundColor: PostoAppUiConfigurations.lightPurpleColor,
            barRadius: Radius.circular(30),
            padding: EdgeInsets.zero,
            animation: true,
          ),
          const SizedBox(height: 11),
          ItemCampanhaDetail(
            titleItem: 'Valor realizado',
            dotColor: PostoAppUiConfigurations.blueMediumColor,
            typeBonificacao: campanha.tipoBonificacao,
            value: Text(
              UtilBrasilFields.obterReal(
                totalHundredCompleted * campanha.valorBonificacao.toDouble(),
              ),
            ),
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
  final TypeBonificacao typeBonificacao;
  final Color? dotColor;
  const ItemCampanhaDetail({
    super.key,
    required this.titleItem,
    required this.value,
    this.dotColor,
    required this.typeBonificacao,
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

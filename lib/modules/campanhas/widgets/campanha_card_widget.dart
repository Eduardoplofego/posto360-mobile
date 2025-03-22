import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/models/campanha_model.dart';
import 'package:posto360/models/performance_model.dart';

enum TypeBonificacao { valor, unidade }

extension TypeBonificacaoDescription on TypeBonificacao {
  String description() {
    switch (this) {
      case TypeBonificacao.valor:
        return 'Valor';
      case TypeBonificacao.unidade:
        return 'Unidade';
    }
  }
}

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
    final type =
        campanha.tipoBonificacao == 'UNIDADE'
            ? TypeBonificacao.unidade
            : TypeBonificacao.valor;
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
          Text(
            'Descritivo curto sobre a campanha. Exemplo campanha de incentivo aos colaboradores.',
          ),
          const SizedBox(height: 16),
          ItemCampanhaDetail(
            titleItem: 'Tipo de Bonificação',
            value: type.description(),
          ),
          const SizedBox(height: 6),
          ItemCampanhaDetail(
            titleItem: 'Meta Bonificação',
            value:
                type == TypeBonificacao.unidade
                    ? '${campanha.volumeBonificacao.toStringAsFixed(0)} unid.'
                    : UtilBrasilFields.obterReal(
                      (campanha.volumeBonificacao * campanha.valorBonificacao)
                          .toDouble(),
                    ),
          ),
          const SizedBox(height: 6),
          ItemCampanhaDetail(
            titleItem:
                '${type == TypeBonificacao.valor ? 'Valor' : 'Qtd.'} Realizad${type == TypeBonificacao.valor ? 'o' : 'a'}',
            value:
                type == TypeBonificacao.unidade
                    ? '${performace.unidadesVendidas.toStringAsFixed(0)} unid.'
                    : UtilBrasilFields.obterReal(performace.unidadesVendidas),
          ),
          const SizedBox(height: 6),
          Divider(color: Color(0xFFECECEC)),
          const SizedBox(height: 11),
          ItemCampanhaDetail(
            titleItem: 'Realizado',
            value:
                '${((performace.unidadesVendidas / campanha.volumeBonificacao) * 100).toStringAsFixed(0)}%',
            dotColor: PostoAppUiConfigurations.blueMediumColor,
          ),
          const SizedBox(height: 11),
          LinearPercentIndicator(
            percent:
                (performace.unidadesVendidas / campanha.volumeBonificacao) > 1.0
                    ? 1.0
                    : (performace.unidadesVendidas /
                        campanha.volumeBonificacao),
            lineHeight: 12,
            progressColor: PostoAppUiConfigurations.blueMediumColor,
            backgroundColor: PostoAppUiConfigurations.lightPurpleColor,
            barRadius: Radius.circular(30),
            padding: EdgeInsets.zero,
            animation: true,
          ),
        ],
      ),
    );
  }
}

class ItemCampanhaDetail extends StatelessWidget {
  final String titleItem;
  final String value;
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
        Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

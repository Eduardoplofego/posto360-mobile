import 'dart:convert';

import 'package:posto360/modules/core/domain/utils/enums/type_bonificacao.dart';

class CampanhaModel {
  final int campanhaId;
  final String nome;
  final String? descricao;
  final String dataInicio;
  final String dataFim;
  final TypeBonificacao tipoBonificacao;
  final double bonificacaoIndividualVolume;
  final double bonificacaoIndividualValor;
  final double metaEquipe;
  final double bonificacaoMetaValor;
  CampanhaModel({
    required this.campanhaId,
    required this.tipoBonificacao,
    required this.bonificacaoIndividualVolume,
    required this.bonificacaoIndividualValor,
    required this.dataInicio,
    required this.dataFim,
    this.descricao,
    required this.bonificacaoMetaValor,
    required this.metaEquipe,
    required this.nome,
  });

  Map<String, dynamic> toMap() {
    return {
      'campanhaId': campanhaId,
      'nome': nome,
      'descricao': descricao,
      'dataInicio': dataInicio,
      'dataFim': dataFim,
      'tipoBonificacao':
          tipoBonificacao == TypeBonificacao.unidade ? 'UNIDADE' : 'VALOR',
      'bonificacaoIndividualVolume': bonificacaoIndividualVolume,
      'bonificacaoIndividualValor': bonificacaoIndividualValor,
      'metaEquipe': metaEquipe,
      'bonificacaoMetaValor': bonificacaoMetaValor,
    };
  }

  factory CampanhaModel.fromMap(Map<String, dynamic> map) {
    return CampanhaModel(
      campanhaId: map['campanhaId']?.toInt() ?? 0,
      nome: map['nome'] ?? '',
      descricao: map['descricao'],
      dataInicio: map['dataInicio'] ?? '',
      dataFim: map['dataFim'] ?? '',
      tipoBonificacao:
          map['tipoBonificacao'] == 'UNIDADE'
              ? TypeBonificacao.unidade
              : TypeBonificacao.valor,
      bonificacaoIndividualVolume:
          map['bonificacaoIndividualVolume']?.toDouble() ?? 0.0,
      bonificacaoIndividualValor:
          map['bonificacaoIndividualValor']?.toDouble() ?? 0.0,
      metaEquipe: map['metaEquipe']?.toDouble() ?? 0.0,
      bonificacaoMetaValor: map['bonificacaoMetaValor']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CampanhaModel.fromJson(String source) =>
      CampanhaModel.fromMap(json.decode(source));
}

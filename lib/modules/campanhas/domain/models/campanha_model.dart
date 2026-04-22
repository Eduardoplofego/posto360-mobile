import 'dart:convert';

import 'package:posto360/modules/core/domain/utils/enums/type_bonificacao.dart';

class CampanhaModel {
  final int campanhaId;
  final String nomeCampanha;
  final String descricao;
  final TypeBonificacao tipoBonificacao;
  final double metaEquipe;
  final double metaIndividual;
  final double bonificacaoEquipe;
  final double bonificacaoIndividual;
  final double progresso;
  final double resultadoEquipe;
  final double resultadoIndividual;
  final double bonificacaoEquipeConquistada;
  final double bonificacaoIndividualConquistada;

  CampanhaModel({
    required this.campanhaId,
    required this.nomeCampanha,
    required this.descricao,
    required this.tipoBonificacao,
    required this.metaEquipe,
    required this.metaIndividual,
    required this.bonificacaoEquipe,
    required this.bonificacaoIndividual,
    required this.progresso,
    required this.resultadoEquipe,
    required this.resultadoIndividual,
    required this.bonificacaoEquipeConquistada,
    required this.bonificacaoIndividualConquistada,
  });

  factory CampanhaModel.empty() {
    return CampanhaModel(
      campanhaId: 0,
      nomeCampanha: '',
      descricao: '',
      tipoBonificacao: TypeBonificacao.unidade,
      metaEquipe: 0.0,
      metaIndividual: 0.0,
      bonificacaoEquipe: 0.0,
      bonificacaoIndividual: 0.0,
      progresso: 0.0,
      resultadoEquipe: 0.0,
      resultadoIndividual: 0.0,
      bonificacaoEquipeConquistada: 0.0,
      bonificacaoIndividualConquistada: 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'campanhaId': campanhaId,
      'nomeCampanha': nomeCampanha,
      'descricao': descricao,
      'tipoBonificacao': tipoBonificacao.description(),
      'metaEquipe': metaEquipe,
      'metaIndividual': metaIndividual,
      'bonificacaoEquipe': bonificacaoEquipe,
      'bonificacaoIndividual': bonificacaoIndividual,
      'progresso': progresso,
      'resultadoEquipe': resultadoEquipe,
      'resultadoIndividual': resultadoIndividual,
      'bonificacaoEquipeConquistada': bonificacaoEquipeConquistada,
      'bonificacaoIndividualConquistada': bonificacaoIndividualConquistada,
    };
  }

  factory CampanhaModel.fromMap(Map<String, dynamic> map) {
    return CampanhaModel(
      campanhaId: map['id']?.toInt() ?? 0,
      nomeCampanha: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
      tipoBonificacao:
          map['tipoBonificacao'] == 'UNIDADE'
              ? TypeBonificacao.unidade
              : TypeBonificacao.valor,
      metaEquipe: map['metaEquipe']?.toDouble() ?? 0.0,
      metaIndividual: map['metaIndividual']?.toDouble() ?? 0.0,
      bonificacaoEquipe: map['bonificacaoEquipe']?.toDouble() ?? 0.0,
      bonificacaoIndividual: map['bonificacaoIndividual']?.toDouble() ?? 0.0,
      progresso: map['progresso']?.toDouble() ?? 0.0,
      resultadoEquipe: map['resultadoEquipe']?.toDouble() ?? 0.0,
      resultadoIndividual: map['resultadoIndividual']?.toDouble() ?? 0.0,
      bonificacaoEquipeConquistada:
          map['bonificacaoEquipeConquistada']?.toDouble() ?? 0.0,
      bonificacaoIndividualConquistada:
          map['bonificacaoIndividualConquistada']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CampanhaModel.fromJson(String source) =>
      CampanhaModel.fromMap(json.decode(source));
}

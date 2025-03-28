import 'dart:convert';

import 'package:posto360/core/utils/enums/type_bonificacao.dart';
import 'package:posto360/models/produto_model.dart';

class CampanhaModel {
  final int campanhaId;
  final String nomeCampanha;
  final List<ProdutoModel> produtos;
  final TypeBonificacao tipoBonificacao;
  final double volumeBonificacao;
  final double valorBonificacao;
  final DateTime dataDisponibilidade;
  CampanhaModel({
    required this.campanhaId,
    required this.nomeCampanha,
    required this.produtos,
    required this.tipoBonificacao,
    required this.volumeBonificacao,
    required this.valorBonificacao,
    required this.dataDisponibilidade,
  });

  Map<String, dynamic> toMap() {
    return {
      'campanhaId': campanhaId,
      'nomeCampanha': nomeCampanha,
      'produtos': produtos.map((e) => e.toJson()).toList(),
      'tipoBonificacao': tipoBonificacao.description(),
      'volumeBonificacao': volumeBonificacao,
      'valorBonificacao': valorBonificacao,
      'dataDisponibilidade': dataDisponibilidade.toIso8601String(),
    };
  }

  factory CampanhaModel.empty() {
    return CampanhaModel(
      campanhaId: 0,
      nomeCampanha: '',
      produtos: [],
      tipoBonificacao: TypeBonificacao.unidade,
      volumeBonificacao: 0,
      valorBonificacao: 0,
      dataDisponibilidade: DateTime(2025),
    );
  }

  factory CampanhaModel.fromMap(Map<String, dynamic> map) {
    return CampanhaModel(
      campanhaId: map['campanhaId']?.toInt() ?? 0,
      nomeCampanha: map['nomeCampanha'] ?? '',
      produtos:
          map['produtos']
              .map<ProdutoModel>((p) => ProdutoModel.fromMap(p))
              .toList(),
      tipoBonificacao:
          map['tipoBonificacao'] == 'UNIDADE'
              ? TypeBonificacao.unidade
              : TypeBonificacao.valor,
      volumeBonificacao: map['volumeBonificacao'] ?? 0,
      valorBonificacao: map['valorBonificacao'] ?? 0,
      dataDisponibilidade: DateTime.parse(map['dataDisponibilidade']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CampanhaModel.fromJson(String source) =>
      CampanhaModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CampanhaModel(campanhaId: $campanhaId, nomeCampanha: $nomeCampanha, produtos: $produtos, tipoBonificacao: $tipoBonificacao, volumeBonificacao: $volumeBonificacao, valorBonificacao: $valorBonificacao, dataDisponibilidade: $dataDisponibilidade)';
  }
}

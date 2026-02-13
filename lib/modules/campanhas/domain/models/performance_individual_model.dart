class PerformanceIndividualModel {
  final int campanhaId;
  final String tipoBonificacao;
  final double unidadesVendidas;
  final double valorVendas;
  final double valorBonificacao;
  final double volumeBonificacao;
  final double progresso;

  PerformanceIndividualModel({
    required this.campanhaId,
    required this.tipoBonificacao,
    required this.unidadesVendidas,
    required this.valorVendas,
    required this.valorBonificacao,
    required this.volumeBonificacao,
    required this.progresso,
  });
  factory PerformanceIndividualModel.empty() {
    return PerformanceIndividualModel(
      campanhaId: 0,
      tipoBonificacao: '',
      unidadesVendidas: 0.0,
      valorVendas: 0.0,
      valorBonificacao: 0.0,
      volumeBonificacao: 0.0,
      progresso: 0.0,
    );
  }
  factory PerformanceIndividualModel.fromJson(Map<String, dynamic> json) {
    return PerformanceIndividualModel(
      campanhaId: json['campanhaId'] as int,
      tipoBonificacao: json['tipoBonificacao'] as String,
      unidadesVendidas: (json['unidadesVendidas'] as num).toDouble(),
      valorVendas: (json['valorVendas'] as num).toDouble(),
      valorBonificacao: (json['valorBonificacao'] as num).toDouble(),
      volumeBonificacao: (json['volumeBonificacao'] as num).toDouble(),
      progresso: (json['progresso'] as num).toInt().toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'campanhaId': campanhaId,
      'tipoBonificacao': tipoBonificacao,
      'unidadesVendidas': unidadesVendidas,
      'valorVendas': valorVendas,
      'valorBonificacao': valorBonificacao,
      'volumeBonificacao': volumeBonificacao,
      'progresso': progresso,
    };
  }
}

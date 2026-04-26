class CampanhasResumoModel {
  final int campanhasAtivas;
  final double bonificacaoTotal;

  CampanhasResumoModel({
    required this.campanhasAtivas,
    required this.bonificacaoTotal,
  });

  factory CampanhasResumoModel.empty() =>
      CampanhasResumoModel(campanhasAtivas: 0, bonificacaoTotal: 0);

  factory CampanhasResumoModel.fromMap(Map<String, dynamic> map) {
    return CampanhasResumoModel(
      campanhasAtivas: (map['campanhasAtivas'] as num?)?.toInt() ?? 0,
      bonificacaoTotal: (map['bonificacaoTotal'] as num?)?.toDouble() ?? 0,
    );
  }
}

class PerformanceEquipeModel {
  final int campanhaId;
  final double vendaFilialMes;
  final double quantidadeVendida;
  final double metaEquipe;
  final double bonificacaoMetaValor;
  final double progresso;

  PerformanceEquipeModel({
    required this.campanhaId,
    required this.vendaFilialMes,
    required this.quantidadeVendida,
    required this.metaEquipe,
    required this.bonificacaoMetaValor,
    required this.progresso,
  });

  factory PerformanceEquipeModel.empty() {
    return PerformanceEquipeModel(
      campanhaId: 0,
      vendaFilialMes: 0.0,
      quantidadeVendida: 0.0,
      metaEquipe: 0.0,
      bonificacaoMetaValor: 0.0,
      progresso: 0.0,
    );
  }

  factory PerformanceEquipeModel.fromJson(Map<String, dynamic> json) {
    return PerformanceEquipeModel(
      campanhaId: json['campanhaId'],
      vendaFilialMes: (json['vendaFilialMes'] as num).toDouble(),
      quantidadeVendida: (json['quantidadeVendida'] as num).toDouble(),
      metaEquipe: (json['metaEquipe'] as num).toDouble(),
      bonificacaoMetaValor: (json['bonificacaoMetaValor'] as num).toDouble(),
      progresso: (json['progresso'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'campanhaId': campanhaId,
      'vendaFilialMes': vendaFilialMes,
      'quantidadeVendida': quantidadeVendida,
      'metaEquipe': metaEquipe,
      'bonificacaoMetaValor': bonificacaoMetaValor,
      'progresso': progresso,
    };
  }
}

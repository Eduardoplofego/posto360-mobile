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
    final metaEquipeNum = json['metaEquipe'] as num;
    final bonificacaoMetaValor = json['bonificacaoMetaValor'] as num;
    return PerformanceEquipeModel(
      campanhaId: json['campanhaId'],
      vendaFilialMes: json['vendaFilialMes'],
      quantidadeVendida: json['quantidadeVendida'],
      metaEquipe: metaEquipeNum.toDouble(),
      bonificacaoMetaValor: bonificacaoMetaValor.toDouble(),
      progresso: json['progresso'],
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
